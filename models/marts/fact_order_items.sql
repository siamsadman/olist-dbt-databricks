select
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    c.customer_unique_id,
    cast(date_format(o.order_purchase_at, 'yyyyMMdd') as int) as order_date_key,
    o.order_status,
    oi.price,
    oi.freight_value
from {{ ref('stg_olist__order_items') }} as oi
inner join {{ ref('stg_olist__orders') }} as o
    on oi.order_id = o.order_id
inner join {{ ref('stg_olist__customers') }} as c
    on o.customer_id = c.customer_id