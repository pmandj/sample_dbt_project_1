
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from "ecommerce_analytics"."main_dbt_test__audit"."accepted_values_dim_customers_ef26879badf9745a7f6bba37fd1e92d2"
    
      
    ) dbt_internal_test