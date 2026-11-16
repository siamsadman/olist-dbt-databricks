    with customer_orders as (

    select
        c.customer_unique_id,
        c.customer_city,
        c.customer_state,
        c.customer_zip_code_prefix as customer_zip_prefix,
        o.order_purchase_at,
        o.order_id
    from {{ ref('stg_olist__customers') }} as c
    inner join {{ ref('stg_olist__orders') }} as o
        on c.customer_id = o.customer_id

),

ranked as (

    select
        *,
        row_number() over (
            partition by customer_unique_id
            order by order_purchase_at desc, order_id desc
        ) as order_rank
    from customer_orders

)

select
    customer_unique_id,
    customer_city,
    customer_state,
    customer_zip_prefix
from ranked
where order_rank = 1