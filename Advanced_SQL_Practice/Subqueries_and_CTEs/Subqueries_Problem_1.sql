/* Identify the top 5 skills that are most frequently mentioned in job postings. Use a subquery to find the skill IDs with the 
highest counts in the skills_job_dim table and then join this result with the skills_dim table to get the skill names.*/

--Main Query
SELECT
    skills_dim.skills
FROM
    skills_dim
INNER JOIN (
--Subquery
    SELECT
        skills_job_dim.skill_id,
        COUNT(skills_job_dim.job_id) AS skill_count
    FROM
        skills_job_dim
    GROUP BY
        skills_job_dim.skill_id
    ORDER BY
        skill_count DESC
    LIMIT 5
) AS top_skills ON skills_dim.skill_id = top_skills.skill_id
ORDER BY
    top_skills.skill_count DESC;