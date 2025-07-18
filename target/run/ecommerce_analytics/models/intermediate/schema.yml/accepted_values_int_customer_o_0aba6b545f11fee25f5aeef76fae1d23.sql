
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from "ecommerce_analytics"."main_dbt_test__audit"."accepted_values_int_customer_o_0aba6b545f11fee25f5aeef76fae1d23"
    
      
    ) dbt_internal_test