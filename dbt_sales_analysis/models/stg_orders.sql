-- models/stg_orders.sql

{{ config(materialized='view') }}

select
    order_id,
    customer_id,
    product_id,
    cast(order_date as date) as order_date,
    cast(quantity as integer) as quantity
from {{ ref('orders') }}