--The timestamp YYYY-MM-DD HH:MM:SS of when a job was posted in UTC

SELECT 
    job_postings_fact.job_posted_date
FROM 
    job_postings_fact;

/*:: Converts one data type to another. We want to remove the timestamp so we use DATE
to convert it to yyyy/mm/dd format */

SELECT 
    job_postings_fact.job_posted_date::DATE AS date_column
FROM 
    job_postings_fact;

-- Converting back to timestamp format
SELECT
    job_postings_fact.job_posted_date:: timestamp
FROM 
    job_postings_fact;

-- UTC to EST timezone

SELECT
    job_postings_fact.job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
FROM
    job_postings_fact;

-- Extracting Month and Year
SELECT
	job_Postings_fact.job_title_short,
	job_Postings_fact.job_location,
	EXTRACT(MONTH FROM job_Postings_fact.job_posted_date) AS job_posted_month,
	EXTRACT(YEAR FROM job_Postings_fact.job_posted_date) AS job_posted_year
FROM
	job_postings_fact;