-- Data Cleaning Project

USE world_layoffs;

SELECT *
FROM layoffs;

-- 1. Removing duplicates if exists
-- 2. Standardizing the data
-- 3. Reviewing NULL and blank values
-- 4. Removing any columns

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;

-- 1. Removing duplicates
-- 1.2.1. Creating a CTE with new col (row_num) to see any dupl
SELECT *, 
ROW_NUMBER() OVER(
	PARTITION BY 
		company, 
        location, 
        industry, 
        total_laid_off, 
        percentage_laid_off, 
        `date`, 
        stage,
        country,
        funds_raised_millions
        ) AS row_num
FROM layoffs_staging;

WITH duplicate_row AS
(
	SELECT *, 
	ROW_NUMBER() OVER(
		PARTITION BY 
			company, 
			location, 
			industry, 
			total_laid_off, 
			percentage_laid_off, 
			`date`, 
			stage,
			country,
			funds_raised_millions
			) AS row_num
	FROM layoffs_staging
)
SELECT *
FROM duplicate_row
WHERE row_num > 1;

-- 1.2.2. Checking for individual dupl row for double-checking
SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

-- 1.2.3. Creating a new table (layoffs_staging2) that contains the row_num in prev CTE
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT 
	*, 
	ROW_NUMBER() OVER(
		PARTITION BY 
			company, 
			location, 
			industry, 
			total_laid_off, 
			percentage_laid_off, 
			`date`, 
			stage,
			country,
			funds_raised_millions
			) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;

-- 2. Standardizing the data
-- 2.1. Cleaning the industry field
SELECT DISTINCT(industry)
FROM layoffs_staging2
ORDER BY 1; # Checks for any irregular names

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%'; # Found the Crypto has different names

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'; # Updates the irregular names with proper names

-- 2.2. Cleaning the country field
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1; # Found uncommon naming: "United States."

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1; # Trying TRIM(TRAILING ... FROM ...)

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%'; # Trims any trailing dot in country col

-- 2.3 Cleaning the date field
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2; # Trying STR_TO_DATE()

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y'); # Updates the date into uniform format

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE; # Changes the data type of column date

SELECT *
FROM layoffs_staging2;

-- 2.4. Cleaning NULL values
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; # Checks for NULL

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = ''; # Checks for NULL, blanks

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = ''; # Updates blanks with NULL

SELECT t1.company, t1.industry, t2.industry
FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL; # Checks for company where one of the NULL is populated

UPDATE layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL; # Updates the rows where company with NULLs in industry with industry value of the same company

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; # Deletes rows with main interest data is NULL

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; # Checks for the DELETE operation

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- 2.5. Cleaning percentage_laid_off col
ALTER TABLE layoffs_staging2
MODIFY COLUMN percentage_laid_off FLOAT; # Alters the percentage_laid_off from text to float data type