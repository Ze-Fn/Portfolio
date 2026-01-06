USE hasil_cpns2024_kemendikbud;

SELECT *
FROM from_csv;


SELECT COUNT(DISTINCT __page__)
FROM from_csv; # Checks the column -> unnecesary column

SELECT COUNT(__table__)
FROM from_csv;
SELECT __table__
FROM from_csv; # Checks the column -> unnecesary column

/*
all columns must undergo modification.
0 -> unnecessary, drop
1 -> id, preserve
2 -> full_name, preserve
3 -> birthdate, preserve
__page__ -> unnecessary, drop
__table__ -> unnecessary, drop
4 -> last_edu, preserve
5 -> gpa, preserve
6 -> twk, preserve
7 -> tiu, preserve
8 -> tkp, preserve
9 -> skd, preserve
10 -> skd_40, preserve
11 -> skb, preserve
12 -> skb_60, preserve
13 -> final_score, preserve
14 -> declaration, preserve
*/

CREATE TABLE csv_staging1 LIKE from_csv;
INSERT INTO csv_staging1
SELECT * FROM from_csv;
SELECT * FROM csv_staging1;

/***************************|
|		csv_staging1	    |
|***************************/
SELECT * FROM csv_staging1;

/* Alter the columns appropriately based on last comment */
ALTER TABLE csv_staging1 RENAME COLUMN `1` TO `id`;
ALTER TABLE csv_staging1 RENAME COLUMN `2` TO `full_name`;
ALTER TABLE csv_staging1 RENAME COLUMN `3` TO `birthdate`;
ALTER TABLE csv_staging1 RENAME COLUMN `4` TO `last_edu`;
ALTER TABLE csv_staging1 RENAME COLUMN `5` TO `gpa`;
ALTER TABLE csv_staging1 RENAME COLUMN `6` TO `twk`;
ALTER TABLE csv_staging1 RENAME COLUMN `7` TO `tiu`;
ALTER TABLE csv_staging1 RENAME COLUMN `8` TO `tkp`;
ALTER TABLE csv_staging1 RENAME COLUMN `9` TO `skd`;
ALTER TABLE csv_staging1 RENAME COLUMN `10` TO `skd_40`;
ALTER TABLE csv_staging1 RENAME COLUMN `11` TO `skb`;
ALTER TABLE csv_staging1 RENAME COLUMN `12` TO `skb_60`;
ALTER TABLE csv_staging1 RENAME COLUMN `13` TO `final_score`;
ALTER TABLE csv_staging1 RENAME COLUMN `14` TO `declaration`;
ALTER TABLE csv_staging1 DROP COLUMN `0`;
ALTER TABLE csv_staging1 DROP COLUMN `__page__`;
ALTER TABLE csv_staging1 DROP COLUMN `__table__`;

/* A more concise way to do alterization */
ALTER TABLE csv_staging1
CHANGE `1` `id` TEXT,
CHANGE `2` `full_name` TEXT,
CHANGE `3` `birthdate` TEXT,
CHANGE `4` `last_edu` TEXT,
CHANGE `5` `gpa` TEXT,
CHANGE `6` `twk` TEXT,
CHANGE `7` `tiu` TEXT,
CHANGE `8` `tkp` TEXT,
CHANGE `9` `skd` TEXT,
CHANGE `10` `skd_40` TEXT,
CHANGE `11` `skb` TEXT,
CHANGE `12` `skb_60` TEXT,
CHANGE `13` `final_score` TEXT,
CHANGE `14` `declaration` TEXT;

ALTER TABLE csv_staging1 
DROP COLUMN `__page__`,
DROP COLUMN `__table__`;

SELECT * FROM csv_staging1;

/* Check for unnecessary rows to be deleted */
SELECT *
FROM csv_staging1
WHERE
	id = "(2)" AND
	full_name = "(3)" AND
	birthdate = "(4)" AND
	last_edu = "(5)" AND
	gpa = "(6)" AND
	twk = "(7)" AND
	tiu = "(8)" AND
	tkp = "(9)" AND
	skd = "(10)" AND
	skd_40 = "(11)" AND
	skb = "(12)" AND
	skb_60 = "(13)" AND
	final_score = "(14)" AND
	declaration = "(15)";

