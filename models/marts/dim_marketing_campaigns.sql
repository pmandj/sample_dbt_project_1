{{
  config(
    materialized='table'
  )
}}

-- Marketing campaign dimension with performance categorization
select
    campaign_id,
    campaign_name,
    marketing_channel as channel,  -- Different naming
    campaign_days as duration_days,  -- Different naming
    budget_amount,
    performance_grade,
    efficiency_category,
    performance_score,
    
    -- Campaign classification
    case 
        when marketing_channel = 'email' then 'direct_marketing'
        when marketing_channel = 'social_media' then 'social_marketing'
        when marketing_channel = 'paid_search' then 'search_marketing'
        else 'other_marketing'
    end as campaign_type,
    
    current_timestamp as dim_created_at
from {{ ref('fct_marketing_performance') }}