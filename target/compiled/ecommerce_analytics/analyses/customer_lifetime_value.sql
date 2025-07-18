-- Analysis: Customer Lifetime Value Calculation
-- This analysis provides insights into customer value and retention

with customer_metrics as (
    select
        customer_id,
        full_name,
        email,
        customer_segment,
        customer_value_tier,
        total_orders,
        total_revenue_dollars,
        avg_order_value_dollars,
        first_order_date,
        last_order_date,
        customer_lifespan_days,
        estimated_annual_clv
    from "ecommerce_analytics"."main"."dim_customers"
    where total_orders > 0
),

clv_analysis as (
    select
        customer_segment,
        customer_value_tier,
        count(*) as customer_count,
        avg(total_revenue_dollars) as avg_total_revenue,
        avg(avg_order_value_dollars) as avg_order_value,
        avg(total_orders) as avg_orders_per_customer,
        avg(customer_lifespan_days) as avg_lifespan_days,
        avg(estimated_annual_clv) as avg_annual_clv,
        sum(total_revenue_dollars) as total_segment_revenue
    from customer_metrics
    group by customer_segment, customer_value_tier
),

final as (
    select
        customer_segment,
        customer_value_tier,
        customer_count,
        round(avg_total_revenue, 2) as avg_total_revenue,
        round(avg_order_value, 2) as avg_order_value,
        round(avg_orders_per_customer, 1) as avg_orders_per_customer,
        round(avg_lifespan_days, 0) as avg_lifespan_days,
        round(avg_annual_clv, 2) as avg_annual_clv,
        round(total_segment_revenue, 2) as total_segment_revenue,
        round(total_segment_revenue / sum(total_segment_revenue) over() * 100, 2) as revenue_percentage
    from clv_analysis
)

select * from final
order by total_segment_revenue desc