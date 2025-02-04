SELECT column_name
FROM information_schema.columns
WHERE table_name = 'job_postings_fact';

SELECT job_posted_date
FROM job_postings_fact
ORDER BY job_posted_date DESC

SELECT *
FROM job_postings_fact

SELECT


SELECT column_name
FROM information_schema.columns
WHERE table_name = 'job_postings_fact';




SELECT
    job_country,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_country = 'Serbia' and
    salary_year_avg IS NOT NULL
GROUP BY
    job_country,
    salary_year_avg


select
    name
    
FROM company_dim
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'company_dim';

SELECT
    job_postings_fact.company_id,
    job_postings_fact.company_name,
    job_postings_fact.company_country
FROM 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_postings_fact.company_country = 'UNITED STATES';

CREATE TABLE gsearch_jobs (
    id SERIAL PRIMARY KEY,
    index INT,
    title TEXT NOT NULL,
    company_name TEXT NOT NULL,
    location TEXT,
    via TEXT,
    description TEXT,
    extensions TEXT,
    job_id TEXT UNIQUE,
    thumbnail TEXT,
    posted_at TIMESTAMP,
    schedule_type TEXT,
    work_from_home TEXT,
    salary TEXT,
    search_term TEXT NOT NULL,
    date_time TIMESTAMP NOT NULL,
    search_location TEXT NOT NULL,
    commute_time FLOAT,
    salary_pay TEXT,
    salary_rate TEXT,
    salary_avg FLOAT,
    salary_min FLOAT,
    salary_max FLOAT,
    salary_hourly FLOAT,
    salary_yearly FLOAT,
    salary_standardized FLOAT,
    description_tokens TEXT
);

SELECT COUNT(*) FROM gsearch_jobs;

COPY gsearch_jobs
FROM 'C:\Users\milos\Desktop\Projects\SQL-Job-Analyse\files\gsearch_jobs.csv'
DELIMITER ','
CSV HEADER;
  ALTER

WITH skills_cte AS (
    SELECT unnest(string_to_array(
        regexp_replace(description_tokens, '\[|\]|''', '', 'g'), ',\s*'
    )) AS skill
    FROM gsearch_jobs
)
SELECT skill, COUNT(*) AS count
FROM skills_cte
WHERE skill <> '' -- Ignore empty values
GROUP BY skill
ORDER BY count DESC;

WITH skills_cte AS (
    SELECT 
        trim(unnest(string_to_array(
            regexp_replace(description_tokens, '\[|\]|''', '', 'g'), ','
        ))) AS skill,
        id  -- Include a unique identifier to join later
    FROM gsearch_jobs
)
SELECT 
    s.skill, 
    COUNT(*) AS count,
    g.title
FROM skills_cte s
JOIN gsearch_jobs g ON s.id = g.id  -- Correct join condition
WHERE s.skill IS NOT NULL AND s.skill <> ''  -- Remove empty values
GROUP BY s.skill, g.title
ORDER BY count DESC;


select description_tokens
from gsearch_jobs


ALTER TABLE gsearch_jobs 
ADD COLUMN skills TEXT;

UPDATE gsearch_jobs
SET skills = (
    CASE
        WHEN description_tokens ILIKE '%python%' THEN 'Python'
        WHEN description_tokens ILIKE '%sql%' THEN 'SQL'
        WHEN description_tokens ILIKE '%excel%' THEN 'Excel'
        WHEN description_tokens ILIKE '%communication%' THEN 'Communication'
        WHEN description_tokens ILIKE '%leadership%' THEN 'Leadership'
        WHEN description_tokens ILIKE '%data analysis%' THEN 'Data Analysis'
        WHEN description_tokens ILIKE '%project management%' THEN 'Project Management'
        WHEN description_tokens ILIKE '%java%' THEN 'Java'
        WHEN description_tokens ILIKE '%c++%' THEN 'C++'
        WHEN description_tokens ILIKE '%machine learning%' THEN 'Machine Learning'
        WHEN description_tokens ILIKE '%deep learning%' THEN 'Deep Learning'
        WHEN description_tokens ILIKE '%data visualization%' THEN 'Data Visualization'
        ELSE 'Other'
    END
);

ALTER TABLE gsearch_jobs ADD COLUMN tokens_array TEXT[];

UPDATE gsearch_jobs
SET tokens_array = string_to_array(description_tokens::text, ','::text);

SELECT
    title,
    tokens_array
FROM
    gsearch_jobs
WHERE
    tokens_array @> ARRAY['python']::TEXT[];  -- Check if 'python' is in the array

SELECT
    title,
    tokens_array
FROM
    gsearch_jobs
WHERE
    tokens_array && ARRAY['python', 'sql']::TEXT[];  -- Check if the array contains any of the values 'python' or 'sql'

SELECT title, description_tokens
FROM gsearch_jobs
LIMIT 10;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'gsearch_jobs';

ALTER TABLE gsearch_jobs ADD COLUMN tokens_array TEXT[];

UPDATE gsearch_jobs
SET tokens_array = string_to_array(replace(description_tokens::text, ']', ''), ',')
WHERE description_tokens IS NOT NULL;
