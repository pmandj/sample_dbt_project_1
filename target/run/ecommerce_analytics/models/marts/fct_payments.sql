
  
    
    

    create  table
      "ecommerce_analytics"."main"."fct_payments__dbt_tmp"
  
    as (
      

-- Payment fact table with inconsistent column naming
with payment_details as (
    select
        p.payment_id,
        p.order_id,
        p.method as payment_type,  -- Different naming
        p.status as payment_state,  -- Different naming
        p.payment_amount as amount_paid,  -- Different naming
        p.gateway_fee as fee_amount,  -- Different naming
        p.currency_code,
        p.payment_processed_date as processed_at,  -- Different naming
        
        -- Order information
        o.customer_id,
        o.order_date,
        o.order_status_clean as order_state,  -- Different naming
        
        -- Customer information
        c.segment as customer_segment,  -- Different naming pattern
        c.acquisition_channel
    from "ecommerce_analytics"."main"."stg_payments" p
    left join "ecommerce_analytics"."main"."stg_orders" o
        on p.order_id = o.order_id
    left join "ecommerce_analytics"."main"."int_customer_marketing" c
        on o.customer_id = c.customer_id
),

final as (
    select
        payment_id,
        order_id,
        customer_id,
        payment_type,
        payment_state,
        amount_paid,
        fee_amount,
        currency_code,
        processed_at,
        order_date,
        order_state,
        customer_segment,
        acquisition_channel,
        
        -- Payment success flag
        case when payment_state = 'completed' then 1 else 0 end as is_successful,
        
        -- Net amount after fees
        amount_paid - fee_amount as net_amount,
        
        -- Payment timing
        case 
            when processed_at = order_date then 'same_day'
            when processed_at <= order_date + interval '1 day' then 'next_day'
            else 'delayed'
        end as payment_timing,
        
        current_timestamp as record_created_at
    from payment_details
)

select * from final
    );
  
  