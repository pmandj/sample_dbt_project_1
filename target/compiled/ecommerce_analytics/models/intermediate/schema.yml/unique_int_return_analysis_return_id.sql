
    
    

select
    return_id as unique_field,
    count(*) as n_records

from "ecommerce_analytics"."main"."int_return_analysis"
where return_id is not null
group by return_id
having count(*) > 1


