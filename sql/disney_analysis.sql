-- Disney+ Content Analysis
-- Data source: https://www.kaggle.com/datasets/shivamb/disney-movies-and-tv-shows
-- Create the table first, then import the Disney+ CSV into it using pgAdmin.

CREATE TABLE IF NOT EXISTS disney_plus (
    show_id VARCHAR(6),
    type VARCHAR(10),
    title VARCHAR(100),
    director VARCHAR(75),
    casts VARCHAR(150),
    country VARCHAR(150),
    date_added VARCHAR(20),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(20),
    listed_in VARCHAR(75),
    description VARCHAR(259)
);


SELECT * FROM disney_plus;

-- 1. Seeing the distinct types of ratings
SELECT  
	DISTINCT rating
FROM disney_plus;

-- 2. Count the number of TV Shows vs Movies

SELECT
	type, 
	COUNT (*) as total_count
FROM disney_plus
GROUP BY type;


-- 3. Seeing the most common rating for both movies and tv shows
SELECT
	type,
	rating
FROM

(
	SELECT
		type,
		rating,
		COUNT(*),
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	FROM disney_plus
	GROUP BY 1, 2
	ORDER BY 1 ,3 DESC
) as t1

WHERE 
	ranking = 1;

-- 4. List all movies released in a specific year (2018)

SELECT *
FROM disney_plus

WHERE 
	release_year = 2018
	AND
	type = 'Movie';


-- 5. List the top 10 countires with the most content on Disney Plus


SELECT
	TRIM(UNNEST(STRING_TO_ARRAY (country, ','))) as new_country,
	COUNT (show_id) as total_content
FROM disney_plus
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- 6. FInd the longest movie

SELECT
	show_id,
	title,
	duration,
	CAST(SPLIT_PART(duration, ' ', 1) as INT) as duration_mins
FROM disney_plus
WHERE type = 'Movie'
ORDER BY duration_mins DESC
LIMIT 1;

-- 7. Identify content added in the last 5 years


SELECT
	type,
	title,
	date_added
FROM disney_plus
WHERE TO_DATE(date_added, 'DD-Mon-YY') >= CURRENT_DATE - INTERVAL '5 Years';
	


-- 8. Find any content directed by Anthony Russo or Joe Russo

SELECT
	type,
	title,
	director
	
FROM disney_plus
WHERE director LIKE '%Anthony Russo%' OR director LIKE '%Joe Russo%';


-- 9. What is the average duration of disney+ movies based on their rating?

SELECT 
	rating,
	AVG(CAST(SPLIT_PART(duration, ' ', 1) as INT)) as average_duration_mins
FROM disney_plus
WHERE type = 'Movie'
GROUP BY rating;

-- 10. Which 5 release years had the most movies?

SELECT
	release_year,
	COUNT (*) as total_movies
FROM disney_plus
WHERE type = 'Movie'
GROUP BY release_year
ORDER BY total_movies DESC
LIMIT 5;

-- 11. What percentage of the Disney+ catalog consist of Movies vs TV Shows?

SELECT
	type,
	COUNT(*) as total_content,

	ROUND(
		COUNT (*) * 100.0 /
		(SELECT COUNT (*) FROM disney_plus),
		2)
		as percentage
FROM disney_plus
GROUP BY type;


-- 12. Find ratings with more than 100 titles

SELECT
	rating,
	COUNT (*) as total_titles
FROM disney_plus
GROUP BY rating
HAVING COUNT(*) > 100;

	
-- 13. Which release years had 10 or less titles

SELECT
	release_year,
	COUNT (*) as total_titles
FROM disney_plus
GROUP BY release_year
HAVING COUNT(*) <= 10;


-- 14. Find the average movie duration for each release year

SELECT
	release_year,

	ROUND(AVG(CAST(SPLIT_PART(duration, ' ', 1) as INT)), 2) as average_duration_minutes
	
FROM disney_plus
WHERE type = 'Movie'
GROUP BY release_year;


-- 15. What are the top 10 individual genres on Disney+?

SELECT
	TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) as genre,
	COUNT (*) as total_count
	
FROM disney_plus
GROUP BY genre
ORDER BY 2 DESC
LIMIT 10;


-- 16. How many titles are missing director information?

SELECT
	COUNT(*) as missing_directors
FROM disney_plus
WHERE director IS NULL;


-- 17. Are There aby duplicate show_id values?

SELECT
	show_id,
	COUNT(*) as occurrence_count
FROM disney_plus
GROUP BY show_id
HAVING COUNT(*) > 1;

-- 18. Which movies are longer than the average movie duration


SELECT
	title,
	CAST(SPLIT_PART(duration, ' ', 1) as INT) as duration_mins
FROM disney_plus
WHERE type = 'Movie'
	AND CAST(SPLIT_PART(duration, ' ', 1) as INT) >
(
	SELECT
		ROUND(AVG(CAST(SPLIT_PART(duration, ' ', 1) as INT)), 2)
	FROM disney_plus
	WHERE type = 'Movie'
)
ORDER BY duration_mins DESC;


-- 19. Rank each years based on the number of movies released that year

SELECT
	release_year,
	COUNT(*) as total_movies,
	RANK() OVER(
		ORDER BY COUNT(*) DESC
	) as ranking
FROM disney_plus
WHERE type = 'Movie'
GROUP BY release_year
ORDER BY ranking;

-- 20. For each release year between 2010 and 2021, what percentage of Disney+ titles were Movies versus TV Shows?


WITH yearly_content as(	
	SELECT
		release_year,
		type,
		COUNT(*) as total_titles
	FROM disney_plus
	WHERE release_year BETWEEN 2010 AND 2021
	GROUP BY release_year, type
)

SELECT
	release_year,
	type,
	total_titles,
	SUM(total_titles) OVER (

		PARTITION BY release_year

	) as yearly_total,

	ROUND(
		total_titles * 100.0 / 
		SUM(total_titles) OVER (PARTITION BY release_year), 2
	)as percentage

FROM yearly_content
ORDER BY release_year DESC, type;

-- 21. How many titles were added to Disney+ each year?

SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'DD-Mon-YY'))::INT AS year_added,
    COUNT(*) AS total_titles
FROM disney_plus
WHERE date_added IS NOT NULL
    AND TRIM(date_added) <> ''
GROUP BY 1
ORDER BY 1;




