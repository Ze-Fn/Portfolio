# Alumni Tracer to Determine Suitable Computer Science Learning Materials

> Work is in progress

## Overview
Inspired by a desire to better prepare Junior High School (JHS) students for their future in higher education, this project analyzes alumni data to identify gaps in the current curriculum. By tracing the academic and career paths of Senior High School alumni, it recommends targeted adjustments to JHS Computer Science lesson plans to enhance student readiness for advanced studies and professional opportunities. Using Python and statistical analysis, the study revealed key areas, such as [TBA], that require greater emphasis to align with alumni success in higher education.


## Key Findings
- To ba added

## Tools & Tech
- Python (Pandas, SciPy for stats)
- Jupyter Notebook

## View the Work
- [Full Analysis Notebook](analysis.ipynb)
- [Sample Report](report.pdf)
- [Dataset](data.csv) (anonymized)

![Screenshot of key chart](https://raw.githubusercontent.com/yourusername/Portfolio/main/assets/images/item-analysis-cs.png)

## Workflow (How I did it)
1. Distribute alumni tracer survey
2. Collect enough data
3. Import data to csv for further analysis
4. Familiarize with the data (duplicates, uniques) using `.unique()` and channel it to `.count_values()`
    * Timestamp (OK)
    * Nama Lengkap / Full Name (no duplicate)
    * Jenis Kelamin / Gender (OK)
    * Lulus dari SMP ... / Year graduated (inconsistent)
    * Lanjut ke Sekolah Menengah ... / Continuing to ... High School (minor inconsistent)
    * Jurusan ... / Field of Study (extremely diverse)
    * No null value
5. Replace each data point in "Nama Lengkap" (English: "Full Name") with "Siswa X" where X is a placeholder for number. Pseudonym is used to protect the respondents' privacy.
6. Normalize data in column 'Lulus dari SMP ...' / 'Year graduated'
    * Define mapping dictionary for column 'Lulus dari SMP ...' / 'Year graduated'
7. Normalize data in column 'Lanjut ke Sekolah Menengah ...' / 'Continuing to ... High School'
    * Define mapping dictionary for column 'Lanjut ke Sekolah Menengah ...' / 'Continuing to ... High School'
8. Normalize data in column 'Jurusan ...' / 'Field of Study'
    * Define mapping dictionary for column 'Jurusan ...' / 'Field of Study'
9. Create a new column 'Fakultas' / 'Faculty' to categorize the data in column 'Jurusan ...' / 'Field of Study'
    * Define mapping dictionary for column 'Fakultas' / 'Faculty' based on 'Jurusan ...' / 'Field of Study'
10. Create a new column 'Spesifik Komputer' / 'Computer Specific' to categorize the data in column 'Fakultas' / 'Faculty'
    * Define mapping dictionary for column 'Spesifik Komputer' / 'Computer Specific' based on 'Fakultas' / 'Faculty'
11. Create a bar chart that shows the count of alumni who continued to SMA or SMK
12. Create a bar chart that plots alumni based on col 'Lanjut ke Sekolah Menengah ...' / 'Continuing to ... High School' and col 'Fakultas' / 'Faculty'
13. Create a column chart that plots alumni based on col 'Spesifik Komputer' / 'Computer Specific' which is filtered to only 'Komputer' in the col 'Fakultas' / 'Faculty'