# Analyzing Test Result from _Seleksi Kompetensi Dasar_ (SKD) _Calon Pegawai Negeri Sipil_ (CPNS) 2024

# Overview
This __personal analysis project__ was driven by my frustration on failing to pass the SKD CPNS 2024. This frustration then fueled me to plan and prepare strategically for the upcoming (who-knows-when) CPNS. Descriptive statistics analysis result highlights the profile of competitors specifically in the `Master of Education -  English Language Education` (or _S-2 Pendidikan Bahasa Inggris_) field as well as the volume of open position in target institutions. With this in mind, it is recommended to plan ahead based on the selection of target `Institution` and `Formation`.

# Contextual Insight
In Indonesia, the *Calon Pegawai Negeri Sipil* (CPNS) is a competitive national recruitment process to select candidates for civil service positions in government institutions. The *Seleksi Kompetensi Dasar* (SKD), or Basic Competency Test, is a critical stage of the CPNS, assessing candidates' general knowledge, cognitive abilities, and personality traits through three sections: *Tes Wawasan Kebangsaan* (TWK, civic knowledge), *Tes Intelegensia Umum* (TIU, general intelligence), and *Tes Karakteristik Pribadi* (TKP, personality test). Passing the SKD is essential to advance to further stages of the CPNS selection. This analysis focuses on the 2024 SKD results for candidates with a Master’s degree in English Language Education (*S-2 Pendidikan Bahasa Inggris*), examining their performance and institutional preferences to inform strategic preparation for future CPNS exams.
 

# Tools and Tech
- Google Sheets

# Research Questions
1. Which institution has the most popularity among test takers who are _S-2 Pendidikan Bahasa Inggris_?
2. Which institution has the lowest popularity among test takers who are _S-2 Pendidikan Bahasa Inggris_?
3. Which insitution in Java-Bali has the most popularity among test takers who are _S-2 Pendidikan Bahasa Inggris_?
4. Which institution in Java-Bali has the lowest popularity among test takers who are _S-2 Pendidikan Bahasa Inggris_?
5. Which work unit in Java-Bali has the most popularity among test takers who are _S-2 Pendidikan Bahasa Inggris_?
6. Which work unit in Java-Bali has the lowest popularity among test takers who are _S-2 Pendidikan Bahasa Inggris_?
7. What is the distribution of `Nilai Total` (translated to "Total Score") of test takers who are _S-2 Pendidikan Bahasa Inggris_?
8. What is the Interquartile Range (IQR) of each test sections (TWK, TIU, TKP)?
9. What is the cognitive characteristics of the test takers who are _S-2 Pendidikan Bahasa Inggris_?

# Dataset
The dataset that I used was retreived from a Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi (Kemendikbudristek) 2024. To clear up the confusion, This Ministry has been split into three ministries as of the new President of Indonesia's declaration. The current equivalent Ministry of the previous Ministry is `Kementerian Pendidikan Tinggi, Sains, dan Teknologi` (_Kemendiktisaintek_).
You can also access the dataset from [here](https://casn.kemendikdasmen.go.id/preview?filename=Hasil%20Seleksi%20Kompetensi%20Dasar%20(SKD)%20Seleksi%20Penerimaan%20CPNS%20Kemdikbudristek%20TA%202024.pdf).

# Data Preparation
Have you seen the amount of pages of the dataset?
Yes, it is overwhelmingly __LARGE__ and I am not jesting. Therefore, I only imported the data that I am interested in the most. that is:
- Any data FROM [this database](https://casn.kemendikdasmen.go.id/preview?filename=Hasil%20Seleksi%20Kompetensi%20Dasar%20(SKD)%20Seleksi%20Penerimaan%20CPNS%20Kemdikbudristek%20TA%202024.pdf) WHERE `Pendidikan` = `S-2 PENDIDIKAN BAHASA INGGRIS`

# View the Work
- [Spreadsheet](https://docs.google.com/spreadsheets/d/1Yy4KkE7pjKiazO2ILaYWPw8ebPEwsRf-jbq9rItFk_s/edit?usp=sharing)

# Workflow
1. Download the dataset (sadly, the dataset is in PDF format).
2. Use the `search` function to query `S-2 Pendidikan Bahasa Inggris`.
3. Copy the tables in the corresponding query result.
4. Paste the tables into the spreadsheet.
5. Repeat step 3 and 4 until all interesting data are extracted from the dataset (PDF).
6. Delete col `No` and `No Peserta` from the dataset.
7. Create pivot tables from the `Dataset` sheet.
8. Create chart from each pivot tables.
9. Add title, subtitle, axis names.
10. Perform descriptive statistical analysis to find IQR.
11. Gather and tidy up all charts in one sheet (`Dashboard`).