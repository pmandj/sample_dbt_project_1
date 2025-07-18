-- Analysis: Monthly Sales Trends
-- This analysis shows sales performance over time with various metrics

with monthly_sales as (
    select
        order_year,
        order_month,
        count(distinct order_id) as total_orders,
        count(distinct customer_id) as unique_customers,
        sum(revenue_dollars) as total_revenue,
        avg(revenue_dollars) as avg_order_value,
        sum(total_items) as total_items_sold
    from "ecommerce_analytics"."main"."fct_orders"
    where is_completed_order = true
    group by order_year, order_month
),

monthly_trends as (
    select
        order_year,
        order_month,
        date(order_year || '-' || lpad(order_month::text, 2, '0') || '-01') as month_date,
        total_orders,
        unique_customers,
        total_revenue,
        avg_order_value,
        total_items_sold,
        
        -- Month-over-month growth
        lag(total_revenue) over (order by order_year, order_month) as prev_month_revenue,
        lag(total_orders) over (order by order_year, order_month) as prev_month_orders,
        
        -- Customer metrics
        round(total_revenue / nullif(unique_customers, 0), 2) as revenue_per_customer,
        round(total_orders::float / nullif(unique_customers, 0), 2) as orders_per_customer
    from monthly_sales
),

final as (
    select
        order_year,
        order_month,
        month_date,
        total_orders,
        unique_customers,
        round(total_revenue, 2) as total_revenue,
        round(avg_order_value, 2) as avg_order_value,
        total_items_sold,
        revenue_per_customer,
        orders_per_customer,
        
        -- Growth calculations
        case 
            when prev_month_revenue is not null and prev_month_revenue > 0 then
                round((total_revenue - prev_month_revenue) / prev_month_revenue * 100, 2)
            else null
        end as revenue_growth_percent,
        
        case 
            when prev_month_orders is not null and prev_month_orders > 0 then
                round((total_orders - prev_month_orders) / prev_month_orders::float * 100, 2)
            else null
        end as order_growth_percent
        
    from monthly_trends
)

select * from final
order by order_year, order_month