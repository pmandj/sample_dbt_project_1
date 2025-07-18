-- Custom singular test to ensure all completed orders have positive amounts
-- This test checks data quality for order totals

select
    order_id,
    customer_id,
    order_date,
    order_status_clean,
    total_amount_dollars
from "ecommerce_analytics"."main"."stg_orders"
where order_status_clean = 'completed'
  and total_amount_dollars <= 0