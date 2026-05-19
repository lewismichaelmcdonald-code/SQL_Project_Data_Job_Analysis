/*
**Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data analyst?** 

- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis
*/

WITH skills_in_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM
        skills_dim
    INNER JOIN skills_job_dim
        ON skills_dim.skill_id = skills_job_dim.skill_id
    INNER JOIN job_postings_fact
        ON skills_job_dim.job_id = job_postings_fact.job_id
    WHERE
        job_Postings_fact.job_title_short = 'Data Analyst' AND
        job_Postings_fact.job_work_from_home = TRUE AND
        job_Postings_fact.salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id,
        skills_dim.skills
),

average_salaries AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg),2) AS average_salary
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst' AND
        job_postings_fact.job_work_from_home = TRUE AND
        job_postings_fact.salary_year_avg is NOT NULL
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skills_in_demand.skill_id,
    skills_in_demand.skills,
    skills_in_demand.demand_count,
    average_salaries.average_salary
FROM
    skills_in_demand
INNER JOIN average_salaries
    ON skills_in_demand.skill_id = average_salaries.skill_id
ORDER BY
    skills_in_demand.demand_count DESC,
    average_salaries.average_salary DESC
LIMIT 10;