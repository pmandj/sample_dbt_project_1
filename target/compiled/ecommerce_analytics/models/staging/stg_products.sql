-- Staging model for products
-- This model cleans and standardizes raw product data

with source_data as (
    select 
        product_id,
        product_name,
        category,
        price_cents,
        created_at,
        updated_at
    from "ecommerce_analytics"."main"."raw_products"
),

cleaned as (
    select
        product_id,
        trim(product_name) as product_name,
        lower(trim(category)) as category,
        price_cents,
        created_at,
        updated_at,
        
        -- Derived fields
        
    round(price_cents / 100.0, 2)
 as price_dollars,
        
        case 
            when lower(trim(category)) = 'electronics' then 'Electronics'
            when lower(trim(category)) = 'footwear' then 'Footwear'
            when lower(trim(category)) = 'kitchen' then 'Kitchen'
            when lower(trim(category)) = 'fitness' then 'Fitness'
            when lower(trim(category)) = 'home office' then 'Home Office'
            else 'Other'
        end as category_clean,
        
        -- Price tiers
        case 
            when price_cents < 2500 then 'Low'
            when price_cents between 2500 and 7500 then 'Medium'
            when price_cents > 7500 then 'High'
            else 'Unknown'
        end as price_tier,
        
        -- Data quality flags
        case 
            when product_name is null or product_name = '' then false
            when category is null or category = '' then false
            when price_cents <= 0 then false
            else true
        end as is_valid_product
        
    from source_data
)

select * from cleaned