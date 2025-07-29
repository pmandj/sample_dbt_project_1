
    
    

select
    inventory_id as unique_field,
    count(*) as n_records

from "ecommerce_analytics"."main"."raw_inventory"
where inventory_id is not null
group by inventory_id
having count(*) > 1


