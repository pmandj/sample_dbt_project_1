
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from "ecommerce_analytics"."main_dbt_test__audit"."accepted_values_dim_customers_b199b726dacd86ff04b42d8e4d09cfea"
    
      
    ) dbt_internal_test