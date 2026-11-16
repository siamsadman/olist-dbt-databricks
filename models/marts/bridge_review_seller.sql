select distinct
    r.review_id,
    s.seller_id
from {{ ref('stg_olist__order_reviews') }} as r
inner join {{ ref('bridge_order_seller') }} as s
    on r.order_id = s.order_id
where s.seller_id is not null