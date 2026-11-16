select
    geolocation_zip_code_prefix,
    cast(geolocation_lat as double) as geolocation_lat,
    cast(geolocation_lng as double) as geolocation_lng,
    geolocation_city,
    geolocation_state
from {{ source('olist_raw', 'geolocation') }}