USE hasil_cpns2024_kemendikbud;

/* Start by taking the bird view of the dataset.
Identify each column for any unnecessary data. */
SELECT * FROM cleaning2;

/* Create a new column called `row_num` for future use when populating rows with blank values*/
ALTER TABLE cleaning2 ADD COLUMN `row_num` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

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
SELECT * FROM cleaning2;
SELECT DISTINCT jabatan_formasi FROM cleaning2 ORDER BY jabatan_formasi ASC;
SELECT DISTINCT lokasi_formasi FROM cleaning2 ORDER BY lokasi_formasi ASC;
SELECT DISTINCT jenis_formasi FROM cleaning2 ORDER BY jenis_formasi ASC;
SELECT DISTINCT pendidikan_formasi FROM cleaning2 ORDER BY pendidikan_formasi ASC;

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
UPDATE cleaning2
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
FROM cleaning2; 

ALTER TABLE cleaning2 ADD COLUMN `rmv_redundant_jf` TEXT AFTER jabatan_formasi;
UPDATE cleaning2
SET rmv_redundant_jf = SUBSTRING(jabatan_formasi, 19);

ALTER TABLE cleaning2 ADD COLUMN `jf_code` TEXT AFTER keterangan;

# Previews changes from step 3
SELECT rmv_redundant_jf, SUBSTRING_INDEX(rmv_redundant_jf, "-", 1) AS temp_jf_code
FROM cleaning2; 
UPDATE cleaning2
SET jf_code = SUBSTRING_INDEX(rmv_redundant_jf, "-", 1);
UPDATE cleaning2
SET jf_code = TRIM(jf_code); # Removes excess spaces

ALTER TABLE cleaning2 ADD COLUMN `jabatan_desc` TEXT AFTER jf_code;
UPDATE cleaning2
SET jabatan_desc = SUBSTRING_INDEX(rmv_redundant_jf, "-",  1);
UPDATE cleaning2
SET jabatan_desc = TRIM(jabatan_desc); # Removes excess spaces

UPDATE cleaning2
SET jabatan_desc = TRIM(REPLACE(rmv_redundant_jf, jf_code, ''))
WHERE jf_code IS NOT NULL 
  AND jf_code != ''
  AND rmv_redundant_jf LIKE CONCAT(jf_code, '%');

UPDATE cleaning2
SET jabatan_desc = SUBSTRING(jabatan_desc, 2);

SELECT jabatan_desc, SUBSTRING_INDEX(jabatan_desc, " ", -1)
FROM cleaning2;

ALTER TABLE cleaning2 ADD COLUMN `temp_jf_desc` TEXT AFTER jabatan_desc;
UPDATE cleaning2
SET temp_jf_desc = SUBSTRING_INDEX(jabatan_desc, " ", -1);

-- SELECT 
--     jabatan_desc AS original,
--     temp_jf_desc,
--     REPLACE(jabatan_desc, temp_jf_desc, '') AS preview_result,
--     TRIM(REPLACE(jabatan_desc, temp_jf_desc, '')) AS preview_trimmed
-- FROM cleaning2
-- WHERE jabatan_desc LIKE CONCAT('%', temp_jf_desc); # Previews changes to jabatan_desc

UPDATE cleaning2
SET jabatan_desc = TRIM(REPLACE(jabatan_desc, temp_jf_desc, ''))
WHERE temp_jf_desc IS NOT NULL 
  AND temp_jf_desc != ''
  AND jabatan_desc LIKE CONCAT('%', temp_jf_desc);

SELECT * FROM cleaning2;
SELECT DISTINCT jabatan_desc FROM cleaning2 ORDER BY jabatan_desc ASC;

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

ALTER TABLE cleaning2 ADD COLUMN `rmv_redundant_loc` TEXT AFTER lokasi_formasi;
ALTER TABLE cleaning2 ADD COLUMN `loc_code` TEXT AFTER rmv_redundant_loc;

# Remove "Lokasi  Formasi  : " from lokasi_formasi and then store it to rmv_redundant_loc
UPDATE cleaning2
SET rmv_redundant_loc = SUBSTRING(lokasi_formasi, 17);

# Preserve locatoin code only and delete the rest
SELECT 
	rmv_redundant_loc AS original,
	LEFT(rmv_redundant_loc, 8) AS preview
FROM cleaning2;

UPDATE cleaning2
SET loc_code = LEFT(rmv_redundant_loc, 8);

