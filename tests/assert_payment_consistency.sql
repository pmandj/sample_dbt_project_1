{{ config(severity = 'warn') }}

-- Test to check for inconsistencies between payment amounts and order totals
-- This test intentionally demonstrates data quality issues across different models
select
    p.order_id,
    p.amount_paid as payment_amount,  -- Different naming pattern
    o.revenue_dollars as order_total,  -- Different naming pattern
    abs(p.amount_paid - o.revenue_dollars) as amount_difference
from {{ ref('fct_payments') }} p
join {{ ref('fct_orders') }} o on p.order_id = o.order_id
where abs(p.amount_paid - o.revenue_dollars) > 0.01
    and p.payment_state = 'completed'  -- Different naming from other models
    and o.order_status_clean = 'completed'