{{
  config(
    materialized='table'
  )
}}

WITH addresses AS (
    SELECT * FROM {{ref('stg_addresses')}}
)
, users AS (
    SELECT * FROM {{ref('stg_users')}}
)

SELECT 
     u.user_id
    ,u.email
    ,u.first_name
    ,u.last_name
    ,u.created_at_utc as user_created_date
    ,a.State
    ,a.Country
FROM users u 
    LEFT JOIN addresses a 
        ON u.address_id=a.address_id
ORDER BY 1