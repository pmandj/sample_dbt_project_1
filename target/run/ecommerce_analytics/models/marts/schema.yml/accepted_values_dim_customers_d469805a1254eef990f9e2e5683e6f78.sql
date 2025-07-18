
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from "ecommerce_analytics"."main_dbt_test__audit"."accepted_values_dim_customers_d469805a1254eef990f9e2e5683e6f78"
    
      
    ) dbt_internal_test