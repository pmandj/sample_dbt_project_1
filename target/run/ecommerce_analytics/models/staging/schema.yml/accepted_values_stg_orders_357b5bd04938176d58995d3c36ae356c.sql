
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from "ecommerce_analytics"."main_dbt_test__audit"."accepted_values_stg_orders_357b5bd04938176d58995d3c36ae356c"
    
      
    ) dbt_internal_test