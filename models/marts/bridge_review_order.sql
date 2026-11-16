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
    d.order_status,
    d.delivered_date_key,
    d.estimated_delivery_date_key,
    d.is_delivered,
    d.is_late,
    d.delay_days,
    t.customer_unique_id,
    datediff(cast(r.review_created_at as date),
             cast(o.order_delivered_customer_at as date)) as delivery_to_review_days,
    t.order_value
from {{ ref('stg_olist__order_reviews') }} as r
inner join {{ ref('int_orders__delivery_status') }} as d
    on r.order_id = d.order_id
inner join {{ ref('stg_olist__orders') }} as o
    on r.order_id = o.order_id
left join order_totals as t
    on r.order_id = t.order_id