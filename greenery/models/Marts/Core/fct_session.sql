{{ config(materialized='table') }}

{%- set event_types = dbt_utils.get_column_values(
    table=ref('stg_events'),
    column='event_type'
) -%}

WITH sessions_orders AS (
select distinct
session_id
,order_id
from dbt_john_j.stg_events
WHERE 1=1 
AND order_id is not null
)


SELECT 
session_id
,user_id
,so.order_id
  {%- for event in event_types %}
  , {{events(event)}} AS e_{{event}}
  {%- endfor %}
FROM {{ref('stg_events')}} 
    LEFT JOIN sessions_orders so USING (session_id)
GROUP BY 1,2,3