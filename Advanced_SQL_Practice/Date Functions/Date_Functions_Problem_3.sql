/* Find companies (include company name) that have posted jobs offering health insurance, 
where these postings were made in the second quarter of 2023. Use date extraction to filter 
by quarter. And order by the job postings count from highest to lowest. */

/*Remember when using aggregation functions 
you should group by columns we are NOT aggregating*/

SELECT
    company_dim.name AS company_name,
    COUNT(job_postings_fact.job_id) AS job_postings_count
FROM
    job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_postings_fact.job_health_insurance = TRUE AND
    EXTRACT(quarter FROM job_postings_fact.job_posted_date) = 2
GROUP BY
    company_name
ORDER BY
    job_postings_count DESC;