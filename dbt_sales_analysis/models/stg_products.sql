-- models/stg_products.sql

{{ config(materialized='view') }}

select
    product_id,
    product_name,
    category,
    cast(price as float64) as price,
    cast(is_active as boolean) as is_active
from {{ ref('products') }}