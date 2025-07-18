
    
    

with all_values as (

    select
        order_status_clean as value_field,
        count(*) as n_records

    from "ecommerce_analytics"."main"."stg_orders"
    group by order_status_clean

)

select *
from all_values
where value_field not in (
    'completed','pending','cancelled','refunded','unknown'
)


