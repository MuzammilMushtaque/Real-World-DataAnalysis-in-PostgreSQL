-- This is the compilation of all the SQL commands
-- However, make sure do not run all commands at once.
-- only run the lines split by (******).


--                 Create tables & Import dataset.
-- If the given CSV files do not import, all you need
-- to give them a permission 
-- follow (https://stackoverflow.com/questions/54031813/i-am-trying-to-copy-a-file-but-getting-error-message)

-- Create Table "regions"
create table regions
(
	country_name varchar(100),
	country_code varchar(100),
	region varchar(100),
	income_group varchar(100)
);
copy regions from '\Data_files\regions.csv' WITH CSV HEADER;
SELECT * FROM regions
-- *******************************************

-- Create Table "land_area"
create table land_area
(
	country_code varchar(100),
	country_name varchar(100),
	years int,
	total_area_sq_mi double precision
);
copy land_area from '\Data_files\land_area.csv' WITH CSV HEADER;
SELECT * FROM land_area
-- *******************************************

-- Create Table "forest_area"
create table forest_area
(
	country_code varchar(100),
	country_name varchar(100),
	years int,
	forest_area_sqkm double precision
);
copy forest_area from '\Data_files\forest_area.csv' WITH CSV HEADER;
SELECT * FROM forest_area
-- *******************************************

-- Creating View named "forestation" that compiles all the columns of forest_area, land_area, and regions.
CREATE view forestation AS
SELECT la.country_name, la.country_code, la.years, r.income_group, r.region, fa.forest_area_sqkm,
la.total_area_sq_mi*2.59 AS total_area_sqkm, (fa.forest_area_sqkm*100)/(la.total_area_sq_mi*2.59) AS
percent_land_area_designed_as_forest
FROM forest_area AS fa
JOIN land_area AS la on fa.country_code = la.country_code and fa.years = la.years
JOIN regions AS r on fa.country_code = r.country_code

-- *******************************************

-- Now print 5 rows of forestation having highest percent_land_area_designed_as_forest, using command

SELECT *
FROM forestation
where percent_land_area_designed_as_forest is not null
order by percent_land_area_designed_as_forest DESC
limit 5;

-- *******************************************

--                   Global Situation

-- Total forest area of World in 1990:
select forest_area_sqkm from forestation
where country_name = 'World' and years =1990;
-- *******************************************

-- Total forest area of World in 2016:
select forest_area_sqkm from forestation
where country_name = 'World' and years =2016;
-- *******************************************

-- Difference in forest area:
select
(select sum(forest_area_sqkm) from forestation where years = 1990 and country_name = 'World')
-
(select sum(forest_area_sqkm) from forestation where years = 2016 and country_name = 'World')
as difference;
-- *******************************************

-- Percentage in forest area:
SELECT
(((SELECT SUM(forest_area_sqkm) FROM forestation WHERE years = 1990 AND
country_name = 'World')
-(SELECT SUM(forest_area_sqkm) FROM forestation WHERE years = 2016 AND country_name = 'World'))*100)/ (SELECT SUM(forest_area_sqkm) FROM forestation WHERE years = 1990
AND country_name = 'World')
as percentage

-- *******************************************

-- Land Area slightly lower than the amount of World forest area lost from 1990 to 2016

select country_name, total_area_sqkm from forestation
where years =2016 and total_area_sqkm < (
select
(select sum(forest_area_sqkm) from forestation where years = 1990 and country_name = 'World')
-
(select sum(forest_area_sqkm) from forestation where years = 2016 and country_name = 'World')
as difference)
order by total_area_sqkm DESC
limit 1;

-- *******************************************

-- Regional Outlook
-- Percent of total land area of world designated as forest in 1990 and 2016
select country_name, region, percent_land_area_designed_as_forest
from forestation
where country_name = 'World' and (years = 2016 or years = 1990)

-- *******************************************

-- Highest/lowest relative region of forestation in 1990 and 2016

select region, (SUM(forest_area_sqkm)/SUM(total_area_sqkm))*100
FROM forestation
WHERE years = 1990
AND
country_name!='World' GROUP BY region;

-- Highest/lowest relative region of forestation in 1990 and 2016
select region, (SUM(forest_area_sqkm)/SUM(total_area_sqkm))*100
FROM forestation
WHERE years = 2016
AND
country_name!='World' GROUP BY region;

-- *******************************************

--                   Country Level Detail
-- To evaluate data between two years (ie 1990 and 2016). I have created view named as
-- forestation_1990 and forestation_2016 having all columns from forestation
create view forestation_2016 as
select * from forestation
where years = 2016;
create view forestation_1990 as
select * from forestation
where years =1990;
-- *******************************************

SELECT f16.country_name, ABS(f90.forest_area_sqkm - f16.forest_area_sqkm) AS
change_in_forest_area
FROM forestation_1990 AS f90
JOIN forestation_2016 AS f16 ON f90.country_name = f16.country_name
WHERE (f90.forest_area_sqkm-f16.forest_area_sqkm) IS NOT NULL
AND
(f90.forest_area_sqkm-f16.forest_area_sqkm) < 0
ORDER BY ABS(f90.forest_area_sqkm - f16.forest_area_sqkm) DESC
LIMIT 2;
-- *******************************************

-- Largest increase in percent forest area from 1990 to 2016
SELECT f16.country_name, ABS((f90.forest_area_sqkm - f16.forest_area_sqkm)*100)/f90.forest_area_sqkm AS change_in_percent_forest_area
FROM forestation_1990 AS f90
JOIN forestation_2016 AS f16 on f90.country_name = f16.country_name
WHERE ((f90.forest_area_sqkm-f16.forest_area_sqkm)*100)/f90.forest_area_sqkm IS NOT
NULL
AND
((f90.forest_area_sqkm-f16.forest_area_sqkm)*100)/f90.forest_area_sqkm < 0
ORDER BY ((f90.forest_area_sqkm-f16.forest_area_sqkm)*100)/f90.forest_area_sqkm ASC
LIMIT 1;
-- *******************************************

-- 3B:
-- Table 3.1
SELECT f16.country_name, f16.region, ABS(f90.forest_area_sqkm - f16.forest_area_sqkm) AS
decrease_in_forest_area_sqkm
FROM forestation_1990 AS f90
JOIN forestation_2016 AS f16 on f90.country_name = f16.country_name
WHERE (f90.forest_area_sqkm-f16.forest_area_sqkm) IS NOT NULL
AND
(f90.forest_area_sqkm-f16.forest_area_sqkm) > 0
AND
f16.region != 'World' ORDER BY ABS(f90.forest_area_sqkm - f16.forest_area_sqkm) DESC
LIMIT 5;
-- *******************************************

-- Table3.2
SELECT f16.country_name, ABS(((f90.forest_area_sqkm-f16.forest_area_sqkm)*100)/(f90.forest_area_sqkm)) AS change_in_forest_area
FROM forestation_1990 as f90
JOIN forestation_2016 as f16 on f90.country_name = f16.country_name
WHERE (((f90.forest_area_sqkm-f16.forest_area_sqkm)*100)/(f90.forest_area_sqkm)) IS NOT
NULL
AND
(((f90.forest_area_sqkm-f16.forest_area_sqkm)*100)/(f90.forest_area_sqkm)) > 0
ORDER BY change_in_forest_area DESC
LIMIT 5;
-- *******************************************

-- 3C:
-- Table 3.3
select
case
when percent_land_area_designed_as_forest between 0 and 25 then '0-25' when percent_land_area_designed_as_forest between 25 and 50 then '25-50' when percent_land_area_designed_as_forest between 50 and 75 then '50-75' when percent_land_area_designed_as_forest between 75 and 100 then '75-100' end as Range, count(country_name) as Count
from forestation
where years = 2016 and percent_land_area_designed_as_forest is not null
and country_name != 'World' group by Range order by count DESC

-- *******************************************

-- Table 3.4
SELECT country_name, region, CAST(percent_land_area_designed_as_forest as
decimal(16,2)),count(country_name) OVER(PARTITION BY
percent_land_area_designed_as_forest>75 and percent_land_area_designed_as_forest<100)
AS total_country_count from forestation_2016
WHERE country_name!='World' and percent_land_area_designed_as_forest IS NOT NULL
AND
percent_land_area_designed_as_forest > 75
ORDER BY percent_land_area_designed_as_forest DESC