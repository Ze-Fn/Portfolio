USE parks_and_recreation;

SELECT first_name, last_name, salary,
CASE
	WHEN salary = 50000 THEN salary
    WHEN salary < 50000 THEN salary * 1.05
    WHEN salary > 50000 THEN salary * 1.07
    WHEN dept_id = 6 THEN salary * 1.1
END AS New_salary
FROM employee_salary;

-- The CASE statement comes with an "END" as its closing statement.
-- Between the CASE and the END is the conditions that we want to apply.
-- This is basically the conditional statement of SQL.
-- Similar to that of IF statements in many programming languages.
-- However, the syntaxes in SQL takes a more natural, human-like structure.
-- Reflecting on my previous exercise on SQL, specifically about the UNION, the CASE statement can be utilized instead of rewriting all of the conditions one by one.
-- It is more simple, faster, and efficient.
-- Below is the better way to label the employee based on age and gender:
SELECT first_name, last_name, age, gender, 
CONCAT(
	(CASE 
		WHEN age BETWEEN 16 AND 19 THEN 'Teen'
		WHEN age BETWEEN 20 AND 29 THEN 'Young Adult'
		WHEN age BETWEEN 30 AND 39 THEN 'Adult'
		WHEN age BETWEEN 40 AND 49 THEN 'Old Adult'
		WHEN age >= 50 THEN "Veteran"
    END), 
    ' ',
    (CASE
		WHEN gender = 'Female' THEN 'Female'
        WHEN gender = 'Male' THEN 'Male'
	END)) AS Label
FROM employee_demographics;