
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from "ecommerce_analytics"."main_dbt_test__audit"."accepted_values_int_order_item_7131439ea5e1ed088814ab64b0d4a38b"
    
      
    ) dbt_internal_test