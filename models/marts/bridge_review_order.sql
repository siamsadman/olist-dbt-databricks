with order_totals as (

    select
        order_id,
        min(customer_unique_id) as customer_unique_id,
        sum(price)              as order_value
    from {{ ref('fact_order_items') }}
    group by order_id

)

select
    r.review_id,
    r.order_id,
    o.order_status,
    cast(date_format(o.order_delivered_customer_at, 'yyyyMMdd') as int)  as delivered_date_key,
    cast(date_format(o.order_estimated_delivery_at, 'yyyyMMdd') as int)  as estimated_delivery_date_key,
    case when o.order_delivered_customer_at is not null then 1 else 0 end as is_delivered,
    case
        when o.order_delivered_customer_at is null then null
        when o.order_delivered_customer_at > o.order_estimated_delivery_at then 1
        else 0
    end                                                                  as is_late,
    datediff(cast(o.order_delivered_customer_at as date),
             cast(o.order_estimated_delivery_at as date))                as delay_days,
    t.customer_unique_id,
    datediff(cast(r.review_created_at as date),
             cast(o.order_delivered_customer_at as date))                as delivery_to_review_days,
    t.order_value
from {{ ref('stg_olist__order_reviews') }} as r
inner join {{ ref('stg_olist__orders') }} as o
    on r.order_id = o.order_id
left join order_totals as t
    on r.order_id = t.order_id