--Creating Table to store job application details
CREATE TABLE job_applied (
  job_id INT, 
  application_sent_date DATE,
	custom_resume BOOLEAN, 
	resume_file_name VARCHAR(255),
	cover_letter_sent BOOLEAN,
	cover_letter_file_name VARCHAR(255), 
  status VARCHAR(50) 
);
--Inserting Data into the job_applied table
INSERT INTO job_applied (job_id, application_sent_date, custom_resume, resume_file_name, cover_letter_sent, cover_letter_file_name, status) 
VALUES
(1, '2024-02-01', TRUE, 'resume_01.pdf', TRUE, 'cover_letter_01.pdf', 'submitted'),
(2, '2024-02-02', FALSE, 'resume_02.pdf', FALSE, NULL, 'interview scheduled'),
(3, '2024-02-03', TRUE, 'resume_03.pdf', TRUE, 'cover_letter_03.pdf', 'ghosted'),
(4, '2024-02-04', TRUE, 'resume_04.pdf', FALSE, NULL, 'submitted'),
(5, '2024-02-05', FALSE, 'resume_05.pdf', TRUE, 'cover_letter_05.pdf', 'rejected');
--Altering the job_applied table to add a new column for contact information
ALTER TABLE job_applied
ADD contact VARCHAR(50);
--Altering the job_applied table to rename the contact column to contact_name
ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;
--Changing the data type of the contact_name column to TEXT
ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;
--Altering the job_applied table to drop the contact_name column
ALTER TABLE job_applied
DROP COLUMN contact_name;
--Back filling the contact_name column with new data
UPDATE job_applied SET contact = 'Erlich Bachman' WHERE job_id = 1;
UPDATE job_applied SET contact = 'Dinesh Chugtai' WHERE job_id = 2;
UPDATE job_applied SET contact = 'Bertram Gilfoyle' WHERE job_id = 3;
UPDATE job_applied SET contact = 'Jian Yang' WHERE job_id = 4;
UPDATE job_applied SET contact = 'Big Head' WHERE job_id = 5;

SELECT *
FROM job_applied;

--Deleting the job_applied table
DROP TABLE job_applied;