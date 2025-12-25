USE parks_and_recreation;

SELECT *
FROM employee_demographics
WHERE employee_id IN (
	SELECT employee_id
    FROM employee_salary
    WHERE dept_id = 1)
;

-- Perhaps the above code is not the best example when it comes to understanding "SUBQUERIES". 
-- SUBQUERIES is essentially a query within a query.
-- A query-ception.
-- We can call a subqueries by simply replacing an argument when calling a column with another queries in parenthesis.
-- Let us take a look on the following lines of codes (Code1 and Code2).

# Code1. Compare each employee's salary based on the average salary
SELECT first_name, salary, AVG(salary)
FROM employee_salary
GROUP BY first_name, salary;

-- Code1 will return the average of each of the salary, not the entire employee.
-- You can easily spot the odd pattern by examining the salary and AVG(salary) column in the output.
-- Both of the columns, they are basically the same number, which means that there is something wrong with out code and logic.
-- See the below code (Code2) for a better example.

# Code2: Compare each employee's salary bnased on the average salary
SELECT first_name, last_name, salary,
	(SELECT AVG(salary) 
	FROM employee_salary)
FROM employee_salary;

-- Notice that there is a subqueries inside the SELECT statement.
-- Let us break this down into smaller pieces so we can digest easier.
-- The SELECT statement in Code2 has four arguments:
-- 1. first_name
-- 2. last_name
-- 3. salary
-- 4. (SELECT AVG(salary) FROM employee_salary)
-- and then followed by the FROM statement.
-- See, the fourth argument is actually the fourth column but since we use a subquery, the main argument seems nested.

-- Beside subquerying in the SELECT statement, we can also use substring in the FROM statement.
-- The most easy-to-digest explanation for "Subquerying in the FROM statement" would perhaps be "temporary table".
-- Let us take a look at the example below.

# Code3: Find the average of age of each gender separately
SELECT *, (SELECT avg_age FROM agg_age)
FROM (SELECT
	gender,
    AVG(age) AS avg_age,
    MIN(age) AS min_age,
    MAX(age) AS max_age,
    COUNT(age) AS count_age
    FROM employee_demographics
    GROUP BY gender) AS agg_age
;

SELECT *, COUNT(gender)
FROM (SELECT
	gender,
    AVG(age) AS avg_age,
    MIN(age) AS min_age,
    MAX(age) AS max_age,
    COUNT(age) AS count_age
    FROM employee_demographics
    GROUP BY gender) AS agg_age
GROUP BY gender;

SELECT 
	gender,
	COUNT(gender),
    SUM(gender)
FROM employee_demographics
GROUP BY gender;