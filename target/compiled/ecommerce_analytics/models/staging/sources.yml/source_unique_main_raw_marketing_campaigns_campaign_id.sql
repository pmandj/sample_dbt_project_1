
    
    

select
    campaign_id as unique_field,
    count(*) as n_records

from "ecommerce_analytics"."main"."raw_marketing_campaigns"
where campaign_id is not null
group by campaign_id
having count(*) > 1


