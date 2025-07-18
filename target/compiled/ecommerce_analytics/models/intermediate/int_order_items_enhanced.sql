-- Intermediate model that enriches order items with product and order information
-- This model joins order items with product and order data for analysis



with order_items as (
    select * from "ecommerce_analytics"."main"."stg_order_items"
    where is_valid_order_item = true
),

products as (
    select * from "ecommerce_analytics"."main"."stg_products"
    where is_valid_product = true
),

orders as (
    select * from "ecommerce_analytics"."main"."stg_orders"
    where is_valid_order = true
),

enhanced_order_items as (
    select
        oi.order_item_id,
        oi.order_id,
        oi.product_id,
        oi.quantity,
        oi.unit_price_cents,
        oi.unit_price_dollars,
        oi.line_total_cents,
        oi.line_total_dollars,
        oi.created_at as order_item_created_at,
        
        -- Product information
        p.product_name,
        p.category,
        p.category_clean,
        p.price_cents as product_list_price_cents,
        p.price_dollars as product_list_price_dollars,
        p.price_tier,
        
        -- Order information
        o.customer_id,
        o.order_date,
        o.order_status_clean,
        o.total_amount_cents as order_total_cents,
        o.total_amount_dollars as order_total_dollars,
        o.order_year,
        o.order_month,
        o.is_completed_order,
        
        -- Derived metrics
        oi.unit_price_cents - p.price_cents as price_discount_cents,
        oi.unit_price_dollars - p.price_dollars as price_discount_dollars,
        
        case 
            when p.price_cents > 0 then 
                round(((p.price_cents - oi.unit_price_cents) * 100.0) / p.price_cents, 2)
            else 0
        end as discount_percentage,
        
        -- Revenue attribution
        case 
            when o.is_completed_order then oi.line_total_dollars
            else 0
        end as revenue_dollars,
        
        -- Product performance flags
        case 
            when oi.unit_price_cents < p.price_cents then true
            else false
        end as is_discounted,
        
        case 
            when oi.quantity > 1 then true
            else false
        end as is_multi_quantity
        
    from order_items oi
    inner join products p on oi.product_id = p.product_id
    inner join orders o on oi.order_id = o.order_id
)

select * from enhanced_order_items