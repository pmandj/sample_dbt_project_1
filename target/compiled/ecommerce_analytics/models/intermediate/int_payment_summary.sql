

-- Payment summary by order with inconsistent column naming
with payment_data as (
    select
        order_id,
        method as payment_method,  -- Different from other models
        status as payment_status,
        payment_amount as total_paid,  -- Different naming
        gateway_fee,
        payment_processed_date as paid_at  -- Different naming
    from "ecommerce_analytics"."main"."stg_payments"
),

order_payments as (
    select
        order_id,
        count(*) as payment_count,
        sum(total_paid) as total_payment_amount,  -- Different naming pattern
        sum(gateway_fee) as total_fees,
        array_agg(payment_method) as payment_methods_used,
        min(paid_at) as first_payment_date,
        max(paid_at) as last_payment_date,
        
        -- Payment status logic
        case 
            when count(case when payment_status = 'completed' then 1 end) > 0 then 'paid'
            when count(case when payment_status = 'pending' then 1 end) > 0 then 'pending'
            when count(case when payment_status = 'failed' then 1 end) > 0 then 'failed'
            else 'unknown'
        end as overall_payment_status
    from payment_data
    group by order_id
)

select * from order_payments