SELECT * FROM cleaning2;
SELECT DISTINCT rmv_redundant_loc FROM cleaning2;


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
ALTER TABLE cleaning2 ADD COLUMN `rmv_redundant_typeform` TEXT AFTER jenis_formasi;
ALTER TABLE cleaning2 ADD COLUMN `type_formation_code` TEXT AFTER rmv_redundant_typeform;
ALTER TABLE cleaning2 ADD COLUMN `type_formation` TEXT AFTER type_formation_code;
ALTER TABLE cleaning2 ADD COLUMN `fix_type_formation` TEXT AFTER type_formation;

# Remove the redundant strings
SELECT 
	jenis_formasi AS original,
	SUBSTRING(jenis_formasi, 16) AS preview
FROM cleaning2;
UPDATE cleaning2
SET rmv_redundant_typeform = SUBSTRING(jenis_formasi, 17);

# Preserve the type formation code in type_formation_code
SELECT 
	rmv_redundant_typeform AS original,
    LEFT(rmv_redundant_typeform, 1) AS preview
FROM cleaning2;
UPDATE cleaning2
SET type_formation_code = LEFT(rmv_redundant_typeform, 1);

# Preserve the type formation description, still leaves redundant number on right.
SELECT rmv_redundant_typeform AS original,
	SUBSTRING(rmv_redundant_typeform, 4) AS preview
FROM cleaning2;
UPDATE cleaning2
SET type_formation = SUBSTRING(rmv_redundant_typeform, 4);

# Removes the number on the right side of the value
SELECT 
	type_formation AS original,
	LENGTH(SUBSTRING_INDEX(type_formation, " ", -1)) AS preview
FROM cleaning2;

ALTER TABLE cleaning2 ADD COLUMN `fix2_type_formation` TEXT AFTER fix_type_formation;

UPDATE cleaning2
SET fix2_type_formation = TRIM(REPLACE(type_formation, fix_type_formation, ''))
WHERE fix_type_formation IS NOT NULL 
	AND fix_type_formation != ''
	AND type_formation LIKE CONCAT('%', fix_type_formation);
    
SELECT * FROM cleaning2;
SELECT DISTINCT type_formation FROM cleaning2;

ALTER TABLE cleaning2 RENAME COLUMN `fix2_type_formation` TO `formation_type_fixed`;

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
FROM cleaning2
WHERE pendidikan_formasi = "Pendidikan TEKNIK ELEKTRONIKA/ S-1 PENDIDIKAN TEKNIK MESIN/ S-1 PENDIDIKAN TEKNIK OTOMOTIF/ S-1 REKAYASA PERANGKAT LUNAK/ S-1 TEKNIK INDUSTRI/ 3" OR
	pendidikan_formasi = "Pendidikan TEKNOLOGI REKAYASA MULTIMEDIA/ D-IV TEKNOLOGI REKAYASA MULTIMEDIA GRAFIS/ D-IV TEKNOLOGI REKAYASA PERANGKAT LUNAK/ S-1 ILMU 1"
;

UPDATE cleaning2
SET cleaning2.pendidikan_formasi = 
	CASE
		WHEN pendidikan_formasi = "Pendidikan TEKNIK ELEKTRONIKA/ S-1 PENDIDIKAN TEKNIK MESIN/ S-1 PENDIDIKAN TEKNIK OTOMOTIF/ S-1 REKAYASA PERANGKAT LUNAK/ S-1 TEKNIK INDUSTRI/ 3"
			THEN "Pendidikan S-1 TEKNIK ELEKTRONIKA/ S-1 PENDIDIKAN TEKNIK MESIN/ S-1 PENDIDIKAN TEKNIK OTOMOTIF/ S-1 REKAYASA PERANGKAT LUNAK/ S-1 TEKNIK INDUSTRI/ 3"
		WHEN pendidikan_formasi = "Pendidikan TEKNOLOGI REKAYASA MULTIMEDIA/ D-IV TEKNOLOGI REKAYASA MULTIMEDIA GRAFIS/ D-IV TEKNOLOGI REKAYASA PERANGKAT LUNAK/ S-1 ILMU 1"
			THEN "Pendidikan S-1 TEKNOLOGI REKAYASA MULTIMEDIA/ D-IV TEKNOLOGI REKAYASA MULTIMEDIA GRAFIS/ D-IV TEKNOLOGI REKAYASA PERANGKAT LUNAK/ S-1 ILMU 1"
		ELSE raw_table.pendidikan_formasi
    END;

SELECT * FROM cleaning2;