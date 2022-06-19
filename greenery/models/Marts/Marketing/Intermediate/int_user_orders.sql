{{
  config(
    materialized='table'
  )
}}

WITH orders AS (
SELECT *
FROM {{ref('stg_orders')}}
)

SELECT DISTINCT
    o.user_id
    ,FIRST_VALUE(created_at_utc)
        OVER (PARTITION BY o.user_id 
        ORDER BY created_at_utc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as first_order_date
    ,LAST_VALUE(created_at_utc)
        OVER (PARTITION BY o.user_id 
        ORDER BY created_at_utc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as last_order_date
FROM orders o
ORDER BY 1