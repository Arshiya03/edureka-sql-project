-- 1. Create department table
CREATE TABLE department (
    Dept_id INT PRIMARY KEY,
    D_Name NVARCHAR(100) NOT NULL,
    Contact_no INT UNIQUE
);

-- 2. Create employee table
CREATE TABLE employee (
    Emp_id INT PRIMARY KEY,
    Dept_id INT,
    Emp_name NVARCHAR(100),
    Designation NVARCHAR(100),
    Salary MONEY,
    FOREIGN KEY (Dept_id) REFERENCES department(Dept_id)
);

-- 3. ADD A NEW COLUMN IN DEPARTMENT TABLE
ALTER TABLE department
ADD City NVARCHAR(50);

-- 4. CHANGE THE DATATYPE OF SALARY TO CHAR(10) IN EMPLOYEE
ALTER TABLE employee
ALTER COLUMN Salary CHAR(10);

-- 5. DELETE THE ‘CITY’ COLUMN FROM THE DEPARTMENT TABLE
ALTER TABLE department
DROP COLUMN City;

-- 6. RENAME A COLUMN(D_NAME) IN DEPARTMENT TABLE to (Dept_NAME)
EXEC sp_rename 'department.D_Name', 'Dept_NAME', 'COLUMN';

-- Data Manipulation language: Insert Values in employee table
INSERT INTO employee (Emp_id, Dept_id, Emp_name, Designation, Salary) VALUES
(1, 1, 'S Ahmad', 'Sales Mgr', '50000'),
(2, 2, 'Anand', 'Senior Mgr', '40000'),
(3, 3, 'Aruna', 'Accounts Mgr', '45000'),
(4, 3, 'Alpesh', 'Accountant', '35000'),
(5, 1, 'Monica', 'Incharge', '25000'),
(6, 1, 'Harish', 'Sales Man', '15000');

-- Assuming you have a way to link employees to cities (this info isn't in the employee table definition)
-- For demonstration, let's assume a temporary link based on the initial data:
-- emp-4 (Alpesh) is in Bangalore, emp-6 (Harish) is in Bangalore.
-- Let's update Harish's contact number.
UPDATE employee
SET contact_no = '9999999999' -- Assuming a contact_no column exists now (it wasn't in the CREATE TABLE)
WHERE Designation = 'Sales Man' AND Emp_id = 6;

-- 8. Select given selective columns from employee table.
SELECT Emp_id, Emp_name, Designation
FROM employee;

-- 9. Select all details of employee whose salary is greater than 30000.
SELECT *
FROM employee
WHERE CAST(Salary AS INT) > 30000;

-- 10. Select details of employee whose salary is between 15000 and 30000
SELECT *
FROM employee
WHERE CAST(Salary AS INT) BETWEEN 15000 AND 30000;

-- 11. Select * from employee who lives in ‘Bangalore’ or ‘New Delhi’
-- Note: The employee table doesn't have a 'city' column.
-- Assuming you have another table or a way to link employees to cities, you'd join them here.
-- For now, we can't directly answer this without that link.

-- 12. Select * from employee who do not stay in cities ‘Bangalore’ and ‘New Delhi’
-- Same limitation as above, we need a 'city' link.

-- 13. Select details of employee whose name starts with character ‘A’
SELECT *
FROM employee
WHERE Emp_name LIKE 'A%';

-- 14. Arrange the details of employee in descending order of their salary.
SELECT *
FROM employee
ORDER BY CAST(Salary AS INT) DESC;

-- 15. Retrieve the average salary of employee per department.
SELECT Dept_id, AVG(CAST(Salary AS INT)) AS AverageSalary
FROM employee
GROUP BY Dept_id;

-- 16. Get the details of Employee( dept_id, Salary) and its average salary whose
-- average salary is greater than 30000
SELECT e.Dept_id, e.Salary, da.AverageSalary
FROM employee e
JOIN (SELECT Dept_id, AVG(CAST(Salary AS INT)) AS AverageSalary
      FROM employee
      GROUP BY Dept_id
      HAVING AVG(CAST(Salary AS INT)) > 30000) da ON e.Dept_id = da.Dept_id;



CREATE TABLE Company (
    Emp_id INT PRIMARY KEY,
    Name NVARCHAR(50),
    Age INT,
    Address NVARCHAR(50),
    Salary NUMERIC(8, 2),
    Join_date DATE
);

-- Step2. Insert data into Company Table
INSERT INTO Company (Emp_id, Name, Age, Address, Salary, Join_date) VALUES
(1, 'PAUL', 32, 'CALIFORNIA', 20000.00, '2001-07-13'),
(3, 'ALLEN', 23, 'NORWAY', 20000.00, NULL),
(4, 'DAVID', 25, 'RICHMOND', 65000.00, '2010-10-25'),
(5, 'MARK', 27, 'TEXAS', 35000.00, '2015-11-02'),
(2, 'TEDDY', 25, 'LOS VEGAS', NULL, '2013-09-01');

-- Step3. Create Dept Table
CREATE TABLE Dept (
    Id INT PRIMARY KEY,
    Dept NVARCHAR(20),
    emp_id INT
);

-- Step4. Insert data into Dept table
INSERT INTO Dept (Id, Dept, emp_id) VALUES
(1, 'IT BILLING', 1),
(2, 'ENGINEERING', 2),
(3, 'FINANCE', 41); -- Note: Emp_id 41 doesn't exist in the Company table yet

-- 17. Query1. Fetch details for employee with id = 2
SELECT
    c.Emp_Id,
    c.Name,
    d.Dept,
    d.Id AS Dept_Id,
    c.Age,
    c.Salary
FROM Company c
JOIN Dept d ON c.Emp_id = d.emp_id
WHERE c.Emp_id = 2;

-- 18. Create a stored procedure to fetch columns based on emp id
-- Note: The Dept table has a column named 'Id', let's refer to it as 'Dep_Id' for clarity
-- Assuming you want to create this stored procedure in a SQL Server environment
CREATE PROCEDURE GetEmployeeDetailsByEmpId (@EmpId INT)
AS
BEGIN
    SELECT
        c.Emp_Id,
        c.Name,
        d.Dept,
        d.Id AS Dep_Id,
        c.Age,
        c.Salary
    FROM Company c
    JOIN Dept d ON c.Emp_id = d.emp_id
    WHERE c.Emp_id = @EmpId;
END;

-- To execute the stored procedure:
-- EXEC GetEmployeeDetailsByEmpId @EmpId = 2;

-- 19. Create a view to fetch the details of employee with specified columns
CREATE VIEW EmployeeDetailsView AS
SELECT
    c.Emp_Id,
    c.Name,
    d.Dept,
    d.Id AS Dep_Id,
    c.Age,
    c.Salary
FROM Company c
JOIN Dept d ON c.Emp_id = d.emp_id;

-- To query the view:
-- SELECT * FROM EmployeeDetailsView;
