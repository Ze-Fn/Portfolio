# 📊 Project Overview
## 🧾 Summary
* __Source file:__ [Pengumuman Hasil Akhir Seleksi (Kelulusan) Pasca UD2 CPNS 2024 - Lampiran I](https://casn.kemendikdasmen.go.id/s3/unduh?bn=renada2024&fn=Pengumuman%20Hasil%20Akhir%20Seleksi%20(Kelulusan)%20Pasca%20UD2%20CPNS%202024_Lampiran%20I.pdf)

* __Technologies:__


| Technology       | Primary Use                                                 | Status           |
|------------------|-------------------------------------------------------------|------------------|
| Python           | Data extraction, cleaning, analysis, scripting              | ⏳ Pending       |
| Google Sheets    | Analysis and dashboard from MySQL data aggregation          | 🟡 In Progress   |
| Microsoft Excel  | Analysis and dashboard from MySQL data aggregation          | 🟡 In Progress   |
| MySQL            | Data storage, transformation, SQL analytics                 | 🟢 Done          |
| Jupyter Notebook | Exploratory data analysis and prototyping                   | ⏳ Pending       |
| Tableau          | Data visualization and dashboarding                         | ⏳ Pending       |
| Power BI         | Business intelligence reporting                             | ⏳ Pending       |

> **CURRENT PROGRESS:** Univariate data analysis using `Python` in `Jupyter Notebook` and perhaps `Google Colab` as well.

* __Results:__
_TBA_

* __Implications:__
_TBA_

---

## 🧩 1. Introduction
### 1.1 Backgrounds
_TBA_

### 1.2 Research Questions
1. 

---
## 🔬 2. Methodology
In this section, I present the full elaboration of the data that I dealt with. From the fetching process to the visualization outcome.

### 2.1 Data Characteristics
The test result data is published in a **PDF file** format with more than 16000 pages. Each open job position is separated by a **header** in the next page unless the test takers data for that job position exceed the page capacity to contain the data. The **overflowed data is continued** to the next page without any header. All of the important data are structured in a **table format** but not the headers. There is, however, a **table header for each job position** that encompasses job position code, job position name, location code, location detail, formation type (general, disability, etc.), and education qualification requirements. Below the table header is the **test takers table** boasting number of test taker relative to the job position, test takers' id, full name, birth date, last education qualification, test scores (TWK, TIU, TKP, SKD, SKD (40%), SKB, SKB (60%), total score, and declaration). Pages with no test takers have this data empty.

### 2.1 Data Collection
I downloaded the data officially from The Ministry of Education and Culture (now, The Ministry of Primary and Secondary Education) in the format of PDF. The link to the PDF file can be publicly accessed from this [link.](https://casn.kemendikdasmen.go.id/s3/unduh?bn=renada2024&fn=Pengumuman%20Hasil%20Akhir%20Seleksi%20(Kelulusan)%20Pasca%20UD2%20CPNS%202024_Lampiran%20I.pdf) 

### 2.2 Data Cleaning
1. Convert PDF to CSV using a Python script [extract_tables_pdfplumber3.py](https://github.com/Ze-Fn/Portfolio/blob/main/Data/Hasil%20CPNS%202024%20Kemendikbud/extract_tables_pdfplumber3.py)
2. Import to MySQL Workbench through `Table Data Import Wizard ...`.
3. Familiarize with the dataset.

> There are several issues with the imported data.
> 1. Inconventional column names
> 2. Open positions with no candidate are not defined
> 3. Unimported rows from source table
> 4. Missing important column: `tiu`, `tkp`

4. Rename all column to a more appropriate name.
5. Define open positions with no candidate based on COUNT(page_number).
6. Import rows from source PDF with different Python script that successfully extract the missing rows.
    * Extract the PDF file using a different script ([extract_missing_rows.py](https://github.com/Ze-Fn/Portfolio/blob/main/Data/Hasil%20CPNS%202024%20Kemendikbud/extract_missing_rows.py)).
    * Save to CSV ([extracted_missing_rows.csv](https://github.com/Ze-Fn/Portfolio/blob/main/Data/Hasil%20CPNS%202024%20Kemendikbud/extract_missing_rows.py)).
    * Clean the CSV using bash script ([omit_newlines1.sh](https://github.com/Ze-Fn/Portfolio/blob/main/Data/Hasil%20CPNS%202024%20Kemendikbud/omit_newlines1.sh)) to eliminate inline `\n` in [missing_rows.csv](https://raw.githubusercontent.com/Ze-Fn/Portfolio/refs/heads/main/Data/Hasil%20CPNS%202024%20Kemendikbud/missing_rows.csv) _(which can cause massive mess in the import process)_ and replaces it with a blank spaces `" "`.
7. Import the [missing_rows.csv](https://raw.githubusercontent.com/Ze-Fn/Portfolio/refs/heads/main/Data/Hasil%20CPNS%202024%20Kemendikbud/missing_rows.csv) to MySQL database under different table name.
8. Extract the PDF once more to extract all data in a text format rather than table using [extract_string.py](https://github.com/Ze-Fn/Portfolio/blob/main/Data/Hasil%20CPNS%202024%20Kemendikbud/extract_string.py). This is to extract the entire textual content of the PDF, aiming to extract the location details of each `loc_code`.
9. The result of [extract_string.py](https://github.com/Ze-Fn/Portfolio/blob/main/Data/Hasil%20CPNS%202024%20Kemendikbud/extract_string.py) can be found in [extracted_loc_details.csv](https://raw.githubusercontent.com/Ze-Fn/Portfolio/refs/heads/main/Data/Hasil%20CPNS%202024%20Kemendikbud/extracted_loc_details.csv), to which it is then cleaned using [extracted_loc_detailv1.py](https://github.com/Ze-Fn/Portfolio/blob/main/Data/Hasil%20CPNS%202024%20Kemendikbud/extract_loc_detailv1.py) and resulted in a cleaned [extracted_loc_details1.csv](https://raw.githubusercontent.com/Ze-Fn/Portfolio/refs/heads/main/Data/Hasil%20CPNS%202024%20Kemendikbud/extracted_loc_details1.csv).
10. Replace all unnecessary symbols like `|`, `..`, etc. in the [extracted_loc_details1.csv](https://raw.githubusercontent.com/Ze-Fn/Portfolio/refs/heads/main/Data/Hasil%20CPNS%202024%20Kemendikbud/extracted_loc_details1.csv) file using VS Code `Find & Replace`, as well as adding columns at line[1] of the csv.
11. Add `Null` to the rows with values less than the number of available columns in the modified [extracted_loc_details1.csv](https://raw.githubusercontent.com/Ze-Fn/Portfolio/refs/heads/main/Data/Hasil%20CPNS%202024%20Kemendikbud/extracted_loc_details1.csv) file using [add_null.py](https://github.com/Ze-Fn/Portfolio/blob/main/Data/Hasil%20CPNS%202024%20Kemendikbud/add_null.py).
12. Import the resulting CSV file ([add_nulls_extd_loc_details1.csv](https://raw.githubusercontent.com/Ze-Fn/Portfolio/refs/heads/main/Data/Hasil%20CPNS%202024%20Kemendikbud/add_nulls_extd_loc_details1.csv)) from step 11 to MySQL for further data cleaning (see [loc_details.sql](https://github.com/Ze-Fn/Portfolio/blob/main/Data/Hasil%20CPNS%202024%20Kemendikbud/loc_details.sql)).

>The [**cleaned script**](https://github.com/Ze-Fn/Portfolio/blob/main/Data/Hasil%20CPNS%202024%20Kemendikbud/attempt1_cleanquery.sql).
>
>The [**dirty script**](https://github.com/Ze-Fn/Portfolio/blob/main/Data/Hasil%20CPNS%202024%20Kemendikbud/MySQL/cleaning2_hasil_cpns2024_kemendikbud.sql), on the other hand, needs **no** further **adjustments**, but the script is **very ugly** that I don't recommend running it to query the data (you have been warned :D). It contains my learning journey that materializes my theoretical comprehension of SQL language.

Hereafter, I am using the cleaned version as my main data source.

### 2.3 Data Analysis
1. Univariate data analysis:
    * Measure of Central Tendency
    * Measure of Dispersion
    * Frequency Distribution

    > Available in [SQL script](https://github.com/Ze-Fn/Portfolio/blob/main/Data/Hasil%20CPNS%202024%20Kemendikbud/univariate_analysis.sql), more to come ...

2. Bivariate data analysis.
    * Pearson Correlation
        * `birthdate` vs `total_score`
        * _TBA_
    * TBA
