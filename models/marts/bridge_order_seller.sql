select distinct
    order_id,
    seller_id
from {{ ref('stg_olist__order_items') }}