
  
    
    

    create  table
      "ecommerce_analytics"."main"."fct_order_items__dbt_tmp"
  
    as (
      -- Order items fact table
-- This model provides order item-level facts for detailed analytics



with order_items_enhanced as (
    select * from "ecommerce_analytics"."main"."int_order_items_enhanced"
),

final as (
    select
        order_item_id,
        order_id,
        product_id,
        customer_id,
        order_date,
        quantity,
        unit_price_cents,
        unit_price_dollars,
        line_total_cents,
        line_total_dollars,
        
        -- Product attributes
        product_name,
        category,
        category_clean,
        product_list_price_cents,
        product_list_price_dollars,
        price_tier,
        
        -- Order attributes
        order_status_clean,
        order_total_cents,
        order_total_dollars,
        order_year,
        order_month,
        is_completed_order,
        
        -- Pricing analysis
        price_discount_cents,
        price_discount_dollars,
        discount_percentage,
        is_discounted,
        
        -- Business metrics
        revenue_dollars,
        is_multi_quantity,
        
        -- Advanced metrics
        case 
            when order_total_dollars > 0 then 
                round(line_total_dollars / order_total_dollars * 100, 2)
            else 0
        end as line_item_percentage_of_order,
        
        case 
            when price_discount_dollars > 0 then 
                price_discount_dollars * quantity
            else 0
        end as total_discount_dollars,
        
        -- Data quality
        current_timestamp as last_updated
        
    from order_items_enhanced
)

select * from final
    );
  
  