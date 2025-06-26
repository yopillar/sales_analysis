-- models/marts/mart_product_perf.sql  (complément)

with funnel as (...),
orders as (...),
products as (...),

joined as (
  select
    p.product_id,
    p.product_name,
    p.category,
    count(distinct f.customer_id)              as nb_clients_vus,
    count(distinct o.order_id)                 as nb_commandes,
    sum(o.quantity)                            as qt_vendue,
    round(sum(o.quantity * p.price), 2)        as ca_total,
    count(*) filter (where f.cart_ts is not null and f.purchase_ts is null) as nb_abandons
  from products p
  left join funnel f on p.product_id = f.product_id
  left join orders o on p.product_id = o.product_id
  group by 1,2,3
)

select *,
       round(nb_commandes::float / nullif(nb_clients_vus,0),2)        as taux_conversion,
       round(nb_abandons::float  / nullif(nb_clients_vus,0),2)        as taux_abandon
from joined;
