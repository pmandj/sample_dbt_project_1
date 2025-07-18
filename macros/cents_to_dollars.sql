-- Macro to convert cents to dollars
-- This macro provides consistent currency conversion across models

{% macro cents_to_dollars(column_name) %}
    round({{ column_name }} / 100.0, 2)
{% endmacro %} 
