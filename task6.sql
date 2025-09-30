-- Task 6: Subqueries and Nested Queries
-- Objective: Use subqueries in SELECT, WHERE, and FROM

-- 1. Create tables (reuse schema from Task 5)
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
  customer_id INT PRIMARY KEY,
  name VARCHAR(100),
  city VARCHAR(100)
);

CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  product VARCHAR(100),
  amount DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- 2. Insert sample data
INSERT INTO Customers VALUES 
(1, 'Alice', 'Hyderabad'),
(2, 'Bob', 'Delhi'),
(3, 'Charlie', 'Mumbai');

INSERT INTO Orders VALUES
(101, 1, 'Laptop', 50000),
(102, 2, 'Mobile', 15000),
(103, 1, 'Headphones', 2000),
(104, 2, 'Tablet', 12000);

-- 3. Subquery in SELECT (scalar subquery)
-- Show each customer with their total order amount
SELECT c.name,
       (SELECT SUM(o.amount) 
        FROM Orders o 
        WHERE o.customer_id = c.customer_id) AS total_spent
FROM Customers c;

-- 4. Subquery in WHERE with IN
-- Customers who ordered something costing more than 20,000
SELECT name 
FROM Customers
WHERE customer_id IN (
    SELECT customer_id 
    FROM Orders 
    WHERE amount > 20000
);

-- 5. Subquery in WHERE with EXISTS (correlated subquery)
-- Customers who have at least one order
SELECT name
FROM Customers c
WHERE EXISTS (
    SELECT 1 
    FROM Orders o 
    WHERE o.customer_id = c.customer_id
);

-- 6. Subquery in FROM (derived table)
-- Find the average spend per customer using a subquery as a table
SELECT customer_id, AVG(total_amount) AS avg_spent
FROM (
    SELECT customer_id, SUM(amount) AS total_amount
    FROM Orders
    GROUP BY customer_id
) t
GROUP BY customer_id;

-- 7. Correlated Subquery in WHERE
-- Orders greater than the average order amount of the same customer
SELECT o.order_id, o.product, o.amount, o.customer_id
FROM Orders o
WHERE o.amount > (
    SELECT AVG(o2.amount) 
    FROM Orders o2 
    WHERE o2.customer_id = o.customer_id
);
