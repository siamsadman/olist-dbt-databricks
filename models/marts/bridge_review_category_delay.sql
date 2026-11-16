select distinct
    f.review_id,
    coalesce(dp.category_name_en, 'Unknown') as category_name_en,
    case
        when bo.is_late is null  then 'Not Delivered'
        when bo.is_late = 0      then 'On Time'
        when bo.delay_days <= 7  then '1-7 Days Late'
        when bo.delay_days <= 14 then '8-14 Days Late'
        else '15+ Days Late'
    end                                       as delay_bucket,
    f.review_score
from {{ ref('fact_reviews') }} as f
inner join {{ ref('bridge_review_order') }} as bo
    on bo.review_id = f.review_id
inner join {{ ref('bridge_review_product') }} as bp
    on bp.review_id = f.review_id
left join {{ ref('dim_product') }} as dp
    on dp.product_id = bp.product_id