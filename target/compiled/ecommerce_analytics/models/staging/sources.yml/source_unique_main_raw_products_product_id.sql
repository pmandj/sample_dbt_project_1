
    
    

select
    product_id as unique_field,
    count(*) as n_records

from "ecommerce_analytics"."main"."raw_products"
where product_id is not null
group by product_id
having count(*) > 1


