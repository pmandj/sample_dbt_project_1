
  
  create view "ecommerce_analytics"."main"."int_return_analysis__dbt_tmp" as (
    

-- Return analysis with product and order information
with return_data as (
    select
        r.return_id,
        r.order_id,
        r.product_id,
        r.returned_on as return_date,  -- Different naming
        r.reason as return_reason,  -- Different naming
        r.status as return_status,
        r.refund_amount_dollars as refund_amt,  -- Abbreviated naming
        r.net_refund_dollars as net_refund,
        r.is_approved,
        r.return_category,
        
        -- Join with order data
        o.order_date,
        o.customer_id,
        
        -- Join with product data
        p.product_name,
        p.category as product_category,  -- Different naming
        p.price_dollars as product_price  -- Different naming
    from "ecommerce_analytics"."main"."stg_returns" r
    left join "ecommerce_analytics"."main"."stg_orders" o
        on r.order_id = o.order_id
    left join "ecommerce_analytics"."main"."stg_products" p
        on r.product_id = p.product_id
),

enhanced_returns as (
    select
        *,
        return_date - order_date as days_to_return,
        
        -- Return timing analysis
        case 
            when return_date - order_date <= 7 then 'immediate'
            when return_date - order_date <= 30 then 'short_term'
            when return_date - order_date <= 90 then 'medium_term'
            else 'long_term'
        end as return_timing,
        
        -- Financial impact
        refund_amt / product_price as refund_percentage,
        
        -- Return severity
        case 
            when return_category = 'quality_issue' then 'high'
            when return_category = 'expectation_mismatch' then 'medium'
            else 'low'
        end as return_severity
    from return_data
)

select * from enhanced_returns
  );
