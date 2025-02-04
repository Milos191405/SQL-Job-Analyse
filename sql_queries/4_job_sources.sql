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