
  
  create view "ecommerce_analytics"."main"."stg_orders__dbt_tmp" as (
    -- Staging model for orders
-- This model cleans and standardizes raw order data



with source_data as (
    select 
        order_id,
        customer_id,
        order_date,
        status,
        total_amount_cents,
        created_at,
        updated_at
    from "ecommerce_analytics"."main"."raw_orders"
),

cleaned as (
    select
        order_id,
        customer_id,
        order_date,
        lower(trim(status)) as status,
        total_amount_cents,
        created_at,
        updated_at,
        
        -- Derived fields
        
    round(total_amount_cents / 100.0, 2)
 as total_amount_dollars,
        
        case 
            when lower(trim(status)) = 'completed' then 'completed'
            when lower(trim(status)) = 'pending' then 'pending'
            when lower(trim(status)) = 'cancelled' then 'cancelled'
            when lower(trim(status)) = 'refunded' then 'refunded'
            else 'unknown'
        end as order_status_clean,
        
        case 
            when lower(trim(status)) = 'completed' then true
            else false
        end as is_completed_order,
        
        -- Time-based fields
        extract(year from order_date) as order_year,
        extract(month from order_date) as order_month,
        extract(day from order_date) as order_day,
        extract(dayofweek from order_date) as order_day_of_week,
        
        -- Data quality flags
        case 
            when order_date is null then false
            when customer_id is null then false
            when total_amount_cents < 0 then false
            else true
        end as is_valid_order
        
    from source_data
)

select * from cleaned
  );
