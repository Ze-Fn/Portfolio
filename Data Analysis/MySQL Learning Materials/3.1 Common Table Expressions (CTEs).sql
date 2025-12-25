USE parks_and_recreation;

# Code 1
WITH CTE_Example AS
(
SELECT gender, AVG(salary), SUM(salary), MIN(salary), MAX(salary)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE_Example
;
-- The Code 1 above is a demonstration of CTE, a short for Common Table Expressions.
-- It similar to making a temporary table.
-- Its main function is to increase readibility and for further advanced aggregations.
-- It is far more readable and user friendly compared to that of Subeuqery techniques.
-- CTE is indicated by the WITH at the very beginning of the code.

# Code 2
WITH CTE_Example1 AS
(
SELECT gender, AVG(salary), SUM(salary), MIN(salary), MAX(salary), COUNT(salary)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
),
CTE_example2 AS
(
SELECT employee_id, first_name, last_name
FROM employee_demographics
)
SELECT *
FROM CTE_Example2
;
-- The Code 2 above shows that we can create two CTEs in one go.
-- The concept is similar to Subquery.

# Code 3
WITH CTE_Example1 (gender, AVG_sal, SUM_sal, MIN_sal, MAX_sal) AS
(
SELECT gender, AVG(salary), SUM(salary), MIN(salary), MAX(salary)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE_Example1
;
-- The Code 3 above shows that we can alias the column name within our CTE by simply giving the alias right after calling for the CTE function.
-- Take a look at line 42. Instead of giving the alias right next to the column query (which can be tedious sometimes),
-- we can just give it in one go at the very beginning of our CTE.
-- This can save our time and sanity of renaming/aliasing the columns.
