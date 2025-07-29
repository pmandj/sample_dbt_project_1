{{
  config(
    materialized='table',
    pre_hook="{{ log('Building fact table: ' ~ this, info=true) }}",
    post_hook="{{ log('Completed fact table: ' ~ this, info=true) }}"
  )
}}

-- Inventory fact table with supplier and product information
with inventory_details as (
    select
        i.inventory_id,
        i.product_id,
        i.warehouse_location as location,  -- Simplified naming
        i.quantity_available as available_qty,  -- Different naming pattern
        i.reserved_quantity as reserved_qty,
        i.available_to_sell as sellable_qty,  -- Different naming
        i.stock_status,
        i.unit_cost_dollars as unit_cost,  -- Different naming
        i.supplier_id,
        
        -- Product information
        p.product_name,
        p.category as product_category,  -- Different naming
        p.price_dollars as selling_price,  -- Different naming
        
        -- Supplier information
        s.supplier_name,
        s.rating as supplier_rating,
        s.supplier_tier
    from {{ ref('stg_inventory') }} i
    left join {{ ref('stg_products') }} p
        on i.product_id = p.product_id
    left join {{ ref('dim_suppliers') }} s
        on i.supplier_id = s.supplier_id
),

final as (
    select
        inventory_id,
        product_id,
        location,
        available_qty,
        reserved_qty,
        sellable_qty,
        stock_status,
        unit_cost,
        supplier_id,
        product_name,
        product_category,
        selling_price,
        supplier_name,
        supplier_rating,
        supplier_tier,
        
        -- Financial metrics
        available_qty * unit_cost as inventory_value,
        selling_price - unit_cost as potential_margin,
        (selling_price - unit_cost) / selling_price as margin_percentage,
        
        -- Inventory turn indicators
        case 
            when sellable_qty = 0 then 'out_of_stock'
            when sellable_qty <= 5 then 'critical'
            when sellable_qty <= 20 then 'low'
            else 'adequate'
        end as inventory_level,
        
        current_date as snapshot_date
    from inventory_details
)

select * from final