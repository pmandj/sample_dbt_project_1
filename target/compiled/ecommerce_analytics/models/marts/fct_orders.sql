-- Orders fact table
-- This model provides order-level facts for analytics



with orders as (
    select * from "ecommerce_analytics"."main"."stg_orders"
    where is_valid_order = true
),

order_items_agg as (
    select
        order_id,
        count(*) as total_items,
        sum(quantity) as total_quantity,
        sum(line_total_dollars) as calculated_total_dollars,
        count(distinct product_id) as unique_products,
        count(distinct category_clean) as unique_categories
    from "ecommerce_analytics"."main"."int_order_items_enhanced"
    group by order_id
),

final as (
    select
        o.order_id,
        o.customer_id,
        o.order_date,
        o.status,
        o.order_status_clean,
        o.total_amount_cents,
        o.total_amount_dollars,
        o.order_year,
        o.order_month,
        o.order_day,
        o.order_day_of_week,
        o.is_completed_order,
        o.created_at as order_created_at,
        o.updated_at as order_updated_at,
        
        -- Order item aggregations
        coalesce(oia.total_items, 0) as total_items,
        coalesce(oia.total_quantity, 0) as total_quantity,
        coalesce(oia.calculated_total_dollars, 0) as calculated_total_dollars,
        coalesce(oia.unique_products, 0) as unique_products,
        coalesce(oia.unique_categories, 0) as unique_categories,
        
        -- Data quality checks
        case 
            when abs(o.total_amount_dollars - coalesce(oia.calculated_total_dollars, 0)) <= 0.01 
            then true
            else false
        end as totals_match,
        
        -- Business logic
        case 
            when o.is_completed_order then o.total_amount_dollars
            else 0
        end as revenue_dollars,
        
        case 
            when coalesce(oia.unique_products, 0) > 3 then 'Large Basket'
            when coalesce(oia.unique_products, 0) > 1 then 'Medium Basket'
            when coalesce(oia.unique_products, 0) = 1 then 'Single Item'
            else 'Empty Basket'
        end as basket_size_category,
        
        -- Time-based attributes
        case 
            when o.order_day_of_week in (1, 7) then 'Weekend'
            else 'Weekday'
        end as weekend_flag,
        
        -- Data quality
        current_timestamp as last_updated
        
    from orders o
    left join order_items_agg oia on o.order_id = oia.order_id
    
    
        where o.updated_at > (select max(order_updated_at) from "ecommerce_analytics"."main"."fct_orders")
    
)

select * from final