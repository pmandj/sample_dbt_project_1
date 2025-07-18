
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from "ecommerce_analytics"."main_dbt_test__audit"."unique_int_order_items_enhanced_order_item_id"
    
      
    ) dbt_internal_test