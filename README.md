# Introduction
Jumping into the job market for Data Science! Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics

SQL queries? Check them out here: [project_sql folder](/project_sql/)
# Background
This project was created to better understand the data analyst job market by identifying the highest-paying and most in-demand skills, making it easier for others to find optimal job opportunities.

### The questions I wanted to answer through my queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
To tackle these questions, I sought out these key tools:

- **SQL**: The primary language for accessing and manipulating the database
- **PostgreSQL**: The database management system used to handle the job posting data
- **Visual Studio Code**: Database platform for carrying out SQL queries
- **Github**: Sharing and uploading my SQL scripts, ensuring collaboration

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the fields with the highest pay opportunities.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
```

Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** The top 10 paying data analyst roles range from $184,000 to $650,000, suggesting opportunities for salary growth
- **Diverse Employers:** Wide range of companies that are offering job opportunities for those interested in data analytics, ranging from Meta to AT&T to Pinterest.

![Top Paying Roles](assets\1_top_paying_jobs.png)

*Bar graph visualizing the salary for the top 10 salaries for data analysts; ChatGPT generated this from my results*

### 2. Skills for Top Paying Jobs
To understnad what skills are needed for the top paying jobs, I joined the job postings with the skills data. This query highlights what skills employers look for when hiring candidates.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```

Here's the breakdown of the top skills required for data analyst positions in 2023:

- **High-Paying Skills & Roles:** SQL, Python, R, and cloud computing (AWS, Snowflake, Databricks) are essential for top-paying data roles, with senior positions exceeding $200K. Data visualization (Tableau, Power BI) is also highly valued.
- **Remote & Industry Trends:** Senior roles (Director, Principal Analyst) offer more remote/hybrid flexibility, especially in tech, telecom, and healthcare, which are investing heavily in data analytics.
- **Salary & Specialization:** Higher salaries correlate with expertise in big data, DevOps (Bitbucket, Jenkins), and cloud platforms, while lower-paid roles require fewer specialized skills.

![Top Skills in Top-Paying Jobs](assets\2_top_paying_job_skills.png)

*Bar graph visualizing the most common skills with the highest pays in Data Analyst Jobs*

### 3. Most In-Demand Skills for Data Analysts
This query helped identify the most desired skills in job postings.

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```

Here's the breakdown of the most in-demand skills for data analysts:

- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundation in data management
- Prograaming and Visualization tools, like **Python**, **Tableau**, and **Power BI** are also crucial in data analyst roles.

| Skills   | Demand Count |
|----------|-------------|
| SQL      | 7,291       |
| Excel    | 4,611       |
| Python   | 4,330       |
| Tableau  | 3,745       |
| Power BI | 2,609       |


*Table of the top 5 skills in demand for data analyst job postings*

### 4. Top Skills Based on Salary
I explored the top skills that paid the most by joining tables from the job_posting along with the skills and jobs table.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25
```

Here's the breakdown of the top skills and its association to the salary:
- AI, ML, and Big Data skills pay well – Tools like **DataRobot**, **PyTorch**, **TensorFlow**, and **Cassandra** are highly valued.
- Cloud & DevOps expertise is lucrative – **Terraform**, **VMware**, **Kafka**, and **Airflow** highlight demand for scalable infrastructure.
- Niche and legacy skills can be goldmines – **Solidity (blockchain)** and **SVN (version control)** offer exceptionally high salaries.

| Skills     | Avg Salary |
|-----------|-----------|
| SVN       | 400,000   |
| Solidity  | 179,000   |
| Couchbase | 160,515   |
| DataRobot | 155,486   |
| Golang    | 155,000   |
| MXNet     | 149,000   |
| dplyr     | 147,633   |
| VMware    | 147,500   |
| Terraform | 146,734   |
| Twilio    | 138,500   |

*Table of the top skills with high pay in data analyst job postings*

### 5. Most Optimal Skills to Learn
After combining insights from skills that pay the most, this query aimed to identify skills that are high in demand and have high salaries.

```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
),

average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = TRUE
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

Here's a breakdown of the most optimal skills that also pay the most:

- Top Skills: **Python**, **R**, **SQL**, and **Tableau** are essential for data analysts, covering programming, data manipulation, and visualization.

- Emerging Tools: **Snowflake**, **AWS**, and **Azure** are valuable for cloud-based data processing and storage, offering high salaries and growing demand.

- Big Data & Processing: Skills in **Hadoop**, **Spark**, and **BigQuery** are important for analysts working with large datasets or in big data environments.

# What I Learned
Throughout my time with SQL, I learned how to:

- work with multiple tables, merging them together with the JOIN clause and using them with subqueries and CTEs.
- I got better with data aggregation, using GROUP BY, COUNT(), and AVG() when manipulating my data.
- I was able to gain some valuable insight into the job market for data analysts.

# Conclusions

This project enhanced my SQL skills and provided insight into what I should focus on when trying to land my next job as a Data Analyst. The findings from my analysis serve as a guide to what I need to prioritize and continue focusing on to improve my skills as an aspiring Data Analyst. Since the field of Data Analytics is not decreasing anytime soon, it is better to start as soon as I can to land a job in the future soon.