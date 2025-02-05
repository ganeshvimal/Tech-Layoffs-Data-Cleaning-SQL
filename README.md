# Executive Summary: Tech Layoffs Data Cleaning Project

This SQL project focuses on cleaning a dataset of tech layoffs by following several key steps. First, a staging table is created to work with raw data without affecting the original. Duplicates are identified and removed using row numbers to filter out redundant records. Next, the data is standardized by trimming whitespace, consolidating industry names, and correcting inconsistent country and date formats. Null and blank values are handled by updating missing fields, especially in the industry column. Finally, unnecessary rows and columns are removed, and the cleaned data is prepared for further analysis.

## Key Steps

1. **Creation of Staging Table:**
  A staging table (layoffs_staging) was created to hold a raw copy of the data. This served as a backup and ensured that the original dataset remained intact during the cleaning process.

2. **Duplicate Removal:**
 To remove duplicates, a row numbering approach was used based on the combination of columns such as company, industry, total_laid_off, and date. Duplicate rows were identified and removed by filtering out those with row_num > 1.

3. **Standardization of Data:**
- Whitespace Removal: Leading spaces in company names were removed using the TRIM() function.
- Industry Standardization: Industry names related to "cryptocurrency" were unified under the term "Crypto".
- Location and Country Cleanup: Inconsistent country names (e.g., "United States" variations) were standardized, and location inconsistencies were addressed.
- Date Format Conversion: The date column was converted from text to a proper DATE format to facilitate further analysis.

4. **Handling Null and Blank Values:**
- Rows with NULL or blank values in key columns like industry and company were identified.
- Where industry values were missing, they were updated based on matching rows with the same company and location, ensuring data consistency.
- Non-essential rows, where both total_laid_off and percentage_laid_off were NULL, were deleted to improve data integrity.

5. **Column and Row Removal:**
- Columns such as row_num were removed post-cleaning to ensure the final dataset only contained necessary information.
- Any rows with completely missing or irrelevant data were deleted.

## Outcome 
The data was successfully cleaned, with duplicates, formatting issues, and missing values addressed. The dataset is now in a standardized and usable format, ready for further analysis and reporting on the impact of layoffs in the tech industry

## Conclusion
The data cleaning process for the tech layoffs dataset ensured that the information was accurate, consistent, and ready for exploratory data analysis (EDA). By addressing duplicates, standardizing values, and handling missing data, we have improved the dataset’s reliability for insights. This clean dataset can now be used effectively for further EDA, helping stakeholders understand trends and impacts in the tech industry layoffs
