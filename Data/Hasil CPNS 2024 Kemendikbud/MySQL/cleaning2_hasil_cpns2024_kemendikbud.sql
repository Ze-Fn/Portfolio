USE hasil_cpns2024_kemendikbud;

CREATE TABLE `cleaning3` LIKE raw_table;
SELECT * FROM cleaning3;
INSERT INTO cleaning3
SELECT * FROM raw_table;

/* Start by taking the bird view of the dataset.
Identify each column for any unnecessary data. */
SELECT * FROM cleaning3;

/* Create a new column called `row_num` for future use when populating rows with blank values*/
# ALTER TABLE cleaning3 ADD COLUMN `row_num` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

/* Comment:
Some columns may benefit from separations of data.
For example, `jabatan_formasi` has data "Jabatan Formasi : JF0000334 - ANALIS HUKUM AHLI PERTAMA 10".
It is better to remove the first "Jabatan Formasi : ", move the "JF_______", delete the remaining " - ", and preserve the rest.
The same goes with other columns including `lokasi_formasi`, `jenis_formasi`, `pendidikan_formasi`
*/

/*
Check for DISTINCT values to ensure safety when altering the values in the column.
Perform this for each columns.
*/
SELECT * FROM cleaning3;
SELECT DISTINCT jabatan_formasi FROM cleaning3 ORDER BY jabatan_formasi ASC;
SELECT DISTINCT lokasi_formasi FROM cleaning3 ORDER BY lokasi_formasi ASC;
SELECT DISTINCT jenis_formasi FROM cleaning3 ORDER BY jenis_formasi ASC;
SELECT DISTINCT pendidikan_formasi FROM cleaning3 ORDER BY pendidikan_formasi ASC;

/*
1. jabatan_formasi: blanks, no code but position name exists, full
Problematic values include,
Jabatan Formasi : - PENERJEMAH AHLI PERTAMA - PENERJEMAH BAHASA ARAB 4
Jabatan Formasi : - PENERJEMAH AHLI PERTAMA - PENERJEMAH BAHASA BELANDA 2
Jabatan Formasi : - PENERJEMAH AHLI PERTAMA - PENERJEMAH BAHASA INGGRIS 13
Jabatan Formasi : - PENERJEMAH AHLI PERTAMA - PENERJEMAH BAHASA KOREA 2
Jabatan Formasi : - PENERJEMAH AHLI PERTAMA - PENERJEMAH BAHASA MANDARIN 8

Proposed actions:
1. Consult to source PDF, note values, then UPDATE the column with the new fixed value.
2. Remove "Jabatan Formasi : " from the values, leaving position code and position desc.
3. Separate between position code and position desc in its respective new columns.

Proposed changes for step 1
PENERJEMAH BAHASA ARAB 		-> JF00187041101
PENERJEMAH BAHASA INGGRIS 	-> JF00187041102
PENERJEMAH BAHASA MANDARIN	-> JF00187041103
PENERJEMAH BAHASA BELANDA	-> JF00187041108
PENERJEMAH BAHASA KOREA		-> JF00187041111
*/
UPDATE cleaning3
SET jabatan_formasi =
	CASE 
		WHEN jabatan_formasi = "Jabatan Formasi : - PENERJEMAH AHLI PERTAMA - PENERJEMAH BAHASA ARAB 4" 
			THEN "Jabatan Formasi : JF00187041101 - PENERJEMAH AHLI PERTAMA - PENERJEMAH BAHASA ARAB 4"
		WHEN jabatan_formasi = "Jabatan Formasi : - PENERJEMAH AHLI PERTAMA - PENERJEMAH BAHASA BELANDA 2"
			THEN "Jabatan Formasi : JF00187041108 - PENERJEMAH AHLI PERTAMA - PENERJEMAH BAHASA BELANDA 2"
		WHEN jabatan_formasi = "Jabatan Formasi : - PENERJEMAH AHLI PERTAMA - PENERJEMAH BAHASA INGGRIS 13"
			THEN "Jabatan Formasi : JF00187041102 - PENERJEMAH AHLI PERTAMA - PENERJEMAH BAHASA INGGRIS 13"
		WHEN jabatan_formasi = "Jabatan Formasi : - PENERJEMAH AHLI PERTAMA - PENERJEMAH BAHASA KOREA 2"
			THEN "Jabatan Formasi : JF00187041111 - PENERJEMAH AHLI PERTAMA - PENERJEMAH BAHASA KOREA 2"
		WHEN jabatan_formasi = "Jabatan Formasi : - PENERJEMAH AHLI PERTAMA - PENERJEMAH BAHASA MANDARIN 8"
			THEN "Jabatan Formasi : JF00187041103 - PENERJEMAH AHLI PERTAMA - PENERJEMAH BAHASA MANDARIN 8"
		ELSE jabatan_formasi
	END
;

# Previews changes from step 2
SELECT jabatan_formasi AS origin,
	SUBSTRING(jabatan_formasi, 19) AS cleaned_jf
FROM cleaning3; 

ALTER TABLE cleaning3 ADD COLUMN `rmv_redundant_jf` TEXT AFTER jabatan_formasi;
UPDATE cleaning3
SET rmv_redundant_jf = SUBSTRING(jabatan_formasi, 19);

ALTER TABLE cleaning3 ADD COLUMN `jf_code` TEXT AFTER rmv_redundant_jf;

# Previews changes from step 3
SELECT rmv_redundant_jf, SUBSTRING_INDEX(rmv_redundant_jf, "-", 1) AS temp_jf_code
FROM cleaning3; 

# Returns the code only of the jabatan_formasi
UPDATE cleaning3
SET jf_code = SUBSTRING_INDEX(rmv_redundant_jf, "-", 1);

# Removes excess spaces
UPDATE cleaning3
SET jf_code = TRIM(jf_code); 

SELECT * FROM cleaning3;

ALTER TABLE cleaning3 ADD COLUMN `jabatan_desc` TEXT AFTER jf_code;

