{{
  config(
    materialized='table'
  )
}}

WITH orders AS (
SELECT *
FROM {{ref('stg_orders')}}
)
, order_product AS (
SELECT *
FROM {{ref ('int_order_product')}}
)
, users as (
SELECT *
FROM {{ref('dim_users')}}
)

SELECT
     o.order_id
    ,op.product_id
    ,op.product_name
    ,op.order_quantity
    ,op.price
    ,o.user_id
    ,u.email
    ,o.created_at_utc
    ,o.delivered_at_utc
    ,o.order_status
FROM order_product op
    LEFT JOIN orders o
        ON op.order_id=o.order_id
    LEFT JOIN users u
        ON o.user_id=u.user_id
ORDER BY 1,2 