/* Identify companies with the most diverse (unique) job titles. 
Use a CTE to count the number of unique job titles per company, then select companies with the highest diversity in job titles. */

WITH unique_titles AS (
    SELECT
        company_dim.name AS company,
        COUNT(DISTINCT job_postings_fact.job_title) AS no_unique_jobs
    FROM
        job_postings_fact
    INNER JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    GROUP BY
        company_dim.name
)

SELECT
    company,
    no_unique_jobs
FROM
    unique_titles
ORDER BY
    no_unique_jobs DESC;