UPDATE cleaning3
SET jabatan_desc = TRIM(REPLACE(rmv_redundant_jf, jf_code, ''))
WHERE jf_code IS NOT NULL 
	AND jf_code != ''
	AND rmv_redundant_jf LIKE CONCAT(jf_code, '%');

UPDATE cleaning3
SET jabatan_desc = SUBSTRING(jabatan_desc, 2);


SELECT jabatan_desc, SUBSTRING_INDEX(jabatan_desc, " ", -1)
FROM cleaning3;

ALTER TABLE cleaning3 ADD COLUMN `temp_jf_desc` TEXT AFTER jabatan_desc;
UPDATE cleaning3
SET temp_jf_desc = SUBSTRING_INDEX(jabatan_desc, " ", -1);

-- SELECT 
--     jabatan_desc AS original,
--     temp_jf_desc,
--     REPLACE(jabatan_desc, temp_jf_desc, '') AS preview_result,
--     TRIM(REPLACE(jabatan_desc, temp_jf_desc, '')) AS preview_trimmed
-- FROM cleaning3
-- WHERE jabatan_desc LIKE CONCAT('%', temp_jf_desc); # Previews changes to jabatan_desc

UPDATE cleaning3
SET jabatan_desc = TRIM(REPLACE(jabatan_desc, temp_jf_desc, ''))
WHERE temp_jf_desc IS NOT NULL 
  AND temp_jf_desc != ''
  AND jabatan_desc LIKE CONCAT('%', temp_jf_desc);

SELECT * FROM cleaning3;
SELECT DISTINCT jabatan_desc FROM cleaning3 ORDER BY jabatan_desc ASC;

/*
2. lokasi_formasi: blanks, code exists but no details, full
Problematic values include
Lokasi Formasi : 30100017 - 1
Lokasi Formasi : 30100017 - 4
Lokasi Formasi : 30100018 - Sains dan Teknologi | Jurusan Matematika dan Ilmu Pengetahuan Alam, Fakultas Sains dan Teknologi | Prodi S1 Biologi, Fakultas Sains 1

Proposed actions:
1. Create a new column `loc_code` beside lokasi_formasi
2. Populate loc_code only with the code of the formation location

Proposed action (out of scope):
1. Export text where value LIKE "Lokasi Formasi : %"
2. Create new table loc_formation with loc_code and loc_detail columns
*/

ALTER TABLE cleaning3 ADD COLUMN `rmv_redundant_loc` TEXT AFTER lokasi_formasi;
ALTER TABLE cleaning3 ADD COLUMN `loc_code` TEXT AFTER rmv_redundant_loc;

# Remove "Lokasi  Formasi  : " from lokasi_formasi and then store it to rmv_redundant_loc
UPDATE cleaning3
SET rmv_redundant_loc = SUBSTRING(lokasi_formasi, 17);

# Preserve locatoin code only and delete the rest
SELECT 
	rmv_redundant_loc AS original,
	LEFT(rmv_redundant_loc, 8) AS preview
FROM cleaning3;

UPDATE cleaning3
SET loc_code = LEFT(rmv_redundant_loc, 8);

SELECT * FROM cleaning3;
SELECT DISTINCT rmv_redundant_loc FROM cleaning3;


/*
3. jenis_formasi: blanks, full
No problematic rows.
There are 5 types.
UMUM, PENYANDANG DISABILITAS, PUTRA/PUTRI PAPUA DAN PAPUA BARAT, LULUSAN TERBAIK, PUTRA/PUTRI KALIMANTAN
With each category having code
1, 2, 3, 4, 9
respectively.

Proposed actions:
1. Create two new columns: type_formation_code, type_formation
2. Populate type_formation_code with code.
3. Populate type_formation with the type of formation.
*/
ALTER TABLE cleaning3 ADD COLUMN `rmv_redundant_typeform` TEXT AFTER jenis_formasi;
ALTER TABLE cleaning3 ADD COLUMN `type_formation_code` TEXT AFTER rmv_redundant_typeform;
ALTER TABLE cleaning3 ADD COLUMN `type_formation` TEXT AFTER type_formation_code;
-- ALTER TABLE cleaning3 ADD COLUMN `fix_type_formation` TEXT AFTER type_formation;

# Remove the redundant strings
SELECT 
	jenis_formasi AS original,
	SUBSTRING(jenis_formasi, 16) AS preview
FROM cleaning3;
UPDATE cleaning3
SET rmv_redundant_typeform = SUBSTRING(jenis_formasi, 17);

# Preserve the type formation code in type_formation_code
SELECT 
	rmv_redundant_typeform AS original,
    LEFT(rmv_redundant_typeform, 1) AS preview
FROM cleaning3;
UPDATE cleaning3
SET type_formation_code = LEFT(rmv_redundant_typeform, 1);

SELECT DISTINCT type_formation, LENGTH(type_formation) AS char_count FROM cleaning3;

UPDATE cleaning3
SET type_formation = CASE
	WHEN type_formation LIKE " UMUM%" THEN "Umum"
    WHEN type_formation LIKE " LULUSAN TERBAIK%" THEN "Lulusan Terbaik" 
    WHEN type_formation LIKE " PENYANDANG DISABILITAS%" THEN "Disabilitas"
    WHEN type_formation LIKE " PUTRA/PUTRI PAPUA DAN PAPUA BARAT%" THEN "Putra/Putri Papua dan Papua Barat"
    WHEN type_formation LIKE " PUTRA/PUTRI KALIMANTAN%" THEN "Putra/Putri Kalimantan"
	ELSE type_formation
    END;
    
SELECT * FROM cleaning3;
SELECT DISTINCT type_formation FROM cleaning3;

ALTER TABLE cleaning3 RENAME COLUMN `fix2_type_formation` TO `formation_type_fixed`;

