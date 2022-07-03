{{ config(materialized='table') }}

{%- set event_types = dbt_utils.get_column_values(
    table=ref('stg_events'),
    column='event_type'
) -%}

SELECT 
session_id
,user_id
,MIN(created_at_utc) as session_start_date
,MAX(created_at_utc) as session_end_date
  {%- for event in event_types %}
  , {{events(event)}} AS e_{{event}}
  {%- endfor %}
FROM {{ref('stg_events')}}
WHERE 1=1
AND event_type<>'package_shipped'
GROUP BY 1,2