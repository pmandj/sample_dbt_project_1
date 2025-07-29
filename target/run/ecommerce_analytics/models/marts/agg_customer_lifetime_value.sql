
  
    
    

    create  table
      "ecommerce_analytics"."main"."agg_customer_lifetime_value__dbt_tmp"
  
    as (
      

-- Customer lifetime value calculation with multiple approaches
with customer_orders as (
    select
        customer_id,
        count(*) as total_orders,
        sum(revenue_dollars) as lifetime_revenue,  -- Different naming
        avg(revenue_dollars) as avg_order_amount,  -- Different naming
        min(order_date) as first_order_date,
        max(order_date) as last_order_date
    from "ecommerce_analytics"."main"."fct_orders"
    where order_status_clean = 'completed'
    group by customer_id
),

customer_payments as (
    select
        customer_id,
        sum(amount_paid) as total_paid,  -- Different naming
        sum(fee_amount) as total_fees_paid,  -- Different naming
        count(distinct payment_type) as payment_methods_used  -- Different naming
    from "ecommerce_analytics"."main"."fct_payments"
    where payment_state = 'completed'  -- Different naming
    group by customer_id
),

customer_returns as (
    select
        customer_id,
        count(*) as return_incidents,  -- Different naming
        sum(refund_amount) as total_returned,  -- Different naming
        avg(impact_score) as avg_return_impact  -- Different naming
    from "ecommerce_analytics"."main"."fct_returns"
    where is_approved = true
    group by customer_id
),

final as (
    select
        c.customer_id,
        c.full_name as customer_name,  -- Different naming
        c.email as contact_email,  -- Different naming
        c.total_orders as order_count,  -- Different naming
        c.total_revenue_dollars as revenue_total,  -- Different naming
        
        m.segment as customer_type,  -- Different naming
        m.value_tier as tier,  -- Simplified naming
        m.engagement_status as status,  -- Simplified naming
        m.customer_score as score,  -- Simplified naming
        
        coalesce(p.total_paid, 0) as payment_total,  -- Different naming
        coalesce(p.total_fees_paid, 0) as fees_paid,  -- Different naming
        coalesce(p.payment_methods_used, 0) as payment_variety,  -- Different naming
        
        coalesce(r.return_incidents, 0) as returns_made,  -- Different naming
        coalesce(r.total_returned, 0) as refunds_received,  -- Different naming
        coalesce(r.avg_return_impact, 0) as return_impact_avg,  -- Different naming
        
        -- LTV calculations
        c.total_revenue_dollars as simple_ltv,  -- Different naming
        c.total_revenue_dollars - coalesce(r.total_returned, 0) as net_ltv,  -- Different naming
        case when c.total_orders > 0 then c.total_revenue_dollars / c.total_orders else 0 end as ltv_per_order,
        
        -- Customer tenure
        current_date - c.first_order_date as customer_age_days,
        c.last_order_date - c.first_order_date as active_period_days,
        
        -- Customer health score
        case 
            when c.total_orders >= 10 and c.total_revenue_dollars >= 1000 and coalesce(r.return_incidents, 0) <= 2 then 5
            when c.total_orders >= 5 and c.total_revenue_dollars >= 500 and coalesce(r.return_incidents, 0) <= 3 then 4
            when c.total_orders >= 3 and c.total_revenue_dollars >= 200 then 3
            when c.total_orders >= 1 and c.total_revenue_dollars >= 50 then 2
            else 1
        end as health_score
    from "ecommerce_analytics"."main"."dim_customers" c
    left join "ecommerce_analytics"."main"."int_customer_marketing" m on c.customer_id = m.customer_id
    left join customer_payments p on c.customer_id = p.customer_id
    left join customer_returns r on c.customer_id = r.customer_id
)

select * from final
    );
  
  