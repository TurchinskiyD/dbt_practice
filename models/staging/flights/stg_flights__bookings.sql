{{
    config(
        materialized = 'table'
    )
}}

select 
    book_ref, 
    book_date, 
    total_amount,
    total_amount * 0.1 as tax_amount
from 
    {{ source('demo_src', 'bookings') }}
    