/* 
Import and clean missing column loc_details
*/

CREATE TABLE `loc_details` AS
WITH rmv_noise AS(
	SELECT 
		(CASE 
			WHEN loc_code LIKE "Lokasi%" 
				THEN SUBSTRING(loc_code, (LOCATE(": ", loc_code) + 2), 8)
			ELSE loc_code END) AS loc_code,
		(CASE
			WHEN string1 LIKE "__KEMENTERIAN PENDIDIKAN KEBUDAYAAN RISET DAN TEKNOLOGI"
				THEN NULL
			WHEN string1 LIKE "KEMENTERIAN PENDIDIKAN KEBUDAYAAN RISET DAN TEKNOLOGI"
				THEN NULL
			WHEN string1 LIKE "___KEMENTERIAN PENDIDIKAN KEBUDAYAAN RISET DAN TEKNOLOGI"
				THEN NULL
			ELSE string1 END) AS string1,
            string2,
            string3,
        (CASE
			WHEN string4 LIKE "%TINGGI NEGE%"
				THEN SUBSTRING(string4, 1, (LOCATE(" KEMEN", string4)))
                ELSE string4 END) AS string4,
		(CASE
			WHEN string5 LIKE "%TINGGI NEGE%"
				THEN SUBSTRING(string5, 1, (LOCATE(" KEMEN", string4)))
                ELSE string5 END) AS string5,
		string6
--         (CASE 
-- 			WHEN string1 LIKE "KEMENTERIAN%" THEN NULL
--             WHEN string1 LIKE "% KEMEN%" 
-- 				THEN SUBSTRING(string1, 1, (LOCATE(" KEMEN%", string1)))
--             ELSE string1 END) AS string1
	FROM add_nulls_extd_loc_details1
),

no_politeknik AS(
	SELECT 
		loc_code, string1, string2, string3, string4, string5, string6,
		(CASE
			WHEN string1 LIKE "%Univer%" OR string1 LIKE "%Institut%" OR string1 LIKE "%Politeknik%" OR string1 LIKE "%Akademi%" THEN string1 
			WHEN string2 LIKE "%Univer%" OR string2 LIKE "%Institut%" OR string2 LIKE "%Politeknik%" OR string2 LIKE "%Akademi%" OR string2 LIKE "%Sekretariat Jend%" OR string2 LIKE "%Direktorat Jend%" OR string2 LIKE "%Badan%" OR string2 LIKE "%INSPEK%" THEN string2
			WHEN string3 LIKE "%Univer%" OR string3 LIKE "%Institut%" OR string3 LIKE "%Politeknik%" OR string3 LIKE "%Akademi%"  OR string3 LIKE "Univer%"THEN string3
			WHEN string4 LIKE "%Univer%" OR string4 LIKE "%Institut%" OR string4 LIKE "%Politeknik%" OR string4 LIKE "%Akademi%" THEN string4
			WHEN string5 LIKE "%Univer%" OR string5 LIKE "%Institut%" OR string5 LIKE "%Politeknik%" OR string5 LIKE "%Akademi%" THEN string5
			WHEN string6 LIKE "%Univer%" OR string6 LIKE "%Institut%" OR string6 LIKE "%Politeknik%" OR string6 LIKE "%Akademi%" THEN string6
			ELSE NULL END) AS institution,
		(CASE
			WHEN string1 LIKE "Fakult%" THEN string1
			WHEN string2 LIKE "Fakult%" OR string2 LIKE "%PUSAT%" THEN string2
			WHEN string3 LIKE "Fakult%" THEN string3
			WHEN string4 LIKE "Fakult%"  OR string4 LIKE "%Pasca%" THEN string4
			WHEN string5 LIKE "Fakult%" THEN string5
			WHEN string6 LIKE "Fakult%" THEN string6
			ELSE NULL END) AS faculty,
		(CASE
			WHEN string1 LIKE "Jurusan%" OR string1 LIKE "%S1%" OR string1 LIKE "%S2%" OR string1 LIKE "%S3%" OR string1 LIKE "%S-1%" OR string1 LIKE "%S-2%"  OR string1 LIKE "%S-3%" OR string1 LIKE "%D4%" OR string1 LIKE "%D3%" OR string1 LIKE "%Biro%"
				THEN string1
			WHEN string2 LIKE "Jurusan%" OR string2 LIKE "%S1%" OR string2 LIKE "%S2%" OR string2 LIKE "%S3%" OR string2 LIKE "%S-1%" OR string2 LIKE "%S-2%"  OR string2 LIKE "%S-3%" OR string2 LIKE "%D4%" OR string2 LIKE "%D3%" OR string2 LIKE "%Biro%" OR string2 LIKE "%Bagian%"
				THEN string2
			WHEN string3 LIKE "Jurusan%" OR string3 LIKE "%S1%" OR string3 LIKE "%S2%" OR string3 LIKE "%S3%" OR string3 LIKE "%S-1%" OR string3 LIKE "%S-2%"  OR string3 LIKE "%S-3%" OR string3 LIKE "%D4%" OR string3 LIKE "%D3%" OR string3 LIKE "%Biro%"
				THEN string3
			WHEN string4 LIKE "Jurusan%" OR string4 LIKE "%S1%" OR string4 LIKE "%S2%" OR string4 LIKE "%S3%" OR string4 LIKE "%S-1%" OR string4 LIKE "%S-2%"  OR string4 LIKE "%S-3%" OR string4 LIKE "%D4%" OR string4 LIKE "%D3%" OR string4 LIKE "%Biro%" OR string4 LIKE "%Profesi%" 
				THEN string4
			WHEN string5 LIKE "Jurusan%" OR string5 LIKE "%S1%" OR string5 LIKE "%S2%" OR string5 LIKE "%S3%" OR string5 LIKE "%S-1%" OR string5 LIKE "%S-2%"  OR string5 LIKE "%S-3%" OR string5 LIKE "%D4%" OR string5 LIKE "%D3%" OR string5 LIKE "%Biro%"
				THEN string5
			WHEN string6 LIKE "Jurusan%" OR string6 LIKE "%S1%" OR string6 LIKE "%S2%" OR string6 LIKE "%S3%" OR string6 LIKE "%S-1%" OR string6 LIKE "%S-2%"  OR string6 LIKE "%S-3%" OR string6 LIKE "%D4%" OR string6 LIKE "%D3%" OR string6 LIKE "%Biro%"
				THEN string6
			ELSE NULL END) AS dept
	FROM rmv_noise
	WHERE 
		string1 NOT LIKE "Politeknik%" AND 
		string2 NOT LIKE "Politeknik%" AND 
		string3 NOT LIKE "Politeknik%" AND 
		string4 NOT LIKE "Politeknik%" AND 
		string5 NOT LIKE "Politeknik%" AND 
		string6 NOT LIKE "Politeknik%"
),

