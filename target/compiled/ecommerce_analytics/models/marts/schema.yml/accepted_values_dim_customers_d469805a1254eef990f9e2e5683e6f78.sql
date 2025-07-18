
    
    

with all_values as (

    select
        customer_segment as value_field,
        count(*) as n_records

    from "ecommerce_analytics"."main"."dim_customers"
    group by customer_segment

)

select *
from all_values
where value_field not in (
    'One-time','Occasional','Frequent','Unknown'
)


