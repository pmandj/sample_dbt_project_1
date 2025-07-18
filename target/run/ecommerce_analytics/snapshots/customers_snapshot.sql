
      
  
    
    

    create  table
      "ecommerce_analytics"."snapshots"."customers_snapshot"
  
    as (
      
    

    select *,
        md5(coalesce(cast(customer_id as varchar ), '')
         || '|' || coalesce(cast(updated_at as varchar ), '')
        ) as dbt_scd_id,
        updated_at as dbt_updated_at,
        updated_at as dbt_valid_from,
        
  
  coalesce(nullif(updated_at, updated_at), null)
  as dbt_valid_to
from (
        



select
    customer_id,
    email,
    first_name,
    last_name,
    created_at,
    updated_at
from "ecommerce_analytics"."main"."raw_customers"

    ) sbq



    );
  
  
  