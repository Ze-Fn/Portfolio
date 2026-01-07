/*
# Attempt 1
This SQL script is the first attempt on querying:
`HasilCPNS2024KemendikbudLampiran1.pdf`
with clean and more optimized code structure.

The preceding SQL scripts in the Archive dir are the dirty version of data cleaning.
One of them even surpassed 1000 lines of codes just for cleaning the table.
It was engaging, but that was when I know little about intermediate-level SQL, hence the extensively long scripts.
Another reason for those script to be exhaustively long was because of my fear of losing partial/all of the data.
So afraid of losing the data that I might even have developed a `paranoia`.
*/

/* Import CSV using Table Data Import Wizard */
/* Overview of the table */
SELECT * FROM attempt1_cleanquery;

/* Problems detected:
1. Inconventional column names
2. Open positions with no candidate are not defined
3. Unimported rows from source table
4. Missing important column: `tiu`, `tkp`

Proposed actions (respectively):
1. Rename all column to a more appropriate name
2. Define open positions with no candidate based on COUNT(page_number)
3. Import rows from source PDF with different Python script that successfully extract the missing rows
4. Import tables from source PDF with different Python script that successfully extract either `tiu` or `tkp` or both

*/

/* Rename all column to a more appropriate name */
ALTER TABLE attempt1_cleanquery 
	RENAME COLUMN `ï»¿no` TO `relative_num`,
    RENAME COLUMN no_peserta TO id,
    RENAME COLUMN nama TO full_name,
    RENAME COLUMN `tanggal lahir` TO birthdate,
    RENAME COLUMN`pendidikan_peserta` TO last_edu,
    RENAME COLUMN`nilai/ipk` TO gpa,
    RENAME COLUMN`nilai skd` TO twk,
    ADD COLUMN `tiu` INT DEFAULT NULL AFTER twk,
    ADD COLUMN `tkp` INT DEFAULT NULL AFTER tiu,
    RENAME COLUMN `MyUnknownColumn` TO skd,
    RENAME COLUMN `skor skd (40%)` TO skd40,
    RENAME COLUMN `nilai skb` TO skb,
    RENAME COLUMN `skor skb (60%)` TO skb60,
    RENAME COLUMN `nilai akhir` TO final_score,
    RENAME COLUMN `keterangan` TO decl_code;

/* 2. Define open positions with no candidate based on COUNT(page_number) */
WITH no_candidate AS(               -- CTE for open positions with no candidate
	SELECT page_number
	FROM attempt1_cleanquery
    GROUP BY page_number
    HAVING COUNT(page_number) = 3   
)
UPDATE attempt1_cleanquery lt       -- Updates the table
LEFT JOIN no_candidate rt
	ON lt.page_number = rt.page_number
SET 
	relative_num = CASE
			WHEN relative_num LIKE "(1)" THEN "No Candidate"
			WHEN relative_num LIKE "" THEN "Omit"
			ELSE relative_num
		    END,
    id = CASE 
			WHEN id LIKE "(2)" THEN NULL
            ELSE id
            END,
    full_name = CASE
            WHEN full_name LIKE "(3)" THEN NULL
            ELSE full_name
            END,
    birthdate = CASE
            WHEN birthdate LIKE "(4)" THEN NULL
            ELSE birthdate
            END,
    last_edu = CASE
            WHEN last_edu LIKE "(5)" THEN NULL
            ELSE last_edu
            END,
    gpa = CASE
            WHEN gpa LIKE "(6)" THEN NULL
            ELSE gpa
            END,
    twk = CASE
            WHEN twk LIKE "(7)" OR twk LIKE "TWK" THEN NULL
            ELSE twk
            END,
    skd = CASE
            WHEN skd LIKE "(%" THEN NULL
            ELSE skd
            END,
    skd40 = CASE
            WHEN skd40 LIKE "(%" THEN NULL
            ELSE skd40
            END,
    skb = CASE
            WHEN skb LIKE "(%" THEN NULL
            ELSE skb
            END,
    skb60 = CASE
            WHEN skb60 LIKE "(%" THEN NULL
            ELSE skb60
            END,
    final_score = CASE
            WHEN final_score LIKE "(%" THEN NULL
            ELSE final_score
            END,
    decl_code = CASE
            WHEN decl_code LIKE "(%" THEN NULL
            ELSE decl_code
            END
WHERE lt.page_number = rt.page_number;

