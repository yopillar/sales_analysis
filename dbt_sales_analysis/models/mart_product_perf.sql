{{ config(materialized='table') }}

with funnel as (
    select * from {{ ref('int_funnel') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

agg as (
    select
        p.product_id,
        p.product_name,
        p.category,

        count(distinct f.customer_id)                                         as nb_clients_vus,
        count(distinct o.order_id)                                            as nb_commandes,
        sum(o.quantity)                                                       as qt_vendue,
        sum(o.quantity * p.price)                                             as ca_total,
        sum(case
                when f.cart_ts is not null and f.purchase_ts is null then 1
                else 0
            end)                                                              as nb_abandons
    from products p
    left join funnel  f on p.product_id = f.product_id
    left join orders  o on p.product_id = o.product_id
    group by p.product_id, p.product_name, p.category
)

select
    *,
    safe_divide(nb_commandes, nb_clients_vus)                                 as taux_conversion,
    safe_divide(nb_abandons , nb_clients_vus)                                 as taux_abandon
from agg
order by ca_total desc
