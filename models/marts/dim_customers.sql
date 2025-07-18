-- Customer dimension table
-- This model provides the definitive customer dimension for analytics

{{ config(
    materialized='table',
    tags=['marts', 'dimensions']
) }}

with customer_history as (
    select * from {{ ref('int_customer_order_history') }}
),

final as (
    select
        customer_id,
        email,
        first_name,
        last_name,
        full_name,
        email_provider,
        customer_created_at,
        
        -- Order metrics
        total_orders,
        completed_orders,
        cancelled_orders,
        
        -- Revenue metrics
        total_revenue_dollars,
        avg_order_value_dollars,
        
        -- Customer lifetime value (simple calculation)
        case 
            when customer_lifespan_days > 0 then 
                total_revenue_dollars / nullif(customer_lifespan_days, 0) * 365
            else total_revenue_dollars
        end as estimated_annual_clv,
        
        -- Time metrics
        first_order_date,
        last_order_date,
        customer_lifespan_days,
        
        -- Product metrics
        unique_products_purchased,
        unique_categories_purchased,
        
        -- Segmentation
        customer_segment,
        customer_status,
        
        -- Enrichment fields
        case 
            when total_revenue_dollars >= 500 then 'High Value'
            when total_revenue_dollars >= 200 then 'Medium Value'
            when total_revenue_dollars > 0 then 'Low Value'
            else 'No Value'
        end as customer_value_tier,
        
        case 
            when completed_orders > 0 then 
                round(cancelled_orders * 100.0 / total_orders, 2)
            else 0
        end as cancellation_rate_percent,
        
        -- Data quality
        current_timestamp as last_updated
        
    from customer_history
)

select * from final
