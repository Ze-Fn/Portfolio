USE parks_and_recreation;		# This USE is used to select which database I want to use. 
SELECT *						# The argument after the SELECT is meant to "select" the column that we want to call.
FROM employee_demographics;		# The argument in this FROM is for calling the table(s) that we want to show.

SELECT *, age + 10				# We can also add a new column by simply writing the column(s) that we want in the SELECT argument.
FROM employee_demographics;		# In addition, we can also perform mathematic operation in the column and it will be applied to every single rows in the column.

SELECT DISTINCT gender			# The DISTINCT argument returns only unique value in the selected column. Take the code at line 8-9 as an example. It calls the "DISTINCT" values from column "gender". As a result, it returns the column "gender" but only containing two values: "Female" and "Male".
FROM employee_demographics;

