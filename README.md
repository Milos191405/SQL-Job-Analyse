# Introduction 

📊 Welcome to my first SQL project, where I explore the dynamic world of the data job market with a special emphasis on data analysis roles.

The dataset encompasses over 700,000 job postings from around the globe in 2023.


## The questions that I wanted to answer through my queries:

## 1. **Analyzing Number of Jobs and Percentage of Home Office and Jobs Not Requiring a Degree**
   - Analyze the number of job postings and percentage of remote work.
   - Determine the percentage of jobs not requiring a degree.

   

```sql
   SELECT 
    COALESCE(CAST(job_work_from_home AS TEXT), 'False') AS job_work_from_home,
    COUNT(job_id) AS number_of_jobs,
    ROUND(100.0 * COUNT(job_id) / (SELECT COUNT(*) FROM job_postings_fact ), 2) AS percentage
FROM 
    job_postings_fact
WHERE
    job_work_from_home IS NOT NULL 
GROUP BY 
    job_work_from_home

UNION ALL

SELECT 
    'TOTAL',
    COUNT(job_id),
    100.00
FROM 
    job_postings_fact;
    
```   
## Work From Home Job Distribution
### Data Table

| Work From Home | Number of Jobs | Percentage |
|---------------|--------------|------------|
| No (false)   | 718,080      | 91.16%     |
| Yes (true)   | 69,606       | 8.84%      |
| **Total**    | **787,686**  | **100%**   |

![Work From Home Pie Chart](assets\work_from_home_pie_chart.png)
 *Pie chart visualizing the work-from-home job distribution*

*The majority (91.16%) of jobs do not offer work-from-home options.
 Only 8.84% of jobs allow remote work, indicating a smaller proportion of remote opportunities.*

 ## Jobs Without Degree Requirement

```sql
SELECT 
    COALESCE(CAST(job_no_degree_mention AS TEXT), 'False') AS job_no_degree_mention,
    COUNT(job_id) AS number_of_jobs,
    ROUND(100.0 * COUNT(job_id) / (SELECT COUNT(*) FROM job_postings_fact ), 2) AS percentage
FROM 
    job_postings_fact
WHERE
    job_no_degree_mention IS NOT NULL
GROUP BY 
    job_no_degree_mention

UNION ALL

SELECT 
    'TOTAL',
    COUNT(job_id),
    100.00
FROM 
    job_postings_fact;
```



## Data Table

| No Degree Required | Number of Jobs | Percentage |
|-------------------|--------------|------------|
| No (false)       | 546,329      | 69.36%     |
| Yes (true)       | 241,357      | 30.64%     |
| **Total**        | **787,686**  | **100%**   |





![No Degree Pie Chart](assets\no_degree_pie_chart.png)
P*ie chart visualizing the jobs that do not require a degree:*

*69.36% of jobs require a degree.
30.64% of jobs do not require a degree, showing a significant number of opportunities available without higher education.*


## 2. **Top-Paying Jobs and Skills for Those Jobs**
   - Identify the highest-paying jobs in data analytics.
   - Determine the skills most sought after for these positions.

```sql
SELECT
    job_postings_fact.job_title_short,
    job_postings_fact.salary_year_avg,
    skills_dim.skills
FROM
    job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.salary_year_avg IS NOT NULL 
    AND skills_dim.skills IS NOT NULL
GROUP BY
    job_postings_fact.job_title_short,
    job_postings_fact.salary_year_avg,
    skills_dim.skills
ORDER BY
    job_postings_fact.salary_year_avg DESC
LIMIT 20;
```
## Data Table
   | Job Title            | Average Salary ($) | Most Sought-After Skills          |
|----------------------|---------------------|------------------------------------|
| Data Scientist       | 960,000            | C++, Java, Python, R              |
| Senior Data Scientist| 890,000            | Azure, C#, Databricks, Docker, Git, GitHub, GitLab, Hadoop, Java, Jupyter, Keras, Kubernetes |



![Top paying jobs skills](assets\most_sought_after_skills.png)

*Data Scientist positions have the highest average salary of $960,000, reflecting the demand for professionals skilled in advanced programming languages like C++, Java, Python, and R.
Senior Data Scientist roles follow with an average salary of $890,000, requiring a broader skillset including Azure, C#, Databricks, Docker, Git, GitHub, GitLab, Hadoop, Java, Jupyter, Keras, and Kubernetes.*

## 3. **Most In-Demand Skills and Search Trends**
   - Identify the trending skills based on job postings.
   - Highlight the most frequently searched skills.

```sql
SELECT
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS number_of_jobs
FROM
    job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    skills_dim.skills IS NOT NULL
GROUP BY
    skills_dim.skills
ORDER BY
    number_of_jobs DESC
LIMIT 10;
```

| Skills    | Number of Jobs |
|-----------|----------------|
| SQL       | 385,750        |
| Python    | 381,863        |
| AWS       | 145,718        |
| Azure     | 132,851        |
| Linux     | 131,285        |
| Tableau   | 127,500        |
| Excel     | 127,341        |
| Spark     | 114,928        |
| Power BI  | 98,363         |
| Java      | 85,854         |