/* NULL-ify the unnecessary rows */
UPDATE csv_staging1
SET
	id = NULL,
	full_name = NULL,
	birthdate = NULL,
	last_edu = NULL,
	gpa = NULL,
	twk = NULL,
	tiu = NULL,
	tkp = NULL,
	skd = NULL,
	skd_40 = NULL,
	skb = NULL,
	skb_60 = NULL,
	final_score = NULL,
	declaration = NULL
WHERE 
	id = "(2)" AND
	full_name = "(3)" AND
	birthdate = "(4)" AND
	last_edu = "(5)" AND
	gpa = "(6)" AND
	twk = "(7)" AND
	tiu = "(8)" AND
	tkp = "(9)" AND
	skd = "(10)" AND
	skd_40 = "(11)" AND
	skb = "(12)" AND
	skb_60 = "(13)" AND
	final_score = "(14)" AND
	declaration = "(15)";


/* Comment:
Tried to select the unnecessary rows with the commented-out conditions but returned nothing.
I also tried to do only some of the conditions to be evaluated but then it retuned nothing as well.
Then I tried to evaluate the filter to only 1 condition, and it returned rows as expected.
*/
SELECT * FROM csv_staging1
WHERE
	id = "No Peserta" /*AND
	full_name = "Nama" AND
	birthdate = "Tanggal Lahir" AND
	last_edu = "Pendidikan" AND
	gpa = "Nilai/IPK" AND
	twk = "Nilai SKD" AND
--     skd_40 = "Skor SKD
--  (40%)" AND
	skb = "Nilai SKB" AND
-- 	skb_60 = "Skor SKB
--  (60%)" AND
	final_score = "Nilai Akhir" AND
	declaration = "Keterangan"*/;

/* NULL-ify the unnecessary rows */
UPDATE csv_staging1
SET
	id = NULL,
	full_name = NULL,
	birthdate = NULL,
	last_edu = NULL,
	gpa = NULL,
	twk = NULL,
    skd_40 = NULL,
	skb = NULL,
	skb_60 = NULL,
	final_score = NULL,
	declaration = NULL
WHERE 
	id = "No Peserta" /*AND
	full_name = "Nama" AND
	birthdate = "Tanggal Lahir" AND
	last_edu = "Pendidikan" AND
	gpa = "Nilai/IPK" AND
	twk = "Nilai SKD" AND
    skd_40 = "Skor SKD (40%)" AND
	skb = "Nilai SKB" AND
	skb_60 = "Skor SKB (60%)" AND
	final_score = "Nilai Akhir" AND
	declaration = "Keterangan" */;
    
UPDATE csv_staging1
SET
-- SELECT * FROM csv_staging1 # Shortcut to see data
	id = NULL,
	full_name = NULL,
	birthdate = NULL,
	last_edu = NULL,
	gpa = NULL,
	twk = NULL,
    tiu = NULL,
    tkp = NULL,
    skd = NULL,
    skd_40 = NULL,
	skb = NULL,
	skb_60 = NULL,
	final_score = NULL,
	declaration = NULL
WHERE 
	wk = "TWK"; 
    
UPDATE csv_staging1
SET
-- SELECT * FROM csv_staging1 # Shortcut to see data
	id = NULL,
	full_name = NULL,
	birthdate = NULL,
	last_edu = NULL,
	gpa = NULL,
	twk = NULL,
    skd_40 = NULL,
	skb = NULL,
	skb_60 = NULL,
	final_score = NULL,
	declaration = NULL
WHERE 
	twk = "TWK"; 
	
UPDATE csv_staging1
SET
-- SELECT * FROM csv_staging1
	id = NULL,
	full_name = NULL,
	birthdate = NULL,
	last_edu = NULL,
	gpa = NULL,
	twk = NULL,
    tiu = NULL,
    tkp = NULL,
    skd = NULL,
    skd_40 = NULL,
	skb = NULL,
	skb_60 = NULL,
	final_score = NULL,
	declaration = NULL
WHERE
	skd = "(7) + (8) + (9)";

/* Check for unnecessary valu in `id` */
SELECT id, COUNT(id) AS id_count FROM csv_staging1
WHERE 
	id NOT LIKE "2430%" AND 
	id NOT LIKE "S-%" AND 
    id NOT LIKE "SUBSP%" AND 
    id NOT LIKE "SPES%" AND 
    id NOT LIKE "NERS%" AND 
    id NOT LIKE "D-I%" AND 
    id NOT LIKE "DOKTER%" AND
    id NOT LIKE "SLT%" AND
    id NOT LIKE "SMK%"
