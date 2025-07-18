
    
    

with all_values as (

    select
        performance_tier as value_field,
        count(*) as n_records

    from "ecommerce_analytics"."main"."dim_products"
    group by performance_tier

)

select *
from all_values
where value_field not in (
    'High Performer','Medium Performer','Low Performer','No Sales'
)


