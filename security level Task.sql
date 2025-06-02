USE master;
CREATE LOGIN hr_login WITH PASSWORD = 'HrStrongP@ss1';
CREATE LOGIN sales_login WITH PASSWORD = 'SalesStrongP@ss1';
CREATE DATABASE Securiity;
USE Securiity;
CREATE USER hr_user FOR LOGIN hr_login;
CREATE USER sales_user FOR LOGIN sales_login;
CREATE SCHEMA HR AUTHORIZATION hr_user;
CREATE SCHEMA Sales AUTHORIZATION sales_user;
CREATE TABLE HR.Employees (
    EmployeeID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Position VARCHAR(50),
    Salary DECIMAL(10,2)
);
CREATE TABLE Sales.Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Region VARCHAR(50)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::HR TO hr_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Sales TO sales_user;
DENY SELECT ON SCHEMA::Sales TO hr_user;
DENY SELECT ON SCHEMA::HR TO sales_user;
SELECT * FROM HR.Employees;
SELECT * FROM Sales.Customers;
SELECT * FROM HR.Employees;
-- Bonus Simulation: Role-Based Test
-- Create role with limited SELECT access
CREATE ROLE ReadOnly_Dev;
GRANT SELECT ON SCHEMA::Sales TO ReadOnly_Dev;
ALTER ROLE ReadOnly_Dev ADD MEMBER sales_user;
-- Now test from this user:
SELECT * FROM Sales.Customers;   --  Allowed
INSERT INTO Sales.Customers VALUES (5, 'Ali', 'East'); -- Denied






