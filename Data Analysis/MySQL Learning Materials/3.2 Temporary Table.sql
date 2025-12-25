USE parks_and_recreation;

CREATE TEMPORARY TABLE temp_table
(first_name VARCHAR(50),
last_name VARCHAR(50),
favorite_movie VARCHAR(100)
);

INSERT INTO temp_table
VALUES
('Shiro', 'Kuro', 'Your Name');

SELECT *
FROM temp_table;

-- TEMPORARY TABLE (hereafter "temp table", as the name suggests, creates a temporary table that can be used globally in the system.
-- This temp table persist as long as the MySQL instance session is running.
-- It will, however, be "forgotten" by the system and the instance if we close the session.
-- So, if you create a temp table, terminate the instance session, and reopen the instance and create a new session, and you call the temp table;
-- you will not be able to see the temp table. The instance will return an error message.
-- It will say something like "temp table doesn't exist". 
-- This is because temporary tables are, well, temporary.
-- It is stored in the memory instead of in the actual database itself.