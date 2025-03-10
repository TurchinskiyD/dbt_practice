{{
  config(
    materialized='table'
  )
}}

select
    airport_code, 
    airport_name, 
    city, 
    coordinates, 
    timezone, 
    dbt_scd_id, 
    dbt_updated_at, 
    dbt_valid_from, 
    dbt_valid_to
from 
    {{ source('snapshot', 'dim_flights__airports') }}
    