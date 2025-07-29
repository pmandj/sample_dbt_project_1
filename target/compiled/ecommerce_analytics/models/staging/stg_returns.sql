

with source_data as (
    select
        return_id,
        order_id,
        product_id,
        return_date::date as returned_on,  -- Different date naming pattern
        return_reason as reason,  -- Simplified naming
        return_status as status,  -- Consistent with payments but different from orders
        refund_amount_cents,
        processing_fee_cents,
        restocking_fee_cents
    from "ecommerce_analytics"."main"."raw_returns"
),

calculated as (
    select
        *,
        -- Using different currency conversion approach
        refund_amount_cents / 100.0 as refund_amount_dollars,  -- Not using cents_to_dollars macro
        processing_fee_cents / 100.0 as processing_fee_dollars,
        restocking_fee_cents / 100.0 as restocking_fee_dollars,
        
        (refund_amount_cents - processing_fee_cents - restocking_fee_cents) / 100.0 as net_refund_dollars,
        
        case 
            when status = 'approved' then true
            else false
        end as is_approved,
        
        case 
            when reason in ('defective', 'damaged_shipping') then 'quality_issue'
            when reason in ('wrong_size', 'not_as_described') then 'expectation_mismatch'
            when reason = 'changed_mind' then 'buyer_remorse'
            else 'other'
        end as return_category
    from source_data
)

select * from calculated