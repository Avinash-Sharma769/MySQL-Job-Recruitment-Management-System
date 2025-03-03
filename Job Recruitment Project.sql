/*🚀 Advanced MySQL Project: Job Recruitment Management System (Enterprise-Level)
This is a highly advanced, real-world, job-ready MySQL project that includes:
✔ Correlated Subqueries
✔ COALESCE Function
✔ Aggregate Functions (MAX, MIN)
✔ Window Functions: RANK(), DENSE_RANK(), LAG(), LEAD(), NTILE(), PERCENT_RANK(), ROW_NUMBER()
✔ CASE Statements
✔ Views (In-Depth)
✔ Stored Procedures
✔ Triggers
✔ ROLLUP for Advanced Aggregation
✔ Other Real-World, Most Needed MySQL Concepts for Industry

This project is resume-worthy and 100% industry-level, making it a strong addition for a MySQL Developer role.

📌 Project Concept: Job Recruitment Management System
This system will manage:
✅ Employers – Companies posting jobs
✅ Jobs – Job listings posted by employers
✅ Candidates – Users applying for jobs
✅ Applications – Candidate applications and their status*/

-- Step 1: Database and Table Creation (DDL Commands)
-- Create the database
CREATE DATABASE JobRecruitmentDB;
USE JobRecruitmentDB;

-- Employers Table (Stores employer details)
CREATE TABLE Employers (
    employer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    company_name VARCHAR(100) NOT NULL
);

-- Jobs Table (Stores job details)
CREATE TABLE Jobs (
    job_id INT AUTO_INCREMENT PRIMARY KEY,
    employer_id INT,
    title VARCHAR(100) NOT NULL,
    category ENUM('IT', 'Finance', 'Healthcare', 'Education', 'Others'),
    salary DECIMAL(10,2),
    location VARCHAR(100),
    job_type ENUM('Full-time', 'Part-time', 'Remote'),
    posted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employer_id) REFERENCES Employers(employer_id) ON DELETE CASCADE
);

-- Candidates Table (Stores candidate details)
CREATE TABLE Candidates (
    candidate_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    skills TEXT NOT NULL
);

-- Applications Table (Stores job applications)
CREATE TABLE Applications (
    application_id INT AUTO_INCREMENT PRIMARY KEY,
    job_id INT,
    candidate_id INT,
    applied_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Accepted', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (job_id) REFERENCES Jobs(job_id) ON DELETE CASCADE,
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id) ON DELETE CASCADE
);
/*👉 DDL (Data Definition Language) creates tables and relationships.
👉 Foreign keys ensure relational integrity.*/

-- Step 2: Inserting Sample Data (DML Commands)
-- Insert Employers
INSERT INTO Employers (name, email, phone, company_name) 
VALUES 
('John Doe', 'john@company.com', '9876543210', 'Tech Solutions'),
('Alice Smith', 'alice@finance.com', '8765432109', 'Finance Experts');

-- Insert Jobs
INSERT INTO Jobs (employer_id, title, category, salary, location, job_type) 
VALUES 
(1, 'Software Engineer', 'IT', 80000, 'New York', 'Full-time'),
(1, 'Web Developer', 'IT', 70000, 'San Francisco', 'Remote'),
(2, 'Accountant', 'Finance', 60000, 'Los Angeles', 'Full-time');

-- Insert Candidates
INSERT INTO Candidates (name, email, phone, skills) 
VALUES 
('Mike Johnson', 'mike@gmail.com', '7654321098', 'Python, Java, SQL'),
('Emma Brown', 'emma@gmail.com', '6543210987', 'Accounting, Excel, Finance');

-- Insert Applications
INSERT INTO Applications (job_id, candidate_id, status) 
VALUES 
(1, 1, 'Pending'), 
(2, 1, 'Accepted'), 
(3, 2, 'Rejected');
/*✅ Auto-incremented IDs ensure unique records.
✅ Job applications are linked to jobs and candidates.*/

