/* Problem Statement
Your goal is to find the names of companies that have an average salary greater than the overall average salary across all job postings.

You'll need to use two tables: company_dim (for company names) and job_postings_fact (for salary data). The solution requires using subqueries.

Hint
Think of it as needing three pieces of information:

The average salary for each company.

The single overall average salary across all jobs.

The names of the companies.

You'll build this query from the inside out.

Part 1️⃣ (Inner Subquery): Overall Average.

Goal: Get the single, overall average salary from all job postings.

Action: Write a subquery: SELECT AVG(salary_year_avg) FROM job_postings_fact.

Use: This will go inside your WHERE clause at the very end for comparison.

Part 2️⃣ (Subquery for JOIN): Average Salary Per Company.

Goal: Get the average salary for each company.

Action: Write a subquery that selects company_id and calculates AVG(salary_year_avg). You must GROUP BY company_id here.

Use: This subquery will be treated like a temporary table that you JOIN to company_dim.

Part 3️⃣ (Main Query): Putting It All Together.

Goal: Select company names and filter them based on the averages you calculated.

Action:

Start with SELECT name FROM company_dim.

JOIN your subquery from Part 2 to the company_dim table using company_id. This connects company names to their specific average salaries.

Use a WHERE clause to filter the results, keeping only rows where the company's average salary (from your Part 2 subquery) is greater than the overall average salary (your Part 1 subquery).
*/

SELECT
    company_name
FROM (
--Average Salary Per Company Table
    SELECT
        company_dim.name AS company_name,
        AVG(job_postings_fact.salary_year_avg) AS average_salary
    FROM
        job_postings_fact
    INNER JOIN company_dim
        ON company_dim.company_id = job_postings_fact.company_id
    GROUP BY
        company_name
) AS company_salary

WHERE average_salary > (
    SELECT
        AVG(job_postings_fact.salary_year_avg)
    FROM
        job_postings_fact
) ;
