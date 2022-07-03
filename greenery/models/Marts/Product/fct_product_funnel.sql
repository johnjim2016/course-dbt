{{
  config(
    materialized='table'
  )
}}

WITH base AS 
(
SELECT *
FROM {{ref('int_session_agg')}}
)

SELECT
    date_trunc('week',session_start_date) as sessions_by_weekdate
    ,COUNT (DISTINCT session_id) as total_sessions
    ,COUNT (DISTINCT CASE WHEN e_add_to_cart>0 THEN session_id ELSE NULL END) as session_add_cart
    ,COUNT (DISTINCT CASE WHEN e_checkout>0 THEN session_id ELSE NULL END) as session_checkout
    ,COUNT (DISTINCT CASE WHEN e_add_to_cart>0 THEN session_id ELSE NULL END)::float/COUNT (DISTINCT session_id) as addtocart_total_session_conversion
    ,COUNT (DISTINCT CASE WHEN e_checkout>0 THEN session_id ELSE NULL END)::float/COUNT (DISTINCT CASE WHEN e_add_to_cart>0 THEN session_id ELSE NULL END) as checkout_addtochart_conversion
    ,COUNT (DISTINCT CASE WHEN e_checkout>0 THEN session_id ELSE NULL END)::float/COUNT (DISTINCT session_id) as checkout_total_session_conversion
FROM base
GROUP BY 1