
{{
  config(
    materialized='table'
  )
}}

SELECT
     city,
     region,
     updated_at
FROM 
    {{ source('snapshot', 'snap_city_region') }}
    