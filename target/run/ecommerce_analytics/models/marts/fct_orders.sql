
        
            delete from "ecommerce_analytics"."main"."fct_orders"
            where (
                order_id) in (
                select (order_id)
                from "fct_orders__dbt_tmp20250718135657978223"
            );

        
    

    insert into "ecommerce_analytics"."main"."fct_orders" ("order_id", "customer_id", "order_date", "status", "order_status_clean", "total_amount_cents", "total_amount_dollars", "order_year", "order_month", "order_day", "order_day_of_week", "is_completed_order", "order_created_at", "order_updated_at", "total_items", "total_quantity", "calculated_total_dollars", "unique_products", "unique_categories", "totals_match", "revenue_dollars", "basket_size_category", "weekend_flag", "last_updated")
    (
        select "order_id", "customer_id", "order_date", "status", "order_status_clean", "total_amount_cents", "total_amount_dollars", "order_year", "order_month", "order_day", "order_day_of_week", "is_completed_order", "order_created_at", "order_updated_at", "total_items", "total_quantity", "calculated_total_dollars", "unique_products", "unique_categories", "totals_match", "revenue_dollars", "basket_size_category", "weekend_flag", "last_updated"
        from "fct_orders__dbt_tmp20250718135657978223"
    )
  