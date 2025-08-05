-- DATA CLEANING

SELECT COUNT(*)
FROM layoffs;

SELECT *
FROM layoffs;

-- 1.Removing duplicates
-- 2.Standardising the data
-- 3.Working with Null values or Blank values
-- 4.Removing unnecessary rows or coloumns

#I will now create a new table with the same data in it for performing all the operations. if there occurs any error in the operations that i perform there will be the original table as a backup,
CREATE TABLE layoffs_copy
LIKE layoffs;

SELECT *
FROM layoffs_copy;

INSERT layoffs_copy
SELECT *
FROM layoffs;

# I will create a unique id for each row so that i can identify the duplicates easily
SELECT *,
row_number() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_copy;

WITH duplicate_cte AS
(
SELECT *,
row_number() OVER(
PARTITION BY company,industry,total_laid_off,percentage_laid_off,`date`) AS row_num
FROM layoffs_copy
)
SELECT *
FROM duplicate_cte
WHERE row_num>1;

SELECT *
FROM layoffs_copy
WHERE company='oda';

# iam now creating a table that contains the same data as of the layoffs table but with an additional coloumn named as row_num
CREATE TABLE `layoffs_copy2` (
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
FROM layoffs_copy2;

INSERT layoffs_copy2
SELECT *,
row_number() OVER(
PARTITION BY company,industry,total_laid_off,percentage_laid_off,`date`) AS row_num
FROM layoffs_copy;

SELECT *
FROM layoffs_copy2
WHERE row_num>1;

DELETE
FROM layoffs_copy2
WHERE row_num>1;

SELECT *
FROM layoffs_copy2;
#Now the duplicate values are deleted.alter

-- Standardizing data: finding issues in the data and then fixing them.
# There are some white spaces in the company coloumn which i want to remove, so i will use the trim function and remove them
SELECT company, TRIM(company)
FROM layoffs_copy2;

UPDATE layoffs_copy2
SET company=TRIM(company);

SELECT *
FROM layoffs_copy2;

SELECT DISTINCT industry
FROM layoffs_copy2
ORDER BY 1;

SELECT *
FROM layoffs_copy2
WHERE industry LIKE 'crypto%';

UPDATE layoffs_copy2
SET industry='crypto'
WHERE industry LIKE 'crypto%';

SELECT *
FROM layoffs_copy2
WHERE industry='crypto%';

SELECT DISTINCT industry
FROM layoffs_copy2;

#Now i check for each and every coloumn for any inconsistencies
SELECT DISTINCT location
FROM layoffs_copy2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_copy2
ORDER BY 1;
#In the country coloum united states is followed by a fullstop, so i will now remove it by running a query.
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_copy2
ORDER BY 1;

UPDATE layoffs_copy2
SET country=TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'united states%';

#now i convert the date coloumn format
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_copy2;

UPDATE layoffs_copy2
SET `date`=STR_TO_DATE(`date`, '%m/%d/%Y');
#Now i am changing the datatype of date from text to date

ALTER TABLE layoffs_copy2
MODIFY COLUMN `date` DATE;

-- Working with NUll or Blank values
SELECT *
FROM layoffs_copy2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_copy2
SET industry=null
WHERE industry='';

SELECT *
FROM layoffs_copy2
WHERE industry IS NULL
OR industry='';

SELECT *
FROM layoffs_copy2
WHERE company='airbnb';
#iam now updating the blank cell with the non blank cell values

SELECT *
FROM layoffs_copy2 AS t1
JOIN layoffs_copy2 AS t2
    ON t1.company=t2.company
    AND t1.location=t2.location
WHERE t1.industry IS NULL OR t1.industry=''
AND t2.industry IS NOT NULL;

UPDATE layoffs_copy2 AS t1
JOIN layoffs_copy2 AS t2
    ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_copy2;

SELECT *
FROM layoffs_copy2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_copy2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_copy2;
#now that i have standardized the dta i dont need the row_num column anymore, so i will now delete that column.
ALTER TABLE layoffs_copy2
DROP COLUMN row_num;

-- Now the complete data is cleaned