/*
4. pendidikan_formasi: blanks, no detail, missing first three strings.
Problematic values include
Pendidikan 1
Pendidikan 11
Pendidikan 2
Pendidikan 3
Pendidikan 4
Pendidikan 5
Pendidikan 6
Pendidikan 7
Pendidikan 8
Pendidikan TEKNIK ELEKTRONIKA/ S-1 PENDIDIKAN TEKNIK MESIN/ S-1 PENDIDIKAN TEKNIK OTOMOTIF/ S-1 REKAYASA PERANGKAT LUNAK/ S-1 TEKNIK INDUSTRI/ 3
Pendidikan TEKNOLOGI REKAYASA MULTIMEDIA/ D-IV TEKNOLOGI REKAYASA MULTIMEDIA GRAFIS/ D-IV TEKNOLOGI REKAYASA PERANGKAT LUNAK/ S-1 ILMU 1

Proposed actions:
1. Append "S-1 " to "Pendidikan TEKNIK ELEKTRONIKA/ S-1 PENDIDIKAN TEKNIK MESIN/ S-1 PENDIDIKAN TEKNIK OTOMOTIF/ S-1 REKAYASA PERANGKAT LUNAK/ S-1 TEKNIK INDUSTRI/ 3"
AND
"Pendidikan TEKNOLOGI REKAYASA MULTIMEDIA/ D-IV TEKNOLOGI REKAYASA MULTIMEDIA GRAFIS/ D-IV TEKNOLOGI REKAYASA PERANGKAT LUNAK/ S-1 ILMU 1"
*/

# Appends "S-1 " to the values in the Proposed actions
SELECT pendidikan_formasi
FROM cleaning3
WHERE pendidikan_formasi = "Pendidikan TEKNIK ELEKTRONIKA/ S-1 PENDIDIKAN TEKNIK MESIN/ S-1 PENDIDIKAN TEKNIK OTOMOTIF/ S-1 REKAYASA PERANGKAT LUNAK/ S-1 TEKNIK INDUSTRI/ 3" OR
	pendidikan_formasi = "Pendidikan TEKNOLOGI REKAYASA MULTIMEDIA/ D-IV TEKNOLOGI REKAYASA MULTIMEDIA GRAFIS/ D-IV TEKNOLOGI REKAYASA PERANGKAT LUNAK/ S-1 ILMU 1"
;

UPDATE cleaning3
SET pendidikan_formasi = 
	CASE
		WHEN pendidikan_formasi LIKE "Pendidikan TEKNIK ELEKTRONIKA/ S-1 PENDIDIKAN TEKNIK MESIN/ S-1 PENDIDIKAN TEKNIK OTOMOTIF/ S-1 REKAYASA PERANGKAT LUNAK/ S-1 TEKNIK INDUSTRI/ 3"
			THEN "Pendidikan S-1 TEKNIK ELEKTRONIKA/ S-1 PENDIDIKAN TEKNIK MESIN/ S-1 PENDIDIKAN TEKNIK OTOMOTIF/ S-1 REKAYASA PERANGKAT LUNAK/ S-1 TEKNIK INDUSTRI/ 3"
		WHEN pendidikan_formasi LIKE "Pendidikan TEKNOLOGI REKAYASA MULTIMEDIA/ D-IV TEKNOLOGI REKAYASA MULTIMEDIA GRAFIS/ D-IV TEKNOLOGI REKAYASA PERANGKAT LUNAK/ S-1 ILMU 1"
			THEN "Pendidikan S-1 TEKNOLOGI REKAYASA MULTIMEDIA/ D-IV TEKNOLOGI REKAYASA MULTIMEDIA GRAFIS/ D-IV TEKNOLOGI REKAYASA PERANGKAT LUNAK/ S-1 ILMU 1"
		ELSE pendidikan_formasi
    END;

SELECT * FROM cleaning3;

/*
Inspecting on the rest of the columns...
Some of the columns have inconvenience name.
In addition, there are supposed to be tiu and tkp columns.

Proposed actions:
1. Rename all remaining columns with a proper name.
2. Create new columns: tiu, tkp
3. Populate cleaning3.tiu wih from_csv.`7` on condition: cleaning3.full_name = `1`
4. Populate cleaning3.tkp with from_csv.`8` on condition: cleaning3.full_name = `1`
*/
ALTER TABLE cleaning3 
	RENAME COLUMN `ï»¿no` TO relative_num,
    RENAME COLUMN `no_peserta` TO `full_name`,
	RENAME COLUMN `tanggal lahir` TO birthdate,
	RENAME COLUMN `pendidikan_peserta` TO last_edu,
    RENAME COLUMN `nilai/ipk` TO gpa,
    RENAME COLUMN `nilai skd` TO twk,
    RENAME COLUMN MyUnknownColumn TO skd,
    RENAME COLUMN `skor skd (40%)` TO skd_40,
    RENAME COLUMN `nilai skb` TO skb,
    RENAME COLUMN `skor skb (60%)` TO skb_60,
    RENAME COLUMN `nilai akhir` TO final_score;
    
ALTER TABLE cleaning3 RENAME COLUMN full_name TO id, RENAME COLUMN nama TO `full_name`;
    
ALTER TABLE cleaning3
	ADD COLUMN `tiu` TEXT AFTER twk,
    ADD COLUMN `tkp` TEXT AFTER tiu;

/* The following code took to long to fetch. I afraid data type mismatch caused the extensive time taken to process the query.
 SELECT full_name, tiu, tkp, `7` AS tiu_import, `8` AS tkp_import
 FROM cleaning3
 INNER JOIN from_csv
	ON full_name = `1`;
*/

CREATE TABLE `tiu_tkp_import` LIKE from_csv;
INSERT INTO tiu_tkp_import
SELECT * FROM from_csv;

SELECT * FROM tiu_tkp_import;

/*
I am now beginning the process to create a table where the columns in tiu_tkp_import only contain id, tiu, tkp.
Therefore, all columns aside from the three are disposed.
Prior to performing this action, I have created the backup source CSV file in case of catasthropy.
*/

