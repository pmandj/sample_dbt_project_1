
    
    

with all_values as (

    select
        customer_status as value_field,
        count(*) as n_records

    from "ecommerce_analytics"."main"."dim_customers"
    group by customer_status

)

select *
from all_values
where value_field not in (
    'Active','Dormant','Inactive'
)