/* 3. Import rows from source PDF with different Python script that successfully extract the missing rows */
WITH missing_rows_cte AS(       -- CTE for missing rows
    SELECT `0`,`1`,`2`,`3`,`4`,`5`,`6`,`7`,`8`,`9`,`10`,`11`,`12`,`13`,`14` 
    FROM missing_rows
    WHERE 
        `__page__` LIKE "1636" OR
        `__page__` LIKE "7496" OR
        `__page__` LIKE "8037" OR
        `__page__` LIKE "8559" OR
        `__page__` LIKE "9138" OR
        `__page__` LIKE "9831" OR
        `__page__` LIKE "10026")
SELECT * FROM missing_rows_cte  -- Main query to see the missing rows
WHERE 
	`0` NOT LIKE "" AND
    `0` NOT LIKE "P%" AND
    `0` NOT LIKE "(%" AND
    `0` NOT LIKE "J%" AND
    `1` NOT LIKE 2 AND
    `1` NOT LIKE 7 AND
    `1` NOT LIKE "N%";

INSERT INTO attempt1_cleanquery (relative_num, id, full_name, birthdate, last_edu, gpa, twk, tiu, tkp, skd, skd40, skb, skb60, final_score, decl_code, jabatan_formasi, lokasi_formasi, jenis_formasi, pendidikan_formasi, page_number)
VALUES 
('1', '24301020110025383', 'MUHAMMAD FARRAS HANIF', '02 Desember1995', 'S-2 EKONOMISYARIAH', '3.62', '75', '130', '189', '394', '28.654', '71.6', '42.96', '71.614', 'P/L',NULL,NULL,NULL,NULL,1636),
('2', '24301020120001182', 'AI KOKOY KOYYIMAH', '01 Desember1998', 'S-2 EKONOMISYARIAH', '3.9', '100', '120', '192', '412', '29.964', '68.4', '41.04', '71.004', 'P/L',NULL,NULL,NULL,NULL,1636),
('3', '24301020120012667', 'RINA NUR SHABRINA', '18 Maret 1992', 'S-2 EKONOMISYARIAH', '3.79', '115', '125', '183', '423', '30.764', '63.6', '38.16', '68.924', 'P/L',NULL,NULL,NULL,NULL,1636),
('4', '24301020120003259', 'NAUFAL LUTHFI ALIFA', '25 Desember1997', 'S-2 EKONOMISYARIAH', '3.82', '75', '115', '195', '385', '28.0', '68.0', '40.8', '68.8', 'TL',NULL,NULL,NULL,NULL,1636),
('5', '24301020110000808', 'ABDULLAH JUNDI FAISHAL', '26 Februari 1994', 'S-2 EKONOMISYARIAH', '3.71', '80', '115', '192', '387', '28.146', '66.4', '39.84', '67.986', 'TL',NULL,NULL,NULL,NULL,1636),
('6', '24301020120031179', 'NOSHRATINA ALYANI', '18 Juni 1997', 'S-2 EKONOMISYARIAH', '3.62', '90', '115', '196', '401', '29.164', '59.4', '35.64', '64.804', 'TL',NULL,NULL,NULL,NULL,1636),
('7', '24301020120031876', 'NURHAFIANI', '30 Agustus 1996', 'S-2 EKONOMISYARIAH', '3.69', '95', '115', '184', '394', '28.654', '58.8', '35.28', '63.934', 'TL',NULL,NULL,NULL,NULL,1636),
('8', '24301020110018545', 'MUHAMAD FAEQI HADI SAPUTRA', '02 Juli 1992', 'S-2 EKONOMISYARIAH', '3.5', '95', '100', '198', '393', '28.582', '54.8', '32.88', '61.462', 'TL',NULL,NULL,NULL,NULL,7496),
('1', '24301020120027474', 'DIAN EKAYANTI ASTARI', '09 Maret 1996', 'S-2 ILMUBIOMEDIS', '3.94', '85', '145', '187', '417', '30.327', '72.0', '43.2', '73.527', 'P/L',NULL,NULL,NULL,NULL,7496),
('2', '24301020120032566', 'AFIFA RADHINA', '16 November1993', 'S-2 ILMUBIOMEDIS', '3.45', '85', '120', '182', '387', '28.146', '63.2', '37.92', '66.066', 'P/L',NULL,NULL,NULL,NULL,7496),
('3', '24301020120004947', 'NIKEN RAHMAH GHANNY', '21 Mei 1993', 'S-2 ILMUBIOMEDIS', '3.67', '80', '125', '190', '395', '28.727', '61.8', '37.08', '65.807', 'P/L',NULL,NULL,NULL,NULL,7496),
('4', '24301020110017847', 'EDY WIRANTO', '08 Juni 1998', 'S-2 ILMUBIOMEDIS', '3.81', '85', '155', '196', '436', '31.709', '69.8', '41.88', '73.589', 'TMS-1',NULL,NULL,NULL,NULL,7496),
('5', '24301020120001445', 'YULIANDINI PANGESTIKA', '09 Juli 1993', 'S-2 ILMUBIOMEDIS', '3.4', '95', '95', '191', '381', '27.709', '53.4', '32.04', '59.749', 'TMS-1',NULL,NULL,NULL,NULL,7496),
('6', '24301020120028946', 'INDAH SARI', '01 Agustus 1995', 'S-2 ILMUBIOMEDIS', '3.86', '90', '145', '191', '426', '30.982', '3.8', '2.28', '33.262', 'TMS-1',NULL,NULL,NULL,NULL,7496),
('7', '24301020110005079', 'RIZKI AWALUDDIN', '14 Agustus 1994', 'S-2 ILMUBIOMEDIS', '3.78', '85', '95', '189', '369', '26.836', '9.2', '5.52', '32.356', 'TMS-1',NULL,NULL,NULL,NULL,7496),
('8', '24301020120006373', 'GITA WIDEANI', '26 Januari 1990', 'S-2 ILMUBIOMEDIS', '3.67', '85', '130', '178', '393', '28.582', '6.2', '3.72', '32.302', 'TMS-1',NULL,NULL,NULL,NULL,7496),
('1', '24301020120020167', 'RIRI OKTAVANI BANJARNAHOR', '02 Oktober 1995', 'S-2 KESEHATANMASYARAKAT', '3.87', '85', '140', '192', '417', '30.327', '77.0', '46.2', '76.527', 'P/L',NULL,NULL,NULL,NULL,8037),
('2', '24301020120022532', 'GITA APRILICIA', '02 April 1995', 'S-2EPIDEMIOLOGI', '3.86', '85', '135', '188', '408', '29.673', '68.6', '41.16', '70.833', 'P/L',NULL,NULL,NULL,NULL,8037),
('3', '24301020120021703', 'DELA RIADI', '02 September1991', 'S-2 KESEHATANMASYARAKAT', '3.73', '100', '125', '200', '425', '30.909', '56.0', '33.6', '64.509', 'P/L',NULL,NULL,NULL,NULL,8037),
('4', '24301020120002422', 'DELLA DWI AYU', '23 November1996', 'S-2 KESEHATANMASYARAKAT', '3.85', '95', '130', '189', '414', '30.109', '54.8', '32.88', '62.989', 'P/L',NULL,NULL,NULL,NULL,8037),
('5', '24301020120032065', 'GUSTIA ARMINDA SIREGAR', '20 Agustus 1999', 'S-2EPIDEMIOLOGI', '3.85', '120', '135', '186', '441', '32.073', '56.4', '33.84', '65.913', 'TMS-1',NULL,NULL,NULL,NULL,8037),
('6', '24301020110007991', 'HURIP NURYANA', '01 September2000', 'S-2 KESEHATANMASYARAKAT', '3.95', '75', '120', '188', '383', '27.854', '52.4', '31.44', '59.294', 'TMS-1',NULL,NULL,NULL,NULL,8037),
('7', '24301020120001323', 'RAFIDA KUSUMA WARDANI', '11 November1998', 'S-2 KESEHATANMASYARAKAT', '3.53', '70', '130', '186', '386', '28.073', '50.2', '30.12', '58.193', 'TMS-1',NULL,NULL,NULL,NULL,8037),
('8', '24301020120036053', 'MEIA AUDINAH, M.P.H', '20 Mei 1994', 'S-2 KESEHATANMASYARAKAT', '3.9', '105', '115', '195', '415', '30.182', '8.2', '4.92', '35.102', 'TMS-1',NULL,NULL,NULL,NULL,8037),
('1', '24301020110018383', 'ARY PRIAMBODO', '21 April 1991', 'S-2 MANAJEMEN', '3.69', '110', '140', '207', '457', '33.236', '69.4', '41.64', '74.876', 'P/L',NULL,NULL,NULL,NULL,8559),
('2', '24301020120001531', 'SITI HANDAYANI MAULIDINA', '12 Juli 1997', 'S-2 MANAJEMEN', '4.0', '85', '120', '196', '401', '29.164', '74.0', '44.4', '73.564', 'P/L',NULL,NULL,NULL,NULL,8559),
('3', '24301020110017662', 'IRFAN HANDOKO', '23 Februari 1994', 'S-2 MANAJEMEN', '3.83', '120', '115', '192', '427', '31.054', '67.2', '40.32', '71.374', 'P/L',NULL,NULL,NULL,NULL,8559),
('4', '24301020120031319', 'DEBORA JUSTICE VALENTINA', '17 Februari 1992', 'S-2 MANAJEMEN', '3.98', '100', '125', '209', '434', '31.564', '64.2', '38.52', '70.084', 'P/L',NULL,NULL,NULL,NULL,8559),
('5', '24301020120030262', 'DIAN ANDRAYANI', '18 Februari 1990', 'S-2 MANAJEMEN', '3.84', '105', '115', '190', '410', '29.818', '67.0', '40.2', '70.018', 'P/L',NULL,NULL,NULL,NULL,8559),
('6', '24301020120020554', 'INTAN SETIA PERTIWI', '17 Januari 1991', 'S-2 MANAJEMEN', '3.71', '65', '145', '189', '399', '29.018', '65.8', '39.48', '68.498', 'TL',NULL,NULL,NULL,NULL,8559),
('7', '24301020120037001', 'AL NISA MIN FADLILLAH', '11 April 1991', 'S-2 MANAJEMEN', '3.42', '85', '115', '198', '398', '28.946', '65.2', '39.12', '68.066', 'TL',NULL,NULL,NULL,NULL,8559),
('8', '24301020120006688', 'ARINI GIRI MARYUJATI', '02 Juni 1998', 'S-2 MANAJEMEN', '3.85', '105', '125', '188', '418', '30.4', '60.4', '36.24', '66.64', 'TL',NULL,NULL,NULL,NULL,8559),
('1', '24301020120034897', 'CAHAYANI YOGASWARI', '26 November1998', 'S-2 ILMUKOMUNIKASI', '3.82', '100', '135', '187', '422', '30.691', '81.4', '48.84', '79.531', 'P/L',NULL,NULL,NULL,NULL,9138),
('2', '24301020120011526', 'DEANDA DEWINDARU', '31 Mei 1995', 'S-2 ILMUKOMUNIKASI', '3.87', '90', '120', '192', '402', '29.236', '73.2', '43.92', '73.156', 'P/L',NULL,NULL,NULL,NULL,9138),
('3', '24301020120002415', 'NUR INAYAH YUSHAR', '26 Oktober 1994', 'S-2 ILMUKOMUNIKASI', '3.93', '85', '140', '200', '425', '30.909', '68.2', '40.92', '71.829', 'P/L',NULL,NULL,NULL,NULL,9138),
('4', '24301020120012964', 'VINA MAHDALENA', '29 Juni 1991', 'S-2 ILMUKOMUNIKASI', '3.8', '95', '125', '177', '397', '28.873', '70.4', '42.24', '71.113', 'P/L',NULL,NULL,NULL,NULL,9138),
('5', '24301020120001902', 'SYFAAMELIA', '22 Oktober 1997', 'S-2 ILMUKOMUNIKASI', '3.8', '80', '85', '199', '364', '26.473', '73.2', '43.92', '70.393', 'P/L',NULL,NULL,NULL,NULL,9138),
('6', '24301020120011392', 'AGNES MONICA MARPAUNG', '12 Juli 1999', 'S-2 ILMUKOMUNIKASI', '3.72', '90', '110', '191', '391', '28.436', '69.4', '41.64', '70.076', 'P/L',NULL,NULL,NULL,NULL,9138),
('7', '24301020120028244', 'ADE INDRIANI SIAGIAN', '08 Oktober 1997', 'S-2 ILMUKOMUNIKASI', '3.88', '100', '145', '182', '427', '31.054', '62.6', '37.56', '68.614', 'P/L',NULL,NULL,NULL,NULL,9138),
('8', '24301020120001338', 'FITRIA HANI APRINA', '22 April 1992', 'S-2 ILMUKOMUNIKASI', '3.96', '85', '105', '181', '371', '26.982', '69.0', '41.4', '68.382', 'P/L',NULL,NULL,NULL,NULL,9138),
('1', '24301020120028903', 'ANDIRI NIZA SYARIFAH', '15 Juni 1993', 'S-2 FARMASI', '3.76', '115', '110', '188', '413', '30.036', '81.2', '48.72', '78.756', 'P/L',NULL,NULL,NULL,NULL,9831),
('2', '24301020110010132', 'KHRISNA PANGERAN', '02 April 1998', 'S-2 ILMUFARMASI', '3.88', '85', '125', '187', '397', '28.873', '79.4', '47.64', '76.513', 'P/L',NULL,NULL,NULL,NULL,9831),
('3', '24301020120021532', 'PRISNU TIRTANIRMALA', '22 September1992', 'S-2 FARMASI', '3.86', '70', '155', '191', '416', '30.254', '72.2', '43.32', '73.574', 'P/L',NULL,NULL,NULL,NULL,9831),
('4', '24301020120007584', 'ARINI NUR YUNIA PUSPITANINGRUMRAHMAWATI', '10 Juni 1999', 'S-2 ILMUFARMASI', '3.96', '100', '145', '168', '413', '30.036', '68.8', '41.28', '71.316', 'P/L',NULL,NULL,NULL,NULL,9831),
('5', '24301020110002267', 'RIFALDI SAPUTRA', '22 Juni 1995', 'S-2 FARMASI', '3.58', '110', '130', '189', '429', '31.2', '64.0', '38.4', '69.6', 'P/L',NULL,NULL,NULL,NULL,9831),
('6', '24301020120037821', 'VARDA ARIANTI', '11 Agustus 1990', 'S-2 FARMASI', '3.48', '85', '130', '181', '396', '28.8', '51.0', '30.6', '59.4', 'TMS-1',NULL,NULL,NULL,NULL,9831),
('7', '24301020120031859', 'NISRIEN ILMIA', '22 Mei 1998', 'S-2 FARMASI', '3.97', '70', '110', '188', '368', '26.764', '53.0', '31.8', '58.564', 'TMS-1',NULL,NULL,NULL,NULL,9831),
('8', '24301020120005047', 'HIBATUL WAFI ATIKAH', '10 Juni 1994', 'S-2 FARMASI', '3.53', '65', '125', '193', '383', '27.854', '50.4', '30.24', '58.094', 'TMS-1',NULL,NULL,NULL,NULL,9831),
('1', '24301020120010840', 'AISYAH ASRI NURRAHMA', '19 Juni 1998', 'S-2 MANAJEMEN', '3.94', '80', '145', '191', '416', '30.254', '72.2', '43.32', '73.574', 'P/L',NULL,NULL,NULL,NULL,10026),
('2', '24301020110021780', 'ARDYAN WICAKSANA', '17 Januari 1995', 'S-2 MANAJEMEN', '3.64', '100', '125', '209', '434', '31.564', '69.8', '41.88', '73.444', 'P/L',NULL,NULL,NULL,NULL,10026),
('3', '24301020120032657', 'DYAH ISYANA LASTRI, ST', '02 Oktober 1990', 'S-2 MANAJEMEN', '3.78', '115', '125', '187', '427', '31.054', '70.0', '42.0', '73.054', 'P/L',NULL,NULL,NULL,NULL,10026),
('4', '24301020120032626', 'DYAJENG PUTERI WORO SUBAGIO', '04 Desember1992', 'S-2 MANAJEMEN', '3.93', '95', '125', '192', '412', '29.964', '68.6', '41.16', '71.124', 'P/L',NULL,NULL,NULL,NULL,10026),
('5', '24301020120005749', 'EKA PUTRI WULANDARI', '30 Agustus 1997', 'S-2 MANAJEMEN', '3.73', '90', '155', '197', '442', '32.146', '63.4', '38.04', '70.186', 'P/L',NULL,NULL,NULL,NULL,10026),
('6', '24301020120013712', 'NOVIA KRISTIANTI', '18 November1995', 'S-2 MANAJEMEN', '3.94', '95', '135', '196', '426', '30.982', '63.2', '37.92', '68.902', 'TL',NULL,NULL,NULL,NULL,10026),
('7', '24301020120005793', 'MUTIARA CLARASATI', '13 Mei 1995', 'S-2 MANAJEMEN', '3.73', '115', '115', '185', '415', '30.182', '61.6', '36.96', '67.142', 'TL',NULL,NULL,NULL,NULL,10026),
('8', '24301020110006586', 'USMAN HADI YULIANTO', '31 Oktober 1997', 'S-2 MANAJEMEN', '3.63', '85', '145', '179', '409', '29.746', '61.4', '36.84', '66.586', 'TL',NULL,NULL,NULL,NULL,10026);

