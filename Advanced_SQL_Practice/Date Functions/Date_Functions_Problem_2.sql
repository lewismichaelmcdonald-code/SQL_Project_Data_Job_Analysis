/* Count the number of job postings for each month, adjusting the
job_posted_date to be in 'America/New_York' time zone before extracting the month. Assume the job_posted_date is stored in UTC. 
Group by and order by the month. */

SELECT
    COUNT(*),
    job_postings_fact.job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST',
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date) AS month
FROM
    job_postings_fact
GROUP BY
    month
ORDER BY
    month;

/* Failed attempt, because we are grouping by month but the second select statement cant be grouped because SQL doesnt know how to group the dates 
so we need to wrap extract around it*/

SELECT
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') AS month,
    COUNT(*)
FROM
    job_postings_fact
GROUP BY
    month
ORDER BY
    month;