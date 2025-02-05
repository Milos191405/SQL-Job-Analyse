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

