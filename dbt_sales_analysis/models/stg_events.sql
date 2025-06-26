-- models/stg_events.sql

{{ config(materialized='view') }}

select
    event_id,
    customer_id,
    event_type,
    product_id,
    event_timestamp
from {{ ref('events') }}