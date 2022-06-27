{{ config(materialized='table') }}

{%- set event_types = dbt_utils.get_column_values(
    table=ref('stg_events'),
    column='event_type'
) -%}

SELECT 
session_id
,user_id
  {%- for event in event_types %}
  , {{events(event)}} AS e_{{event}}
  {%- endfor %}
FROM {{ref('stg_events')}}
GROUP BY 1,2