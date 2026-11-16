{% docs __overview__ %}

# Olist dbt pipeline on Databricks

Built by **Siam Sadman**, BI Developer, Dhaka, Bangladesh.

This is the documentation for a dbt v2 project that rebuilds the data pipelines of three published Power BI projects (Sales, Logistics, Customer Satisfaction) on the public Olist Brazilian e-commerce dataset, running on Databricks Free Edition.

- Source code: [github.com/siamsadman/olist-dbt-databricks](https://github.com/siamsadman/olist-dbt-databricks)
- Portfolio: [siamsadman.vercel.app](https://siamsadman.vercel.app)

Layers: raw (bronze), staging, intermediate, marts. 25 models and 57 tests; mart row counts are reconciled against the original Power BI projects, and the differences are documented.

The dataset is the Olist public dataset (Kaggle). This documentation site is generated with dbt Docs v2, which dbt labels alpha.

{% enddocs %}