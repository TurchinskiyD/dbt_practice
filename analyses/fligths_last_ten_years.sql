{% set current_date = run_started_at | string | truncate(10, True, "")   %}
{% set current_year = run_started_at | string | truncate(4, True, "") | int  %}
{% set prev_year = current_year - 10 %}

SELECT 
    COUNT(*)
    --scheduled_departure::date AS scheduled_departure
FROM
    {{ ref('fct_flights_schedule') -}}
WHERE 
    scheduled_departure::date BETWEEN '{{ current_date | replace(current_year, prev_year) }}' AND '{{ current_date }}'
    --scheduled_departure BETWEEN current_timestamp - interval '10 years' AND current_timestamp

{% set source_relation = adapter.get_relation(
      database="dwh_flight",
      schema="intermediate",
      identifier="fct_flights_schedule") -%}

{% set source_relation = load_relation( ref('fct_flights_schedule')) %}
{% set columns = adapter.get_columns_in_relation(source_relation) -%}

{% for column in columns %}
    {{ 'Columns: ' ~ column -}}
{% endfor %}



{# {{ source_relation }}
{{ source_relation.database  }}
{{ source_relation.schema  }}
{{ source_relation.identifier  }}
{{ source_relation.is_table  }}
{{ source_relation.is_view  }}
{{ source_relation.is_cte  }} #}

