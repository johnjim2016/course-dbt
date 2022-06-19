{{
  config(
    materialized='table'
  )
}}

WITH orders AS (
SELECT *
FROM {{ref('int_user_orders')}}
)
,agg AS (
SELECT user_id
,SUM(order_cost) as total_cost
,COUNT(DISTINCT order_id) as total_orders
,CAST(SUM(order_cost) AS DECIMAL(7,2))/COUNT(DISTINCT order_id) as avg_order_value
FROM {{ref('stg_orders')}}
GROUP BY 1
)


SELECT DISTINCT
     o.user_id
    ,o.first_order_date
    ,o.last_order_date
    ,agg.total_cost
    ,agg.total_orders
    ,ROUND(agg.avg_order_value,2)
FROM orders o
    LEFT JOIN agg USING (user_id)
ORDER BY 1