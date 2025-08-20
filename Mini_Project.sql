SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Order_items;
SELECT * FROM Payments;
SELECT * FROM Product_reviews;

/* 														QUESTIONS													

													Level 1: Basics
*/

-- 1. Retrieve customer names and emails for email marketing
-- This helps the marketing team extract basic customer contact details for campaigns.

SELECT name, email FROM customers;

-- 2. View complete product catalog with all available details
-- The product manager may want to review all product listings in one go.

SELECT * FROM products;

-- 3. List all unique product categories
-- Useful for analyzing the range of departments or for creating filters on the website.

SELECT DISTINCT(category) FROM products;

-- 4. Show all products priced above ₹1,000
-- This helps identify high-value items for premium promotions or pricing strategy reviews.

SELECT name, price FROM products
WHERE price > 1000
ORDER BY price;

-- 5. Display products within a mid-range price bracket (₹2,000 to ₹5,000)
-- A merchandising team might need this to create a mid-tier pricing campaign.

SELECT name, price AS mid_range FROM products
WHERE price BETWEEN 2000 AND 5000
ORDER BY mid_range;	

-- 6. Fetch data for specific customer IDs (e.g., from loyalty program list)
-- This is used when customer IDs are pre-selected from another system.

SELECT * FROM customers
WHERE customer_id IN (1,3,5,7,8,12,15);

-- 7. Identify customers whose names start with the letter ‘A’
-- Used for alphabetical segmentation in outreach or app display.

SELECT name FROM customers
WHERE name LIKE 'A%';

-- 8. List electronics products priced under ₹3,000
-- Used by merchandising or frontend teams to showcase budget electronics.

SELECT name, category, price FROM products
WHERE category = "Electronics" AND price < 3000;

-- 9. Display product names and prices in descending order of price
-- This helps teams easily view and compare top-priced items.

SELECT name, price FROM products
ORDER BY price DESC;

-- 10. Display product names and prices, sorted by price and then by name
-- The merchandising or catalog team may want to list products from most expensive to cheapest. If multiple products have the same price, they should be sorted alphabetically for clarity on storefronts or printed catalogs.

SELECT name, price FROM products
ORDER BY price DESC, name ASC;

-- ========================================================================================================================================================================

/* 														QUESTIONS													

													Level 2: Filtering and Formatting
*/			

-- 1. Retrieve orders where customer information is missing (possibly due to data migration or deletion)
-- Used to identify orphaned orders or test data where customer_id is not linked.

SELECT * FROM Orders
WHERE customer_id IS NULL;

-- 2. Display customer names and emails using column aliases for frontend readability
-- Useful for feeding into frontend displays or report headings that require user-friendly labels.

SELECT name AS customer_name, email FROM customers;

-- 3. Calculate total value per item ordered by multiplying quantity and item price
-- This can help generate per-line item bill details or invoice breakdowns.

SELECT order_item_id, quantity, item_price, (quantity*item_price) AS total_value
FROM order_items;

-- 4. Combine customer name and phone number in a single column
-- Used to show brief customer summaries or contact lists.

SELECT CONCAT(name, '-' , phone) AS customer_detail
FROM customers;

-- 5. Extract only the date part from order timestamps for date-wise reporting
-- Helps group or filter orders by date without considering time.

SELECT order_id, DATE(order_date) AS date
FROM orders;

-- 6. List products that do not have any stock left
-- This helps the inventory team identify out-of-stock items.

SELECT product_id, name, stock_quantity FROM products
WHERE stock_quantity = 0;

-- =======================================================================================================================================================================

/* 														QUESTIONS													

													Level 3: Aggregations
*/

-- 1. Count the total number of orders placed
-- Used by business managers to track order volume over time.

SELECT COUNT(order_id) FROM orders;

-- 2. Calculate the total revenue collected from all orders
-- This gives the overall sales value.

SELECT SUM(total_amount) AS total_revenue FROM orders;

-- 3. Calculate the average order value
-- Used for understanding customer spending patterns.

SELECT AVG(total_amount) AS avg_order_value
FROM orders;

-- 4. Count the number of customers who have placed at least one order
-- This identifies active customers.

SELECT COUNT(DISTINCT customer_id) AS active_customers FROM orders;

-- 5. Find the number of orders placed by each customer
-- Helpful for identifying top or repeat customers.

SELECT customer_id, COUNT(order_id) AS number_of_orders
FROM orders
GROUP BY customer_id
ORDER BY number_of_orders DESC;

-- 6. Find total sales amount made by each customer

SELECT customer_id, SUM(total_amount) AS total_sales
FROM orders
GROUP BY customer_id
ORDER BY total_sales DESC;

-- 7. List the number of products sold per category
-- This helps category managers assess performance by department.

SELECT p.category, SUM(o.quantity) AS total_products_sold FROM products p
JOIN order_items o ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY total_products_sold DESC;

-- 8. Find the average item price per category
-- Useful to compare pricing across departments.

SELECT category, AVG(price) AS avg_price FROM products
GROUP BY category
ORDER BY avg_price DESC;

