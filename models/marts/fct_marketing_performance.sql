{{
  config(
    materialized='table',
    pre_hook="{{ log('Building fact table: ' ~ this, info=true) }}",
    post_hook="{{ log('Completed fact table: ' ~ this, info=true) }}"
  )
}}

-- Marketing performance fact with campaign details
with campaign_metrics as (
    select
        campaign_id,
        campaign_name,
        channel as marketing_channel,  -- Different naming
        duration as campaign_days,  -- Different naming
        budget as budget_amount,  -- Different naming
        spend as actual_spend,  -- Different naming
        impressions,
        clicks,
        conversions,
        ctr as click_through_rate,  -- Different naming
        conv_rate as conversion_rate,  -- Different naming
        cpc as cost_per_conversion,  -- Different naming
        estimated_roi as roi,  -- Different naming
        performance_grade,
        channel_effectiveness,
        budget_status
    from {{ ref('int_campaign_performance') }}
),

final as (
    select
        campaign_id,
        campaign_name,
        marketing_channel,
        campaign_days,
        budget_amount,
        actual_spend,
        impressions,
        clicks,
        conversions,
        click_through_rate,
        conversion_rate,
        cost_per_conversion,
        roi,
        performance_grade,
        channel_effectiveness,
        budget_status,
        
        -- Additional calculated metrics
        budget_amount - actual_spend as budget_remaining,
        actual_spend / campaign_days as daily_spend,
        conversions / campaign_days as daily_conversions,
        
        -- Performance scoring
        case 
            when performance_grade = 'excellent' then 5
            when performance_grade = 'good' then 4
            when performance_grade = 'average' then 3
            when performance_grade = 'poor' then 2
            else 1
        end as performance_score,
        
        -- Campaign efficiency
        case 
            when roi > 1.5 and performance_grade in ('excellent', 'good') then 'highly_efficient'
            when roi > 0.5 and performance_grade in ('good', 'average') then 'efficient'
            when roi > 0 then 'marginally_profitable'
            else 'unprofitable'
        end as efficiency_category,
        
        current_timestamp as analysis_date
    from campaign_metrics
)

select * from final