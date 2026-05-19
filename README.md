# Data Analyst Job Market Analysis

An exploratory SQL project analysing the data analyst job market, with a focus on identifying top-paying roles, in-demand skills, and the most strategically valuable skills to develop for career growth.

## Background

This project was developed to better understand the data analyst job market, looking at which roles offer the highest salaries, which skills employers value most, and how to identify skills that offer both strong demand and strong pay.

The analysis draws on **Luke Barousse's Data Jobs dataset**, which aggregates real-world job postings with structured information on job titles, locations, salaries, and required skills.

The core questions driving this analysis were:

1. What are the top-paying data analyst jobs?
2. What skills are required for those top-paying roles?
3. What are the most in-demand skills for data analysts?
4. Which skills are associated with the highest average salaries?
5. What are the most optimal skills to learn, balancing high demand with high pay?


## Tools Used

| Tool | Purpose |
|------|---------|
| **SQL** | Core analysis language for querying, filtering, joining, and aggregating job posting data |
| **PostgreSQL** | Database management system used to store and query the dataset |
| **VS Code** | Primary development environment for writing and running SQL queries |
| **Git & GitHub** | Version control and project hosting |


## Analysis

Each SQL file addresses one of the five research questions.

### 1. Top-Paying Data Analyst Jobs (`1_top_paying_jobs.sql`)

Identifies the 10 highest-paying Data Analyst roles available remotely or in London, filtering to only postings with a specified salary.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_work_from_home,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    (job_location = 'Anywhere' OR job_location LIKE '%London%') AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

**Key finding:** The highest paying role in the dataset was a Data Analyst position at $650,000/year, followed by a Director of Analytics at $336,500. All 10 results were remote ("Anywhere") and full-time, suggesting that the top end of the market is concentrated in remote-first roles.


### 2. Skills Required for Top-Paying Jobs (`2_top_paying_jobs_skills.sql`)

Extends the previous query using a CTE to join skill data onto the top 10 highest-paying roles, revealing which specific skills those jobs require.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        job_location,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        (job_location = 'Anywhere' OR job_location LIKE '%London%') AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills_dim.skills
FROM
    top_paying_jobs
LEFT JOIN skills_job_dim
    ON top_paying_jobs.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    top_paying_jobs.salary_year_avg DESC;
```

**Key finding:** The AT&T Associate Director role ($255,829) required the broadest skill set, including SQL, Python, R, Azure, Databricks, AWS, Pandas, PySpark, Jupyter, Excel, Tableau, Power BI, and PowerPoint. Python and SQL appeared across multiple top-paying companies including AT&T and Pinterest, pointing to them as the most consistent requirements at the higher salary bands.


### 3. Most In-Demand Skills (`3_skills_in_demand.sql`)

Counts the frequency of each skill across all Data Analyst job postings to identify which skills appear most often in the market.

```sql
SELECT
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    skills_dim
INNER JOIN skills_job_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
INNER JOIN job_postings_fact
    ON skills_job_dim.job_id = job_postings_fact.job_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills_dim.skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

**Key finding:** SQL was by far the most requested skill with 92,628 mentions, nearly 40% more than Excel in second place (67,031). Python followed at 57,326, then Tableau at 46,554 and Power BI at 39,468. The gap between SQL and everything else underlines how foundational it remains across the industry.


### 4. Top-Paying Skills (`4_top_paying_skills.sql`)

Calculates the average salary associated with each skill across all Data Analyst roles that have a specified salary, regardless of location.

```sql
SELECT
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg),2) AS avg_salary
FROM
    skills_dim
INNER JOIN skills_job_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
INNER JOIN job_postings_fact
    ON skills_job_dim.job_id = job_postings_fact.job_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
ORDER BY
    avg_salary DESC;
```

**Key finding:** SVN topped the list at $400,000 average salary, though this likely reflects a small number of high-paying outliers rather than consistent demand. More notably, skills like Solidity ($179,000), Couchbase ($160,515), and DataRobot ($155,485) all outpaced mainstream tools, reinforcing that specialist and emerging technology skills carry a significant salary premium even when they are less commonly listed.


### 5. Most Optimal Skills to Learn (`5_most_optimal_skills.sql`)

Combines demand count and average salary into a single query using two CTEs to identify skills that offer both job security and strong compensation, targeting remote roles with specified salaries.

```sql
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
```

**Key finding:** SQL came out on top with 398 job postings and an average salary of $97,237. Python (236 postings, $101,397) and Tableau (230 postings, $99,287) offered strong demand alongside salaries above $99,000. Looker stood out as a higher-salary option at $103,795 despite lower demand (49 postings), making it worth considering for those already confident in the core tools.


## What I Learned

Working through this project reinforced and developed several key SQL competencies:

- **CTEs (Common Table Expressions):** Used extensively in queries 2 and 5 to structure multi-step logic cleanly and readably, rather than nesting subqueries.
- **Aggregation and grouping:** Applied `COUNT()` and `AVG()` with `GROUP BY` to summarise skill demand and salary data at scale.
- **Multi-table joins:** Navigated a relational schema involving job postings, companies, skills, and join tables, requiring careful use of `LEFT JOIN` and `INNER JOIN` depending on whether null results were acceptable.
- **Filtering for data quality:** Consistently applied `salary_year_avg IS NOT NULL` to ensure salary-based analyses were not skewed by incomplete records.
- **Combining metrics strategically:** Query 5 in particular required thinking about how to balance two dimensions (demand and salary) to produce actionable, rather than merely descriptive, insights.


## Conclusions

This analysis surfaces several clear takeaways for anyone looking to enter or advance within data analytics:

1. **SQL is non-negotiable.** It appears as the most demanded skill and is consistently present in top-paying roles.
2. **Python significantly expands earning potential.** Roles requiring Python tend to sit at the higher end of the salary range.
3. **Visualisation tools are highly valued.** Tableau and Power BI appear frequently across both high-demand and high-salary listings.
4. **Specialised skills command premium salaries.** Niche tools and cloud-based technologies are associated with the highest average pay, even with lower overall demand, making them worth developing once core skills are established.
5. **Remote roles offer strong earning potential.** Filtering for remote-eligible positions (including London) still surfaces competitive salaries, suggesting location flexibility does not come at a pay penalty.

The most practical path for a data analyst looking to maximise both employability and earning potential is to build strong foundations in SQL and Python, develop proficiency in at least one visualisation tool, and progressively layer in cloud or specialisation skills over time.
