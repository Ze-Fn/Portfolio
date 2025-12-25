USE parks_and_recreation;

SELECT LENGTH('gato');		# The LENGTH statement is to count the number of characters (including blank spaces)

SELECT first_name, 
LENGTH(first_name) AS Name_Length
FROM employee_demographics;

SELECT UPPER('gato');		# UPPER statement, pretty self-explanatory, to capitalize any given string.
SELECT LOWER('GATO');		# LOWER statement, ditto as previous, to lower case any given string.
SELECT TRIM(' G  ato  ');	# The TRIM statement rules out the ***leading*** and ***trailing*** extra spaces, extra spaces in the middle of the string is left untouched.
SELECT LTRIM(' G  ato  ');	# The LTRIM is similar to default TRIM statement, but this one only removing the leading.
SELECT RTRIM(' G  ato  ');	# The LTRIM is similar to default TRIM statement, but this one only removing the trailing.

SELECT first_name, last_name, 	
LEFT(first_name, 3),			# Takes the first specified (n) chars from the left.
RIGHT(first_name, 2),			# Takes given n of strings from the right.
SUBSTRING(first_name, 2, 3)		# Takes three arguments: input, starting point, and number of chars.
FROM employee_demographics;		# Run the code to see the difference.

# Most used scenario for SUBSTRING: separating time
SELECT *,
SUBSTRING(birth_date, 1, 4) AS birth_year,
SUBSTRING(birth_date, 6, 2) AS birth_month,
SUBSTRING(birth_date, 9, 2) AS birth_day
FROM employee_demographics;

SELECT first_name, 
REPLACE(first_name, 'a', 's')	# Self-explanatory. It replaces "second arg" with "third arg" in "first arg". Case sensitive.
FROM employee_demographics;

SELECT LOCATE('x', 'Froxt');	# Prints the location of the first argument from source (argument 2)

SELECT first_name, 				# Can also be used to "LOCATE" for given input in specified column. Not case sensitive.
last_name, 
LOCATE('d', first_name)
FROM employee_demographics;

SELECT first_name,
last_name, 
CONCAT(first_name, ' ', last_name)	# Self-explanatory. Concatenates any specified input.
FROM employee_demographics;