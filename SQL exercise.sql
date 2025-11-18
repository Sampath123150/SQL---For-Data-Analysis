use sampath ;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(100),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150),
    category VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_amount DECIMAL(10,2),
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);




INSERT INTO customers VALUES
(1, 'Arjun Reddy', 'Hyderabad', '2023-02-10'),
(2, 'Sita Lakshmi', 'Chennai', '2023-03-14'),
(3, 'Rahul Kumar', 'Bangalore', '2023-01-18'),
(4, 'Priya Sharma', 'Mumbai', '2023-05-21');

INSERT INTO products VALUES
(101, 'Bluetooth Headphone', 'Electronics', 1299),
(102, 'Running Shoes', 'Footwear', 2499),
(103, 'Laptop Stand', 'Accessories', 899),
(104, 'Smartwatch', 'Electronics', 3499);

INSERT INTO orders VALUES
(1001, 1, 101, 1, 1299, '2023-07-01'),
(1002, 2, 102, 1, 2499, '2023-07-02'),
(1003, 3, 104, 1, 3499, '2023-07-05'),
(1004, 1, 103, 2, 1798, '2023-07-07'),
(1005, 4, 101, 1, 1299, '2023-07-09');


-- 1.List all orders where order amount > 1500
SELECT * FROM orders
WHERE order_amount > 1500;

-- 2.Total spending by each customer
SELECT 
    customer_id,
    SUM(order_amount) AS total_spent
FROM orders
GROUP BY customer_id
ORDER BY total_spent DESC;

-- 3.Average, Minimum, Maximum order amounts
SELECT
    AVG(order_amount) AS avg_amount,
    MIN(order_amount) AS min_amount,
    MAX(order_amount) AS max_amount
FROM orders;

-- 4.INNER JOIN: Orders with customer names
SELECT 
    o.order_id,
    c.customer_name,
    o.order_amount,
    o.order_date
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id;

-- 5.LEFT JOIN: All customers + orders (including no orders)
SELECT 
    c.customer_name,
    o.order_id,
    o.order_amount
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

-- 6.RIGHT JOIN (if supported): All orders + customers
SELECT 
    c.customer_name,
    o.order_id,
    o.order_amount
FROM orders o
RIGHT JOIN customers c
ON o.customer_id = c.customer_id;

-- 7.Customers who placed orders above average order amount

SELECT customer_id, order_amount
FROM orders
WHERE order_amount > (
    SELECT AVG(order_amount) FROM orders
);

-- 8.Products that have been ordered at least once
SELECT product_name
FROM products
WHERE product_id IN (
    SELECT product_id FROM orders
);

-- 9.Highest spending customer
SELECT *
FROM customers
WHERE customer_id = (
    SELECT customer_id 
    FROM orders
    GROUP BY customer_id
    ORDER BY SUM(order_amount) DESC
    LIMIT 1
);
-- 10.Monthly sales view
CREATE VIEW monthly_sales AS
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(order_amount) AS total_sales
FROM orders
GROUP BY month;

SELECT * FROM monthly_sales;

-- 11. Customer revenue view
CREATE VIEW customer_revenue AS
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.order_amount) AS total_revenue
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

SELECT * FROM customer_revenue;

-- 12.Create index on frequently used columns
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_products_category ON products(category);