![Top paying jobs skills](assets\number_of_jobs_by_skill.png)

*Bar graph visualizing the most popular skills for Data Analyst*

## 4. **Job Sources**
   - Analyze the `job_via` data to find out where people are finding job postings.

```sql
SELECT
    job_via,
    COUNT(job_via) AS number_of_jobs
FROM
    job_postings_fact
GROUP BY
    job_via
ORDER BY
    number_of_jobs DESC
LIMIT 10;
```

   | Job Via                          | Number of Jobs |
|----------------------------------|----------------|
| via LinkedIn                     | 186,990        |
| via BeBee                        | 103,655        |
| via Trabajo.org                  | 61,935         |
| via Indeed                       | 42,835         |
| via Recruit.net                  | 23,714         |
| via ZipRecruiter                 | 15,612         |
| via Jobs Trabajo.org             | 10,690         |
| via Snagajob                     | 9,424          |
| via Trabajo.org - Vacancies      | 8,920          |
| via BeBee India                  | 8,705          |


![Job sources](assets\number_of_jobs_by_platform.png)

*Bar graph visualizing the most popular job platforms for Data Analyst*

## 5. **Top 10 Salaries for Data Analyst Positions**
   - Calculate the top 10 highest salaries for Data Analyst jobs.
   

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
    
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

![Top 10 Paying Data Analyst Jobs](assets\top_10_paying_data_analyst_jobs.png)

*Bar graph visualizing for top 10 Data Analyst salary*

6. **Top Skills for Data Analyst Positions**
   - Identify the most in-demand skills for Data Analyst job offers.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS job_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY
    skills 
ORDER BY job_count DESC
LIMIT 10
```

| skills     |   job_count |
|:-----------|------------:|
| sql        |       92628 |
| excel      |       67031 |
| python     |       57326 |
| tableau    |       46554 |
| power bi   |       39468 |
| r          |       30075 |
| sas        |       28068 |
| powerpoint |       13848 |
| word       |       13591 |
| sap        |       11297 |

![Job demands skills for Data Analyst](assets\job_demand_for_skills.png)

## 7. **Salary Comparison for Data Analysts, Data Scientists, and Data Engineers**
   - Compare the average salary for Data Analyst jobs across different countries.
   - Compare the average salary for Data Scientists and Data Engineers.

   ```sql
   SELECT
    job_postings_fact.job_title_short,
    MAX(job_postings_fact.salary_year_avg) AS max_salary,
    MIN(job_postings_fact.salary_year_avg) AS min_salary,
    ROUND(AVG(job_postings_fact.salary_year_avg), 2) AS avg_salary
FROM
    job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.salary_year_avg IS NOT NULL
    AND job_postings_fact.job_title_short IN ('Data Analyst', 'Data Scientist', 'Data Engineer')
GROUP BY
    job_postings_fact.job_title_short
ORDER BY
    avg_salary DESC;
```
![Salary comparison chart](assets\salary_comparison_chart.png)
*Bar graph visualizing the differences between salaries for different roles*

## 8. **Average Salary for On-Site vs. Remote Jobs for Data Analysts**
   - Compare the average salary for on-site and remote Data Analyst jobs.

   ```sql
   WITH DataAnalystJobs AS (
    SELECT
        job_postings_fact.job_title_short,
        job_postings_fact.salary_year_avg,
        job_postings_fact.job_work_from_home
    FROM
        job_postings_fact
    WHERE
        job_postings_fact.salary_year_avg IS NOT NULL
        AND job_postings_fact.job_title_short = 'Data Analyst'
        AND job_postings_fact.job_work_from_home IS NOT NULL
)

SELECT
    job_work_from_home,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary_year
FROM
    DataAnalystJobs
GROUP BY
    job_work_from_home
ORDER BY
    avg_salary_year DESC;
```

| Work From Home | Average Salary (Yearly) |
|----------------|--------------------------|
| YES           | 94,769.86               |
| NO          | 93,764.65               |


## 9. **Impact of Degree Requirement on Job Count and Average Salary for Data Analysts**

 - Analyze the impact of degree requirements on the number of job postings and average salary for Data Analyst positions.

```sql
SELECT
    job_no_degree_mention,
    COUNT(job_id) AS job_count,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary_year
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
    AND job_title_short = 'Data Analyst'
    
GROUP BY
    job_no_degree_mention
ORDER BY
    avg_salary_year DESC;
```

| No Degree Required | Job Count | Average Yearly Salary ($) |
|--------------------|-----------|---------------------------|
| False              | 4227      | 94,146.22                |
| True               | 1236      | 92,950.93                |

  
![Degree requirement and and average salary ](https://github.com/Milos191405/SQL-Job-Analyse/blob/main/assets/degree_salary_job_count_chart_better_colors.png?raw=true)