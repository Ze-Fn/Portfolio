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
-- 2.1.1. Check for any typos or irregular naming conventions

SELECT DISTINCT(industry)
FROM layoffs_staging2
ORDER BY 1;

-- 2.1.2. Update the ones with diverse naming convention into one name
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';