
  
    
    

    create  table
      "ecommerce_analytics"."main"."agg_daily_sales__dbt_tmp"
  
    as (
      

-- Daily sales aggregation with inconsistent naming
with daily_orders as (
    select
        order_date::date as sales_date,  -- Different naming
        count(*) as order_count,
        sum(revenue_dollars) as total_revenue,  -- Different naming from other models
        avg(revenue_dollars) as avg_order_value,  -- Different naming
        count(distinct customer_id) as unique_customers
    from "ecommerce_analytics"."main"."fct_orders"
    where order_status_clean = 'completed'
    group by order_date::date
),

daily_payments as (
    select
        processed_at::date as payment_date,
        sum(amount_paid) as total_payments,  -- Different naming
        count(*) as payment_count,
        avg(amount_paid) as avg_payment_size  -- Different naming
    from "ecommerce_analytics"."main"."fct_payments"
    where payment_state = 'completed'  -- Different naming
    group by processed_at::date
),

combined as (
    select
        coalesce(o.sales_date, p.payment_date) as date,
        coalesce(o.order_count, 0) as orders,  -- Simplified naming
        coalesce(o.total_revenue, 0) as revenue,  -- Simplified naming
        coalesce(o.avg_order_value, 0) as aov,  -- Abbreviated naming
        coalesce(o.unique_customers, 0) as customers,  -- Simplified naming
        coalesce(p.total_payments, 0) as payments,  -- Simplified naming
        coalesce(p.payment_count, 0) as payment_transactions,  -- Different naming
        coalesce(p.avg_payment_size, 0) as avg_payment  -- Simplified naming
    from daily_orders o
    full outer join daily_payments p
        on o.sales_date = p.payment_date
)

select * from combined
    );
  
  