-- Step 3: Using Advanced SQL Concepts
-- 🔹 Correlated Subquery
-- Find the highest-paid job for each employer
SELECT title, salary, employer_id 
FROM Jobs J1
WHERE salary = (SELECT MAX(salary) FROM Jobs J2 WHERE J1.employer_id = J2.employer_id);
-- ✅ Correlated Subqueries dynamically fetch data per row.

-- 🔹 COALESCE Function
-- Display job salary, but show "Not Disclosed" if NULL
SELECT title, COALESCE(salary, 'Not Disclosed') AS salary FROM Jobs;
-- ✅ COALESCE replaces NULL values.

-- 🔹 Aggregate Functions (MAX, MIN)
-- Get the highest and lowest salary in IT jobs
SELECT MAX(salary) AS HighestSalary, MIN(salary) AS LowestSalary FROM Jobs WHERE category = 'IT';
-- ✅ MAX/MIN find highest and lowest values.

-- 🔹 Window Functions
-- Rank jobs by salary (same salary gets same rank)
SELECT title, salary, RANK() OVER (ORDER BY salary DESC) AS Rank FROM Jobs;

-- Dense Rank (no gaps in ranking)
SELECT title, salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS DenseRank FROM Jobs;

-- LAG (Get previous job’s salary)
SELECT title, salary, LAG(salary) OVER (ORDER BY salary DESC) AS PreviousSalary FROM Jobs;

-- LEAD (Get next job’s salary)
SELECT title, salary, LEAD(salary) OVER (ORDER BY salary DESC) AS NextSalary FROM Jobs;

-- NTILE (Divide jobs into 4 salary groups)
SELECT title, salary, NTILE(4) OVER (ORDER BY salary DESC) AS SalaryGroup FROM Jobs;

-- PERCENT_RANK (Find salary percentile)
SELECT title, salary, PERCENT_RANK() OVER (ORDER BY salary DESC) AS SalaryPercentile FROM Jobs;

-- ROW_NUMBER (Unique row numbers)
SELECT title, salary, ROW_NUMBER() OVER (ORDER BY salary DESC) AS RowNum FROM Jobs;
-- ✅ Window functions help analyze ordered data.

-- 🔹 CASE Statement
-- Categorize jobs based on salary
SELECT title, salary,
CASE 
    WHEN salary > 75000 THEN 'High Salary'
    WHEN salary BETWEEN 50000 AND 75000 THEN 'Medium Salary'
    ELSE 'Low Salary'
END AS SalaryCategory
FROM Jobs;
-- ✅ CASE helps create conditional logic in queries.

-- 🔹 Views
-- Create a view to simplify job listings with employer details
CREATE VIEW JobListings AS
SELECT J.title, J.salary, E.company_name 
FROM Jobs J
JOIN Employers E ON J.employer_id = E.employer_id;
-- ✅ Views simplify complex queries.

-- 🔹 Stored Procedure
DELIMITER //
CREATE PROCEDURE GetJobsByCategory(IN jobCategory VARCHAR(50))
BEGIN
    SELECT * FROM Jobs WHERE category = jobCategory;
END //
DELIMITER ;
-- ✅ Stored procedures help reuse queries.

-- 🔹 Triggers
DELIMITER //
CREATE TRIGGER BeforeApplicationInsert
BEFORE INSERT ON Applications
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM Applications WHERE candidate_id = NEW.candidate_id AND status = 'Pending') >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Candidates cannot have more than 3 pending applications';
    END IF;
END //
DELIMITER ;
-- ✅ Triggers enforce business rules automatically.

-- 🔹 ROLLUP
-- Get total jobs per category and grand total
SELECT category, COUNT(*) AS TotalJobs
FROM Jobs
GROUP BY category WITH ROLLUP;
-- ✅ ROLLUP provides subtotals and grand totals.

/*📌 Final Thoughts
🔥 This project is a fully professional, real-world MySQL project covering all advanced topics.
📌 Everything is explained in detail with comments.
📌 This project can be added to your resume and will impress recruiters.*/

