CREATE OR REFRESH STREAMING TABLE bronze_orders (
  CONSTRAINT delivered_has_date
    EXPECT (order_status <> 'delivered' OR order_delivered_customer_date IS NOT NULL),
  CONSTRAINT valid_order_id
    EXPECT (order_id IS NOT NULL AND length(order_id) = 32) ON VIOLATION DROP ROW,
  CONSTRAINT known_status
    EXPECT (order_status IN ('delivered','shipped','canceled','unavailable','invoiced','processing','created','approved')) ON VIOLATION FAIL UPDATE
)
AS SELECT
  *,
  _metadata.file_name AS source_file,
  current_timestamp() AS loaded_at
FROM STREAM read_files(
  '/Volumes/workspace/olist_lakeflow/landing/',
  format => 'csv',
  header => true,
  inferColumnTypes => false
);

CREATE OR REFRESH MATERIALIZED VIEW orders_per_month
AS SELECT
  date_format(cast(order_purchase_timestamp AS timestamp), 'yyyy-MM') AS purchase_month,
  count(*) AS orders
FROM bronze_orders
GROUP BY 1;