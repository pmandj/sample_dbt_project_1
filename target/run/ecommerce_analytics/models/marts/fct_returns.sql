
  
    
    

    create  table
      "ecommerce_analytics"."main"."fct_returns__dbt_tmp"
  
    as (
      

-- Returns fact table with comprehensive return analysis
with return_details as (
    select
        r.return_id,
        r.order_id,
        r.product_id,
        r.customer_id,
        r.return_date,
        r.return_reason,
        r.return_status,
        r.refund_amt as refund_amount,  -- Different naming
        r.net_refund,
        r.is_approved,
        r.return_category,
        r.days_to_return,
        r.return_timing,
        r.refund_percentage,
        r.return_severity,
        
        -- Product details
        r.product_name,
        r.product_category,
        r.product_price,
        
        -- Customer segment info
        c.segment as customer_segment,  -- Different naming
        c.value_tier as customer_tier,  -- Different naming
        c.engagement_status
    from "ecommerce_analytics"."main"."int_return_analysis" r
    left join "ecommerce_analytics"."main"."int_customer_marketing" c
        on r.customer_id = c.customer_id
),

final as (
    select
        return_id,
        order_id,
        product_id,
        customer_id,
        return_date,
        return_reason,
        return_status,
        refund_amount,
        net_refund,
        is_approved,
        return_category,
        days_to_return,
        return_timing,
        refund_percentage,
        return_severity,
        product_name,
        product_category,
        product_price,
        customer_segment,
        customer_tier,
        engagement_status,
        
        -- Financial impact calculations
        case when is_approved then refund_amount else 0 end as actual_refund,
        product_price - refund_amount as revenue_retained,
        
        -- Return impact score
        case 
            when return_severity = 'high' and refund_percentage > 0.8 then 5
            when return_severity = 'high' and refund_percentage > 0.5 then 4
            when return_severity = 'medium' and refund_percentage > 0.8 then 4
            when return_severity = 'medium' and refund_percentage > 0.5 then 3
            when return_severity = 'low' and refund_percentage > 0.5 then 2
            else 1
        end as impact_score,
        
        -- Customer satisfaction indicator
        case 
            when return_timing = 'immediate' and return_category = 'quality_issue' then 'very_dissatisfied'
            when return_timing in ('immediate', 'short_term') and return_severity = 'high' then 'dissatisfied'
            when return_category = 'buyer_remorse' then 'neutral'
            else 'satisfied'
        end as satisfaction_indicator,
        
        current_timestamp as processed_at
    from return_details
)

select * from final
    );
  
  