-- WORLD LAYOFF DATASET 
-- DATA CLEANING PROJECT

SELECT * 
FROM layoffs;

-- Step 1
-- Remove duplicates - To remove duplicate, assign a unique number to each row If that isn't present
SELECT *,
Row_Number() OVER (PARTITION BY
Company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
FROM layoffs_stagging;

WITH Duplicates_CTE AS
(SELECT *,
Row_Number() OVER (PARTITION BY
Company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
FROM layoffs_stagging)
SELECT * 
FROM Duplicates_CTE
WHERE row_num > 1;

-- A copy of the original table was created so as to maintain the original dataset and 
conduct the data cleaning process on the copy of the document. The copy of the dataset is 
called layoffs_stagging2. An additional row titled row_num was added to the copy of the dataset that was made
CREATE TABLE `layoffs_stagging2` (
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

-- To transfer the data in the original document to the new one, the below steps was used
INSERT INTO layoffs_stagging2
SELECT *,
ROW_NUMBER() OVER (PARTITION BY
Company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
FROM layoffs_stagging;

-- Finding rows that are duplicates i.e the unique number in the new column created(row_num) is meant to be 1. Other numbers represents the duplicates
SELECT * FROM layoffs_stagging2
WHERE row_num >1;

-- Delete the duplicates
DELETE
FROM layoffs_stagging2
WHERE row_num > 1;

-- To check if duplicates have been successfully removed, 
SELECT * FROM layoffs_stagging2;


-- Step 2 - Standardising the data(means to ensure the data in each column is well arranged)
-- First of all, have a view of the data in column to spot errors using the DISTINCT operator. Do these for all columns to ensure your data are propoerly standardised. For instance,
SELECT DISTINCT company
FROM layoffs_stagging2;
-- Followed by the use of the TRIM operator. The TRIM operator takes out unncessary spaces between words
SELECT company, TRIM(company)
FROM layoffs_stagging2;
-- Followed by the UPDATE operator to ensure the table is updated the new information
UPDATE layoffs_stagging2
SET company = TRIM(company);

SELECT industry, TRIM(industry)
FROM layoffs_stagging2;
-- Here, the data in the industry column had different spellings for each industry type. You can ensure this is corrected by
UPDATE layoffs_stagging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_stagging2
SET industry = TRIM(industry);

SELECT location, TRIM(location)
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET location = TRIM(location);

-- Here, the spelling of the country was corrected as well
UPDATE layoffs_stagging2
SET country = 'United States'
WHERE country LIKE 'United State%';

SELECT country, TRIM(country)
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET country = TRIM(country);

-- To format the date column
SELECT date,
str_to_date(date, '%m/%d/%Y')
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET date = str_to_date(date, '%m/%d/%Y');

-- Step 3 Null/blank values
-- To view null rows,
SELECT *
FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

--  Step 4 Remove unnecessary rows or columns
DELETE 
FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Final step
-- To have a final view of the current dataset after the cleaning process is complete,
SELECT *
FROM layoffs_stagging2;


-- To drop a column
ALTER TABLE layoffs_stagging2
DROP row_num;

SELECT * FROM layoffs_stagging2;

-- NOTE:  To take out unnecessary columns or rows while maintaining a copy of the original dataset, I would be making a copy of the original dataset. 
-- Doing this would ensure that we can successfully remove the row or columns that aren't needed at this stage without affecting the original file
CREATE TABLE layoffs_stagging
LIKE layoffs;
-- To view the created table
SELECT * 
FROM layoffs_stagging;



