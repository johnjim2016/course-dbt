{{ config(materialized='table') }}

SELECT 
session_id
,user_id
, SUM(CASE WHEN event_type='add_to_cart' THEN 1 ELSE 0 END) as add_to_cart
, SUM(CASE WHEN event_type='checkout' THEN 1 ELSE 0 END) as checkout
, SUM(CASE WHEN event_type='page_view' THEN 1 ELSE 0 END) as page_view
, SUM(CASE WHEN event_type='package_shipped' THEN 1 ELSE 0 END) as package_shipped
FROM {{ref('stg_events')}}
GROUP BY 1,2