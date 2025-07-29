
  
  create view "ecommerce_analytics"."main"."stg_customer_segments__dbt_tmp" as (
    

with source_data as (
    select
        customer_id,
        segment as customer_segment,  -- Different naming pattern
        acquisition_channel,
        lifetime_value_tier as ltv_tier,  -- Abbreviated naming
        risk_score,
        last_engagement_date::date as last_engaged,  -- Different date naming
        preferred_communication as communication_pref
    from "ecommerce_analytics"."main"."raw_customer_segments"
),

final as (
    select
        customer_id,
        customer_segment,
        acquisition_channel,
        ltv_tier,
        risk_score,
        last_engaged,
        communication_pref,
        
        -- Risk categorization
        case 
            when risk_score = 'low' then 1
            when risk_score = 'medium' then 2
            when risk_score = 'high' then 3
            else 0
        end as risk_score_numeric,
        
        current_date - last_engaged as days_since_engagement
    from source_data
)

select * from final
  );
