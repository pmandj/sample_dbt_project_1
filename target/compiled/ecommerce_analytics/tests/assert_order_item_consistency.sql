-- Custom singular test to check order item consistency
-- This test validates that order totals match sum of line items

with order_totals as (
    select
        order_id,
        total_amount_dollars
    from "ecommerce_analytics"."main"."stg_orders"
    where is_completed_order = true
),

line_item_totals as (
    select
        order_id,
        sum(line_total_dollars) as calculated_total
    from "ecommerce_analytics"."main"."stg_order_items"
    where is_valid_order_item = true
    group by order_id
),

comparison as (
    select
        ot.order_id,
        ot.total_amount_dollars as order_total,
        lit.calculated_total as line_items_total,
        abs(ot.total_amount_dollars - lit.calculated_total) as difference
    from order_totals ot
    inner join line_item_totals lit on ot.order_id = lit.order_id
)

select
    order_id,
    order_total,
    line_items_total,
    difference
from comparison
where difference > 0.01  -- Allow for small rounding differences