SELECT DISTINCT `1` FROM tiu_tkp_import;
SELECT * FROM tiu_tkp_import;
ALTER TABLE tiu_tkp_import 
	DROP COLUMN `0`,
	DROP COLUMN `2`,
	DROP COLUMN `3`,
	DROP COLUMN `4`,
	DROP COLUMN `5`,
	DROP COLUMN `6`,
	DROP COLUMN `9`,
	DROP COLUMN `10`,
	DROP COLUMN `11`,
	DROP COLUMN `12`,
	DROP COLUMN `13`,
	DROP COLUMN `14`,
	DROP COLUMN `__page__`,
	DROP COLUMN `__table__`;
    
ALTER TABLE tiu_tkp_import
	RENAME COLUMN `1` TO id,
    RENAME COLUMN `7` TO tiu,
    RENAME COLUMN `8` TO tkp;
    
SELECT id, tiu, tkp
FROM tiu_tkp_import
WHERE 
	id LIKE "2430%";

# Checking number of test takers on cleaning3 and tiu_tkp_import
SELECT COUNT(id) AS num_count
FROM cleaning3
WHERE id LIKE "2430%"; # 16676 records

SELECT 
	COUNT(id) AS count_id_import
FROM tiu_tkp_import
WHERE id LIKE "2430%"; # 14989 records

# Create backup
CREATE TABLE tiu_tkp_import_backup LIKE tiu_tkp_import;
INSERT INTO tiu_tkp_import_backup
SELECT * FROM tiu_tkp_import;

# NULL-ify id, tiu, tkp where id is not id
UPDATE tiu_tkp_import
SET id = 
	CASE WHEN id NOT LIKE "2430%" THEN NULL
	ELSE id
END;

SELECT * FROM tiu_tkp_import;

UPDATE tiu_tkp_import
SET tiu = NULL, tkp = NULL
WHERE id IS NULL;

DELETE FROM tiu_tkp_import
WHERE id IS NULL AND tiu IS NULL AND tkp IS NULL;

ALTER TABLE tiu_tkp_import ADD COLUMN `id_bu` TEXT;
UPDATE tiu_tkp_import
SET id_bu = id;

SELECT * FROM tiu_tkp_import;

ALTER TABLE tiu_tkp_import MODIFY COLUMN id BIGINT;
ALTER TABLE tiu_tkp_import MODIFY COLUMN tiu INT, MODIFY COLUMN tkp INT;

# Creates backup for column cleaning3.id
ALTER TABLE cleaning3 ADD COLUMN `id_backup` TEXT AFTER id;
SELECT * FROM cleaning3;
UPDATE cleaning3
SET id_backup = id
WHERE id LIKE "2430%";

ALTER TABLE cleaning3 MODIFY COLUMN id_backup BIGINT;

/* The following code returned: Error Code: 2013. Lost connection to MySQL server during query.
Upon consulting with Gemini AI, it seemed that full-scan table will, in fact, burdens the server.
It was advised to create an index for lightning-fast iteration instead.
Update: After restarting my PC, it appears that everything went normal again.

*/
UPDATE cleaning3
JOIN tiu_tkp_import ON cleaning3.id_backup = tiu_tkp_import.id
SET cleaning3.tiu = tiu_tkp_import.tiu;

/* The following code also returned the same Error as the previous one.
Changing to alternative number 2: Increasing the timeout setting

ALTER TABLE cleaning3 ADD INDEX (id_backup);
*/

/* The following alternative also failed to execute with the same error as before.
I will try making some adjustment to the values.

SET GLOBAL max_allowed_packet = 67108864; #Default value according to Gemini AI
SET GLOBAL wait_timeout = 28800;
SET GLOBAL interactive_timeout = 28800;

UPDATE cleaning3
JOIN tiu_tkp_import ON cleaning3.id_backup = tiu_tkp_import.id
SET cleaning3.tiu = tiu_tkp_import.tiu;
*/

SELECT id FROM cleaning3;

/* Comment: 
It seemed like there are some data successfuly imported to cleaning3.tiu
However, the time taken to do basic query has become awfully long.
Update: After restarting my PC, it appears that everything went normal again.
*/

/*
Checking for the validity of the data import by random sampling of 5 ids.
*/
SELECT id, twk, tiu
FROM cleaning3
WHERE id = "24301020110011852"; # Checked. Valid. 1

SELECT id, twk, tiu
FROM cleaning3
WHERE id = "24301020210000025"; # Checked. Valid. 2

SELECT *
FROM cleaning3
WHERE id = "24301020110023975"; # Checked. Valid. 3

SELECT *
FROM cleaning3
WHERE id = "24301020410000521"; # Checked. Valid. 4

SELECT *
FROM cleaning3
WHERE id = "24301020120036368"; # Checked. Valid. 5

/*
Continue procedure: Populating tkp
*/
/*
The following code returned the same Error as previous. 
Error Code: 2013. Lost connection to MySQL server during query

UPDATE cleaning3
JOIN tiu_tkp_import ON cleaning3.id_backup = tiu_tkp_import.id
SET cleaning3.tkp = tiu_tkp_import.tkp;

SELECT cleaning3.id, cleaning3.tiu, tiu_tkp_import.tiu, cleaning3.tkp, tiu_tkp_import.tkp
FROM cleaning3
JOIN tiu_tkp_import
	ON cleaning3.id = tiu_tkp_import.id_bu;
    
UPDATE cleaning3
JOIN tiu_tkp_import
	ON cleaning3.id = tiu_tkp_import.id_bu
SET cleaning3.tkp = tiu_tkp_import.tkp;
*/

SELECT * FROM cleaning3;

/*
I am now trying to derive the tkp score using arithmetical approach.
Since skd = twk + tiu + tkp, then we can get tkp by rearranging the formula.
tkp = skd - twk - tiu
*/

SELECT twk, tiu, tkp AS origin_tkp, skd, (skd - twk - tiu) AS d_tkp
FROM cleaning3
WHERE tiu IS NOT NULL;

# The following code returned Error Code: 1366. Incorrect integer value: 'TWK' for column 'twk' at row 1
ALTER TABLE cleaning3 
	MODIFY COLUMN `twk` INT,
    MODIFY COLUMN `tiu` INT,
    MODIFY COLUMN `tkp` INT,
    MODIFY COLUMN `skd` INT;

