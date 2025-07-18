
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from "ecommerce_analytics"."main_dbt_test__audit"."accepted_values_int_customer_o_d8eacd1e5922276f4b8f3ffb3a79f5b8"
    
      
    ) dbt_internal_test