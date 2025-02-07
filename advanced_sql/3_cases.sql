-- Categorize salaries from job postings that are data analyst jobs and have yearly salary information
-- Order in DESC
SELECT
    job_id,
    job_title,
    salary_year_avg,
    CASE
        WHEN salary_year_avg > 100000 THEN 'High Salary'
        WHEN salary_year_avg BETWEEN 60000 AND 99999 THEN 'Standard Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
    AND job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC;


-- Count number of unique companies that offer WFH vs On-Site
SELECT
    COUNT(DISTINCT CASE WHEN job_work_from_home = TRUE THEN company_id END) AS wfh_companies,
    COUNT(DISTINCT CASE WHEN job_work_from_home = FALSE THEN company_id END) AS on_site_companies
FROM
    job_postings_fact;


-- case when experience level and remote option
SELECT 
    job_id,
    salary_year_avg,
    CASE
        WHEN job_title ILIKE '%Senior%' THEN 'Senior'
        WHEN job_title ILIKE '%Manager%' OR job_title ILIKE '%Lead%' THEN 'Lead/Manager'
        WHEN job_title ILIKE '%Junior%' OR job_title ILIKE '%Entry%' THEN 'Junior/Entry'
        ELSE 'Not Specified'
    END AS experience_level,
    CASE
        WHEN job_work_from_home THEN 'Yes'
        ELSE 'No' 
    END AS remote_option
FROM 
  job_postings_fact
WHERE 
  salary_year_avg IS NOT NULL 
ORDER BY 
  job_id;