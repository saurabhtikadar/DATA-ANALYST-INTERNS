CREATE DATABASE companydb;
-- Step 1: Create Tables
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT,
    Salary NUMERIC,
    HireDate DATE);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100),
    ManagerID INT);

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(200),
    DepartmentID INT,
    Budget NUMERIC,
    StartDate DATE,
    EndDate DATE);

CREATE TABLE EmployeeProjects (
    EmployeeID INT,
    ProjectID INT,
    Role VARCHAR(50),
    HoursWorked INT,
    PRIMARY KEY (EmployeeID, ProjectID));

-- Step 2: Import Data from CSV Files
COPY Employees(EmployeeID, FirstName, LastName, DepartmentID, Salary, HireDate)
FROM 'D:/DATA ANALYST/Internship/employees.csv'
DELIMITER ','
CSV HEADER;

COPY Departments(DepartmentID, DepartmentName, ManagerID)
FROM 'D:/DATA ANALYST/Internship/departments.csv'
DELIMITER ','
CSV HEADER;

COPY Projects(ProjectID, ProjectName, DepartmentID, Budget, StartDate, EndDate)
FROM 'D:/DATA ANALYST/Internship/projects.csv'
DELIMITER ','
CSV HEADER;

COPY EmployeeProjects(EmployeeID, ProjectID, Role, HoursWorked)
FROM 'D:/DATA ANALYST/Internship/employee_projects.csv'
DELIMITER ','
CSV HEADER;
----------------------------------------------------------------
--Analyze employee contributions, project involvement, and salary alignment within a specific department, like IT.
CREATE OR REPLACE VIEW employees_with_projects_and_total_hours_worked AS
SELECT e.EmployeeID,e.FirstName,e.LastName,d.DepartmentName,p.ProjectName,
    SUM(ep.HoursWorked) AS TotalHoursWorked,e.Salary
FROM Employees e
JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects p ON ep.ProjectID = p.ProjectID
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'IT' -- Specify the department name
GROUP BY e.EmployeeID, e.FirstName, e.LastName, d.DepartmentName, p.ProjectName, e.Salary
ORDER BY e.salary DESC;

SELECT * FROM employees_with_projects_and_total_hours_worked;
--This SQL query retrieves detailed information about employees, their departments, and projects, along with the total hours they have worked on various projects, specifically for employees in the "IT" department.
------------------------------------------------------------------------
--1. INNER JOIN - Shows only the records that match in all the joined tables.
--Example: Combine employees, departments, and projects where all the related data exists in the tables.
CREATE OR REPLACE VIEW employees_details_with_inner_join AS
SELECT e.EmployeeID, e.FirstName, e.LastName, d.DepartmentName, p.ProjectName, ep.Role, ep.HoursWorked
FROM Employees e
INNER JOIN 
		Departments d ON e.DepartmentID = d.DepartmentID
INNER JOIN 
		EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN 
		Projects p ON ep.ProjectID = p.ProjectID;

SELECT * FROM employees_details_with_inner_join;
--This query will display all employees involved in any project along with their respective department and project information. Employees not associated with any project will be excluded.
--------------------------------------------------------------------------
--2. LEFT JOIN with FILTER : Retrieves all records from the first table (Employees) and the matching records from the other tables (Departments, Projects), even if some data is missing.
--Example : To display employees from a specific department
CREATE OR REPLACE VIEW employees_details_with_left_join AS
SELECT e.EmployeeID, e.FirstName, e.LastName, d.DepartmentName, p.ProjectName, ep.Role, ep.HoursWorked
FROM Employees e
LEFT JOIN 
		Departments d ON e.DepartmentID = d.DepartmentID
LEFT JOIN 
		EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
LEFT JOIN 
		Projects p ON ep.ProjectID = p.ProjectID
WHERE d.DepartmentName = 'HR';

SELECT * FROM employees_details_with_left_join;
--This query will display only employees from the HR department and their associated projects.
------------------------------------------------------------------------------
--3. RIGHT JOIN with FILTER : Retrieves all records from the second table (Projects) and the matching records from the first table (Employees), even if employee data is missing.
--Example : To display employees from a specific department
CREATE OR REPLACE VIEW employees_details_with_right_join AS
SELECT e.EmployeeID, e.FirstName, e.LastName, d.DepartmentName, p.ProjectName, ep.Role, ep.HoursWorked
FROM Projects p
RIGHT JOIN 
		EmployeeProjects ep ON p.ProjectID = ep.ProjectID
RIGHT JOIN 
		Employees e ON ep.EmployeeID = e.EmployeeID
RIGHT JOIN 
		Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'IT';

SELECT * FROM employees_details_with_right_join;
--This query will display only employees from the IT department and their associated projects.
----------------------------------------------------------------------------------
-- With subqueries
--1. Employees earning more than their department's average salary
CREATE OR REPLACE VIEW earning_more_than_avg AS
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Salary, d.DepartmentName
FROM 
    Employees e
