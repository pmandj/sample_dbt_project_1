{{ config(severity = 'warn') }}

-- Test for customer lifetime value data quality
-- Demonstrates inconsistent customer data patterns
select
    customer_id,
    customer_name as full_name,  -- Different naming pattern
    order_count as total_orders,  -- Different naming pattern
    revenue_total as lifetime_revenue,  -- Different naming pattern
    simple_ltv as calculated_ltv,  -- Different naming pattern
    health_score as customer_health  -- Different naming pattern
from {{ ref('agg_customer_lifetime_value') }}
where simple_ltv < 0  -- Negative LTV
    or (order_count > 0 and revenue_total = 0)  -- Orders but no revenue
    or health_score > 5  -- Invalid health score