SELECT DISTINCT twk FROM cleaning3;

ALTER TABLE cleaning3 
	ADD COLUMN twk_backup TEXT AFTER skd,
    ADD COLUMN tiu_backup TEXT AFTER twk_backup,
    ADD COLUMN tkp_backup TEXT AFTER tiu_backup,
    ADD COLUMN skd_backup TEXT AFTER tkp_backup;
    
SELECT * FROM cleaning3;
UPDATE cleaning3
SET 
	twk_backup = twk,
    tiu_backup = tiu,
    tkp_backup = tkp,
    skd_backup = skd;

UPDATE cleaning3
SET twk = 
	CASE
		WHEN twk LIKE "TWK" THEN NULL
        WHEN twk LIKE "" THEN NULL
        WHEN twk LIKE "(7)" THEN NULL
        ELSE twk
	END; # Column `twk` is safe for data type modification.

SELECT DISTINCT tiu FROM cleaning3; # Column `tiu` is safe for data type modification.

SELECT DISTINCT tkp FROM cleaning3; # Column `tkp is WAIT WHAT... Did the `tkp` column just filled itself?!

UPDATE cleaning3
SET tkp = (skd - twk - tiu)
WHERE tiu IS NOT NULL;

/*
Updating the columns with decimals.
This includes gpa, skb, skd_40, skb_60, and final_score.
As a rule of thumb, I will make another backups of all of those columns in the current table.
*/

ALTER TABLE cleaning3 
	ADD COLUMN gpa_backup TEXT AFTER gpa,
    ADD COLUMN skd_40_backup TEXT AFTER skd_40,
    ADD COLUMN skb_backup TEXT AFTER skb,
    ADD COLUMN skb_60_backup TEXT AFTER skb_60;

UPDATE cleaning3
SET 
	gpa_backup = gpa,
	skd_40_backup = skd_40,
    skb_backup = skb,
    skb_60_backup = skb;

SELECT * FROM cleaning3;

/* Create backup table in case of another catasthropic */
CREATE TABLE backup1_cleaning3 LIKE cleaning3;
INSERT INTO backup1_cleaning3
SELECT * FROM cleaning3;

SELECT DISTINCT gpa FROM cleaning3 ORDER BY gpa ASC;
/* Found out that there are two kinds of gpa scale in place.
The university (0-4 GPA scale) and the high school (0-100 GPA score).
This is problematic since this will interfere at the later analysis process.
With this in mind, I propose to create a new column to indicate which row is university and high school.
Then, I decided to use the university scale grading to normalize the high school scores.
*/

ALTER TABLE cleaning3
	ADD COLUMN `edu_level` TEXT AFTER last_edu;

SELECT *  FROM cleaning3;

UPDATE cleaning3
SET edu_level = 
	CASE
		WHEN gpa LIKE "__.%" THEN "Senior High School"
        WHEN gpa LIKE "_.%" THEN "University"
        WHEN last_edu LIKE "SMK" THEN "Vocational High School"
        ELSE NULL
	END;

UPDATE cleaning3
SET gpa = 
	CASE
		WHEN gpa LIKE "(%" THEN NULL
        WHEN gpa LIKE "" THEN NULL
        ELSE gpa
	END;
    
SELECT DISTINCT skd_40 FROM cleaning3
WHERE skd_40 LIKE "(%";

UPDATE cleaning3
SET skd_40 = 
	CASE 
		WHEN skd_40 LIKE "(%" THEN NULL
		WHEN skd_40 LIKE "" THEN NULL
        ELSE skd_40
	END;

SELECT DISTINCT skb FROM cleaning3 ORDER BY skb;

UPDATE cleaning3
SET skb = 
	CASE
		WHEN skb LIKE "(%" THEN NULL
        WHEN skb LIKE "" THEN NULL
        ELSE skb
	END;

SELECT DISTINCT skb_60 FROM cleaning3 ORDER BY skb_60;

UPDATE cleaning3
SET skb_60 = 
	CASE
		WHEN skb_60 LIKE "" THEN NULL
        WHEN skb_60 LIKE "(%" THEN NULL
        ELSE skb_60
	END;

SELECT DISTINCT final_score FROM cleaning3 ORDER BY final_score;

UPDATE cleaning3
SET final_score = 
	CASE
		WHEN final_score LIKE "" THEN NULL
        WHEN final_score LIKE "(%" THEN NULL
        ELSE final_score
	END;

SELECT * FROM cleaning3;

SELECT DISTINCT gpa FROM cleaning3 ORDER BY gpa;
SELECT DISTINCT skd_40 FROM cleaning3 ORDER BY skd_40;
SELECT DISTINCT skb FROM cleaning3 ORDER BY skb;
SELECT DISTINCT skb_60 FROM cleaning3 ORDER BY skb_60;
SELECT DISTINCT final_score FROM cleaning3 ORDER BY final_score;

SELECT *
FROM cleaning3
WHERE
    gpa IS NOT NULL AND gpa NOT REGEXP '^[0-9]+(\\.[0-9]+)?$'
 OR skd_40 IS NOT NULL AND skd_40 NOT REGEXP '^[0-9]+(\\.[0-9]+)?$'
 OR skb IS NOT NULL AND skb NOT REGEXP '^[0-9]+(\\.[0-9]+)?$'
 OR skb_60 IS NOT NULL AND skb_60 NOT REGEXP '^[0-9]+(\\.[0-9]+)?$'
 OR final_score IS NOT NULL AND final_score NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';

UPDATE cleaning3
SET
    gpa = NULLIF(gpa, ''),
    skd_40 = NULLIF(skd_40, ''),
    skb = NULLIF(skb, ''),
    skb_60 = NULLIF(skb_60, ''),
    final_score = NULLIF(final_score, '');

CREATE TABLE backup2_cleaning3 LIKE cleaning3;
INSERT INTO backup2_cleaning3
SELECT * FROM cleaning3;

