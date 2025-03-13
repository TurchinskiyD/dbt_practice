{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'append', 
        tags = ['bookings']
    )
}}

select 
    book_ref, 
    book_date, 
    {{ cent_to_dolar('total_amount')}} as total_amount
from 
    {{ source('demo_src', 'bookings') }}

{% if is_incremental() %}
where 
    book_date > (select max(book_date) from {{ this }})
    --('0x' || book_ref)::bigint > (SELECT MAX(('0x' || book_ref)::bigint) FROM {{ this }})
{% endif %}