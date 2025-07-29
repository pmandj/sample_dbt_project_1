
  
    
    

    create  table
      "ecommerce_analytics"."main"."dim_suppliers__dbt_tmp"
  
    as (
      

-- Supplier dimension table with inconsistent naming patterns
with supplier_base as (
    select
        supplier_id,
        name as supplier_name,  -- Different naming from other dims
        email as contact_email,  -- Different field name pattern
        phone_number,
        full_address,
        rating,
        rating_category,
        contract_start,
        contract_days
    from "ecommerce_analytics"."main"."stg_suppliers"
),

supplier_metrics as (
    select
        s.*,
        count(i.product_id) as products_supplied,
        avg(i.unit_cost_dollars) as avg_product_cost,  -- Different naming
        count(distinct i.warehouse_location) as warehouses_served
    from supplier_base s
    left join "ecommerce_analytics"."main"."stg_inventory" i
        on s.supplier_id = i.supplier_id
    group by s.supplier_id, s.supplier_name, s.contact_email, s.phone_number, 
             s.full_address, s.rating, s.rating_category, s.contract_start, s.contract_days
),

final as (
    select
        supplier_id,
        supplier_name,
        contact_email,
        phone_number,
        full_address,
        rating,
        rating_category,
        contract_start,
        contract_days,
        products_supplied,
        avg_product_cost,
        warehouses_served,
        
        -- Supplier tier classification
        case 
            when products_supplied >= 10 and rating >= 4.5 then 'tier_1'
            when products_supplied >= 5 and rating >= 4.0 then 'tier_2'
            when products_supplied >= 2 and rating >= 3.5 then 'tier_3'
            else 'tier_4'
        end as supplier_tier,
        
        current_timestamp as last_updated
    from supplier_metrics
)

select * from final
    );
  
  