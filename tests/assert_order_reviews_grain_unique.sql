select
    review_id,
    order_id,
    count(*) as row_count
from {{ ref('stg_olist__order_reviews') }}
group by review_id, order_id
having count(*) > 1