GROUP BY id;

/* Comment: 
Filtering rows where id = "Jumlah Formasi" returns nothing.
Other alternataive using wildcard also returned nothing (id = "Ju%"
Upon closed inspection, the value "Jumlah Formasi" has it "Jumlah \n Formasi".
This is infuriating, but I found other solution. See code below.
*/
SELECT * FROM csv_staging1 WHERE birthdate = "SKB";

UPDATE csv_staging1
SET 
	id = NULL,
	full_name = NULL,
	birthdate = NULL,
	last_edu = NULL,
	gpa = NULL,
	twk = NULL,
    tiu = NULL,
    tkp = NULL,
    skd = NULL,
    skd_40 = NULL,
	skb = NULL,
	skb_60 = NULL,
	final_score = NULL,
	declaration = NULL
WHERE birthdate = "SKB";

SELECT * FROM csv_staging1;

SELECT * FROM csv_staging1 WHERE LENGTH(full_name) < 3;

/* Comment:
I was startled when running the following code.
My intention was to only delete the remaining unnecessary rows where LENGTH(full_name) < 3,
thinking that only rows that had value are processed. I was wrong.
It turned out that the code also considers blank value as having 0 length,
making the rows with blank value in the full_name row were also processed.
*/
UPDATE csv_staging1
SET 
	full_name = NULL, # `id` col was excluded, contains important data
	birthdate = NULL,
	last_edu = NULL,
	gpa = NULL,
	twk = NULL,
    tiu = NULL,
    tkp = NULL,
    skd = NULL,
    skd_40 = NULL,
	skb = NULL,
	skb_60 = NULL,
	final_score = NULL,
	declaration = NULL
WHERE LENGTH(full_name) < 3;

SELECT /*id, COUNT(DISTINCT id) as num_count*/ *
FROM csv_staging1
WHERE LENGTH(id) < 3;
-- GROUP BY id;

UPDATE csv_staging1
SET
	id = NULL,
	full_name = NULL,
	birthdate = NULL,
	last_edu = NULL,
	gpa = NULL,
	twk = NULL,
    tiu = NULL,
    tkp = NULL,
    skd = NULL,
    skd_40 = NULL,
	skb = NULL,
	skb_60 = NULL,
	final_score = NULL,
	declaration = NULL
WHERE LENGTH(id) < 3;

SELECT * FROM csv_staging1 WHERE tiu = "";
UPDATE csv_staging1
SET 
	id = NULL,
	full_name = NULL,
	birthdate = NULL,
	last_edu = NULL,
	gpa = NULL,
	twk = NULL,
    tiu = NULL,
    tkp = NULL,
    skd = NULL,
    skd_40 = NULL,
	skb = NULL,
	skb_60 = NULL,
	final_score = NULL,
	declaration = NULL
WHERE tiu = "";

SELECT * FROM csv_staging1 WHERE LENGTH(id) <> 17;
SELECT * FROM csv_staging1;
SELECT DISTINCT last_edu FROM csv_staging1;

DELETE
FROM csv_staging1
WHERE 
	id IS NULL AND
	full_name IS NULL AND
	birthdate IS NULL AND
	last_edu IS NULL AND
	gpa IS NULL AND
	twk IS NULL AND
    tiu IS NULL AND
    tkp IS NULL AND
    skd IS NULL AND
    skd_40 IS NULL AND
	skb IS NULL AND
	skb_60 IS NULL AND
	final_score IS NULL AND
	declaration IS NULL;
    
ALTER TABLE csv_staging1 ADD COLUMN row_num BIGINT;


ALTER TABLE t ADD COLUMN rn BIGINT;

SET @rn := 0;

UPDATE csv_staging1
SET row_num = (@rn := @rn + 1);

DELETE FROM csv_staging1
WHERE row_num IN (
    SELECT row_num
    FROM (
        SELECT
            row_num,
            id,
            LAG(id) OVER (ORDER BY row_num) AS prev_id
        FROM csv_staging1
    ) x
    WHERE id = prev_id
);

ALTER TABLE csv_staging1 ADD COLUMN `position_formation` TEXT;

SELECT * FROM csv_staging1
WHERE last_edu LIKE "S-2%";

UPDATE csv_staging1
SET position_formation = "Dosen Asisten Ahli"
WHERE last_edu LIKE "S-2%";

UPDATE csv_staging1
SET position_formation = "Dosen Lektor"
WHERE last_edu LIKE "S-3%";


