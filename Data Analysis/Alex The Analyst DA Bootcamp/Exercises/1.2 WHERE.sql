USE parks_and_recreation;

SELECT *
FROM employee_salary
-- WHERE occupation = 'Office Manager'		# The WHERE clause is a filtering function. It takes the input and compares it with the "comparison operator" in any specified column in the first argument of the WHERE clause. For example, we want to see Office Manager employees. So, we use the WHERE clause as in the line 5.
WHERE salary > 50000						# The comparison operator includes >, <, >=, <=, !=, AND, OR, NOT, 
;

SELECT *
FROM employee_salary
-- WHERE first_name LIKE 'Don%'				# The LIKE clause takes two kinds of arguments: % and _ signs. The % sign will return anything that has the specified character(s).
WHERE first_name LIKE 'A__'					# On the other hand, the _ sign will return the specific row with the exact length based on the number of the _. Take the code in line 12 for example. WHERE first_name LIKE 'A__' will return all the rows that has A as the first letter of the "first_name" column and two letters afterwards. In this case, the row of data that has the first_name value of Ann is returned. Since the database has only one row that has A__, it only returns one value. If, for instance, the database has a row which has the first_name "Ali", two rows will be returned: Ann and Ali.
;