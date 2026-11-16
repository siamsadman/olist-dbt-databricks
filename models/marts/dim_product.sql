select
    p.product_id,
    coalesce(p.product_category_name, 'Unknown') as category_name_pt,
    coalesce(t.product_category_name_english, o.product_category_name_english) as category_name_en,
    coalesce(p.product_weight_g, 0)  as product_weight_g,
    coalesce(p.product_length_cm, 0) as product_length_cm,
    coalesce(p.product_height_cm, 0) as product_height_cm,
    coalesce(p.product_width_cm, 0)  as product_width_cm
from {{ ref('stg_olist__products') }} as p
left join {{ ref('stg_olist__product_category_translation') }} as t
    on p.product_category_name = t.product_category_name
left join {{ ref('category_name_overrides') }} as o
    on coalesce(p.product_category_name, 'Unknown') = o.product_category_name