
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from "ecommerce_analytics"."main_dbt_test__audit"."not_null_int_order_items_enhanced_is_discounted"
    
      
    ) dbt_internal_test