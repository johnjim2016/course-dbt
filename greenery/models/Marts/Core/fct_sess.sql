{{ config(materialized='table') }}

WITH base AS (
SELECT 
    session_id
    ,MIN(created_at_utc) as start_time
    ,MAX(created_at_utc) as end_time
    ,(date_part('day',MAX(created_at_utc)::timestamp-MIN(created_at_utc)::timestamp)*24 +
       date_part('hour',MAX(created_at_utc)::timestamp-MIN(created_at_utc)::timestamp)*60 +
        date_part('minute',MAX(created_at_utc)::timestamp-MIN(created_at_utc)::timestamp))
        as session_minutes
FROM {{ref('stg_events')}}
GROUP BY 1
)

,int_table as (
    SELECT *
    FROM {{ref('int_session_agg')}}
)

SELECT
     it.session_id
    ,it.user_id
    ,b.session_minutes
    ,it.add_to_cart
    ,it.page_view
    ,it.checkout
    ,it.package_shipped
FROM int_table it
    LEFT JOIN base b ON it.session_id=b.session_id
ORDER BY 1,2