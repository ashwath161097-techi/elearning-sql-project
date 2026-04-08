CREATE DATABASE elearning_db;
USE elearning_db;

-- Learners Table
CREATE TABLE learners (
    learner_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    country VARCHAR(50)
);

-- Courses Table
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2)
);

-- Purchases Table
CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    learner_id INT,
    course_id INT,
    quantity INT,
    purchase_date DATE,
    
    FOREIGN KEY (learner_id) REFERENCES learners(learner_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- INSERTING VALUES
INSERT INTO learners VALUES
(1,'Arjun Kumar','India'),
(2,'Maria Lopez','Spain'),
(3,'John Smith','USA'),
(4,'Aisha Khan','UAE'),
(5,'David Lee','Singapore');

INSERT INTO courses VALUES
(101,'SQL for Beginners','Data Analytics',120.00),
(102,'Python Programming','Programming',150.00),
(103,'Digital Marketing Basics','Marketing',100.00),
(104,'Advanced Excel','Data Analytics',90.00),
(105,'Graphic Design Fundamentals','Design',110.00);

INSERT INTO purchases VALUES
(1,1,101,1,'2025-01-05'),
(2,2,102,2,'2025-01-10'),
(3,3,103,1,'2025-01-15'),
(4,1,104,3,'2025-01-20'),
(5,4,101,2,'2025-01-25'),
(6,5,102,1,'2025-02-01'),
(7,2,103,2,'2025-02-05'),
(8,3,104,1,'2025-02-10');

-- JOINS
-- INNER JOIN
SELECT 
    l.full_name AS learner_name,
    c.course_name,
    c.category,
    p.quantity,
    FORMAT(p.quantity * c.unit_price,2) AS total_amount,
    p.purchase_date
FROM purchases p
INNER JOIN learners l 
ON p.learner_id = l.learner_id
INNER JOIN courses c 
ON p.course_id = c.course_id
ORDER BY total_amount DESC;

-- LEFT JOIN
SELECT 
    l.full_name,
    c.course_name,
    p.quantity
FROM learners l
LEFT JOIN purchases p 
ON l.learner_id = p.learner_id
LEFT JOIN courses c 
ON p.course_id = c.course_id;

-- RIGHT JOIN
SELECT 
    l.full_name,
    c.course_name,
    p.quantity
FROM learners l
RIGHT JOIN purchases p 
ON l.learner_id = p.learner_id
RIGHT JOIN courses c 
ON p.course_id = c.course_id;

-- Analytical Queries

-- Each Learner’s Total Spending
SELECT 
    l.full_name,
    l.country,
    FORMAT(SUM(p.quantity * c.unit_price),2) AS total_spent
FROM purchases p
JOIN learners l 
ON p.learner_id = l.learner_id
JOIN courses c 
ON p.course_id = c.course_id
GROUP BY l.full_name, l.country
ORDER BY total_spent DESC;

-- Top 3 Most Purchased Courses
SELECT 
    c.course_name,
    SUM(p.quantity) AS total_quantity_sold
FROM purchases p
JOIN courses c 
ON p.course_id = c.course_id
GROUP BY c.course_name
ORDER BY total_quantity_sold DESC
LIMIT 3;

-- REVENUE 
SELECT 
    c.category,
    FORMAT(SUM(p.quantity * c.unit_price),2) AS total_revenue,
    COUNT(DISTINCT p.learner_id) AS unique_learners
FROM purchases p
JOIN courses c 
ON p.course_id = c.course_id
GROUP BY c.category
ORDER BY total_revenue DESC;

-- Learners Purchasing From More Than One Category
SELECT 
    l.full_name,
    COUNT(DISTINCT c.category) AS categories_purchased
FROM purchases p
JOIN learners l 
ON p.learner_id = l.learner_id
JOIN courses c 
ON p.course_id = c.course_id
GROUP BY l.full_name
HAVING COUNT(DISTINCT c.category) > 1;

-- COURSES NOT PURCHASED
SELECT 
    c.course_name
FROM courses c
LEFT JOIN purchases p 
ON c.course_id = p.course_id
WHERE p.purchase_id IS NULL;
