-- Snapshot of customer data to track changes over time
-- This snapshot captures the slowly changing dimensions of customer data

{% snapshot customers_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='customer_id',
      strategy='timestamp',
      updated_at='updated_at',
      invalidate_hard_deletes=true
    )
}}

select
    customer_id,
    email,
    first_name,
    last_name,
    created_at,
    updated_at
from {{ ref('raw_customers') }}

{% endsnapshot %}
