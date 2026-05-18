/* Count the number of unique companies that offer work from home (WFH) versus those requiring work to be on-site. 
Use the job_postings_fact table to count and compare the distinct companies based on their WFH policy 
(job_work_from_home).*/


--REMEMBER to write CASE before doing a CASE expression (obviously)
--INNER JOIN because we want only matching data
SELECT
    CASE
        WHEN job_postings_fact.job_work_from_home = TRUE THEN 'Remote'
        WHEN job_postings_fact.job_work_from_home = FALSE THEN 'Not Remote'
        WHEN job_postings_fact.job_work_from_home IS NULL THEN 'No Info'
        END AS WFH_Policy,
    COUNT(DISTINCT company_dim.name)
FROM
    job_postings_fact
    INNER JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
GROUP BY
    WFH_Policy;
