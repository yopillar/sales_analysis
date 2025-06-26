-- models/int_funnel.sql

{{ config(materialized='table') }}

with events as (
    select * from {{ ref('stg_events') }}
),

sessions as (
    select
        customer_id,
        product_id,
        min(case when event_type = 'view'          then event_ts end) as view_ts,
        min(case when event_type = 'add_to_cart'   then event_ts end) as cart_ts,
        min(case when event_type = 'checkout'      then event_ts end) as checkout_ts,
        min(case when event_type = 'purchase'      then event_ts end) as purchase_ts
    from events
    group by customer_id, product_id
)

select * from sessions
