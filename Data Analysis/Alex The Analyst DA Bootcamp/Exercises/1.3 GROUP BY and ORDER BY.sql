USE parks_and_recreation;

SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender					# The GROUP BY statement is similar to that of DISTINCT. However, the two differs on capabilities. The DISTINCT statement only take the unique value of any specified column(s) whereas the GROUP BY statement takes the unique value of any specified column and can perform aggregation calculation such as count, average, sum, etc.
;

SELECT * -- occupation, AVG(salary) AS Avg_sal
FROM employee_salary
-- GROUP BY occupation;
;

SELECT dept_id, AVG(salary) AS "Average Salary"
FROM employee_salary
GROUP BY dept_id;

SELECT *
FROM employee_demographics
ORDER BY age DESC;