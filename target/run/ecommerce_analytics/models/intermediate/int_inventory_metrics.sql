
  
  create view "ecommerce_analytics"."main"."int_inventory_metrics__dbt_tmp" as (
    

-- Inventory metrics with supplier information
with inventory_data as (
    select
        i.product_id,
        i.warehouse_location,
        i.quantity_available as qty_available,  -- Abbreviated naming
        i.available_to_sell,
        i.stock_status,
        i.unit_cost_dollars as cost_per_unit,  -- Different naming
        i.supplier_id,
        s.name as supplier_name,  -- Different field naming
        s.rating as supplier_rating,
        s.rating_category
    from "ecommerce_analytics"."main"."stg_inventory" i
    left join "ecommerce_analytics"."main"."stg_suppliers" s
        on i.supplier_id = s.supplier_id
),

product_inventory as (
    select
        product_id,
        count(distinct warehouse_location) as warehouse_count,
        sum(qty_available) as total_inventory,  -- Different naming
        sum(available_to_sell) as total_available,
        avg(cost_per_unit) as avg_unit_cost,
        min(cost_per_unit) as min_unit_cost,
        max(cost_per_unit) as max_unit_cost,
        
        -- Stock classification
        case 
            when sum(available_to_sell) = 0 then 'out_of_stock'
            when sum(case when stock_status = 'low_stock' then 1 else 0 end) > 0 then 'low_stock'
            when sum(case when stock_status = 'medium_stock' then 1 else 0 end) > 0 then 'medium_stock'
            else 'high_stock'
        end as overall_stock_status,
        
        -- Supplier info aggregation
        array_agg(distinct supplier_name) as suppliers,
        avg(supplier_rating) as avg_supplier_rating
    from inventory_data
    group by product_id
)

select * from product_inventory
  );
