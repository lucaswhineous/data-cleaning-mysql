-- Data Cleaning

USE world_layoffs;

SELECT * 
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null values or blank values
-- 4. Remove any columns that are irrelevant


/* Create an another table ,so you don't work 
with your raw data 
as long as you have your raw data, you can make whatarever you need
*/

CREATE TABLE layoffs_staging 
like layoffs;

INSERT layoffs_staging
SELECT * FROM layoffs;


-- 1. Remove Duplicates

SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company,location,industry, total_laid_off, 
percentage_laid_off, 'data', stage, country, funds_raised_millions) 
AS row_num FROM layoffs_staging;

/* KNOW THE DUPLICATES */

WITH duplicate_cte AS (
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company,location,industry, total_laid_off, 
percentage_laid_off, 'data', stage, country, funds_raised_millions) 
AS row_num FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

/* get one coluns and confirm, if really a duplicate */

SELECT * FROM layoffs_staging
where company = 'ExtraHop'
;

/* Now we are going to create an another table
and insert our row_num, and delete the duplicates*/

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
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company,location,industry, total_laid_off, 
percentage_laid_off, 'data', stage, country, funds_raised_millions) 
AS row_num FROM layoffs_staging;


DELETE FROM layoffs_staging2
WHERE row_num > 1;

SELECT * FROM layoffs_staging2
WHERE row_num > 1;

SELECT * FROM layoffs_staging2;











