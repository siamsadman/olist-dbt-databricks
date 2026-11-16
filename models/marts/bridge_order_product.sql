select distinct
    order_id,
    product_id
from {{ ref('stg_olist__order_items') }}