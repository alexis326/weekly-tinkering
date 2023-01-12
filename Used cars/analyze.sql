CREATE OR REPLACE VIEW car_view AS
SELECT vin,
       body_type,
       city,
       exterior_color,
       fleet,
       frame_damaged,
       franchise_dealer,
       fuel_type,
       has_accidents,
       interior_color,
       listed_date,
       listing_color,
       major_options,
       make_name,
       owner_count,
       sp_name,
       wheel_system,
       year,
       is_new,
       model_name,
       price
FROM used_cars;

-- Top 10 cars ranked by make year in percent
WITH percent_year AS (SELECT year, COUNT(year) year_count, (SELECT COUNT(year) from car_view) AS t_cars
                      FROM car_view
                      GROUP BY year)
SELECT year, ROUND((100 * year_count::NUMERIC) / t_cars, 1) AS percent
FROM percent_year
ORDER BY percent DESC
LIMIT 10;

-- How many vehicles have had 10 or more owners
SELECT DISTINCT make_name, body_type, model_name, year, owner_count, price
FROM car_view
WHERE has_accidents IS TRUE
  AND is_new IS FALSE
  AND owner_count >= 10
ORDER BY owner_count DESC NULLS LAST;

-- Comparing wheel system pricing differences for the same model of cars
WITH compare_drive AS (SELECT make_name,
                              model_name,
                              year,
                              wheel_system,
                              price,
                              string_to_array(REGEXP_REPLACE(major_options, '[\[\]]', '', 'g'), ',') AS options
                       FROM car_view
                       -- To make them more comparable
                       WHERE owner_count = 1
                         AND is_new = FALSE
                         AND has_accidents = FALSE
                         AND wheel_system IS NOT NULL)
SELECT *
FROM compare_drive
ORDER BY model_name, year DESC;
