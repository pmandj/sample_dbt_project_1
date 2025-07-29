
  
  create view "ecommerce_analytics"."main"."stg_marketing_campaigns__dbt_tmp" as (
    

with source_data as (
    select
        campaign_id,
        campaign_name,
        channel as marketing_channel,  -- Different naming convention
        start_date::date as campaign_start,
        end_date::date as campaign_end,
        budget_dollars,
        spend_dollars as actual_spend,  -- Different naming
        impressions,
        clicks,
        conversions,
        target_audience
    from "ecommerce_analytics"."main"."raw_marketing_campaigns"
),

metrics as (
    select
        *,
        campaign_end - campaign_start as campaign_duration_days,
        actual_spend / budget_dollars as budget_utilization,
        
        -- Different calculation approach than other models
        case when impressions > 0 then clicks::float / impressions else 0 end as ctr,
        case when clicks > 0 then conversions::float / clicks else 0 end as conversion_rate,
        case when conversions > 0 then actual_spend / conversions else 0 end as cost_per_conversion,
        
        case 
            when actual_spend > budget_dollars then 'over_budget'
            when actual_spend >= budget_dollars * 0.9 then 'on_budget'
            else 'under_budget'
        end as budget_status
    from source_data
)

select * from metrics
  );
