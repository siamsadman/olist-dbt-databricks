with ranked as (

    select
        r.*,
        row_number() over (
            partition by r.review_id
            order by r.order_id
        ) as review_rank
    from {{ ref('stg_olist__order_reviews') }} as r

)

select
    review_id,
    review_score,
    case
        when review_comment_title is not null
          or review_comment_message is not null then 1
        else 0
    end                                                                as has_comment,
    review_comment_title,
    review_comment_message,
    cast(date_format(review_created_at, 'yyyyMMdd') as int)            as creation_date_key,
    cast(date_format(review_answered_at, 'yyyyMMdd') as int)           as answer_date_key,
    datediff(cast(review_answered_at as date), cast(review_created_at as date)) as response_days
from ranked
where review_rank = 1