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
