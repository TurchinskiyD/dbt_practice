{{
  config(
        materialized='table'
    )
}}
select
    ticket_no,
    flight_id,
    fare_conditions,
    amount,
    current_timestamp as load_data
from
    {{ ref('stg_flights__ticket_flights') }}

