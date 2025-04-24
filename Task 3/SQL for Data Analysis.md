# Company Database Management

This repository contains SQL scripts for managing a company database. The database is designed to manage employee information, departmental structure, project details, and employee involvement in projects. Below is an overview of the functionality provided by the scripts and how to use them.

---

## Database Schema
**Database file : [Company Database Zip](https://github.com/saurabhtikadar/DATA-ANALYST-INTERNS/blob/main/Task%203/Company%20Database%20Zip.zip)**
### 1. **Tables**
The following tables are created to organize the data:

- **Employees**:
  - `EmployeeID` (Primary Key)
  - `FirstName`
  - `LastName`
  - `DepartmentID`
  - `Salary`
  - `HireDate`

- **Departments**:
  - `DepartmentID` (Primary Key)
  - `DepartmentName`
  - `ManagerID`

- **Projects**:
  - `ProjectID` (Primary Key)
  - `ProjectName`
  - `DepartmentID`
  - `Budget`
  - `StartDate`
  - `EndDate`

- **EmployeeProjects**:
  - `EmployeeID`
  - `ProjectID`
  - `Role`
  - `HoursWorked`
  - Composite Primary Key (`EmployeeID`, `ProjectID`)

---

## Importing Data

Data is imported into the database using CSV files with the following commands:

```sql
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
```

---

## Views and Queries

### **1. Analyzing Employee Contributions**
```sql
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
```
- View: `employees_with_projects_and_total_hours_worked`
- Retrieves detailed information about employees, their departments, and projects, along with the total hours they have worked on projects within the "IT" department.

### **2. Joining Data**

- **a. INNER JOIN:** Shows only the records that match in all the joined tables.
```sql
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
```
- View: `employees_details_with_inner_join`
- Displays employees involved in any project along with their department and project details.

- **b. LEFT JOIN with Filter**:Retrieves all records from the first table (Employees) and the matching records from the other tables (Departments, Projects), even if some data is missing.
```sql
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
```
- View: `employees_details_with_left_join`
- Displays all employees from the "HR" department, including those not associated with any project.

- **c. RIGHT JOIN with Filter**:Retrieves all records from the second table (Projects) and the matching records from the first table (Employees), even if employee data is missing.
```sql
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
```
- View: `employees_details_with_right_join`
- Displays all employees and their projects within the "IT" department.

### **3. Subqueries**

1. Employees Earning More Than Their Department's Average Salary
```sql
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
```
- View: `earning_more_than_avg`

2. Total Hours Worked on Projects with Budgets Over 50,000
```sql
CREATE OR REPLACE VIEW project_budget_hours AS
SELECT p.ProjectName, p.Budget,(
        SELECT SUM(ep.HoursWorked) 
        FROM EmployeeProjects ep 
        WHERE ep.ProjectID = p.ProjectID) AS TotalHours
FROM Projects p
WHERE p.Budget > 50000;

SELECT * FROM project_budget_hours;
```
- View: `project_budget_hours`

3. Employee with the Longest Tenure
```sql
CREATE OR REPLACE VIEW longest_tenure_employee AS
SELECT e.FirstName,e.LastName,e.HireDate
FROM Employees e
WHERE e.HireDate = (SELECT MIN(HireDate) FROM Employees);

SELECT * FROM longest_tenure_employee;
```
- View: `longest_tenure_employee`

4. Total Project Budget per Department
```sql
CREATE OR REPLACE VIEW department_budget AS
SELECT d.DepartmentName,(
        SELECT SUM(p.Budget) 
        FROM Projects p 
        WHERE p.DepartmentID = d.DepartmentID) AS TotalBudget
FROM Departments d;

SELECT * FROM department_budget;
```
- View: `department_budget`

5. Employees on the Highest-Budget Project
```sql
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
```
- View: `employees_with_high_budget`

6. Highest-Paid Employee in Each Department
```sql
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
```
- View: `employees_high_salary`

### **4. Aggregate Reports**
Generates a summary report for each department, including total project budget, average employee salary, total employees, and total hours worked.
```sql
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
```
- View: `report_each_department`

---

## Query Optimization

Indexes are created to improve query performance:

- **1. Departments Table**:
  - Index on `DepartmentID` (Primary Key already indexed).

- **2. Projects Table**:
  - Index on `DepartmentID` for department-specific queries.
  - Index on `StartDate` for date-specific queries.

### Example of Optimized Query
Retrieve all projects for the "IT" department:

```sql
SELECT p.ProjectName, p.Budget, p.StartDate 
FROM Projects p
JOIN Departments d ON p.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'IT';
```

### Validate Optimization
Use the `EXPLAIN ANALYZE` command:

```sql
EXPLAIN ANALYZE
SELECT p.ProjectName, p.Budget, p.StartDate 
FROM Projects p
JOIN Departments d ON p.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'IT';
```

---

## Contribution
Feel free to submit issues or pull requests to enhance this repository.