ALTER TABLE cleaning3
	MODIFY gpa DECIMAL(5,2),
	MODIFY skd_40 DECIMAL(6,3),
	MODIFY skb DECIMAL(5,2),
	MODIFY skb_60 DECIMAL(5,2),
	MODIFY final_score DECIMAL(6,3);

SELECT * FROM cleaning3;

ALTER TABLE cleaning3 ADD COLUMN `gpa_4scale` DECIMAL(5,2) AFTER gpa;

UPDATE cleaning3
SET gpa_4scale =
    CASE
        WHEN gpa <= 4 THEN gpa
        ELSE gpa / 25
    END;
    
SELECT DISTINCT gpa_4scale FROM cleaning3
WHERE edu_level LIKE "%High%";

# Another backup :D One can't be too careful, aye.
CREATE TABLE backup3_cleaning3 LIKE cleaning3;
INSERT INTO backup3_cleaning3
SELECT * FROM cleaning3;

ALTER TABLE cleaning3 ADD COLUMN row_id BIGINT AUTO_INCREMENT PRIMARY KEY;
SELECT * FROM cleaning3;

# Removes "\n" in columns with long value such as full_name, birthdate, last_edu, and pendidikan_formasi
UPDATE cleaning3
SET 
    full_name = TRIM(REPLACE(REPLACE(full_name, '\n', ' '), '\r', '')),
    birthdate = TRIM(REPLACE(REPLACE(birthdate, '\n', ' '), '\r', '')),
    last_edu = TRIM(REPLACE(REPLACE(last_edu, '\n', ' '), '\r', '')),
    pendidikan_formasi = TRIM(REPLACE(REPLACE(pendidikan_formasi, '\n', ' '), '\r', ''));


/* Detecting open position with no test taker.
I noticed that many of the open positions are having no candidates.
Therefore, it is imperative to mark them with "No Participan" if there is no candidate.
To achieve this, I proposed an algorithm to detect whether an open position has no candidate, as follows:
1. The pattern is that "(1)" in `relative_num` is an indicator that distinguishes one position to the other.
2. Position with no candidate has row width of 3 rows: [blank, blank, (1)] in the `relative_num`
3. The detection rule is that if one row below the "(1)" IS NOT NULL, then take the two rows above "(1)" as well as including the row in which "(1)" is present.
4. Thus, creating a permanent index column is in order.
5. IF row_id (the index) + 1 IS NOT NULL, then update row_id, row_id - 1, row_id -2 TO "No Participant" WHERE row_id LIKE "(1)"

Update: It was utterly painful to make a row_number in MySQL.
Every time I tried to create a new coulmn with row index in it (ROW_NUMBER), the end result is not the same with what I expected.
As an alternative, I made a bash script to add the row indexing.
It was more reliable than MySQL, in my humble opinion. 
I have also uploaded the CSV file with row indexed.
As a checkpoint, I decided to make the fourth cleaning table attempt: cleaning4.
*/

SELECT * FROM cleaning4; # Looking good, yes!

CREATE TABLE backup1_cleaning4 LIKE cleaning4;
INSERT INTO backup1_cleaning4
SELECT * FROM cleaning4; # Might as well create a new backup for this one :D

/*
Attempting to remove the redundant rows.
Each open position has three excessive rows at the very top of each position.
To standardize the table, I proposed the following actions:
1. DELETE rows where row_id LIKE "No Participant" AND relative_num LIKE ""
2. Change the value of relative_num to "No Participant" based on row_id LIKE "No Participant" AND relative_num LIKE "(1)"
*/

SELECT row_id, relative_num FROM cleaning4
WHERE
	row_id LIKE "No Participant" AND
	relative_num LIKE "(1)";
    
UPDATE cleaning4
SET relative_num = 
	CASE
		WHEN row_id LIKE "No Participant" AND relative_num LIKE "(1)" THEN "No Participant"
        ELSE relative_num
	END
;


SELECT * FROM cleaning4
WHERE 
	row_id LIKE "No Participant" AND
	relative_num LIKE "";

DELETE
FROM cleaning4
WHERE row_id LIKE "No Participant" AND relative_num LIKE "";

SELECT * FROM cleaning4;

SELECT * FROM cleaning4
WHERE row_id IS NULL AND relative_num LIKE "";

DELETE FROM cleaning4
WHERE row_id IS NULL AND relative_num LIKE "";

SELECT COUNT(relative_num) FROM cleaning4;

DELETE FROM cleaning4 
WHERE row_id IS NULL AND relative_num LIKE "(1)";

SELECT * FROM cleaning4;

SELECT COUNT(relative_num) FROM cleaning4
WHERE row_id LIKE "No Participant" AND relative_num LIKE "No Participant"; # 2287 rows will be changed (open position with no candidate)

UPDATE cleaning4
SET 
	id = NULL,
    full_name = NULL,
    birthdate = NULL,
    last_edu = NULL,
    gpa_backup = NULL,
    skd = NULL,
    twk_backup = NULL,
    skd_backup = NULL,
    skd_40_backup = NULL,
    skb_backup = NULL,
    keterangan = NULL
WHERE row_id LIKE "No Participant" AND relative_num LIKE "No Participant";

SELECT * FROM cleaning4;



UPDATE cleaning4
SET relative_num = 
	CASE
		WHEN row_id LIKE "No Participant" AND relative_num LIKE "No Participant" THEN NULL
        ELSE relative_num
	END
;


/* Next step:
Fill blank data for test takers with blank jabatan_formasi, rmv_redundant_jf, jf_code, lokas_formasi, rmv_redundant_loc, loc_code, jenis_formasi, rmv_redundant_typeform, type_formation_code, type_formation, pendidikan_formasi
	with data from the previous row where current row_id = prev.row_id + 1 AND current.page_number = prev.page_number + 1
*/
SELECT page_number, COUNT(page_number) AS count_missing FROM cleaning4
WHERE jabatan_formasi LIKE ""
GROUP BY page_number
ORDER BY count_missing DESC;

CREATE TABLE `backup2_cleaning4` LIKE cleaning4;
SELECT * FROM backup2_cleaning4;

