USE parks_and_recreation;

SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

SELECT dem.employee_id, dem.first_name, dem.last_name, age, occupation, sal.salary
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;

-- INNER JOIN is the default when we talk about JOIN.
-- It joins any specified table(s) into another table.
-- This JOIN statement requires both of the column to have a common column (along with its value).
-- Have you ever heard of "Primari Key" as in relational database?
-- A "Primary Key" is the column that serves as the most primary column for other tables to refer to.
-- Since the topic of "Primary Key" is out of the scope of this exercise file, you are encourage it to do your own googling.
-- It does not always has to be the Primary Key, you can do INNER JOIN "ON" any specified column.
-- As you may have guessed, the ON statement is tied with JOIN statement.
-- It serves as an indicator of which column to match.
-- You may have also scratched your head when seeing "dem.employee_id" and wondered what the heck is that even mean.
-- That "dem.employee_id" is a specific argument to call a column. 
-- You may call both employee_demographics and employee_salary tables and see that both have the same column "employee_id".
-- When we want to join two tables with the same column name, we have to specify from which table is the column especially when the name of the column from both tables are identical.
-- Therefore, we use "dem.employee_id" to tell SQL that we are referring to the "employee_id" col from "dem" table.
-- It also has in intuitive argument: table.column; from the broad to narrow.
-- Let's refresh our memories on data structure.
-- In SQL, the hierarchy of a database is as follows:

-- database
-- |---- schema
-- 		|---- table
-- 				|---- column

-- Or if you prefer graphical representation, go see this image: https://i.sstatic.net/4jDwG.jpg

SELECT *
FROM employee_demographics AS dem
RIGHT OUTER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;

-- The OUTER JOIN has RIGHT and LEFT options.
-- It has the same function as JOIN statement in general but OUTER JOIN has the ability to specify which table to prioritize.
-- Let us take the code at line 40-44 as an example.
-- First off, run the codes to see both tables.
-- After that, run line 40-44 and adjust the code at line 42 to:
-- LEFT OUTER JOIN employee_sal AS sal
-- and left the rest as is.
-- You will see that it has the same output as INNER JOIN, and we can grasp anything significant in terms of comprehending the function of OUTER JOIN.
-- Therefore, let us use the code at line 40-44 without any changes and see the resulting (joined) table.
-- It appears that the RIGHT OUTER JOIN statements take the first table(s) mentioned in the FROM statement and regards it as "table in the left".
-- On the other hand, table(s) in the OUTER JOIN statement (i.e., RIGHT) is regarded as "the table in the right".
-- So, when we command the SQL to do RIGHT OUTER JOIN, we are basically telling the SQL to join the specified tables but use table on the right as the main reference.
-- We can see the evidence from the result of running code at line 40-44 without any adjustment.
-- The table employee_demographics does not contain row that specifies employee_id = 2 whereas table employee_salary does contain a row that specifies employee_id = 2.
-- For this exact reason, LEFT OUTER JOIN operation was the same as INNER JOIN but RIGHT OUTER JOIN will have row index 2 populated partially.
-- To be specific, all columns originating from table employee_demographics have null values when joined by table employee_salary.

SELECT sal1.employee_id AS emp_santa,
sal1.first_name AS first_name_santa,
sal1.last_name AS last_name_santa,
sal2.employee_id AS emp_santa,
sal2.first_name AS first_name_santa,
sal2.last_name AS last_name_santa
FROM employee_salary AS sal1
JOIN employee_salary AS sal2
	ON sal1.employee_id + 1 = sal2.employee_id
;

SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON sal.employee_id = dem.employee_id
INNER JOIN parks_departments as dp
	ON sal.dept_id = dp.department_id
;

-- The line of codes at 74-80 is a "Multiple Table JOINs".
-- Basically, it just takes the table from the FROM statement and combines it with the table in the JOIN statement.
-- It still follow the same rule that JOIN has to be followed by "ON" argument to specify which column to match.
-- When joining multiple tables, the "table on the right" can refer/tie to any of the other table.
-- There are no restriction as to which table to refer as in "we have to refer to only the table in the FROM statement", that is not true.