-- 9. Show number of orders placed per day
-- Used to track daily business activity and demand trends.

SELECT DATE(order_date) AS order_day, COUNT(order_id) AS total_orders FROM orders
GROUP BY order_day
ORDER BY total_orders DESC;

-- OR

SELECT 
    DAYNAME(order_date) AS weekday,
    COUNT(order_id) AS total_orders
FROM
    orders
GROUP BY weekday
ORDER BY total_orders DESC;

-- 10. List total payments received per payment method
-- Helps the finance team understand preferred transaction modes.

SELECT method, SUM(amount_paid) AS total_amount FROM payments
GROUP BY method
ORDER BY total_amount DESC;

-- =========================================================================================================================================================================

/* 														QUESTIONS													

													Level 4: Multi-Table Queries (JOINS)
*/

-- 1. Retrieve order details along with the customer name (INNER JOIN)
-- Used for displaying which customer placed each order.

SELECT c.customer_id, c.name, o.order_id, date(o.order_date), o.total_amount FROM
customers c													
JOIN orders o ON c.customer_id = o.customer_id;

-- 2. Get list of products that have been sold (INNER JOIN with order_items)
-- Used to find which products were actually included in orders.

SELECT DISTINCT(p.product_id), p.name FROM order_items o
JOIN products p ON p.product_id = o.product_id;


-- 3. List all orders with their payment method (INNER JOIN)
-- Used by finance or audit teams to see how each order was paid for.

SELECT o.order_id, date(o.order_date) AS order_date, o.total_amount, p.method FROM orders o
JOIN payments p ON o.order_id = p.order_id;

-- 4. Get list of customers and their orders (LEFT JOIN)
-- Used to find all customers and see who has or hasn’t placed orders.

SELECT c.customer_id, c.name, o.order_id, date(o.order_date) AS order_date FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

-- 5. List all products along with order item quantity (LEFT JOIN)
-- Useful for inventory teams to track what sold and what hasn’t.

SELECT p.product_id, p.name, p.category, SUM(oi.quantity) AS total_quantity FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id,  p.name, p.category;

-- 6. List all payments including those with no matching orders (RIGHT JOIN)
-- Rare but used when ensuring all payments are mapped correctly.

SELECT o.order_id, date(o.order_date), p.payment_id, date(p.payment_date) AS payment_date FROM orders o
RIGHT JOIN payments p ON p.order_id = o.order_id;

-- 7. Combine data from three tables: customer, order, and payment
-- Used for detailed transaction reports.

SELECT c.customer_id, c.name, o.order_id, date(o.order_date) AS order_date, p.payment_id, p.amount_paid FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN payments p ON o.order_id = p.order_id;

-- =========================================================================================================================================================================

/* 														QUESTIONS													

													Level 5: Subqueries (Inner Queries)
*/

-- 1. List all products priced above the average product price
-- Used by pricing analysts to identify premium-priced products.

SELECT product_id, name, category, price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price;

-- 2. Find customers who have placed at least one order
-- Used to identify active customers for loyalty campaigns.

SELECT customer_id, name FROM customers
WHERE customer_id IN (SELECT customer_id FROM orders);

-- 3. Show orders whose total amount is above the average for that customer
-- Used to detect unusually high purchases per customer.

SELECT *
FROM (
    SELECT 
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * oi.item_price) AS order_total,
        AVG(SUM(oi.quantity * oi.item_price)) OVER (PARTITION BY o.customer_id) AS avg_order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.customer_id
) t
WHERE t.order_total > t.avg_order_total;

-- 4. Display customers who haven’t placed any orders
-- Used for re-engagement campaigns targeting inactive users.

SELECT c.customer_id, c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 5. Show products that were never ordered
-- Helps with inventory clearance decisions or product deactivation.

SELECT product_id, name
FROM products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id 
    FROM order_items);


-- 6. Show highest value order per customer
-- Used to identify the largest transaction made by each customer.

SELECT DISTINCT(o.customer_id),
        MAX(oi.quantity * oi.item_price) OVER (PARTITION BY o.customer_id) AS max_order_value
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id;
    
-- 7. Highest Order Per Customer (Including Names)
-- Used to identify the largest transaction made by each customer. Outputs name as well.

SELECT 
    ot.customer_id,
    ot.name,
    MAX(ot.order_total) AS max_order_value
FROM (
    SELECT 
        o.customer_id,
        c.name,
        o.order_id,
        SUM(oi.quantity * oi.item_price) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN customers c ON c.customer_id = o.customer_id
    GROUP BY o.customer_id, o.order_id, c.name
) AS ot
GROUP BY ot.customer_id, ot.name;


-- ======================================================================================================================================================================

/* 														   QUESTIONS													

													Level 6: SET Operations
*/

-- Q1. List all unique product categories and customer names in a single column.

SELECT category AS info FROM products
UNION
SELECT name AS info FROM customers;

-- Q2. List all order IDs and payment IDs together, keeping duplicates if any exist.

SELECT order_id AS info FROM orders
UNION ALL 
SELECT payment_id AS info FROM payments;