/* 4. Import tables from source PDF with different Python script that successfully extract either `tiu` or `tkp` or both */
WITH cleant AS(     -- Query table with cleaned columns plus extracted columns
    SELECT relative_num, id, 
    (REPLACE(REPLACE(full_name, '\n', ''), '\r', '')) AS full_name, 
    (REPLACE(REPLACE(birthdate, '\n', ''), '\r', '')) AS birthdate, 
    (REPLACE(REPLACE(last_edu, '\n', ''), '\r', '')) AS last_edu,
    gpa, twk, skd, skd40, skb, skb60, final_score, decl_code, 
        SUBSTRING(
            jabatan_formasi, 
            (LOCATE(": ", jabatan_formasi) + 2), 
            ((LENGTH(jabatan_formasi) - ((LOCATE(": ", jabatan_formasi) + 2) + (LOCATE("- ", REVERSE(jabatan_formasi))))))) AS jp_code,
        SUBSTRING(
            jabatan_formasi, 
            (LOCATE("- ", jabatan_formasi) + 2), 
            (LENGTH(jabatan_formasi) - (((LOCATE("- ", jabatan_formasi) + 1) + LOCATE(" ", REVERSE(jabatan_formasi)))))) AS job_position,
        SUBSTRING(
            lokasi_formasi, 
            18, 
            8) AS loc_code, 
        SUBSTRING(
            jenis_formasi, 
            (LOCATE(": ", jenis_formasi) + 2), 
            1) AS type_code,
        SUBSTRING(
            jenis_formasi, 
            (LOCATE("- ", jenis_formasi) + 2), 
            (LENGTH(jenis_formasi) - (LOCATE("- ", jenis_formasi) + 2))) AS type_formation,
        page_number
    FROM attempt1_cleanquery
    WHERE 
        relative_num NOT LIKE "" AND
        relative_num NOT LIKE "(1)" AND
        relative_num NOT LIKE "Omit"
    ORDER BY page_number),
