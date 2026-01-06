 USE parks_and_recreation;
 
 SELECT *
 FROM employee_demographics
 ORDER BY employee_id DESC
 LIMIT 5, 6;
 
--  The LIMIT statement is quite straightforward when the argument is only one.
--  However, it will become a bit complicated when there are two arguments in the statement.
--  For example, the above lines of code takes two arguments: the 5 and the 6.
--  The first argument indicates the row index that we want to start from. 
--  In this case, since the first argument is 5 then it means that the starting point is row number 5.
--  Note in mind that the code above has the dataset output ordered descendingly.
--  So, if we were to only use one argument in the LIMIT statement, the number 5 here will only result in the first 5 rows.
--  Now comes the "a bit complicated" part. 
--  The second argument in the LIMIT statement actually indicates the number of rows that we want to show.
--  In the case of our exercise file, the second argument is the number 6.
--  This means that the actual value of the "limit" is 6 rows, or in other words, 6 as in 6 rows limit.
--  To remind, the first argument is the starting point for row index, and the second argument is the number of rows that we want to show.
--  Let's make it more explicit.
--  The code:
--  LIMIT 5, 6;
--  means that the starting point is 5 rows from beginning and take 6 rows from the end of the 5 rows.
--  The first 5 rows of employee_id (12, 11, 10, 9, 8) will not be shown in the result window because they are the first 5 rows.
--  Instead, the shown rows are (or the employee_id) 7, 6, 5, 4, 3, 1.
 
 SELECT gender, AVG(age) AS "Average Age"
 FROM employee_demographics
 GROUP BY gender
 -- HAVING Average Age > 40;	# This part causes an Error Code 1064 becasue the part where "Average" and "Age" is rendered as a function of some sort that SQL don't understand.
 HAVING AVG(age) > 40;