ALTER TABLE backup2_cleaning4
	DROP COLUMN `row_id`,
    DROP COLUMN id_backup,
    DROP COLUMN gpa,
    DROP COLUMN gpa_backup,
    DROP COLUMN twk_backup,
    DROP COLUMN tiu_backup,
    DROP COLUMN tkp_backup, 
    DROP COLUMN skd_backup,
    DROP COLUMN skd_40_backup,
    DROP COLUMN skb_backup,
    DROP COLUMN skb_60_backup,
    DROP COLUMN jabatan_formasi,
    DROP COLUMN rmv_redundant_jf,
    DROP COLUMN temp_jf_desc,
    DROP COLUMN lokasi_formasi,
    DROP COLUMN rmv_redundant_loc,
    DROP COLUMN jenis_formasi,
    DROP COLUMN rmv_redundant_typeform;

INSERT INTO backup2_cleaning4
SELECT relative_num, id, full_name, birthdate, last_edu, edu_level, gpa_4scale, twk, tiu, tkp, skd, skd_40, skb, skb_60,  final_score, keterangan,
	jf_code, jabatan_desc, loc_code, type_formation_code, type_formation, pendidikan_formasi, page_number
FROM cleaning4;

CREATE TABLE cleaning5 LIKE backup2_cleaning4;
INSERT INTO cleaning5
SELECT * FROM backup2_cleaning4;

SELECT * FROM cleaning5;
SELECT DISTINCT jf_code FROM cleaning5 ORDER BY jf_code;

UPDATE cleaning5
SET jf_code = CASE
	WHEN jf_code LIKE "" THEN NULL
    ELSE jf_code
END;

SELECT DISTINCT jabatan_desc FROM cleaning5 ORDER BY jabatan_desc;
SELECT DISTINCT loc_code FROM cleaning5 ORDER BY loc_code;
SELECT DISTINCT type_formation_code FROM cleaning5 ORDER BY type_formation_code;
SELECT DISTINCT type_formation FROM cleaning5 ORDER BY type_formation;
SELECT DISTINCT pendidikan_formasi FROM cleaning5 ORDER BY pendidikan_formasi;

UPDATE cleaning5
SET loc_code = 
	CASE
		WHEN loc_code LIKE "" THEN NULL
		ELSE loc_code
	END,
    type_formation_code = 
		CASE 
			WHEN type_formation_code LIKE "" THEN NULL
            ELSE type_formation_code
		END,
	type_formation = 
		CASE 
			WHEN type_formation LIKE "" THEN NULL
            ELSE type_formation
		END,
	pendidikan_formasi =
		CASE
			WHEN pendidikan_formasi LIKE "" THEN NULL
            ELSE pendidikan_formasi
		END
;

SELECT jf_code, page_number
FROM cleaning5
GROUP BY page_number, jf_code;

SELECT * FROM cleaning5;

CREATE TABLE fill1 LIKE cleaning5;
INSERT INTO fill1
SELECT * FROM cleaning5;

SELECT * FROM fill1;
ALTER TABLE fill1
	DROP COLUMN relative_num,
    DROP COLUMN id,
    DROP COLUMN full_name,
    DROP COLUMN birthdate, 
    DROP COLUMN last_edu,
    DROP COLUMN edu_level,
    DROP COLUMN gpa_4scale,
    DROP COLUMN twk,
    DROP COLUMN tiu,
    DROP COLUMN tkp,
    DROP COLUMN skd_40,
    DROP COLUMN skb,
    DROP COLUMN skb_60,
    DROP COLUMN final_score,
    DROP COLUMN keterangan;
    
SELECT DISTINCT page_number FROM fill1
WHERE jf_code IS NULL;

CREATE TABLE fill1_ref LIKE fill1;
SELECT * FROM fill1_ref;
ALTER TABLE fill1_ref DROP COLUMN skd;

SELECT 
    COALESCE(t1.jf_code, t2.jf_code) AS jf_code_filled,
	COALESCE(t1.jabatan_desc, t2.jabatan_desc) AS jabatan_desc_filled,
    COALESCE(t1.loc_code, t2.loc_code) AS loc_code_filled,
    COALESCE(t1.type_formation_code, t2.type_formation_code) AS type_formation_code_filled,
    COALESCE(t1.type_formation, t2.type_formation) AS type_formation_filled,
    COALESCE(t1.pendidikan_formasi, t2.pendidikan_formasi) AS pendidikan_formasi_filled,
    t1.page_number
FROM fill1 AS t1
LEFT JOIN fill1 AS t2
	ON t2.page_number = t1.page_number - 1
    AND t2.jf_code IS NOT NULL
ORDER BY t1.page_number;

UPDATE fill1 AS t1
JOIN fill1 AS t2
	ON t2.page_number = t1.page_number - 1
    AND t2.page_number IS NOT NULL
SET
	t1.jf_code = t2.jf_code,
    t1.jabatan_desc = t2.jabatan_desc,
    t1.loc_code = t2.loc_code,
    t1.type_formation_code = t2.type_formation_code,
    t1.type_formation = t2.type_formation,
    t1.pendidikan_formasi = t2.pendidikan_formasi
WHERE t1.jf_code IS NULL;

SELECT * FROM fill1;
SELECT COUNT(DISTINCT page_number) FROM fill1 WHERE jf_code IS NULL;
SELECT DISTINCT page_number FROM fill1 WHERE jf_code IS NULL;
SELECT * FROM cleaning5 WHERE page_number LIKE "9138" ORDER BY page_number;

/* There are some rows that are accidentally deleted in the several previous operations.
Now beginning to retrieve data from backup based on `page_number`.
Open positions having some of it rows deleted are of rows with page_number LIKE:
1637 - 1
7497 - 1
8038 - 1
8560 - 1
9139 - 1
9832 - 1
10027 - 1


Update: I have tried importing the table but it seemed that the said pages did not sucessfully imported.
Upon investigating on the corresponding CSV file in a text editor, there are in fact exist the said pages.

*/

