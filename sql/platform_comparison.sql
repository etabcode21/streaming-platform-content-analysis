-- Streaming Platform Comparison: Disney+ vs Amazon Prime Video
-- Amazon Prime data source:
-- https://www.kaggle.com/datasets/shivamb/amazon-prime-movies-and-tv-shows
-- Prerequisite: the disney_plus table must already exist.
-- Create and populate amazon_prime from the CSV before running comparisons.


CREATE TABLE IF NOT EXISTS amazon_prime (
    show_id TEXT,
    type TEXT,
    title TEXT,
    director TEXT,
    casts TEXT,
    country TEXT,
    date_added TEXT,
    release_year INT,
    rating TEXT,
    duration TEXT,
    listed_in TEXT,
    description TEXT
);


CREATE OR REPLACE VIEW streaming_platforms AS

SELECT
    'Disney+' AS platform,
    type,
    title,
    release_year,
    rating,
    duration,
    listed_in,
    country
FROM disney_plus

UNION ALL

SELECT
    'Amazon Prime' AS platform,
    type,
    title,
    release_year,
    rating,
    duration,
    listed_in,
    country
FROM amazon_prime;

-- Comparing total titles betwen both platforms
SELECT
    platform,
    COUNT(*) AS total_titles
FROM streaming_platforms
GROUP BY platform;

-- 1. Which platform has a higher percentage of Movies vs Tv Shows


WITH content_counts as(
	SELECT
		platform,
		type,
		COUNT(*) as total_titles
	FROM streaming_platforms
	GROUP BY platform, type
	ORDER BY platform, type

)

SELECT
	platform,
	type,
	total_titles,

	    ROUND(
        total_titles * 100.0 /
        SUM(total_titles) OVER (
            PARTITION BY platform
        ),
        2
    ) AS percentage

FROM content_counts
ORDER BY platform, type;
	
-- 2. Which platform has longer movies on average?


SELECT
	platform,
	COUNT(*) as movies_analyzed,
	ROUND(
		AVG(CAST(SPLIT_PART(duration, ' ', 1) as INT)),
		2
	) as avg_duration_minutes
FROM streaming_platforms
WHERE type = 'Movie'
	AND TRIM(duration) ~ '^[0-9]+ min$'
GROUP BY platform
ORDER BY avg_duration_minutes DESC;


-- 3. How do movie and TV show release years compare between Disney+ and Amazon Prime?

WITH yearly_counts as(
	SELECT
		platform,
		release_year,
		COUNT(*) as total_titles
	FROM streaming_platforms
	WHERE release_year BETWEEN 2010 AND 2021
	GROUP BY platform, release_year
)

SELECT
	platform,
	release_year,
	total_titles,
	ROUND(
		total_titles * 100.0 /
        SUM(total_titles) OVER (
            PARTITION BY platform
		),
		2

	) as percentage
FROM yearly_counts
ORDER BY release_year, platform;
