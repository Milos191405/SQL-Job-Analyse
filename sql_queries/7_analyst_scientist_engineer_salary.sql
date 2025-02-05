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
