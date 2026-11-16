select
    order_id,
    order_status,
    cast(date_format(order_purchase_at, 'yyyyMMdd') as int) as order_date_key
from {{ ref('stg_olist__orders') }}