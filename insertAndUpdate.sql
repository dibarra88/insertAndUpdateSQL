-- Create a new table called actors (We are going to pretend the actor can only play in one movie) The table should include name, character name, foreign key to movies and date of birth at least plus an id field.

CREATE TABLE `movies`.`actors` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(255) NULL,
  `last_name` VARCHAR(255) NULL,
  `character_name` VARCHAR(255) NULL,
  `birth` DATE NULL,
  `movieid` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `movies_FK_idx` (`movieid` ASC),
  CONSTRAINT `movies_FK`
    FOREIGN KEY (`movieid`)
    REFERENCES `movies`.`movies` (`movieid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- Pick 3 movies and create insert statements for 10 actors each. You should use the multi value insert statements
INSERT INTO actors (first_name, last_name, character_name, birth, movieid)
VALUES ('Tom', 'Hanks', 'Woody', '1956-07-09', 1),
			('Tim', 'Allen', 'Buzz Lightyear', '1953-06-13', 1),
            ('Don', 'Rickles', 'Mr. Potato Head', '1926-05-08', 1),
            ('Jim', 'Barney', 'Slinky Dog', '1949-06-15', 1),
            ('Wallace', 'Shawn', 'Rex', '1943-11-12',1),
            ('John', 'Ratzenberger', 'Hamm', '1947-04-06', 1),
            ('Annie', 'Potts', 'Bo Peep', '1952-10-28', 1),
            ('John', 'Morris', 'Andy', '1984-10-02', 1),
            ('Erik', 'von Detten', 'Sid', '1982-10-03', 1),
            ('Laurie', 'Metcalf', 'Mrs. Davis',  '1955-06-16', 1),
			('Robin', 'Williams', 'Alan Parrish', '1951-07-21', 2),
            ('Jonathan', 'Hyde', 'Velt Pelt/ Sam Parrish', '1948-05-21', 2),
            ('Kristen', 'Dunst', 'Judy Shepherd', '1982-04-30', 2),
            ('Bradley' , 'Pierce', 'Peter Shepherd', '1982-10-23', 2),
            ('Bonnie', 'Hunt', 'Sarah Whittle', '1962-09-22', 2),
            ('Bebe', 'Neuwirth', 'Nora Shepherd', '1958-12-31', 2),
            ('David', 'Alan Grier', 'Carl Bentley', '1956-06-30', 2),
            ('Patricia', 'Clarkson', 'Carol Parrish', '1959-12-29', 2),
            ('Adam', 'Hann-Byrd', 'Young Alan', '1982-02-23', 2),
            ('Laura', 'Bell Bundy', 'Youn Sarah', '1981-04-10', 2),
			('Walter', 'Matthau', 'Max Goldman', '1920-11-01', 3),
			('Jack', 'Lemmon', 'John Gustafson','1925-02-08', 3),
			('Sophia', 'Loren', 'Maria Sophia Coletta Ragetti', '1934-09-20', 3),
			('Ann-Margret', 'Olsson', 'Ariel Gustafson', '1941-04-28', 3),
			('Burgess', 'Meredith', 'Granpa Gustafson', '1907-11-16', 3),
			('Daryl', 'Hannah', 'Melanie Gustafson', '1960-12-03', 3),
			('Kevin', 'Pollak', 'Jacob Goldman', '1957-10-30', 3),
			('Katie', 'Sagona', 'Allie', '1989-11-26', 3),
			('Ann', 'Morgan Guilbert', 'Mama Ragetti', '1928-10-16', 3),
			('James', 'Andelin', 'Sven', '1917-09-27', 3);
            
--  Create a new column in the movie table to hold the MPAA rating. UPDATE 5 different movies to their correct rating
ALTER TABLE `movies`.`movies` 
CHANGE COLUMN `` `mpaa_rating` VARCHAR(255) NULL ;
UPDATE movies 
SET 
    mpaa_rating = 'G'
WHERE
    movieid = 1;

UPDATE movies 
SET 
    mpaa_rating = 'PG'
WHERE
    movieid = 2;

UPDATE movies 
SET 
    mpaa_rating = 'PG-13'
WHERE
    movieid = 3;

UPDATE movies 
SET 
    mpaa_rating = 'R'
WHERE
    movieid = 4;

UPDATE movies 
SET 
    mpaa_rating = 'PG'
WHERE
    movieid = 5;
    
--     Using SQL normalize the tags in the tags table. Make them lowercased and replace the spaces with -
UPDATE tags 
SET 
    tag = REPLACE(LOWER(tag), ' ', '-');
    
--     The movie_genre table was produced by a sql query that could match a movie to the appropriate rows in genre without the use of the join table. Reproduce that query.
SELECT 
	m.movieid, g.id
FROM
    movies m,
    genre g
WHERE
    m.genres LIKE CONCAT('%', g.genres, '%');
    
--  Create a new field on the movies table for the year. Using an update query and a substring method update that column for every movie with the year found in the title column. HINT: The pattern needed is '\d{4}' and depending on how your datagrip was set up you may need to use the psql command line to get the query to work.
ALTER TABLE `movies`.`movies` 
ADD COLUMN `year`  VARCHAR(255)  NULL AFTER `mpaa_rating`;

UPDATE movies 
SET 
    year = SUBSTRING_INDEX(SUBSTRING_INDEX(title, '(', - 1), ')', 1);
    
-- Now that we know we can add actors create a join table between actors and movies. This table should not only have the foreign keys for each of the tables, include an extra field for the character name for the actor. Use the current actor table to populate the join table with data including the character’s name
CREATE TABLE `movies`.`movie_actor` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `movieId` INT NULL,
  `actorId` INT UNSIGNED NULL,
  `character_name` VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `movie_FK_idx` (`movieId` ASC),
  INDEX `actor_FK_idx` (`actorId` ASC),
  CONSTRAINT `movie_FK`
    FOREIGN KEY (`movieId`)
    REFERENCES `movies`.`movies` (`movieid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `actor_FK`
    FOREIGN KEY (`actorId`)
    REFERENCES `movies`.`actors` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

INSERT INTO movie_actor (movieId, actorId, character_name)
SELECT movieid, id, character_name
FROM actors;

-- Once you have completed the new year column go through the title column and strip out the year.
 UPDATE movies 
SET 
    title = SUBSTRING_INDEX(title, '(', 1);
    
    
-- Create a new column in the movies table and store the average review for each and every movie.
ALTER TABLE `movies`.`movies` 
ADD COLUMN `averageRating` FLOAT NULL AFTER `year`;

SET SQL_SAFE_UPDATES = 0;


UPDATE movies m,
    (SELECT 
        movieid, AVG(rating) AS averageRating
    FROM
        ratings
    GROUP BY movieid) r
SET 
    m.averageRating = r.averageRating
WHERE
    m.movieid = r.movieid 
