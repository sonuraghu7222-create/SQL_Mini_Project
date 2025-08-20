# SQL Mini Project — Retail Analytics (MySQL)

A compact retail dataset and 40+ MySQL queries that demonstrate filtering, aggregations, joins, subqueries, and set operations. Each query includes a short business purpose and a screenshot of the result.

## Contents
- **/sql**: queries grouped by level (basics → set ops)
- **/screenshots**: output screenshots named by query number
- **/docs**: polished PDF report and (optional) schema diagram
- **/data** (optional): sample CSVs for quick load

## Schema (overview)
- **customers**(customer_id, name, email, phone, country, …)
- **products**(product_id, name, category, price, stock_quantity, …)
- **orders**(order_id, customer_id, order_date, total_amount, status, …)
- **order_items**(order_item_id, order_id, product_id, quantity, item_price)
- **payments**(payment_id, order_id, method, amount_paid, payment_date)
- **product_reviews**(review_id, product_id, customer_id, rating, review_text, …)

> See `/docs/SQL_Mini_Project.pdf` for a narrative walkthrough with screenshots.

## Highlights
- Clean, readable SQL with consistent style (UPPERCASE keywords, single-quoted strings)
- Daily trends, per-category KPIs, revenue breakdowns
- “Highest value order per customer” using window functions (MySQL 8+)
- Set operations using `UNION`/`UNION ALL`

## How to Run
1. **MySQL 8+** recommended.
2. Create the schema and load sample data (optional `/data` CSVs or your own).
3. Run any script in `/sql`, e.g.:
   ```sql
   SOURCE sql/level-4_joins.sql;
