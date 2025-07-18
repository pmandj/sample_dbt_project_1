
    
    

with all_values as (

    select
        email_provider as value_field,
        count(*) as n_records

    from "ecommerce_analytics"."main"."stg_customers"
    group by email_provider

)

select *
from all_values
where value_field not in (
    'Gmail','Yahoo','Hotmail','Outlook','Other'
)


