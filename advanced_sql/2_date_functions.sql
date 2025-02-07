-- Find average salary for yearly and hourly posted after June 1, 2023
-- Group results by job_schedule_type
-- Order by job_schedule_type
SELECT
    job_schedule_type,
    AVG(salary_year_avg) AS avg_yearly_salary,
    AVG(salary_hour_avg) AS avg_hourly_salary
FROM
    job_postings_fact
WHERE job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type
ORDER BY
    job_schedule_type;


-- Count number of job postings for each month in 2023
-- Group and order by month
SELECT
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') as job_month,
    COUNT(*) as job_count
FROM
    job_postings_fact
GROUP BY
    job_month
ORDER BY
    job_month;


-- find companies that posted jobs offering health insurance
-- Include postings made in second quarter of 2023
-- Order by job posting count DESC
SELECT
    companies.name AS company_name,
    COUNT(job_postings.job_id) AS job_count
FROM
    job_postings_fact AS job_postings
    INNER JOIN company_dim AS companies ON job_postings.company_id = companies.company_id
WHERE
    job_postings.job_health_insurance = TRUE 
    AND EXTRACT(QUARTER FROM job_posted_date) = 2
GROUP BY
    companies.name
HAVING
    COUNT(job_postings.job_id) > 0
ORDER BY
    job_count DESC;
