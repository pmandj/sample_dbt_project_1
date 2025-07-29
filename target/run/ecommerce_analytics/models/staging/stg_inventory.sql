
  
  create view "ecommerce_analytics"."main"."stg_inventory__dbt_tmp" as (
    

with source_data as (
    select
        inventory_id,
        product_id,
        warehouse_location,
        quantity_available,
        reserved_quantity,
        reorder_level,
        last_restocked::date as last_restock_date,
        supplier_id,
        cost_per_unit_cents
    from "ecommerce_analytics"."main"."raw_inventory"
),

calculated as (
    select
        *,
        quantity_available - reserved_quantity as available_to_sell,
        case 
            when quantity_available <= reorder_level then 'low_stock'
            when quantity_available <= (reorder_level * 2) then 'medium_stock'
            else 'high_stock'
        end as stock_status,
        
        -- Inconsistent currency handling - using different field name
        
    round(cost_per_unit_cents / 100.0, 2)
 as unit_cost_dollars
    from source_data
)

select * from calculated
  );
