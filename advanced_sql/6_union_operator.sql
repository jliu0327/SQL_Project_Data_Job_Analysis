-- Create unified query that categorizes job postings into two groups: those with salary information and those w/o it
(SELECT 
    job_id, 
    job_title, 
    'With Salary Info' AS salary_info 
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL  
)
UNION ALL

(
    SELECT 
        job_id, 
        job_title, 
        'Without Salary Info' AS salary_info 
    FROM 
        job_postings_fact
    WHERE 
        salary_year_avg IS NULL AND salary_hour_avg IS NULL 
)
ORDER BY 
	salary_info DESC, 
	job_id; 


-- retrieve following columns for each job posting from first quarter
-- Use subquery to combine job postings from first quarter
SELECT
    job_postings_q1.job_id,
    job_postings_q1.job_title_short,
    job_postings_q1.job_location,
    job_postings_q1.job_via,
    job_postings_q1.salary_year_avg,
    skills_dim.skills,
    skills_dim.type
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
	UNION ALL
	SELECT *
	FROM march_jobs
) AS job_postings_q1
LEFT JOIN skills_job_dim ON job_postings_q1.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_q1.salary_year_avg > 70000
ORDER BY
	job_postings_q1.job_id;


-- Monthly demand for skills
-- Count number of job postings per skill in first quarter
WITH combined_job_postings AS (
    SELECT job_id, job_posted_date
    FROM january_jobs
    UNION ALL
    SELECT job_id, job_posted_date
    FROM february_jobs
    UNION ALL
    SELECT job_id, job_posted_date
    FROM march_jobs
),
-- CTE for calculating monthly skill demand based on the combined postings
monthly_skill_demand AS (
    SELECT
        skills_dim.skills,  
        EXTRACT(YEAR FROM combined_job_postings.job_posted_date) AS job_year,  
        EXTRACT(MONTH FROM combined_job_postings.job_posted_date) AS job_month,  
        COUNT(combined_job_postings.job_id) AS postings_count 
    FROM
        combined_job_postings
	INNER JOIN skills_job_dim ON combined_job_postings.job_id = skills_job_dim.job_id  
	INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id  
    GROUP BY
        skills_dim.skills, job_year, job_month
)

SELECT
    skills,  
    job_year,  
    job_month,  
    postings_count 
FROM
    monthly_skill_demand
ORDER BY
    skills, job_year, job_month;