-- Staging model for customers
-- This model cleans and standardizes raw customer data



with source_data as (
    select 
        customer_id,
        email,
        first_name,
        last_name,
        created_at,
        updated_at
    from "ecommerce_analytics"."main"."raw_customers"
),

cleaned as (
    select
        customer_id,
        lower(trim(email)) as email,
        trim(first_name) as first_name,
        trim(last_name) as last_name,
        created_at,
        updated_at,
        
        -- Derived fields
        concat(trim(first_name), ' ', trim(last_name)) as full_name,
        case 
            when email like '%@gmail.com' then 'Gmail'
            when email like '%@yahoo.com' then 'Yahoo'
            when email like '%@hotmail.com' then 'Hotmail'
            when email like '%@outlook.com' then 'Outlook'
            else 'Other'
        end as email_provider,
        
        -- Data quality flags
        case 
            when first_name is null or first_name = '' then false
            when last_name is null or last_name = '' then false
            when email is null or email = '' then false
            when email not like '%@%' then false
            else true
        end as is_valid_customer
        
    from source_data
)

select * from cleaned