politek AS(
	SELECT loc_code, string1, string2, string3, string4, string5, string6,
		(CASE
			WHEN string1 LIKE "%Politeknik%" THEN String1
			WHEN string2 LIKE "%Politeknik%" THEN String2
			WHEN string3 LIKE "%Politeknik%" THEN String3
			WHEN string4 LIKE "%Politeknik%" THEN String4
			WHEN string5 LIKE "%Politeknik%" THEN String5
			WHEN string6 LIKE "%Politeknik%" THEN String6
			ELSE NULL END) AS institution,
		(CASE 
			WHEN string1 LIKE "%Jurusan%" THEN string1
			WHEN string2 LIKE "%Jurusan%" THEN string2
			WHEN string3 LIKE "%Jurusan%" THEN string3
			WHEN string4 LIKE "%Jurusan%" OR string4 LIKE "Bagian%" OR string4 LIKE "Pusat%" THEN string4
			WHEN string5 LIKE "%Jurusan%" THEN string5
			WHEN string6 LIKE "%Jurusan%" THEN string6
			ELSE NULL END) AS faculty,
		(CASE 
			WHEN string1 LIKE "%D4%" THEN String1
			WHEN string2 LIKE "%D4%" OR string2 LIKE "%Studi%" OR string2 LIKE "%S1%" THEN string2
			WHEN string4 LIKE "%Unit%" OR string4 LIKE "%UPT%" OR string4 LIKE "%UPA%" THEN string4
			WHEN string5 LIKE "%D2%" OR string5 LIKE "%D3%" OR string5 LIKE "%D4%" OR string5 LIKE "%S1%" OR string5 LIKE "%S2%" OR string5 LIKE "%D-%" OR string5 LIKE "%Studi%" OR string5 LIKE "%D1%" OR string5 LIKE "%Subbagian%" THEN String5
			ELSE NULL END) AS dept
	FROM rmv_noise
	WHERE
		string1 LIKE "Politeknik%" OR 
		string2 LIKE "Politeknik%" OR 
		string3 LIKE "Politeknik%" OR 
		string4 LIKE "Politeknik%" OR 
		string5 LIKE "Politeknik%" OR 
		string6 LIKE "Politeknik%"
),

