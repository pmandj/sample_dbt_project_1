
    
    

select
    payment_id as unique_field,
    count(*) as n_records

from "ecommerce_analytics"."main"."raw_payments"
where payment_id is not null
group by payment_id
having count(*) > 1


