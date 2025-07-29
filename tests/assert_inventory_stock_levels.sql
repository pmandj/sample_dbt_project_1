{{ config(severity = 'error') }}

-- Test to ensure inventory levels are not negative
-- Demonstrates different column naming patterns across models
select
    inventory_id,
    product_id,
    location as warehouse,  -- Different naming pattern
    available_qty as stock_quantity,  -- Different naming pattern
    reserved_qty as reserved_stock  -- Different naming pattern
from {{ ref('fct_inventory') }}
where available_qty < 0
    or reserved_qty < 0
    or sellable_qty < 0  -- Different naming pattern