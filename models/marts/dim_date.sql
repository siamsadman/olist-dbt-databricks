with date_range as (

    select
        min(cast(order_purchase_at as date)) as start_date,
        max(cast(order_purchase_at as date)) as end_date
    from {{ ref('stg_olist__orders') }}

),

dates as (

    select explode(sequence(start_date, end_date, interval 1 day)) as full_date
    from date_range

)

select
    cast(date_format(full_date, 'yyyyMMdd') as int) as date_key,
    full_date,
    year(full_date)                                 as year,
    quarter(full_date)                              as quarter,
    month(full_date)                                as month,
    date_format(full_date, 'MMMM')                  as month_name,
    day(full_date)                                  as day,
    date_format(full_date, 'EEEE')                  as day_name,
    cast(floor(
        (dayofyear(full_date) - 1
         + dayofweek(make_date(year(full_date), 1, 1)) - 1) / 7
    ) + 1 as int)                                   as week_of_year,
    case when dayofweek(full_date) in (1, 7) then 1 else 0 end as is_weekend,
    date_format(full_date, 'yyyy-MM')               as year_month,
    case when full_date <= date '2018-08-31' then 1 else 0 end as is_complete_month
from dates