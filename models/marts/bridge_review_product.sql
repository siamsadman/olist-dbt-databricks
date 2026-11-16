select distinct
    r.review_id,
    p.product_id
from {{ ref('stg_olist__order_reviews') }} as r
inner join {{ ref('bridge_order_product') }} as p
    on r.order_id = p.order_id
where p.product_id is not null