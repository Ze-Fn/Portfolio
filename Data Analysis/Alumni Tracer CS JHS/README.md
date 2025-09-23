# Alumni Tracer to Determine Suitable Computer Science Learning Materials

> Work is in progress

## Overview
Inspired by a desire to better prepare Junior High School (JHS) students for their future in higher education, this project analyzes alumni data to identify gaps in the current curriculum. By tracing the academic and career paths of Senior High School alumni, it recommends targeted adjustments to JHS Computer Science lesson plans to enhance student readiness for advanced studies and professional opportunities. Using Python and statistical analysis, the study revealed key areas, such as [TBA], that require greater emphasis to align with alumni success in higher education.


## Key Findings
- To ba added

## Tools & Tech
- Python (numpy, pandas)
- Jupyter Notebook
- Tableau

## View the Work
- [Full Analysis Notebook](analysis.ipynb)
- [Sample Report](report.pdf)
- [Dataset](data.csv) (anonymized)

![Screenshot of key chart](https://raw.githubusercontent.com/yourusername/Portfolio/main/assets/images/item-analysis-cs.png)

## Workflow (simplified)
1. Distribute survey form
2. Wait for data collection
3. Import to CSV
4. Perform data familiarization
5. Perform data cleaning and data standardization
6. Perform descriptive statistics
7. Create visualization based on descriptive statistics

# About the Survey Form
I collect data from alumni through the help of Google Forms. This allows for minimizing the cost to carry out this research. Inside the survey, I inquiried:
- Full name
- Gender
- Year graduated
- Next education level
- Subject field

some of which have a description on how to fill out the survey. To be specific, below are the inquiry along with their respective description in its raw form (Bahasa Indonesia).
- Nama Lengkap
    - _Data ini hanya akan digunakan untuk menyaring data duplikat_
- Jenis Kelamin
- Lulus dari [SMP] tahun ...
    - _Isikan dengan tahun saja (cth: 2022)_
- Lanjut ke Sekolah Menengah ...
- Jurusan ...
    - __SMA__: IPA/IPS/Bahasa
    - __SMK__: Tulis jurusan tanpa disingkat _(cth: Teknik Ketenagalistrikan, Desain Pemodelan dan Informasi Bangunan, Pengembangan Perangakat Lunak dan Gim)_

I decided to design the survey short to avoid respondents' attrition.

# Reflections
I realized that making the survey questions open-ended will leave the analyst worked up in tidying the data. I suspect the low literacy level of Indonesian students caused this "mess", because I have written the guide as to how to fill out the form and yet they neglect the guide, which resulted in an extremely diverse data point even though the essence of the data is identical. For instance, some respondents sent `tkj` while others sent `TKJ` and some others `Teknik Komputer dan Jaringan`. With this in mind, I think that my __next survvey-based analysis project would benefit from close-ended questions__.