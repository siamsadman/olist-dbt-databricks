select
    order_id,
    order_status,
    cast(date_format(order_delivered_customer_at, 'yyyyMMdd') as int)   as delivered_date_key,
    cast(date_format(order_estimated_delivery_at, 'yyyyMMdd') as int)   as estimated_delivery_date_key,
    case when order_delivered_customer_at is not null then 1 else 0 end as is_delivered,
    case
        when order_delivered_customer_at is null then null
        when order_delivered_customer_at > order_estimated_delivery_at then 1
        else 0
    end                                                                 as is_late,
    datediff(cast(order_delivered_customer_at as date),
             cast(order_estimated_delivery_at as date))                 as delay_days
from {{ ref('stg_olist__orders') }}