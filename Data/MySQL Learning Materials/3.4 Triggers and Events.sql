USE parks_and_recreation;

SELECT *
FROM employee_demographics;

SELECT * 
FROM employee_salary;

# Code 1 - Triggers
DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;
INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (13, 'Amber', 'Flyers', 'Analyst', 60000, NULL);

-- The Code 1 above "triggers" a code when you do something stated in the CREATE TRIGGER function.
-- In the example above, the trigger is encapsulated by BEGIN and END.
-- As for the condition(s), it is stated right below the CREATE TRIGGER function.
-- It is usually started with AFTER, and the functions following that AFTER is custom.
-- In the case of Code 1, we want to run the trigger when something is "inserted" on the employee_salary table.
-- The code in line 13 is self-explanatory. Then, when the trigger is on, run the code between the BEGIN and END.

# Code 2 - Events
DELIMITER $$
CREATE EVENT retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	DELETE
    FROM employee_demographics
    WHERE age > 60;
END $$
DELIMITER ;
-- The Code 2 above runs a script on a schedule. That is why it is called EVENT.
-- The structure is similar to that of Code 1 - Triggers, but the functions used is different.
-- In this case, instead of using AFTER and FOR EACH ROW, we use ON SCHEDULE EVERY <x> TIME and DO, followed by BEGIN and END.
