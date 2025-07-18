
    
    

select
    email as unique_field,
    count(*) as n_records

from "ecommerce_analytics"."main"."raw_customers"
where email is not null
group by email
having count(*) > 1


