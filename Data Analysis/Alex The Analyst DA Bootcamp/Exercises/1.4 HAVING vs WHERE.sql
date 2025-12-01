USE parks_and_recreation;

SELECT occupation, AVG(salary) AS "Average Salary"
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) >= 55000
;

-- The idea of HAVING is that it filters data specifically for those of aggregated functions had performed. 
-- An example has been provided on the previous lines of code.
-- HAVING statement comes after the GROUP BY statement and this is a MUST.
-- Another note to take is that the WHERE clause cannot be used to filter columns from aggregated functions.
-- Say, if we wanted to find out "what occupation has average salary of more than or equal to 55000?", we do not use:
-- WHERE AVG(salary) >= 55000
-- This will result in an error because the WHERE statement simply does not accept aggregated function result.
-- As an alternative, the HAVING statement provides the solution to this specific case scenario.