tiutkp AS(          -- Query table with extracted tiu and tkp columns  
    SELECT 
        `7` AS tiu, 
        `8` AS tkp, 
        `1` AS id, 
        `__page__`  
    FROM missing_rows),
no_candidate AS(    -- Query table for open positions with no candidate
    SELECT * 
    FROM cleant
    WHERE relative_num LIKE "No Candidate")

SELECT * FROM cleant lt -- Main query combining all tables
INNER JOIN tiutkp rt
	ON lt.id = rt.id
UNION 
SELECT lt2.relative_num, lt2.id, 
	lt2.full_name, lt2.birthdate, lt2.last_edu, lt2.gpa, 
    lt2.twk, lt2.skd, lt2.skd40, lt2.skb, lt2.skb60, lt2.final_score, 
    lt2.decl_code, lt2.jp_code, lt2.job_position, lt2.loc_code, lt2.type_code, lt2.type_formation, lt2.page_number,
	(rt2.tiu = CASE
		WHEN rt2.tiu LIKE "" THEN NULL
        WHEN rt2.tiu LIKE "TIU" THEN NULL
        WHEN rt2.tiu LIKE "(%" THEN NULL
        ELSE rt2.tiu 
        END) AS tiu,
	(rt2.tkp = CASE
		WHEN rt2.tkp LIKE "" THEN NULL
        WHEN rt2.tkp LIKE "TKP" THEN NULL
        WHEN rt2.tkp LIKE "(%" THEN NULL
        ELSE rt2.tkp 
        END) AS tkp,
	(rt2.id = CASE
		WHEN rt2.id LIKE "No%" THEN NULL
        WHEN rt2.id LIKE "" THEN NULL
        WHEN rt2.id LIKE "(%" THEN NULL
        WHEN rt2.id LIKE "Kode" THEN NULL
        END) AS id, 
	rt2.`__page__`
FROM no_candidate lt2
INNER JOIN tiutkp rt2
	ON lt2.page_number = rt2.`__page__`
ORDER BY page_number
;


UPDATE attempt1_cleanquery
SET birthdate = REPLACE(birthdate, 'Januari', 'January'),
    birthdate = REPLACE(birthdate, 'Februari', 'February'),
    birthdate = REPLACE(birthdate, 'Maret', 'March'),
    birthdate = REPLACE(birthdate, 'Mei', 'May'),
    birthdate = REPLACE(birthdate, 'Juni', 'June'),
    birthdate = REPLACE(birthdate, 'Juli', 'July'),
    birthdate = REPLACE(birthdate, 'Agustus', 'August'),
    birthdate = REPLACE(birthdate, 'Oktober', 'October'),
    birthdate = REPLACE(birthdate, 'Desember', 'December');