Project 1:

How many users do we have?
130 

select COUNT (distinct user_id) as user_count
FROM dbt_john_j."stg_users";


On average, how many orders do we receive per hour?
~8 (7.522)

WITH base AS (
select 
date_trunc('hour',created_at_utc) as hour
,COUNT (distinct order_id) as order_count
FROM dbt_john_j."stg_orders"
GROUP BY 1)

select 
AVG(order_count) as order_count
FROM base;

On average, how long does an order take from being placed to being delivered?
3 Days and 21 hours

select 
avg(delivered_at_utc - created_at_utc) as average_delivery_time
FROM dbt_john_j."stg_orders"
WHERE delivered_at_utc IS NOT NULL
;


How many users have only made one purchase? Two purchases? Three+ purchases?
1 = 25
2 = 28
3+ = 71


WITH base1 AS (
select
user_id
,COUNT(distinct order_id) as orders
from dbt_john_j."stg_orders"
GROUP BY 1
)
, base2 AS (
select user_id, orders
,CASE WHEN orders=1 THEN '1' 
WHEN orders =2 then '2' ELSE '3+' END as order_total
FROM base1
)

SELECT 
order_total
,COUNT(DISTINCT user_id)
FROM base2
GROUP BY 1;

Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.

On average, how many unique sessions do we have per hour?
16.33



WITH base AS (
select 
date_trunc('hour',created_at_utc) as hour
,COUNT (distinct session_id) as session_count
FROM dbt_john_j."stg_events"
GROUP BY 1)

select 
AVG(session_count) as avg_session_count
FROM base;

