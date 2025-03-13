{%- macro concat_columns(columns, delim=', ') %}
    {%- for column in columns %}
        {{- column }} {% if not loop.last %} || '{{ delim }}' || {% endif -%}
    {% endfor -%}
{% endmacro %}

{% macro drop_old_relations(dryrun=False) %}

{% if execute %}
 {# знаходимо всі models, seed, snapshot проєкта dbt #}
{% set current_models = [] %}

    {% for node in graph.nodes.values() | selectattr("resource_type", "in", ["model", "snapshot", "seed"]) %}
        {% do current_models.append(node.name) %}
    {% endfor %}

{% do log(current_models, True) %}

{# формування скрипта видалення всіх таблиць і представлень яким не відповідають #}

{% set cleanup_query %}
    WITH MODELS_TO_DROP AS (
        SELECT
            CASE
                WHEN TABLE_TYPE = 'BASE TABLE' THEN 'TABLE'
                WHEN TABLE_TYPE = 'VIEW' THEN 'VIEW'
            END AS RELATION_TYPE,
                CONCAT_WS('.', TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME) as RELATION_NAME
        FROM
            {{ target.database }}.INFORMATION_SCHEMA.TABLES
        WHERE
            TABLE_SCHEMA = '{{ target.schema }}'
            AND UPPER(TABLE_NAME) NOT IN (
                {%- for model in current_models -%}
                    '{{ model.upper() }}'
                    {%- if not loop.last -%}
                        ,
                    {%- endif %}
                {%- endfor -%}
            )
    )
    SELECT
        'DROP ' || RELATION_TYPE || ' ' || RELATION_NAME || ';' as DROP_COMMANDS
    FROM
        MODELS_TO_DROP;
{% endset %}
        
{% do log(cleanup_query, True) %}
        
{% set drop_commands = run_query(cleanup_query).columns[0].values() %}

{% do log(drop_commands, True) %}

{# видалення лишніх таблиць #}

{% if drop_commands %}
    {% if dryrun | as_bool == False %}
        {% do log['Executing Drop commands ...,', True]%}
    {% else %}
        {% do log['Printing Drop commands ...,', True]%}
    {% endif%}

    {% for drop_command in drop_commands %}
                {% do log(drop_command, True) %}
                {% if  dryrun | as_bool == False %}
                    {% do run_query(drop_command) %}
                {% endif %}
    {% endfor %}
{% else %}
    {% do log('No relations to clean', True) %}
{% endif %}

{% endif%}
{% endmacro %}