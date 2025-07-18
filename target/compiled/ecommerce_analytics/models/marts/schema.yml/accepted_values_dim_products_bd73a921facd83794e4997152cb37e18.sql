
    
    

with all_values as (

    select
        category_clean as value_field,
        count(*) as n_records

    from "ecommerce_analytics"."main"."dim_products"
    group by category_clean

)

select *
from all_values
where value_field not in (
    'Electronics','Footwear','Kitchen','Fitness','Home Office','Other'
)


