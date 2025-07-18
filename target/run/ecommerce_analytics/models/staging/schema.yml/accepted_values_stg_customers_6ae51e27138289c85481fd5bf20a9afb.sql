
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from "ecommerce_analytics"."main_dbt_test__audit"."accepted_values_stg_customers_6ae51e27138289c85481fd5bf20a9afb"
    
      
    ) dbt_internal_test