/* Part 4.1: Create Movies table */

CREATE TABLE movies (
    movieId INTEGER DEFAULT '0',
    title VARCHAR(50) DEFAULT NULL,
    genres VARCHAR(50) DEFAULT NULL
);

/* Part 4.1: Create Ratings table */
CREATE TABLE ratings (
    userId INTEGER DEFAULT '0',
    movieId INTEGER DEFAULT '0',
    rating DECIMAL(10,5) DEFAULT '0.0',
    timestamp INTEGER DEFAULT '0'
);

/* Part 4.2: View the first ten rows from the 'movies' table */
SELECT * FROM movies LIMIT 10;

/* Part 4.2: View the first ten rows from the 'ratings' table */
SELECT * FROM ratings LIMIT 10;

/* Part 4.3a: Create table showing how many reviews each user left */
CREATE TABLE s3_users_count AS
SELECT
    userId,
    COUNT(*) AS num_of_reviews
FROM ratings
GROUP BY userId;

/* Part 4.3b: View users with more than 500 reviews */
SELECT *
FROM s3_users_count
WHERE num_of_reviews > 500;

/* Part 4.4a: Create table showing number of reviews per movie */
CREATE TABLE s4_popular_movies AS
SELECT
    m.movieId,
    m.title,
    COUNT(r.rating) AS num_of_reviews
FROM movies m
JOIN ratings r
    ON m.movieId = r.movieId
GROUP BY m.movieId, m.title;

/* Part 4.4b: View top 10 most reviewed movies */
SELECT
    title,
    num_of_reviews
FROM s4_popular_movies
ORDER BY num_of_reviews DESC
LIMIT 10;

/* Part 4.5a: Create table showing average rating per movie */
CREATE TABLE s5_highest_stars AS
SELECT
    m.movieId,
    m.title,
    AVG(r.rating) AS average_rating
FROM movies m
JOIN ratings r
    ON m.movieId = r.movieId
GROUP BY m.movieId, m.title;

/* Part 4.5b: View Toy movies ordered by average rating */
SELECT
    title,
    average_rating
FROM s5_highest_stars
WHERE title LIKE '%Toy%'
ORDER BY average_rating ASC;

/* Part 4.6a: Convert unix timestamp into readable datetime */
CREATE TABLE s6_converted_date AS
SELECT
    userId,
    movieId,
    rating,
    datetime(timestamp, 'unixepoch') AS date
FROM ratings;

/* Part 4.6b: View first 10 rows */
SELECT *
FROM s6_converted_date
LIMIT 10;

/* Part 4.7a: Create table of highly rated reviews before 1997 */
CREATE TABLE s7_good_oldies AS
SELECT
    userId,
    movieId,
    rating,
    date
FROM s6_converted_date
WHERE rating > 4
  AND date < '1997-01-01 00:00:00'
ORDER BY rating DESC;

/* Part 4.7b: Count rows in s7_good_oldies */
SELECT
    COUNT(*) AS row_count
FROM s7_good_oldies;

/* Part 4.8a: Create table showing frequent critics before 1997 */
CREATE TABLE s8_frequent_critics AS
SELECT
    userId,
    COUNT(*) AS review_count
FROM s7_good_oldies
GROUP BY userId
ORDER BY review_count DESC;

/* Part 4.8b: View all rows from s8_frequent_critics */
SELECT *
FROM s8_frequent_critics;

/* Part 4.9: Create an exact copy of the movies table */
CREATE TABLE s9_movies AS
SELECT *
FROM movies;

/* Part 4.9 check: View first 10 rows of copied movies table */
SELECT *
FROM s9_movies
LIMIT 10;

/* Part 4.10a: Insert new Indie movie into s9_movies */
INSERT INTO s9_movies (
    movieId,
    title,
    genres
)
SELECT
    MAX(movieId) + 1,
    '591 Breakout Hit (2024)',
    'Indie'
FROM s9_movies;

/* Part 4.10b: View all Indie movies */
SELECT *
FROM s9_movies
WHERE genres = 'Indie';
