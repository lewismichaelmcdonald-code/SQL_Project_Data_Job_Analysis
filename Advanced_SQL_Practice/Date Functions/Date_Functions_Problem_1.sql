/* Find the average salary both yearly (salary_year_avg) and hourly (salary_hour_avg) for job postings using the job_postings_fact table that were posted after June 1, 2023. 
Group the results by job schedule type. Order by the job_schedule_type in ascending order. */

SELECT
    job_Postings_fact.job_schedule_type,
    AVG(job_Postings_fact.salary_year_avg),
    AVG(job_Postings_fact.salary_hour_avg)
FROM
    job_postings_fact
WHERE
    job_Postings_fact.job_posted_date > '2023-06-01'
GROUP BY
    job_postings_fact.job_schedule_type
ORDER BY
    job_Postings_fact.job_schedule_type ASC;