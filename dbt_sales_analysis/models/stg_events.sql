-- models/stg_events.sql

{{ config(materialized='view') }}

select
    event_id,
    customer_id,
    event_type,
    product_id,
    cast(event_timestamp as timestamp) as event_ts
from {{ ref('events') }}