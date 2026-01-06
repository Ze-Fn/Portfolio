USE parks_and_recreation;

SELECT employee_id, first_name, last_name
FROM employee_demographics
UNION
SELECT employee_id, first_name, last_name
FROM employee_salary
ORDER BY employee_id ASC;

-- Now, the table employee_demographics is missing row for employee_id = 2 (for obvious reason).
-- We can fix this by using UNION statement.
-- If we look closely, the table employee_salary has the row the table employee_demographics is missing, the employee_id = 2 row.
-- The UNION statement has similar concept to that of JOIN, in a way that both of them concatenates table(s) into another table.
-- While JOIN statement concatenates tables to the side, UNION statement on the contrary appends the content of other table into the existing column of a specified column.
-- To make it clearer, write the code that shows both tables, then run the code at line 3-8.
-- Notice that "Ron Swanson" is not available in the table employee_demographics but is available in the table employee_salary.
-- We want to add "Ron Swanson" (his employee_id, first_name, and last_name) into the final output, because who does not want to complete a table?
-- In order to do that, we use the UNION statement as in the abovementioned codes.
-- Also, notice that the UNION statement only return the unique value instead of just concatenating the data into the table?
-- That is because the UNION statement comes with DISTINCT statement as default.
-- So, when we perform UNION, we are actually telling SQL to UNION DISTINCT.
-- Say we want to just concatenate the tables and do not care about any duplicates, we can achieve this by using "UNION ALL".
-- Let's try some advanced exercise, shall we? Because learning is all about i+1, you have to learn to at least one level above you.
-- Q: Label each of the employee to based on age. If age > 50 then Veteran, age 40-50 Senior Adult, age 30-39 Adult, age 20-29 Young Adult, age 16-19 Teen. In addition, also categorize the label to each gender.

SELECT first_name, last_name, 'Teen Male' AS Label
FROM employee_demographics
WHERE age < 20 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Young Adult Male' AS Label
FROM employee_demographics
WHERE age < 30 AND gender = 'Male'
UNION 
SELECT first_name, last_name, 'Adult Male' AS Label
FROM employee_demographics
WHERE age < 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Senior Male' AS Label
FROM employee_demographics
WHERE age > 50 AND gender = 'Male'
UNION 
SELECT first_name, last_name, 'Veteran Male' AS Label
FROM employee_demographics
WHERE age > 50 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Teen Female' AS Label
FROM employee_demographics
WHERE age < 20 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'Young Adult Female' AS Label
FROM employee_demographics
WHERE age < 30 AND gender = 'Female'
UNION 
SELECT first_name, last_name, 'Adult Female' AS Label
FROM employee_demographics
WHERE age < 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'Senior Female' AS Label
FROM employee_demographics
WHERE age < 50 AND gender = 'Female'
UNION 
SELECT first_name, last_name, 'Veteran Female' AS Label
FROM employee_demographics
WHERE age > 50 AND gender = 'Female'
ORDER BY first_name;

-- Doing this categorization is painstakingly slow and inefficient.
-- I wonder if there is any method that can simplify this categorization.
-- I have studied Python a little bit and I recalled a built-in function in Python that can do conditional statement without rewriting the same code over and over again.
