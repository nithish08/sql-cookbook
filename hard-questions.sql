-- Use of window function + dense rank for same row number for same values


-- https://leetcode.com/problems/department-top-three-salaries/description/?envType=study-plan-v2&envId=top-sql-50
-- A company's executives are interested in seeing who earns the most money in each of the company's departments. A high earner in a department is an employee who has a salary in the top three unique salaries for that department.
-- Write a solution to find the employees who are high earners in each of the departments.
-- Return the result table in any order.
-- The result format is in the following example.

with agg as (
select Employee.name as name, Salary, departmentId, Dense_rank() OVER (PARTITION BY departmentId ORDER BY Salary desc) as r,
Department.name as Department
from Employee
join Department
on Employee.departmentId=Department.id
)

select Department, name as Employee, Salary from agg where r <= 3;
