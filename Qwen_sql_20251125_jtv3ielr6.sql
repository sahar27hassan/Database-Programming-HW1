-- Database Programming - Homework #1
-- Student Name: [Sahar Wessam Hassan Hassan]
-- University ID: [202220185]
-- Due Date: 27/11/2025

--------------------------------------------------------------------
-- Q1: DDL for Employee Database with Referential Integrity Constraints
--------------------------------------------------------------------

-- Create company table
CREATE TABLE company (
    company_name VARCHAR(50) PRIMARY KEY,
    city VARCHAR(50)
);

-- Create employee table
CREATE TABLE employee (
    ID INT PRIMARY KEY,
    person_name VARCHAR(50),
    street VARCHAR(100),
    city VARCHAR(50)
);

-- Create works table with foreign keys
CREATE TABLE works (
    ID INT,
    company_name VARCHAR(50),
    salary DECIMAL(10, 2),
    PRIMARY KEY (ID, company_name),
    FOREIGN KEY (ID) REFERENCES employee(ID) ON DELETE CASCADE,
    FOREIGN KEY (company_name) REFERENCES company(company_name) ON DELETE CASCADE
);

-- Create manages table
CREATE TABLE manages (
    ID INT PRIMARY KEY,
    manager_id INT,
    FOREIGN KEY (ID) REFERENCES employee(ID) ON DELETE CASCADE,
    FOREIGN KEY (manager_id) REFERENCES employee(ID) ON DELETE SET NULL
);

--------------------------------------------------------------------
-- Q2: SQL Queries for Bank Database
--------------------------------------------------------------------

-- A. Customers who have an account but NOT a loan
SELECT DISTINCT d.ID
FROM depositor d
WHERE d.ID NOT IN (
    SELECT b.ID
    FROM borrower b
);

-- B. Customers who live on the same street and city as customer '12345'
SELECT c1.ID
FROM customer c1
JOIN customer c2 ON c1.customer_street = c2.customer_street
                 AND c1.customer_city = c2.customer_city
WHERE c2.ID = '12345'
  AND c1.ID <> '12345';

-- C. Branch names with at least one customer living in 'Harrison'
SELECT DISTINCT a.branch_name
FROM account a
JOIN depositor d ON a.account_number = d.account_number
JOIN customer c ON d.ID = c.ID
WHERE c.customer_city = 'Harrison';

--------------------------------------------------------------------
-- Q3: Window Functions
--------------------------------------------------------------------

-- A. Cumulative sum of qty from demand table
SELECT 
    day,
    qty,
    SUM(qty) OVER (ORDER BY day ROWS UNBOUNDED PRECEDING) AS cumQty
FROM demand
ORDER BY day;

-- B. Two worst-performing days (lowest qty) per product
SELECT product, day, qty, RN
FROM (
    SELECT 
        product,
        day,
        qty,
        ROW_NUMBER() OVER (PARTITION BY product ORDER BY qty ASC) AS RN
    FROM sales
) AS ranked_sales
WHERE RN <= 2;