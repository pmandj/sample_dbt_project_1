

-- Staging model for payment data with inconsistent naming conventions
with source_data as (
    select
        payment_id,
        order_id,
        payment_method as method,  -- Different naming than other models
        payment_status as status,  -- Different naming than other models
        amount_cents,
        currency_code,
        processed_at::timestamp as payment_processed_date,  -- Different naming pattern
        gateway_fee_cents,
        created_at::timestamp as payment_created_at
    from "ecommerce_analytics"."main"."raw_payments"
),

final as (
    select
        payment_id,
        order_id,
        method,
        status,
        
        -- Inconsistent currency conversion - using different logic than other models
        round(amount_cents / 100.0, 2) as payment_amount,  -- Not using macro
        round(gateway_fee_cents / 100.0, 2) as gateway_fee,
        
        currency_code,
        payment_processed_date,
        payment_created_at
    from source_data
)

select * from final