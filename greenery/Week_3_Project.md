What is our overall conversion rate?
62%

SELECT 
COUNT(DISTINCT session_id) as total_sessions
,SUM(checkout)  as total_orders
,CAST(SUM(checkout) AS FLOAT)/COUNT(DISTINCT session_id) as conversion
FROM dbt_john_j.fct_sess;


What is our conversion rate by product?

WITH sessions_product AS (
SELECT DISTINCT
e.session_id
,e.product_id
FROM dbt_john_j.stg_events e
WHERE 1=1 
AND product_id is not null
ORDER BY session_id
)
, sessions_orders AS (
select distinct
session_id
,order_id
from dbt_john_j.stg_events
WHERE 1=1 
AND order_id is not null
)
, session_order_item AS (
SELECT so.session_id,op.order_id,op.product_id,op.product_name
FROM sessions_orders so
JOIN dbt_john_j.fct_order_product op  
    ON so.order_id=op.order_id
GROUP BY 1,2,3,4
ORDER BY op.order_id ASC  
)
, base as (
SELECT sp.*
, CASE WHEN soi.product_id IS NULL THEN 0 ELSE 1 END as ordered_product
FROM sessions_product sp
     LEFT JOIN session_order_item soi
     ON sp.session_id=soi.session_id
     AND sp.product_id=soi.product_id
ORDER By 1,2
)
SELECT
b.product_id
,p.product_name
,p.price
,COUNT (DISTINCT session_id) as total_sessions
,SUM (ordered_product) as orders_within_session
,SUM (ordered_product)::float/COUNT (DISTINCT session_id) as conversion_rate
FROM base b
    JOIN dbt_john_j.stg_products p
      ON b.product_id=p.product_id
GROUP BY 1,2,3
ORDER By 6 DESC


Why might certain products be converting at higher/lower rates than others?
    - I would like to understand the purchase process to document the process. 
    - I would recommend evaluating certain product pages for both high/low conversions and where they are in the site map structure. Image quality, layout, and design could be some factors that effect conversion. 


Create a macro to simplify part of a model(s).

used macro for session data


Add a post hook to your project to apply grants to the role “reporting”. Create reporting role first by running CREATE ROLE reporting in your database instance.
- completed


Install a package (i.e. dbt-utils, dbt-expectations) and apply one or more of the macros to your project.
    - Used the dbt-utils 
    - get_column_values
