USE parks_and_recreation;

# Code 1 - Stored Procedures calling two queries
DROP PROCEDURE IF EXISTS large_salary;
DELIMITER $$
CREATE PROCEDURE large_salary()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
    SELECT *
    FROM employee_salary
    WHERE salary > 10000;
END $$
DELIMITER ;
CALL large_salary();

# Code 2 - Basic Stored Procedure call
DROP PROCEDURE IF EXISTS small_salary;
DELIMITER $$
CREATE PROCEDURE small_salary()
BEGIN
	SELECT *
    FROM employee_salary
    WHERE salary < 50000;
END $$
DELIMITER ;
CALL small_salary();

# Code 3 - Stored Procedure with custom param call
DROP PROCEDURE IF EXISTS employee_search;
DELIMITER $$
CREATE PROCEDURE employee_search(employee_id_param INT)
BEGIN
	SELECT employee_id, first_name, last_name, salary
	FROM employee_salary
	WHERE employee_id = employee_id_param;
END $$
DELIMITER ;
CALL employee_search(3);