{{ config(severity = 'warn') }}

-- Test to validate marketing campaign ROI calculations
-- Shows inconsistent metric naming across models
select
    campaign_id,
    campaign_name,
    actual_spend as campaign_spend,  -- Different naming pattern
    conversions as total_conversions,  -- Different naming pattern
    roi as calculated_roi,  -- Different naming pattern
    efficiency_category as performance_tier  -- Different naming pattern
from {{ ref('fct_marketing_performance') }}
where roi > 10  -- Unrealistic ROI values
    or (actual_spend > 0 and conversions = 0)  -- Spend with no conversions