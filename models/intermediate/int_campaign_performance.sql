{{
  config(
    materialized='view'
  )
}}

-- Campaign performance analysis with inconsistent metrics
with campaign_data as (
    select
        campaign_id,
        campaign_name,
        marketing_channel as channel,  -- Different naming
        campaign_duration_days as duration,  -- Different naming
        budget_dollars as budget,  -- Simplified naming
        actual_spend as spend,  -- Different naming
        impressions,
        clicks,
        conversions,
        ctr,
        conversion_rate as conv_rate,  -- Abbreviated naming
        cost_per_conversion as cpc,  -- Abbreviated naming
        budget_status
    from {{ ref('stg_marketing_campaigns') }}
),

performance_metrics as (
    select
        *,
        -- ROI calculation (simplified)
        case 
            when spend > 0 then (conversions * 50 - spend) / spend  -- Assuming $50 average order value
            else 0
        end as estimated_roi,
        
        -- Performance grade
        case 
            when conv_rate >= 0.05 and cpc <= 20 then 'excellent'
            when conv_rate >= 0.03 and cpc <= 30 then 'good'
            when conv_rate >= 0.02 and cpc <= 50 then 'average'
            else 'poor'
        end as performance_grade,
        
        -- Channel effectiveness
        case 
            when channel = 'email' and ctr >= 0.05 then 'high_performing'
            when channel = 'social_media' and ctr >= 0.03 then 'high_performing'
            when channel = 'paid_search' and ctr >= 0.02 then 'high_performing'
            else 'standard'
        end as channel_effectiveness
    from campaign_data
)

select * from performance_metrics