ALTER TABLE fill2 ADD COLUMN `count` TEXT;
INSERT INTO fill2
SELECT jf_code, jabatan_desc, loc_code, type_formation_code, type_formation, pendidikan_formasi, page_number, COUNT(page_number) AS count FROM fill1
GROUP BY jf_code, jabatan_desc, loc_code, type_formation_code, type_formation, pendidikan_formasi, page_number;

SELECT * FROM fill2;
ALTER TABLE fill2 DROP COLUMN `count`;

ALTER TABLE fill1 DROP COLUMN skd;

CREATE TABLE fill2 LIKE fill1;
INSERT INTO fill2
SELECT  DISTINCT(*) FROM fill1;

CREATE TABLE backup1_cleaning5 LIKE cleaning5;
INSERT INTO backup1_cleaning5
SELECT * FROM cleaning5;

UPDATE cleaning5 t1
JOIN fill2 t2 ON t1.page_number = t2.page_number
SET 
	t1.jf_code = t2.jf_code,
    t1.jabatan_desc = t2.jabatan_desc,
    t1.loc_code = t2.loc_code,
    t1.type_formation_code = t2.type_formation_code,
    t1.type_formation = t2.type_formation,
    t1.pendidikan_formasi = t2.pendidikan_formasi
WHERE t1.jf_code IS NULL;

SELECT * FROM cleaning5;

SELECT * FROM cleaning6;

/*
Created `job_position` table to contain jf_code and job_desc.
Later on, `jf_code` in cleaning6 will be renamed to `jp_code`.
In addition, `jabatan_desc` will also be renamed to `position`.
*/

SELECT COUNT(jf_code), jabatan_desc, jf_code FROM cleaning6
GROUP BY jabatan_desc, jf_code
ORDER BY jf_code; # Query result exported to CSV then re-import

SELECT * FROM cleaning6
WHERE page_number LIKE "1635";

SELECT COUNT(type_formation), type_formation_code, type_formation
FROM cleaning6
GROUP BY type_formation_code, type_formation
ORDER BY type_formation_code;

INSERT INTO fill1 (
    jf_code, 
    jabatan_desc, 
    loc_code, 
    type_formation_code, 
    type_formation, 
    pendidikan_formasi, 
    page_number
) VALUES 
('JF0000908', 'DOSEN ASISTEN AHLI', '30102210', '1', 'Umum', 'Pendidikan S-2 ILMU BIOMEDIS 5', '7496'),
('JF0000908', 'DOSEN ASISTEN AHLI', '30100073', '1', 'Umum', 'Pendidikan S-2 EKONOMI SYARIAH 3', '1636'),
('JF0000908', 'DOSEN ASISTEN AHLI', '30102713', '1', 'Umum', 'Pendidikan S-2 EPIDEMIOLOGI/ S-2 KESEHATAN MASYARAKAT 4', '8037'),
('JF0000908', 'DOSEN ASISTEN AHLI', '30102976', '1', 'Umum', 'Pendidikan S-2 ILMU MANAJEMEN/ S-2 MANAJEMEN/ S-2 MANAJEMEN SUMBER DAYA MANUSIA 5', '8559'),
('JF0000908', 'DOSEN ASISTEN AHLI', '30103191', '1', 'Umum', 'Pendidikan S-2 ILMU KOMUNIKASI 8', '9138'),
('JF0000908', 'DOSEN ASISTEN AHLI', '30103456', '1', 'Umum', 'Pendidikan S-2 FARMASI/ S-2 ILMU FARMASI 5', '9831'),
('JF0000908', 'DOSEN ASISTEN AHLI', '30103567', '1', 'Umum', 'Pendidikan S-2 MANAJEMEN 5', '10026');

SELECT * FROM fill1 WHERE jf_code IS NULL;

UPDATE fill1 AS t1
JOIN fill1 AS t2
	ON t2.page_number = t1.page_number - 1
    AND t2.page_number IS NOT NULL
SET
	t1.jf_code = t2.jf_code,
    t1.jabatan_desc = t2.jabatan_desc,
    t1.loc_code = t2.loc_code,
    t1.type_formation_code = t2.type_formation_code,
    t1.type_formation = t2.type_formation,
    t1.pendidikan_formasi = t2.pendidikan_formasi
WHERE t1.jf_code IS NULL;

UPDATE union_cleaning7 t1
JOIN fill1 t2 ON t1.page_number = t2.page_number
SET 
	t1.jf_code = t2.jf_code,
    t1.jabatan_desc = t2.jabatan_desc,
    t1.loc_code = t2.loc_code,
    t1.type_formation_code = t2.type_formation_code,
    t1.type_formation = t2.type_formation,
    t1.pendidikan_formasi = t2.pendidikan_formasi
WHERE t1.jf_code IS NULL;

SELECT * FROM union_cleaning7 WHERE jf_code IS NULL;

SELECT * FROM union_cleaning7;

UPDATE union_cleaning7
SET birthdate = REPLACE(birthdate, 'Januari', 'January'),
    birthdate = REPLACE(birthdate, 'Februari', 'February'),
    birthdate = REPLACE(birthdate, 'Maret', 'March'),
    birthdate = REPLACE(birthdate, 'Mei', 'May'),
    birthdate = REPLACE(birthdate, 'Juni', 'June'),
    birthdate = REPLACE(birthdate, 'Juli', 'July'),
    birthdate = REPLACE(birthdate, 'Agustus', 'August'),
    birthdate = REPLACE(birthdate, 'Oktober', 'October'),
    birthdate = REPLACE(birthdate, 'Desember', 'December');
    
UPDATE union_cleaning7
SET birthdate = STR_TO_DATE(birthdate, '%d %M %Y');

SELECT * FROM union_cleaning7;

SELECT DISTINCT keterangan FROM union_cleaning7 ORDER BY keterangan;
SELECT DISTINCT type_formation_code, type_formation, COUNT(type_formation) FROM union_cleaning7 GROUP BY type_formation_code, type_formation ORDER BY type_formation_code;