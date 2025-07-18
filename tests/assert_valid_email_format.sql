-- Custom singular test to validate email format
-- This test ensures all customer emails contain @ symbol and domain

select
    customer_id,
    email,
    full_name
from {{ ref('stg_customers') }}
where email is not null
  and (
      email not like '%@%'
      or email not like '%.%'
      or length(email) < 5
  )
