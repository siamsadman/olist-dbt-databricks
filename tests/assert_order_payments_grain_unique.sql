select
    order_id,
    payment_sequential,
    count(*) as row_count
from {{ ref('stg_olist__order_payments') }}
group by order_id, payment_sequential
having count(*) > 1