-- Exploratory Data Analysis

# Selects the database
USE world_layoffs;

# Looks at data overview
SELECT * 
FROM layoffs_staging2; 

# Checks whether there is company who laid off everyone
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1; 

# Sees which company has the most laid off
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC; 

# Sees which industry has the most laid off
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC; 

# Sees which country has the most laid off
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC; 

# Sees which year has the most laid off
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC; 

# Sees which company stage has the most laid off
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC; 

# Sees the total laid off by month for every year
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY SUBSTRING(`date`,1,7)
ORDER BY 1 DESC; 

# Sees the rolling total of laid off over the time
WITH monthly_roll_total AS
(SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY SUBSTRING(`date`,1,7)
ORDER BY 1 DESC)
SELECT *, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM monthly_roll_total
; 

# Sees the total laid off by company each year
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 1 ASC; 

# Sees the top 5 companies who laid off the most in every year
WITH most_laid_off_by_company_yearly (company, `years`, total_laid_off) AS
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)), 
company_laid_off_ranking AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY `years` ORDER BY total_laid_off DESC) AS Ranking
FROM most_laid_off_by_company_yearly
WHERE `years` IS NOT NULL)
SELECT * 
FROM company_laid_off_ranking
WHERE Ranking <= 5; 