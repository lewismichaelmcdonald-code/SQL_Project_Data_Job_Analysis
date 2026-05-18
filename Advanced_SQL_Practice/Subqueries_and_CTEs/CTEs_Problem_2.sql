/* Explore job postings by listing job id, job titles, company names, and their average salary rates, 
while categorizing these salaries relative to the average in their respective countries. Include the 
month of the job posted date. Use CTEs, conditional logic, and date functions, to compare individual 
salaries with national averages. */

WITH avg_salaries AS (
    SELECT
        job_postings_fact.job_country,
        AVG(job_postings_fact.salary_year_avg) AS avg_salary
    FROM
        job_postings_fact
    GROUP BY
        job_postings_fact.job_country
)

SELECT
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    company_dim.name,
    job_postings_fact.salary_year_avg,
    CASE
        WHEN job_postings_fact.salary_year_avg > avg_salaries.avg_salary THEN 'Above Average'
        ELSE 'Below Average'
    END AS salary_category,
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date) AS posted_month
FROM
    job_postings_fact
INNER JOIN company_dim 
    ON job_postings_fact.company_id = company_dim.company_id
INNER JOIN avg_salaries 
    ON job_postings_fact.job_country = avg_salaries.job_country
ORDER BY
    posted_month DESC;
