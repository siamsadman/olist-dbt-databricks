select
    seller_id,
    seller_city,
    seller_state,
    seller_zip_code_prefix as seller_zip_prefix
from {{ ref('stg_olist__sellers') }}