JOIN 
    Departments d ON e.DepartmentID = d.DepartmentID
WHERE 
    e.Salary > (
        SELECT AVG(Salary)
        FROM Employees
        WHERE DepartmentID = e.DepartmentID);

SELECT * FROM earning_more_than_avg;
--This query lists employees who earn more than the average salary of their respective departments.

--2. Total hours worked on a project and project budget
CREATE OR REPLACE VIEW project_budget_hours AS
SELECT p.ProjectName, p.Budget,(
        SELECT SUM(ep.HoursWorked) 
        FROM EmployeeProjects ep 
        WHERE ep.ProjectID = p.ProjectID) AS TotalHours
FROM Projects p
WHERE p.Budget > 50000;

SELECT * FROM project_budget_hours;
--This query shows project names, their budgets, and the total hours worked for projects with a budget greater than 50,000.
--3. Employee with the longest tenure
SELECT e.FirstName,e.LastName,e.HireDate
FROM Employees e
WHERE e.HireDate = (SELECT MIN(HireDate) FROM Employees);
--This query retrieves the details of the employee who has been working the longest in the company.
--4. Total project budget per department
CREATE OR REPLACE VIEW department_budget AS
SELECT d.DepartmentName,(
        SELECT SUM(p.Budget) 
        FROM Projects p 
        WHERE p.DepartmentID = d.DepartmentID) AS TotalBudget
FROM Departments d;

SELECT * FROM department_budget;
--This query displays the total project budget for each department.
--5. Employees working on the highest-budget project
CREATE OR REPLACE VIEW employees_with_high_budget AS
SELECT e.FirstName,e.LastName,p.ProjectName,p.Budget
FROM Employees e
JOIN 
    EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
JOIN 
    Projects p ON ep.ProjectID = p.ProjectID
WHERE p.Budget = (
        SELECT MAX(Budget) 
        FROM Projects);

SELECT * FROM employees_with_high_budget;
--This query lists employees working on the project with the highest budget.
--6. Highest-paid employee in each department
CREATE OR REPLACE VIEW employees_high_salary AS
SELECT e.EmployeeID,e.FirstName,e.LastName,e.Salary,d.DepartmentName
FROM Employees e
JOIN 
    Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary = (
        SELECT MAX(Salary) 
        FROM Employees 
        WHERE DepartmentID = e.DepartmentID);

SELECT * FROM employees_high_salary;
--This query identifies the highest-paid employee in each department.
-----------------------------------------------------------------------------
--Use aggregate functions (SUM, AVG, COUNT)
--The query will generate a summary report for each department, including:
--1.The department's total project budget.
--2.The average salary of its employees.
--3.The total number of employees in the department.
--4.The total hours worked by employees on all associated projects.
CREATE OR REPLACE VIEW report_each_department AS
SELECT d.DepartmentName AS Department,
    SUM(p.Budget) AS TotalBudget,
    AVG(e.Salary) AS AverageSalary,
    COUNT(e.EmployeeID) AS TotalEmployees,
    SUM(ep.HoursWorked) AS TotalHoursWorked
FROM Departments d
LEFT JOIN Employees e 
    ON d.DepartmentID = e.DepartmentID
LEFT JOIN Projects p 
    ON d.DepartmentID = p.DepartmentID
LEFT JOIN EmployeeProjects ep 
    ON e.EmployeeID = ep.EmployeeID
GROUP BY d.DepartmentName
ORDER BY TotalBudget DESC;

SELECT * FROM report_each_department;
-------------------------------------------------------------------
--Optimize queries with indexes
--1. Departments Table
--In the Departments table, create indexes on DepartmentID to quickly fetch related data.
-- Create an index on DepartmentID (Primary key already indexed)
CREATE INDEX idx_department_id ON Departments(DepartmentID);
--2. Projects Table
--In the Projects table, create indexes on DepartmentID, and StartDate to optimize queries involving projects.
-- Create an index on DepartmentID for faster lookup by department
CREATE INDEX idx_project_department ON Projects(DepartmentID);
-- Create an index on StartDate to optimize queries that filter by start date
CREATE INDEX idx_project_start_date ON Projects(StartDate);

-- Optimized query using index on DepartmentID
--example:retrieve all projects for a specific department, an index on DepartmentID will help:
SELECT p.ProjectName, p.Budget, p.StartDate 
FROM Projects p
JOIN Departments d ON p.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'IT';
--To ensure PostgreSQL is using the indexes, use the EXPLAIN command:
EXPLAIN ANALYZE
SELECT p.ProjectName, p.Budget, p.StartDate 
FROM Projects p
JOIN Departments d ON p.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'IT';
--This will show whether the indexes are being used and provide insights into query performance.