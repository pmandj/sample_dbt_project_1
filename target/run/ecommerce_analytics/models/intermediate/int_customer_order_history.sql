
  
    
    

    create  table
      "ecommerce_analytics"."main"."int_customer_order_history__dbt_tmp"
  
    as (
      -- Intermediate model that aggregates customer order history
-- This model provides customer-level metrics and segments



with customers as (
    select * from "ecommerce_analytics"."main"."stg_customers"
    where is_valid_customer = true
),

orders as (
    select * from "ecommerce_analytics"."main"."stg_orders"
    where is_valid_order = true
),

order_items as (
    select * from "ecommerce_analytics"."main"."int_order_items_enhanced"
),

customer_orders as (
    select
        c.customer_id,
        c.email,
        c.first_name,
        c.last_name,
        c.full_name,
        c.email_provider,
        c.created_at as customer_created_at,
        
        -- Order counts
        count(distinct o.order_id) as total_orders,
        count(distinct case when o.is_completed_order then o.order_id end) as completed_orders,
        count(distinct case when o.order_status_clean = 'cancelled' then o.order_id end) as cancelled_orders,
        
        -- Revenue metrics
        sum(case when o.is_completed_order then o.total_amount_dollars else 0 end) as total_revenue_dollars,
        avg(case when o.is_completed_order then o.total_amount_dollars end) as avg_order_value_dollars,
        
        -- Time-based metrics
        min(o.order_date) as first_order_date,
        max(o.order_date) as last_order_date,
        max(o.order_date) - min(o.order_date) as customer_lifespan_days,
        
        -- Product diversity
        count(distinct oi.product_id) as unique_products_purchased,
        count(distinct oi.category_clean) as unique_categories_purchased,
        
        -- Behavioral flags
        case 
            when count(distinct o.order_id) = 1 then 'One-time'
            when count(distinct o.order_id) between 2 and 5 then 'Occasional'
            when count(distinct o.order_id) > 5 then 'Frequent'
            else 'Unknown'
        end as customer_segment,
        
        case 
            when max(o.order_date) >= current_date - interval '90 days' then 'Active'
            when max(o.order_date) >= current_date - interval '365 days' then 'Dormant'
            else 'Inactive'
        end as customer_status
        
    from customers c
    left join orders o on c.customer_id = o.customer_id
    left join order_items oi on o.order_id = oi.order_id
    
    group by 1, 2, 3, 4, 5, 6, 7
)

select * from customer_orders
    );
  
  