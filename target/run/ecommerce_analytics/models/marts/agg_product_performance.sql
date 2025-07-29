
  
    
    

    create  table
      "ecommerce_analytics"."main"."agg_product_performance__dbt_tmp"
  
    as (
      

-- Product performance aggregation with multiple metrics
with product_sales as (
    select
        oi.product_id,
        count(*) as times_ordered,  -- Different naming
        sum(oi.quantity) as total_qty_sold,  -- Different naming
        sum(oi.revenue_dollars) as total_sales,  -- Different naming
        avg(oi.revenue_dollars) as avg_item_value  -- Different naming
    from "ecommerce_analytics"."main"."fct_order_items" oi
    group by oi.product_id
),

product_returns as (
    select
        product_id,
        count(*) as return_count,
        sum(refund_amount) as total_refunds,  -- Different naming
        avg(days_to_return) as avg_return_days  -- Different naming
    from "ecommerce_analytics"."main"."fct_returns"
    where is_approved = true
    group by product_id
),

product_inventory as (
    select
        product_id,
        sum(available_qty) as current_stock,  -- Different naming
        avg(unit_cost) as avg_cost,  -- Different naming
        avg(margin_percentage) as avg_margin  -- Different naming
    from "ecommerce_analytics"."main"."fct_inventory"
    group by product_id
),

final as (
    select
        p.product_id,
        p.product_name,
        p.category as product_type,  -- Different naming
        p.price_dollars as list_price,  -- Different naming
        
        coalesce(s.times_ordered, 0) as order_frequency,  -- Different naming
        coalesce(s.total_qty_sold, 0) as units_sold,  -- Different naming
        coalesce(s.total_sales, 0) as sales_revenue,  -- Different naming
        coalesce(s.avg_item_value, 0) as avg_sale_value,  -- Different naming
        
        coalesce(r.return_count, 0) as returns,  -- Simplified naming
        coalesce(r.total_refunds, 0) as refund_total,  -- Different naming
        coalesce(r.avg_return_days, 0) as return_days_avg,  -- Different naming
        
        coalesce(i.current_stock, 0) as inventory_qty,  -- Different naming
        coalesce(i.avg_cost, 0) as cost_average,  -- Different naming
        coalesce(i.avg_margin, 0) as margin_avg,  -- Different naming
        
        -- Performance calculations
        case when s.times_ordered > 0 then r.return_count::float / s.times_ordered else 0 end as return_rate,
        case when s.total_sales > 0 then r.total_refunds / s.total_sales else 0 end as refund_rate,
        
        -- Product ranking
        case 
            when s.total_sales >= 5000 then 'top_performer'
            when s.total_sales >= 2000 then 'good_performer'
            when s.total_sales >= 500 then 'average_performer'
            else 'low_performer'
        end as performance_tier
    from "ecommerce_analytics"."main"."dim_products" p
    left join product_sales s on p.product_id = s.product_id
    left join product_returns r on p.product_id = r.product_id
    left join product_inventory i on p.product_id = i.product_id
)

select * from final
    );
  
  