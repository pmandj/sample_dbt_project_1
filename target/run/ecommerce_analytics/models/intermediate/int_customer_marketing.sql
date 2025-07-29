
  
  create view "ecommerce_analytics"."main"."int_customer_marketing__dbt_tmp" as (
    

-- Customer marketing data with segment analysis
with customer_segments as (
    select
        customer_id,
        customer_segment as segment,  -- Different naming
        acquisition_channel,
        ltv_tier as value_tier,  -- Different naming
        risk_score_numeric as risk_level,  -- Different naming
        communication_pref as preferred_contact,  -- Different naming
        days_since_engagement
    from "ecommerce_analytics"."main"."stg_customer_segments"
),

customer_data as (
    select
        c.customer_id,
        c.email,
        c.full_name,
        cs.segment,
        cs.acquisition_channel,
        cs.value_tier,
        cs.risk_level,
        cs.preferred_contact,
        cs.days_since_engagement,
        
        -- Engagement status
        case 
            when cs.days_since_engagement <= 7 then 'highly_engaged'
            when cs.days_since_engagement <= 30 then 'engaged'
            when cs.days_since_engagement <= 90 then 'at_risk'
            else 'inactive'
        end as engagement_status,
        
        -- Customer score calculation
        case 
            when cs.value_tier = 'high' and cs.risk_level = 1 then 5
            when cs.value_tier = 'high' and cs.risk_level = 2 then 4
            when cs.value_tier = 'medium' and cs.risk_level = 1 then 4
            when cs.value_tier = 'medium' and cs.risk_level = 2 then 3
            when cs.value_tier = 'low' and cs.risk_level = 1 then 3
            when cs.value_tier = 'low' and cs.risk_level = 2 then 2
            else 1
        end as customer_score
    from "ecommerce_analytics"."main"."stg_customers" c
    left join customer_segments cs
        on c.customer_id = cs.customer_id
)

select * from customer_data
  );
