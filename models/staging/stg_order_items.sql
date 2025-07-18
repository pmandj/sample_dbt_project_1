-- Staging model for order items
-- This model cleans and standardizes raw order item data

{{ config(
    materialized='view',
    tags=['staging', 'order_items']
) }}

with source_data as (
    select 
        order_item_id,
        order_id,
        product_id,
        quantity,
        unit_price_cents,
        created_at,
        updated_at
    from {{ ref('raw_order_items') }}
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
        {{ cents_to_dollars('unit_price_cents') }} as unit_price_dollars,
        quantity * unit_price_cents as line_total_cents,
        {{ cents_to_dollars('quantity * unit_price_cents') }} as line_total_dollars,
        
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
