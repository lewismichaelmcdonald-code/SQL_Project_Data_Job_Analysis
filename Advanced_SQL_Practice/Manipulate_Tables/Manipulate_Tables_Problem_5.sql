--Modify the remote column so that it defaults to FALSE in the data_science_job table.

ALTER TABLE data_science_jobs
ALTER COLUMN remote SET DEFAULT FALSE;

/*The rows already there wont be affected by this change, thats what the update command is for.
Adding a new row of data will be affected. Didnt add data to remote column so it
will default to FALSE*/

INSERT INTO data_science_jobs (job_id,job_title,company_name,posted_on)
VALUES
(4,'Data Man','Data Guy','2026-05-09');

SELECT *
FROM data_science_jobs;