create database IMDBMovies;
use IMDBMovies;

/* movie basic data */
CREATE TABLE movie_basic(
title VARCHAR(100) NOT NULL,
genre VARCHAR(50) NOT NULL,
release_year INT NOT NULL,
director VARCHAR(50) NOT NULL,
studio VARCHAR(50) NOT NULL,
critic_rating DECIMAL(2,1) DEFAULT 0
);


/* movie genres*/
CREATE TABLE Genre(
id INT PRIMARY KEY AUTO_INCREMENT,
genre VARCHAR(20) NOT NULL
);


/* movie director */
CREATE TABLE Director(
id INT PRIMARY KEY AUTO_INCREMENT,
dir_name VARCHAR(40) NOT NULL
);


/* movie studio */
CREATE TABLE Studio(
id INT PRIMARY KEY AUTO_INCREMENT,
studio_name VARCHAR(30) NOT NULL,
city VARCHAR(50) NOT NULL
);

/* movie titles */
CREATE TABLE Titles(
id INT PRIMARY KEY AUTO_INCREMENT,
title VARCHAR(100) NOT NULL,
genre_id INT NOT NULL,
release_year INT NOT NULL,
director_id INT NOT NULL,
studio_id INT NOT NULL,
FOREIGN KEY(genre_id) REFERENCES Genre(id),
FOREIGN KEY(director_id) REFERENCES Director(id),
FOREIGN KEY(studio_id) REFERENCES Studio(id)
);


/* movie critics rating */
CREATE TABLE Critic_Rating(
id INT PRIMARY KEY AUTO_INCREMENT,
titles_id INT NOT NULL,
critics_rating DECIMAL(2,1) DEFAULT 0,
FOREIGN KEY(titles_id) REFERENCES titles(id)
);


/* posters */
CREATE TABLE posters(
titles_id INT NOT NULL,
filename VARCHAR(100) NOT NULL,
resolution VARCHAR(20) NOT NULL,
FOREIGN KEY(titles_id) REFERENCES titles(id) 
);

-- ============== EDA Exploratory Data Analysis ============== -- 
-- ======================================================
/*Getting All Data */

select * from movie_basic,director,genre,posters,studio,critic_rating,titles;




/* Selecting Data */
SELECT id,IF(critics_rating > 6, 'Good', 'Bad') AS score
FROM critic_rating;

SELECT id,
	CASE
		WHEN critics_rating > 8 THEN 'Good'
		WHEN critics_rating > 6 THEN 'Decent'
		ELSE 'Bad'
	END AS score
FROM critic_rating;


/* Challenge: Filter movie by score */
SELECT 
t.title AS 'Title:', 
IF (t.release_year > 2000, '21st Century', '20th Century') AS 'Released:', 
d.dir_name AS 'Director:', 
cr.critics_rating,
CASE
	WHEN cr.critics_rating >= 9 THEN 'Amazing'
    WHEN cr.critics_rating > 7 AND cr.critics_rating < 9 THEN 'Good'
    WHEN cr.critics_rating > 5 AND cr.critics_rating <= 7 THEN 'Decent'
    ELSE 'Bad'
END AS 'Reviews:'
FROM titles t
JOIN director d ON t.director_id = d.id
JOIN critic_rating cr ON t.id = cr.titles_id
ORDER BY 1 DESC;


/* Challenge: fixing mistakes */
/* add Rence movies */
INSERT INTO movie_basic(title, genre, release_year, director, studio, critic_rating)
VALUES('Run for the Forest', 'Drama', 1946, 'Rence Pera', 'Lionel Brownstone', 7.3),
('Luck of the Night', 'Drama', 1951, 'Rence Pera', 'Lionel Brownstone', 6.8),
('Invader Glory', 'Adventure', 1953, 'Rence Pera', 'Lionel Brownstone', 5.5);


/* change genre 'sci-fi' to 'sf' for all falsted group flims*/
SELECT * FROM movie_basic
WHERE studio LIKE 'Falstead Group';

UPDATE movie_basic
SET genre = 'SF'
WHERE genre = 'Sci-Fi'
AND studio LIKE 'Falstead Group';

/* remove all the flims Garry Scott did for Lionel Brownstone as those were lost */
SELECT * FROM movie_basic
WHERE director = 'Garry Scott'
AND studio = 'Lionel Brownstone';

DELETE
FROM movie_basic
WHERE director = 'Garry Scott'
AND studio = 'Lionel Brownstone';


/* Challenge: Find the best film */
SELECT t.title, d.dir_name, cr.critics_rating, p.filename
FROM titles t
JOIN director d ON t.director_id = d.id
JOIN critic_rating cr ON t.id = cr.titles_id
JOIN posters p ON t.id = p.titles_id
ORDER BY critics_rating DESC
LIMIT 10;








