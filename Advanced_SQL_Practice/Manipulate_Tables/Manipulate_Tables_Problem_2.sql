--Insert three job postings into the data_science_jobs table. Make sure each job posting has a unique job_id, a job_title, a company_name, and a post_date.
INSERT INTO data_science_jobs (job_id,job_title,company_name,post_date) VALUES
(1,'Data Analyst','Data Company','2026-06-20'),
(2,'Amazon Walker','Amazon','2026-05-05'),
(3,'Icecream Scooper','Cafe','2026-03-02');
--In SQL Date is in YYYY-MM-DD format and also has to be in quotation marks
SELECT *
FROM data_science_jobs