
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from "ecommerce_analytics"."main_dbt_test__audit"."accepted_values_fct_orders_8dd62e267dcca94ae283ab5d391994f5"
    
      
    ) dbt_internal_test