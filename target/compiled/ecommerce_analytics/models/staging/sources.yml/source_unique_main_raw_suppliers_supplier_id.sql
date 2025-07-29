
    
    

select
    supplier_id as unique_field,
    count(*) as n_records

from "ecommerce_analytics"."main"."raw_suppliers"
where supplier_id is not null
group by supplier_id
having count(*) > 1


