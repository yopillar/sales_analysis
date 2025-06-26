{{ config(materialized='table') }}

with base as (
    select
        o.order_date,
        p.category,
        sum(o.quantity * p.price) as ca_total
    from {{ ref('stg_orders') }} o
    join {{ ref('stg_products') }} p on o.product_id = p.product_id
    group by o.order_date, p.category
),

ranked as (
    select
        *,
        rank() over (partition by order_date order by ca_total desc) as ca_rank
    from base
)

select *
from ranked
