{{
    config(
        materialized = 'table'
    )
}}

select
    flight_id,
    flight_no,
    scheduled_departure,
    scheduled_arrival,
    departure_airport,
    arrival_airport,
    status,
    aircraft_code,
    actual_departure,
    actual_arrival,
    current_timestamp as load_data,
    {{ concat_columns(['flight_id', 'flight_no'])}} AS flight_info
from 
    {{ ref('stg_flights__flights') }}