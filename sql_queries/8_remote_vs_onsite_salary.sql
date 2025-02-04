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
