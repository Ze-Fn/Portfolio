USE parks_and_recreation;

# Code 1
SELECT gender, AVG(salary) AS avg_salary
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
;
-- The Code 1 above returns the gender column and creates a new aggregated column "avg_salary".
-- It takes the gender from 'employee_demographics' table and salary from 'employee_salary' table,
-- and joins the two table based on the primary key 'employee_id'.
-- The final result of Code 1 is grouped by gender (2 rows) with different value for 'Female' and 'Male'.

# Code 2
SELECT gender, AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;
-- The code 2 above returns 11 rows.
-- In fact, the aggregation result of Code 1 and Code 2 is the same.
-- The difference lies in the way the values are represented.
-- You can see the difference by running the whole script by clickin on the yellow lightning icon above.
-- Once you finished running the script, there will be two results in the below panel.
-- The first result is the Code 1 and the result 2 is Code 2.
-- Let us take a look at the second result (Code 2).
-- The average salary for female is 53750.000, the same with that in the Code 1.
-- The same goes for the male, which is 57428.5714.
-- Now, see that the Code 2 distributes the values based on the gender, unlike Code 1 which only returns two rows for each unique gender value.

# Code 3
SELECT dem.first_name, dem.last_name, gender, salary, 
SUM(salary) OVER(PARTITION BY gender ORDER BY salary)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;
-- The code above has the same principle to that of Code 2.
-- However, this one adds a new little refinement to the script in that it uses SUM() instead of AVG,
-- and that there is an additional argument inside the OVER() statement where it states 'ORDER BY'.
-- When we do such thing, the SQL will sum the salary based on gender, separately.
-- In addition, the ORDER BY inside the OVER() is translated into something called "Rolling Total".
-- A rolling total is basically adding up the value from the previous cell and stores it in the current cell.
-- Run the Code 3 and take a look at the result.
-- The first row of the salary is 25000, then the second row is 80000 even though the corresponding salary for that person is only 55000.
-- This is "Rolling total".

# Code 4
SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary ASC)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;
-- The Code 4 above is an example of how you can create a row number.
-- The row numbering in this example is "windowed" by the OVER() function.
-- The following explains how this works:
-- ROW_NUMBER() indicates the funciton that we want to use, 
-- OVER(PARTITION BY <col>) acts as a separator to which the ROW_NUMBER() function should be applied, or you can say partitioned,
-- and the ORDER BY acts as the name suggests, it defines how and which row should the ROW_NUMBER() function be starting.

# Code 5
SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary,
RANK() OVER(PARTITION BY gender ORDER BY salary)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;
-- The 5th Code above demonstrates how the RANK() function works with OVER() function.
-- As you might have suggested, the RANK() function "ranks" the rows based on the parameters in the OVER() function.
-- So, in turn, as of now, you might have grasped the gist of what or which constitutes the window functions.
-- Your guess is right: the OVER() function.
-- The Code 5 above sligthly differs from that of ROW_NUMBER() function in which the former could return the same ranking number given the value being ranked has identical value,
-- where as the latter only assings plain numbering to any given condition in the OVER() function.

# Code 6
SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;
-- The Code 6 has similar properties to that of the RANK() function but there is a distinct feature to DENSE_RANK().
-- The DENSE_RANK() "ranks" the rows based on the condition(s) stated in the OVER() function,
-- and it will return numbers that indicates the rank of each row.
-- The difference lies in the way DENSE_RANK() handles the numbering.
-- While RANK() function returns the same ranking number for rows that have identical value and then skipping the number that is being replaced by the duplicates,
-- for example employee_id = 3 and employee_id = 5 both have the rank of 2, and the next row in line is assigned rank number 4;
-- DENSE_RANK() function does not skip the numbering system.
-- It continues the numbering. Run the Code 6 to see the difference.
-- Take a look at the rows that have employee_id = 3, 5, 11.
-- The employee_id = 11 has its rank assigned 3 instead of 4 (as in RANK() function).
-- This is the difference between the RANK() and DENSE_RANK() functions.