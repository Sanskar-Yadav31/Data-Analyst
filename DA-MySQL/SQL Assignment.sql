# 1a. Question

SELECT employeeNumber, firstName, lastName
FROM employees
WHERE jobTitle = 'Sales Rep'
  AND reportsTo = 1102;
  
# 1b. Question

SELECT DISTINCT productLine
FROM products
WHERE productLine LIKE '%cars';

# 2. Question

SELECT 
  customerNumber,
  customerName,
  CASE 
    WHEN country IN ('USA', 'Canada') THEN 'North America'
    WHEN country IN ('UK', 'France', 'Germany') THEN 'Europe'
    ELSE 'Other'
  END AS CustomerSegment
FROM customers;

# 3a. Question

SELECT 
  productCode,
  SUM(quantityOrdered) AS total_quantity
FROM orderdetails
GROUP BY productCode
ORDER BY total_quantity DESC
LIMIT 10;

# 3b. Question

SELECT 
  MONTHNAME(paymentDate) AS MonthName,
  COUNT(*) AS total_payments
FROM payments
GROUP BY MonthName
HAVING total_payments > 20
ORDER BY total_payments DESC;

# 4a. Question

CREATE DATABASE Customers_Orders;
USE Customers_Orders;

CREATE TABLE Customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(255) UNIQUE,
  phone_number VARCHAR(20)
);

#  4b. Question 

CREATE TABLE Orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10,2),
  CONSTRAINT fk_customer
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
  CONSTRAINT chk_total_amount
    CHECK (total_amount > 0)
);

# 5a. Question
use classicmodels;
SELECT 
  c.country,
  COUNT(o.orderNumber) AS total_orders
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY c.country
ORDER BY total_orders DESC
LIMIT 5;

# 6. Question

  CREATE TABLE project (
  EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
  FullName VARCHAR(50) NOT NULL,
  Gender ENUM('Male', 'Female'),
  ManagerID INT
);



INSERT INTO project (EmployeeID, FullName, Gender, ManagerID) VALUES
(1, 'Pranaya', 'Male', 3),
(2, 'Priyanka', 'Female', 1),
(3, 'Preety', 'Female', NULL),
(4, 'Anurag', 'Male', 1),
(5, 'Sambit', 'Male', 1),
(6, 'Rajesh', 'Male', 3),
(7, 'Hina', 'Female', 3);



SELECT 
  p1.FullName AS Employee,
  p2.FullName AS Manager
FROM project p1
LEFT JOIN project p2 ON p1.ManagerID = p2.EmployeeID;

# 7. Question

CREATE TABLE facility (
  Facility_ID INT,
  Name VARCHAR(100),
  State VARCHAR(100),
  Country VARCHAR(100)
);

ALTER TABLE facility
MODIFY Facility_ID INT AUTO_INCREMENT PRIMARY KEY;

ALTER TABLE facility
ADD city VARCHAR(100) NOT NULL AFTER Name;

desc facility;

# 8. Question

CREATE VIEW product_category_sales AS
SELECT 
  pl.productLine,
  SUM(od.quantityOrdered * od.priceEach) AS total_sales,
  COUNT(DISTINCT o.orderNumber) AS number_of_orders
FROM productlines pl
JOIN products p ON pl.productLine = p.productLine
JOIN orderdetails od ON p.productCode = od.productCode
JOIN orders o ON o.orderNumber = od.orderNumber
GROUP BY pl.productLine;

SELECT * FROM product_category_sales;

# 9. Question

CALL Get_country_payments(2004, 'USA');

# 10a. Question

SELECT 
  c.customerNumber,
  c.customerName,
  COUNT(o.orderNumber) AS total_orders,
  RANK() OVER (ORDER BY COUNT(o.orderNumber) DESC) AS order_rank
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName;

# 10b. Question

SELECT 
  YEAR(orderDate) AS order_year,
  MONTHNAME(orderDate) AS order_month,
  COUNT(orderNumber) AS order_count,
  CONCAT(
    ROUND(
      (
        COUNT(orderNumber) - 
        LAG(COUNT(orderNumber)) OVER (PARTITION BY MONTH(orderDate) ORDER BY YEAR(orderDate))
      ) / 
      LAG(COUNT(orderNumber)) OVER (PARTITION BY MONTH(orderDate) ORDER BY YEAR(orderDate)) * 100
    , 0), '%') AS YoY_Change
FROM orders
GROUP BY YEAR(orderDate), MONTH(orderDate), MONTH(orderDate)
ORDER BY MONTH(orderDate), YEAR(orderDate);

# 11. Question

SELECT 
  productLine,
  COUNT(*) AS product_count
FROM products
WHERE buyPrice > (
  SELECT AVG(buyPrice) FROM products
)
GROUP BY productLine;

# 12. Question

CREATE TABLE Emp_EH (
  EmpID INT PRIMARY KEY,
  EmpName VARCHAR(100),
  EmailAddress VARCHAR(255)
);

CALL InsertIntoEmp_EH(1, 'Amit', 'amit@example.com');


# 13. Question
USE classicmodels;  -- ya jo bhi database tu use kar raha hai

DROP TABLE IF EXISTS Emp_BIT;

CREATE TABLE Emp_BIT (
  Name VARCHAR(100),
  Occupation VARCHAR(100),
  Working_date DATE,
  Working_hours INT
);

DELIMITER //

CREATE TRIGGER fix_negative_hours
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
  IF NEW.Working_hours < 0 THEN
    SET NEW.Working_hours = ABS(NEW.Working_hours);
  END IF;
END;
//

DELIMITER ;fix_negative_hours
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);


INSERT INTO Emp_BIT VALUES ('Ravi', 'Engineer', '2024-10-11', -5);
SELECT * FROM Emp_BIT;



 

