-- Product dimension table
-- This model provides the definitive product dimension for analytics

with products as (
    select * from {{ ref('stg_products') }}
    where is_valid_product = true
),

product_performance as (
    select
        product_id,
        count(distinct order_id) as total_orders,
        sum(quantity) as total_quantity_sold,
        sum(revenue_dollars) as total_revenue,
        avg(revenue_dollars) as avg_revenue_per_order,
        count(distinct customer_id) as unique_customers
    from {{ ref('int_order_items_enhanced') }}
    where is_completed_order = true
    group by product_id
),

final as (
    select
        p.product_id,
        p.product_name,
        p.category,
        p.category_clean,
        p.price_cents,
        p.price_dollars,
        p.price_tier,
        p.created_at as product_created_at,
        p.updated_at as product_updated_at,
        
        -- Performance metrics
        coalesce(pp.total_orders, 0) as total_orders,
        coalesce(pp.total_quantity_sold, 0) as total_quantity_sold,
        coalesce(pp.total_revenue, 0) as total_revenue,
        coalesce(pp.avg_revenue_per_order, 0) as avg_revenue_per_order,
        coalesce(pp.unique_customers, 0) as unique_customers,
        
        -- Performance flags
        case 
            when pp.total_orders >= 5 then 'High Performer'
            when pp.total_orders >= 2 then 'Medium Performer'
            when pp.total_orders >= 1 then 'Low Performer'
            else 'No Sales'
        end as performance_tier,
        
        case 
            when pp.total_revenue > 0 then 
                round(pp.total_revenue / pp.total_quantity_sold, 2)
            else 0
        end as avg_selling_price,
        
        -- Data quality
        current_timestamp as last_updated
        
    from products p
    left join product_performance pp on p.product_id = pp.product_id
)

select * from final