union_all AS(
	SELECT 
		loc_code, 
		(CASE
			WHEN institution LIKE "UNIVERSITAS LAMBUNG%" THEN "Universitas Lambung Mangkurat"
			WHEN institution LIKE "Universitas Pembangunan%" THEN "Universitas Pembangunan 'Veteran' [truncated]"
			WHEN institution LIKE "Institut Seni Indonesia Padang%" THEN "Institut Seni Indonesia Padang"
			WHEN institution LIKE "Institut Seni Budaya Indonesia%" THEN "Institut Seni Budaya Indonesia"
			WHEN institution LIKE "%Universitas Pattimura" THEN "Universitas Pattimura"
			WHEN institution LIKE "%Universitas Negeri Manado" THEN "Universitas Manado"
			WHEN institution LIKE "Universitas Sultan Ageng%" THEN "Universitas Sultan Ageng"
			WHEN institution LIKE "Politeknik Pertanian Negeri Teknologi Produksi Pertanian" THEN "Politeknik Pertanian Negeri [truncated]"
			WHEN institution LIKE "Politeknik Pertanian Negeri Teknologi Pertanian" THEN "Politeknik Pertanian Negeri [truncated]"
			WHEN institution LIKE "%Produksi Pertanian" THEN "Politeknik Pertanian Negeri [truncated]"
			WHEN institution LIKE "Politeknik Pertanian Negeri Produksi Pertanian" THEN "Politeknik Pertanian Negeri [truncated]"
			WHEN institution LIKE "%Kemaritiman" THEN "Politeknik Pertanian Negeri [truncated]"
            WHEN institution LIKE "%Universitas Jenderal Soe%" THEN "Universitas Jenderal Soedirman"
			ELSE institution END) AS institution, 
		faculty, 
        (CASE 
			WHEN dept LIKE "Universitas Sembilanbelas Prodi S1 Agribisnis Fakultas Pertanian Perikanan dan Peternakan" THEN "S1 Agribisnis"
            WHEN dept LIKE "Universitas Sembilanbelas Prodi S1 Agroteknologi Fakultas Pertanian Perikanan dan Peternakan" THEN "S1 Agroteknologi"
            WHEN dept LIKE "Universitas Sembilanbelas Prodi S1 Teknologi Hasil Pertanian Fakultas Pertanian Perikanan dan Peternakan" THEN "S1 Teknologi Hasil Pertanian"
            ELSE dept END) AS dept
	FROM no_politeknik
	UNION
	SELECT loc_code, institution, faculty, dept
	FROM politek
),
    
dept_fix1 AS(
	SELECT 
		lt.loc_code, 
		(CASE 
			WHEN rt.string1 = 'Nasional "Veteran"" Yogyakarta"' THEN 'Universitas Pembangunan Nasional "Veteran" Yogyakarta'
			WHEN rt.string1 = 'Nasional "Veteran"" Jakarta"' THEN 'Universitas Pembangunan Nasional "Veteran" Jakarta'
			WHEN rt.string1 = 'Nasional "Veteran"" Jawa Timur"' THEN 'Universitas Pembangunan Nasional "Veteran" Jawa Timur'
			WHEN rt.string1 = 'Jurusan S1 Pendidikan Luar Biasa Fakultas Ilmu Pendidikan dan Psikologi Universitas Negeri 3 KEMENTERIAN PENDIDIKAN KEBUDAYAAN RISET DAN TEKNOLOGI' THEN 'Universitas Negeri Manado'
			WHEN rt.string1 = "Universitas Sembilanbelas%" THEN 'Universitas Sembilanbelas November Kolaka'
			WHEN rt.string1 = '%Singaperbangsa%' THEN "Universitas SIngaperbangsa"
			ELSE lt.institution END) AS fix_institution,
		lt.faculty, 
		(CASE 
			WHEN rt.string3 LIKE "%S1%" THEN rt.string3
			WHEN rt.string3 LIKE "%S2%" THEN rt.string3
			WHEN rt.string3 LIKE "%S3%" THEN rt.string3
			WHEN rt.string3 LIKE "%D3%" THEN rt.string3
			WHEN rt.string3 LIKE "%D4%" THEN rt.string3
			WHEN rt.string3 LIKE "%D-%" THEN rt.string3
			WHEN rt.string3 LIKE "%Profesi Dokter%" THEN rt.string3
			WHEN rt.string3 LIKE "%Sp_%" THEN rt.string3
			WHEN rt.string4 LIKE "%S1%" THEN rt.string4
			WHEN rt.string4 LIKE "%D-%" THEN rt.string4
			WHEN rt.string4 LIKE "%S-%" THEN rt.string4
			WHEN rt.string4 LIKE "%S2%" THEN rt.string4
			WHEN rt.string4 LIKE "%D4%" THEN rt.string4
			WHEN rt.string4 LIKE "%D3%" THEN rt.string4
			WHEN rt.string4 LIKE "%Profesi Dokter%" THEN rt.string4
			WHEN rt.string6 LIKE "%S1%" THEN rt.string6
			WHEN rt.string6 LIKE "%S2%" THEN rt.string6
			WHEN rt.string6 LIKE "%S3%" THEN rt.string6
			WHEN rt.string6 LIKE "%S-%" THEN rt.string6
			WHEN rt.string6 LIKE "%D-%" THEN rt.string6
			ELSE lt.dept END) AS fix_dept,
			rt.loc_code AS loc_codert, rt.string1, rt.string2, rt.string3, rt.string4, rt.string5, rt.string6
	FROM union_all AS lt
	JOIN no_politeknik AS rt
		ON lt.loc_code = rt.loc_code
	ORDER BY fix_institution, lt.faculty, lt.dept
),

uniq_uni AS(
	SELECT loc_code, fix_institution, faculty, fix_dept, COUNT(loc_code)
	FROM dept_fix1
	GROUP BY loc_code, fix_institution, faculty, fix_dept
)

SELECT loc_code AS lc_code, fix_institution AS inst, faculty, fix_dept AS dept
FROM uniq_uni
UNION
SELECT loc_code, institution, faculty, dept
FROM politek
ORDER BY inst, faculty;