-- Create table called data_science_job
-- Include job_id, job title, company_name, and post_date
CREATE TABLE data_science_jobs (
    job_id INT PRIMARY KEY,
    job_title TEXT,
    company_name TEXT,
    post_date DATE
);

-- Insert job postings into table
INSERT INTO data_science_jobs (job_id, job_title, company_name, post_date)
VALUES 
    (1, 'Data Scientist', 'Tech Innovations', '2023-01-01'),
    (2, 'Machine Learning Engineer', 'Data Driven Co', '2023-01-15'),
    (3, 'AI Specialist', 'Future Tech', '2023-02-01');

-- Alter table to add new boolean column called remote
ALTER TABLE data_science_jobs
ADD COLUMN remote BOOLEAN;

-- Rename 'post_date' column to 'posted_on'
ALTER TABLE data_science_jobs
RENAME COLUMN post_date TO posted_on;

-- modify 'remote' column to have default FALSE
ALTER TABLE data_science_jobs
ALTER COLUMN remote SET DEFAULT FALSE;

-- Drop company_name column from table
ALTER TABLE data_science_jobs
DROP COLUMN company_name;

-- Update job_posting with 'job_id' = 2. Update remote column for job posting to TRUE
UPDATE data_science_jobs
SET remote = TRUE
WHERE job_id = 2;

-- Drop data_science_job table
DROP TABLE data_science_jobs;
