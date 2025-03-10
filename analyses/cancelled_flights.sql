SELECT 
    scheduled_departure::date AS scheduled_departure,
    COUNT(*) AS cancelled_flights
FROM 
   {{ ref('stg_flights__flights') }}
WHERE departure_airport = 'DME'
    AND status = 'Cancelled'
GROUP BY scheduled_departure::date

--DME