
    
    

with all_values as (

    select
        customer_value_tier as value_field,
        count(*) as n_records

    from "ecommerce_analytics"."main"."dim_customers"
    group by customer_value_tier

)

select *
from all_values
where value_field not in (
    'High Value','Medium Value','Low Value','No Value'
)


