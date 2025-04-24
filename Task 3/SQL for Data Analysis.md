# Company Database Management

This repository contains SQL scripts for managing a company database. The database is designed to manage employee information, departmental structure, project details, and employee involvement in projects. Below is an overview of the functionality provided by the scripts and how to use them.

---

## Database Schema
**Database file : [Company Database Zip]()**
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
- View: `employees_with_projects_and_total_hours_worked`
- Retrieves detailed information about employees, their departments, and projects, along with the total hours they have worked on projects within the "IT" department.

### **2. Joining Data**

#### **INNER JOIN**
- View: `employees_details_with_inner_join`
- Displays employees involved in any project along with their department and project details.

#### **LEFT JOIN with Filter**
- View: `employees_details_with_left_join`
- Displays all employees from the "HR" department, including those not associated with any project.

#### **RIGHT JOIN with Filter**
- View: `employees_details_with_right_join`
- Displays all employees and their projects within the "IT" department.

### **3. Subqueries**

#### Employees Earning More Than Their Department's Average Salary
- View: `earning_more_than_avg`

#### Total Hours Worked on Projects with Budgets Over 50,000
- View: `project_budget_hours`

#### Employee with the Longest Tenure
- Query to retrieve the employee with the earliest hire date.

#### Total Project Budget per Department
- View: `department_budget`

#### Employees on the Highest-Budget Project
- View: `employees_with_high_budget`

#### Highest-Paid Employee in Each Department
- View: `employees_high_salary`

### **4. Aggregate Reports**
- View: `report_each_department`
- Generates a summary report for each department, including total project budget, average employee salary, total employees, and total hours worked.

---

## Query Optimization

Indexes are created to improve query performance:

- **Departments Table**:
  - Index on `DepartmentID` (Primary Key already indexed).

- **Projects Table**:
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
