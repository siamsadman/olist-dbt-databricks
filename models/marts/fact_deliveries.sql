with item_totals as (

    select
        oi.order_id,
        sum(oi.freight_value)   as total_freight,
        sum(oi.price)           as order_value,
        sum(p.product_weight_g) as total_weight_g
    from {{ ref('stg_olist__order_items') }} as oi
    left join {{ ref('dim_product') }} as p
        on oi.product_id = p.product_id
    group by oi.order_id

)

select
    o.order_id,
    c.customer_unique_id,
    o.order_status,
    cast(date_format(o.order_purchase_at, 'yyyyMMdd') as int)            as purchase_date_key,
    cast(date_format(o.order_approved_at, 'yyyyMMdd') as int)            as approved_date_key,
    cast(date_format(o.order_delivered_carrier_at, 'yyyyMMdd') as int)   as carrier_date_key,
    cast(date_format(o.order_delivered_customer_at, 'yyyyMMdd') as int)  as delivered_date_key,
    cast(date_format(o.order_estimated_delivery_at, 'yyyyMMdd') as int)  as estimated_delivery_date_key,
    coalesce(f.total_freight, 0)                                         as total_freight_value,
    datediff(cast(o.order_delivered_customer_at as date), cast(o.order_purchase_at as date))        as delivery_days,
    datediff(cast(o.order_approved_at as date), cast(o.order_purchase_at as date))                  as approval_days,
    datediff(cast(o.order_delivered_customer_at as date), cast(o.order_delivered_carrier_at as date)) as shipping_days,
    datediff(cast(o.order_delivered_customer_at as date), cast(o.order_estimated_delivery_at as date)) as days_vs_estimate,
    case when o.order_delivered_customer_at is not null then 1 else 0 end as is_delivered,
    case
        when o.order_delivered_customer_at is null then null
        when o.order_delivered_customer_at > o.order_estimated_delivery_at then 1
        else 0
    end                                                                  as is_late,
    cast(f.order_value as decimal(10,2))                                 as order_value,
    cast(f.total_weight_g as decimal(12,2))                              as total_weight_g
from {{ ref('stg_olist__orders') }} as o
inner join {{ ref('stg_olist__customers') }} as c
    on o.customer_id = c.customer_id
left join item_totals as f
    on o.order_id = f.order_id