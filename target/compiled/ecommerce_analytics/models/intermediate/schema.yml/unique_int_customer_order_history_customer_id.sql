
    
    

select
    customer_id as unique_field,
    count(*) as n_records

from "ecommerce_analytics"."main"."int_customer_order_history"
where customer_id is not null
group by customer_id
having count(*) > 1


