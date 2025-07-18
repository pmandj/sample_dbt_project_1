-- Macro for safe division to avoid division by zero errors
-- Returns 0 when denominator is zero or null

{% macro safe_divide(numerator, denominator) %}
    case 
        when {{ denominator }} = 0 or {{ denominator }} is null then 0
        else {{ numerator }} / {{ denominator }}
    end
{% endmacro %}
