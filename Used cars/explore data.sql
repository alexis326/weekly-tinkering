-- Exploring the data "by hand" rather than looking at docs for more practice

-- duplicates, vin can't be primary key
SELECT COUNT(DISTINCT vin) FROM used_cars;

-- kaggle states these column(s) are empty, double checking before dropping since queries already take a while to run
SELECT DISTINCT combine_fuel_economy FROM used_cars;
SELECT DISTINCT vehicle_damage_category FROM used_cars;
SELECT DISTINCT is_certified FROM used_cars;


-- below are just queries to standardize units/check to see what is being treated as representing NULL
-- could check docs but wanted to explore by hand

SELECT COUNT(height) FROM used_cars WHERE height NOT LIKE '%in';
-- 468, list them
SELECT height FROM used_cars WHERE height NOT LIKE '%in';
-- all "--", null for dataset maybe so check with another column

SELECT width FROM used_cars WHERE width NOT LIKE '%in';
-- NULL values are also "--" in this column 
-- The standard dimension is inches written as 'in' in the last two spaces
-- So dimension queries will be written as: COALESCE(NULLIF(column,'--'), LEFT(column, 2)::NUMERIC)

SELECT string_to_array(REGEXP_REPLACE(major_options,'[\[\]]','','g'),',') FROM used_cars LIMIT 5;
-- the column looks like it's meant to be an array