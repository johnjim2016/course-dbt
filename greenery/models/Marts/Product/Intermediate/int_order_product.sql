{{
  config(
    materialized='table'
  )
}}

WITH order_items as (
    SELECT *
    FROM {{ref('stg_order_items')}}
)
,products as (
    SELECT *
    FROM {{ref('stg_products')}}
)

SELECT 
    oi.order_id
    ,p.product_id
    ,p.product_name
    ,p.price
    ,oi.quantity as order_quantity
    ,p.price* oi.quantity as total
FROM order_items oi 
    LEFT JOIN products p 
        ON oi.product_id=p.product_id
ORDER BY order_id
