-- 01_load_raw.sql
-- Loads the nine Olist CSV files from the managed volume into workspace.olist_raw.
-- Every column is loaded as text (inferColumnTypes => false). dbt does all casting and cleaning.
--
-- Before running:
--   1. Upload the nine CSV files into the volume workspace.olist_raw.landing
--      (Catalog > workspace > olist_raw > landing > Upload to this volume).
--   2. Run this script in the Databricks SQL Editor (serverless SQL warehouse).
--
-- Safe to re-run: every table uses CREATE OR REPLACE.

CREATE SCHEMA IF NOT EXISTS workspace.olist_raw;
CREATE VOLUME IF NOT EXISTS workspace.olist_raw.landing;

-- customers
CREATE OR REPLACE TABLE workspace.olist_raw.customers AS
SELECT *
FROM read_files(
  '/Volumes/workspace/olist_raw/landing/olist_customers_dataset.csv',
  format => 'csv',
  header => true,
  inferColumnTypes => false
);

-- geolocation
CREATE OR REPLACE TABLE workspace.olist_raw.geolocation AS
SELECT *
FROM read_files(
  '/Volumes/workspace/olist_raw/landing/olist_geolocation_dataset.csv',
  format => 'csv',
  header => true,
  inferColumnTypes => false
);

-- order_items
CREATE OR REPLACE TABLE workspace.olist_raw.order_items AS
SELECT *
FROM read_files(
  '/Volumes/workspace/olist_raw/landing/olist_order_items_dataset.csv',
  format => 'csv',
  header => true,
  inferColumnTypes => false
);

-- order_payments
CREATE OR REPLACE TABLE workspace.olist_raw.order_payments AS
SELECT *
FROM read_files(
  '/Volumes/workspace/olist_raw/landing/olist_order_payments_dataset.csv',
  format => 'csv',
  header => true,
  inferColumnTypes => false
);

-- order_reviews
-- Reviews need multiLine and escape: comments contain line breaks and quote characters.
CREATE OR REPLACE TABLE workspace.olist_raw.order_reviews AS
SELECT *
FROM read_files(
  '/Volumes/workspace/olist_raw/landing/olist_order_reviews_dataset.csv',
  format => 'csv',
  header => true,
  inferColumnTypes => false,
  multiLine => true,
  escape => '"'
);

-- orders
CREATE OR REPLACE TABLE workspace.olist_raw.orders AS
SELECT *
FROM read_files(
  '/Volumes/workspace/olist_raw/landing/olist_orders_dataset.csv',
  format => 'csv',
  header => true,
  inferColumnTypes => false
);

-- product_category_name_translation
CREATE OR REPLACE TABLE workspace.olist_raw.product_category_name_translation AS
SELECT *
FROM read_files(
  '/Volumes/workspace/olist_raw/landing/product_category_name_translation.csv',
  format => 'csv',
  header => true,
  inferColumnTypes => false
);

-- products
CREATE OR REPLACE TABLE workspace.olist_raw.products AS
SELECT *
FROM read_files(
  '/Volumes/workspace/olist_raw/landing/olist_products_dataset.csv',
  format => 'csv',
  header => true,
  inferColumnTypes => false
);

-- sellers
CREATE OR REPLACE TABLE workspace.olist_raw.sellers AS
SELECT *
FROM read_files(
  '/Volumes/workspace/olist_raw/landing/olist_sellers_dataset.csv',
  format => 'csv',
  header => true,
  inferColumnTypes => false
);

-- Check: row counts and rescued rows (rows Auto Loader could not parse cleanly).
-- rescued_rows should be 0 for every table.
-- Expected counts for the standard Olist files:
--   customers 99441 | geolocation 1000163 | order_items 112650 | order_payments 103886
--   order_reviews 99224 | orders 99441 | product_category_name_translation 71
--   products 32951 | sellers 3095
SELECT 'customers' AS table_name, COUNT(*) AS row_count, COUNT(_rescued_data) AS rescued_rows FROM workspace.olist_raw.customers
UNION ALL
SELECT 'geolocation' AS table_name, COUNT(*) AS row_count, COUNT(_rescued_data) AS rescued_rows FROM workspace.olist_raw.geolocation
UNION ALL
SELECT 'order_items' AS table_name, COUNT(*) AS row_count, COUNT(_rescued_data) AS rescued_rows FROM workspace.olist_raw.order_items
UNION ALL
SELECT 'order_payments' AS table_name, COUNT(*) AS row_count, COUNT(_rescued_data) AS rescued_rows FROM workspace.olist_raw.order_payments
UNION ALL
SELECT 'order_reviews' AS table_name, COUNT(*) AS row_count, COUNT(_rescued_data) AS rescued_rows FROM workspace.olist_raw.order_reviews
UNION ALL
SELECT 'orders' AS table_name, COUNT(*) AS row_count, COUNT(_rescued_data) AS rescued_rows FROM workspace.olist_raw.orders
UNION ALL
SELECT 'product_category_name_translation' AS table_name, COUNT(*) AS row_count, COUNT(_rescued_data) AS rescued_rows FROM workspace.olist_raw.product_category_name_translation
UNION ALL
SELECT 'products' AS table_name, COUNT(*) AS row_count, COUNT(_rescued_data) AS rescued_rows FROM workspace.olist_raw.products
UNION ALL
SELECT 'sellers' AS table_name, COUNT(*) AS row_count, COUNT(_rescued_data) AS rescued_rows FROM workspace.olist_raw.sellers
ORDER BY table_name;
