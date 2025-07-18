-- Staging model for order items
-- This model cleans and standardizes raw order item data



with source_data as (
    select 
        order_item_id,
        order_id,
        product_id,
        quantity,
        unit_price_cents,
        created_at,
        updated_at
    from "ecommerce_analytics"."main"."raw_order_items"
),

cleaned as (
    select
        order_item_id,
        order_id,
        product_id,
        quantity,
        unit_price_cents,
        created_at,
        updated_at,
        
        -- Derived fields
        
    round(unit_price_cents / 100.0, 2)
 as unit_price_dollars,
        quantity * unit_price_cents as line_total_cents,
        
    round(quantity * unit_price_cents / 100.0, 2)
 as line_total_dollars,
        
        -- Data quality flags
        case 
            when order_id is null then false
            when product_id is null then false
            when quantity <= 0 then false
            when unit_price_cents <= 0 then false
            else true
        end as is_valid_order_item
        
    from source_data
)

select * from cleaned