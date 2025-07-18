
    
    

with all_values as (

    select
        basket_size_category as value_field,
        count(*) as n_records

    from "ecommerce_analytics"."main"."fct_orders"
    group by basket_size_category

)

select *
from all_values
where value_field not in (
    'Large Basket','Medium Basket','Single Item','Empty Basket'
)


