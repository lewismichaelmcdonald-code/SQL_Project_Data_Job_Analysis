/*Your goal is to calculate two metrics for each company:

The number of unique skills required for their job postings.

The highest average annual salary among job postings that require at least one skill.

Your final query should return the company name, the count of unique skills, 
and the highest salary. For companies with no skill-related job postings, the skill 
count should be 0 and the salary should be null. */

/*CTE 1 Unique Skills for Job Postings, company ID because we want the amount
of unique skills for any job assocaited with that compnay */

WITH required_skills AS (
    SELECT
        job_postings_fact.company_id,
        COUNT(DISTINCT skills_job_dim.skill_id) AS unique_skills_required
    FROM
        job_postings_fact
    LEFT JOIN skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
    GROUP BY
        job_postings_fact.company_id
),

/*CTE 2 Max salary each company is offering*/

max_salary AS (
    SELECT
        job_postings_fact.company_id,
        MAX(job_postings_fact.salary_year_avg) AS highest_average_salary
    FROM
        job_postings_fact
    WHERE
        job_postings_fact.job_id IN (
            SELECT job_id 
            FROM skills_job_dim)
    GROUP BY
        job_postings_fact.company_id
)

SELECT
    company_dim.name,
    required_skills.unique_skills_required as unique_skills_required, --handle companies w/o any skills required
    max_salary.highest_average_salary
FROM
    company_dim
LEFT JOIN required_skills ON company_dim.company_id = required_skills.company_id
LEFT JOIN max_salary ON company_dim.company_id = max_salary.company_id
ORDER BY
    company_dim.name;