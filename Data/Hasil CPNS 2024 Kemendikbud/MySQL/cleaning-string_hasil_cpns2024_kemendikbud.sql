USE hasil_cpns2024_kemendikbud;

/* Check the imported raw text data */
SELECT *
FROM cleaning1;

/* Rename column name to a more appropriate name */
ALTER TABLE `cleaning1` RENAME COLUMN `PAGE 1 / 16071` TO `all_string`;

/* Duplicate cleanin1 table to cleaning 2 for staging process */
CREATE TABLE `cleaning2`
LIKE cleaning1;

/* Copy all data from cleaning1 to cleaning2 */
INSERT INTO cleaning2
SELECT * FROM cleaning1;

/* Check for the duplication operation */
SELECT * FROM cleaning2;

/* Create a new blank column `id` */
ALTER TABLE cleaning2
ADD `id` TEXT;

/* Check: copy rows that has test takers' data into the `id` column and leave the rest NULL */
SELECT all_string,
	CASE WHEN all_string LIKE "%2430_____________%"
    THEN all_string
		ELSE NULL 
	END AS temp_id
FROM cleaning2;

/* Perform the copy of test takers' data into `id` */
UPDATE cleaning2
SET id = all_string
	WHERE all_string LIKE "%2430_____________%";

SELECT *
FROM cleaning2;

/* */
SELECT DISTINCT all_string
FROM cleaning2
WHERE all_string LIKE "%19__%" OR all_string LIKE "%20__%";