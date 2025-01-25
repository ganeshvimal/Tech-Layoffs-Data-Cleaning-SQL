-- Data Cleaning Project 
-- https://www.kaggle.com/datasets/swaptr/layoffs-2022

use tech_layoffs;
select * from layoffs;

-- Data cleaning we usually follow a few steps - 
-- 1. Check for duplicates and remove any
-- 2. Standardize the data and fix errors
-- 3. Look at null values and blank values
-- 4. Remove any columns and rows that are not necessary


-- First thing we want to do is create a staging table. This is the one we will work in and clean the data. 
-- We want a table with the raw data as it is in case something happens
-- In real world we shouldnt work with raw data table always good to make staging table
-- using like here to copy all the raw data from layoffs table to layoffs staging table
CREATE TABLE layoffs_staging 
LIKE layoffs;
select * from layoffs_staging;
-- inserting value 
INSERT layoffs_staging 
SELECT * FROM layoffs;

-- 1. Remove Duplicates

# First let's check for duplicates

-- If no id is given then we can use row no and match it against all the columns 
-- doing row number partition by all of the columns essentially. we could just do a few for now
select *, 
row_number() over(PARTITION BY company, industry, total_laid_off, percentage_laid_off , `date`) as row_num
from layoffs_staging;

# we get row no most of them 1 so its unique but there will be duplicates( ie 2 or above)
-- we can make cte 

WITH duplicate_cte as
(
select *, 
row_number() over(PARTITION BY company,location, industry, total_laid_off, percentage_laid_off , `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging 
)

select * from duplicate_cte where row_num >1;
-- neeed to get rid of these now

select * from layoffs_staging where company = 'casper';

delete from duplicate_cte where row_num >1;
# makes it super easy to remove but not able to do it 

-- take and put in staging 2 table then we can delete it. we can filter on row_num and delete which is equal to 2
-- so need to create another table that has the extra row (row_num INT) and then deleting where that row is equal to 2 

CREATE TABLE `layoffs_staging2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int,
`row_num` INT
);

select * from layoffs_staging2;

-- Now table is created staging 2 
-- now need to insert info of above into this. so now we can see extra column row_num
INSERT INTO layoffs_staging2
select *, 
row_number() over(PARTITION BY company,location, industry, total_laid_off, percentage_laid_off , `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;

-- now filter
select * from layoffs_staging2 where row_num >1;
delete from layoffs_staging2 where row_num >1;
select * from layoffs_staging2;
-- so now we have succesfully deleted all the duplicates 
-- at last now we can delete the extra column which is row_num from staging 2 table

-- 2. Standardizing Data (finding issues in data and fixing it)

-- There is some space in front of company name lets trim that and remove it
select DISTINCT(company)
from  layoffs_staging2;
-- the code for it below
select distinct(trim(company))
from  layoffs_staging2;

select company, trim(company)
from  layoffs_staging2;

-- updating it
UPDATE layoffs_staging2
SET company = trim(company);

-- looking at industry 
select distinct industry 
from layoffs_staging2
order by 1;

select *
from layoffs_staging2 where industry like 'Crypto%'
;
-- updating everything to only crypto from cryptocurrency
UPDATE layoffs_staging2
SET industry = 'Crypto'
where industry like 'Crypto%';

-- looking at location
select distinct location
from layoffs_staging2
order by 1;

-- looking at country
select distinct country
from layoffs_staging2
order by 1;

-- fixing 1 row where it has united states. bcz of which there were 2 us under country
select * from layoffs_staging2 where country like 'United States%';
UPDATE layoffs_staging2
SET country = 'United States'
where country like 'United States%';


-- date ( need to convert from text to date format) 
-- important to follow below format
select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

-- now updating old date column to new date format
UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y')

ALTER TABLE layoffs_staging2
MODIFY column `date` DATE;

SELECT * 
from layoffs_staging2;

-- 3. Looking at null values or blank values

select * from layoffs_staging2 where total_laid_off is null
and percentage_laid_off is null;

select * from layoffs_staging2
where industry is null or industry = '';

-- lets look at these companies for null values
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'airbnb%';

SELECT *
FROM layoffs_staging2
WHERE company = 'Carvana';

SELECT *
FROM layoffs_staging2
WHERE company = 'Juul';

-- write a query that if there is another row with the same company name, it will update it to the non-null industry values
-- makes it easy so if there were thousands we wouldn't have to manually check them all

-- first update blank to null
update layoffs_staging2
set industry = null where industry = '';

-- NEED TO DO JOIN ON SELECT STATEMENT. Then we can change it to update if it works
select * from layoffs_staging2 t1
join layoffs_staging2 t2 
	on t1.company = t2.company
    and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

-- it worked now lets write UPDATE STATEMENT

UPDATE layoffs_staging2 t1 
join layoffs_staging2 t2 
	on t1.company = t2.company
    and t1.location = t2.location
SET t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

-- now all the company which didnt have industry is populated but only 1 company Ballys interactive which has only 1 row is still null 
-- unlike other companies which had multiple entries

select * from layoffs_staging2;
-- we cannot populate total laid off and percentage laid off because we dont have a total people column before laid off
-- if we had total people column then we can populate 

-- 4. remove any columns and rows we need to
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
and percentage_laid_off IS NULL;

-- Delete these data 
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2;

-- now removing row_num column
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * 
FROM layoffs_staging2;

