-- models/stg_orders.sql

{{ config(materialized='view') }}

select
    order_id,
    customer_id,
    product_id,
    order_date,
    quantity
from {{ ref('orders') }}