UPDATE csv_staging1
SET position_formation = "Dosen Asisten Ahli"
WHERE id LIKE "S-2%";

UPDATE csv_staging1
SET position_formation = "Dosen Lektor"
WHERE id LIKE "S-3%";

SELECT * FROM csv_staging1;

ALTER TABLE csv_staging1 ADD COLUMN `edu_qualifications` TEXT;
UPDATE csv_staging1
SET edu_qualifications = id
WHERE id NOT LIKE "2430%";

ALTER TABLE csv_staging1 RENAME COLUMN `edu_qualifications` TO `formation_edu_qualify`;

SELECT
    row_num,
    formation_edu_qualify AS original_value,
    MAX(formation_edu_qualify) OVER (
        ORDER BY formation_edu_qualify
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS preview_filled_value
FROM csv_staging1;

ALTER TABLE csv_staging1
ADD COLUMN temp_form_edu_qual TEXT;

ALTER TABLE csv_staging1 CHANGE COLUMN temp_form_edu_qual temp_form_edu_qual TEXT;

SELECT
    row_num,
    formation_edu_qualify AS original_value,
    CAST(
        (@prev := IF(formation_edu_qualify IS NOT NULL,
                     formation_edu_qualify,
                     @prev))
        AS CHAR(1000)
    ) AS col1_filled
FROM csv_staging1
JOIN (SELECT @prev := NULL) vars
ORDER BY row_num;

UPDATE csv_staging1 t
JOIN (
    SELECT
        row_num,
        CAST(
            (@prev := IF(formation_edu_qualify IS NOT NULL,
                         formation_edu_qualify,
                         @prev))
            AS CHAR(1000)
        ) AS filled_value
    FROM csv_staging1
    JOIN (SELECT @prev := NULL) vars
    ORDER BY row_num
) x
ON t.row_num = x.row_num
SET t.temp_form_edu_qual = x.filled_value;

ALTER TABLE csv_staging1 ADD COLUMN `faculty_formation` TEXT;

SELECT * FROM csv_staging1;

SELECT DISTINCT temp_form_edu_qual, LENGTH(temp_form_edu_qual) AS detect_wi 
FROM csv_staging1
ORDER BY detect_wi DESC;

SELECT temp_form_edu_qual, LENGTH(temp_form_edu_qual) AS detect_wi 
FROM csv_staging1
WHERE temp_form_edu_qual LIKE "%S-2%S-2%S-2%" AND
			LENGTH(temp_form_edu_qual) > 801
ORDER BY detect_wi DESC;

SELECT DISTINCT temp_form_edu_qual
FROM csv_staging1
WHERE 
	temp_form_edu_qual LIKE "%S-2 PENDIDIKAN%" AND
			temp_form_edu_qual NOT LIKE "%VOKASI%" AND
			temp_form_edu_qual NOT LIKE "%KOPMUTER%" AND
			temp_form_edu_qual NOT LIKE "%KEARSIPAN%" AND
			temp_form_edu_qual NOT LIKE "%TEKNOLOGI%" AND
			temp_form_edu_qual NOT LIKE "%ADMINISTRASI%" AND
			temp_form_edu_qual NOT LIKE "%INTERNASIONAL%" AND
			temp_form_edu_qual NOT LIKE "%DESAIN%" AND
			temp_form_edu_qual NOT LIKE "%ANIMASI%" AND
			LENGTH(temp_form_edu_qual) < 150
ORDER BY LENGTH(temp_form_edu_qual) DESC;

SELECT temp_form_edu_qual
FROM csv_staging1
WHERE temp_form_edu_qual LIKE "%DOKTER%" AND
	temp_form_edu_qual NOT LIKE "%S-1%"
;

UPDATE csv_staging1
SET faculty_formation =
	CASE 
		WHEN temp_form_edu_qual LIKE "S-2%PENDIDIKAN%PENDIDIKAN%" AND
			temp_form_edu_qual NOT LIKE "%VOKASI%" AND
			temp_form_edu_qual NOT LIKE "%KOPMUTER%" AND
			temp_form_edu_qual NOT LIKE "%KEARSIPAN%" AND
			temp_form_edu_qual NOT LIKE "%TEKNOLOGI%" AND
			temp_form_edu_qual NOT LIKE "%ADMINISTRASI%" AND
			temp_form_edu_qual NOT LIKE "%INTERNASIONAL%" AND
			temp_form_edu_qual NOT LIKE "%DESAIN%" AND
			temp_form_edu_qual NOT LIKE "%ANIMASI%" AND
			LENGTH(temp_form_edu_qual) < 150
				THEN "Fakultas Keguruan dan Ilmu Pendidikan"
        WHEN temp_form_edu_qual LIKE "S-3%PENDIDIKAN%PENDIDIKAN%" AND
			temp_form_edu_qual NOT LIKE "%VOKASI%" AND
			temp_form_edu_qual NOT LIKE "%KOPMUTER%" AND
			temp_form_edu_qual NOT LIKE "%KEARSIPAN%" AND
			temp_form_edu_qual NOT LIKE "%TEKNOLOGI%" AND
			temp_form_edu_qual NOT LIKE "%ADMINISTRASI%" AND
			temp_form_edu_qual NOT LIKE "%INTERNASIONAL%" AND
			temp_form_edu_qual NOT LIKE "%DESAIN%" AND
			temp_form_edu_qual NOT LIKE "%ANIMASI%" AND
			LENGTH(temp_form_edu_qual) < 150
				THEN "Fakultas Keguruan dan Ilmu Pendidikan"
		WHEN temp_form_edu_qual LIKE "S-3%PENDIDIKAN%" AND
			temp_form_edu_qual NOT LIKE "%VOKASI%" AND
			temp_form_edu_qual NOT LIKE "%KOPMUTER%" AND
			temp_form_edu_qual NOT LIKE "%KEARSIPAN%" AND
			temp_form_edu_qual NOT LIKE "%TEKNOLOGI%" AND
			temp_form_edu_qual NOT LIKE "%ADMINISTRASI%" AND
			temp_form_edu_qual NOT LIKE "%INTERNASIONAL%" AND
			temp_form_edu_qual NOT LIKE "%DESAIN%" AND
			temp_form_edu_qual NOT LIKE "%ANIMASI%" AND
			LENGTH(temp_form_edu_qual) < 150
				THEN "Fakultas Keguruan dan Ilmu Pendidikan"
		WHEN temp_form_edu_qual LIKE "%S-2%S-2%S-2%" AND
			LENGTH(temp_form_edu_qual) > 801
				THEN faculty_formation = "Balai Besar Guru Penggerak"
		WHEN temp_form_edu_qual LIKE "%DOKTER%" AND
			temp_form_edu_qual NOT LIKE "%S-1%"
				THEN "Fakultas Kedokteran"
    END
;

SELECT * FROM csv_staging1;

ALTER TABLE csv_staging1
DROP COLUMN `formation_edu_qualify`;

ALTER TABLE csv_staging1 RENAME COLUMN `temp_form_edu_qual` TO `formation_edu_qualify`;

SET @increment_var := 0;

UPDATE csv_staging1
SET id = (@increment_var := @increment_var + 1)
WHERE id NOT LIKE '2430_____________';

SELECT * FROM csv_staging1;

-- ALTER TABLE csv_staging1
-- 	MODIFY COLUMN id BIGINT UNSIGNED,
-- 	MODIFY COLUMN full_name TEXT,
-- 	MODIFY COLUMN birthdate TEXT,
-- 	MODIFY COLUMN last_edu TEXT,
-- 	MODIFY COLUMN gpa DECIMAL,
-- 	MODIFY COLUMN twk TEXT,
-- 	MODIFY COLUMN tiu TEXT,
-- 	MODIFY COLUMN tkp TEXT,
-- 	MODIFY COLUMN skd TEXT,
-- 	MODIFY COLUMN skd_40 TEXT,
-- 	MODIFY COLUMN skb INT UNSIGNED,
-- 	MODIFY COLUMN skb_60 TEXT,
-- 	MODIFY COLUMN final_score TEXT,
-- 	MODIFY COLUMN declaration VARCHAR(20),
-- 	MODIFY COLUMN row_num BIGINT UNSIGNED,
-- 	MODIFY COLUMN position_formation TEXT,
-- 	MODIFY COLUMN formation_edu_qualify TEXT,
-- 	MODIFY COLUMN faculty_formation TEXT;

UPDATE csv_staging1 
SET 
    gpa = REPLACE(gpa, ',', '.'),
    skd_40 = REPLACE(skd_40, ',', '.'),
    skb_60 = REPLACE(skb_60, ',', '.'),
    final_score = REPLACE(final_score, ',', '.');