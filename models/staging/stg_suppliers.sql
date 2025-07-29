{{
  config(
    materialized='view'
  )
}}

with source_data as (
    select
        supplier_id,
        supplier_name as name,  -- Inconsistent naming
        contact_email as email,  -- Different field name than customers
        phone_number,
        address,
        city,
        state,
        country,
        rating,
        contract_start_date::date as contract_start
    from {{ source('main', 'raw_suppliers') }}
),

enhanced as (
    select
        *,
        concat(city, ', ', state, ' ', country) as full_address,
        case 
            when rating >= 4.5 then 'excellent'
            when rating >= 4.0 then 'good'
            when rating >= 3.5 then 'average'
            else 'poor'
        end as rating_category,
        current_date - contract_start as contract_days
    from source_data
)

select * from enhanced