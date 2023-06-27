SELECT * FROM covid_death;
SELECT * FROM covid_vaccine;
SET extra_float_digits = 3;

-- Select the data that we are going to use

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_death;


-- Looking at to total cases vs Total deaths

SELECT location, date, total_cases, total_deaths, (total_deaths /  total_cases ) *100 AS death_percentage
FROM covid_death
ORDER BY 1 , 2 DESC;

-- Looking at to total cases vs Total deaths for Unites states
-- you can see the likelihoof of dying from covid if you infected
SELECT location, date, total_cases, total_deaths, (total_deaths /  total_cases ) *100 AS death_percentage
FROM covid_death
WHERE location = 'United States'
ORDER BY 1 , 2 DESC;

-- Looking at to total cases vs population
-- shows what percentage of population got covid.
SELECT location, date, total_cases, population, 
	  ( total_cases / population ) *100 AS case_percentage
FROM covid_death
WHERE location = 'United States'
ORDER BY 1 , 2 DESC;

-- Which countries has highers infection rate compared to population
SELECT location, cast(population as int),  MAX(total_cases) highestcases,
	  MAX(total_cases / population ) *100 AS case_percentage
FROM covid_death
WHERE total_cases IS NOT NULL
GROUP BY location, population
ORDER BY case_percentage DESC;

-- Showing Counties with Higest Death Count per Population

SELECT location,  MAX(total_deaths) highestdeathcount
FROM covid_death
WHERE total_deaths IS NOT NULL AND continent IS NOT NULL 
GROUP BY location
ORDER BY highestdeathcount DESC;


-- Showing Counties with Higest Percent of the death from covid
 
SELECT location, CAST(population AS bigint),  MAX(total_deaths) highestdeathcount,
	  MAX(total_deaths / population ) *100 AS death_percentage
FROM covid_death
WHERE total_deaths IS NOT NULL AND continent IS NOT NULL 
GROUP BY location, population
ORDER BY death_percentage DESC;

-- Showing Continents with Higest Death Counts 

SELECT continent,  MAX(total_deaths) highestdeathcount
FROM covid_death
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY highestdeathcount DESC;

-- Showing Continents with the Total Death 

SELECT continent,  SUM(total_deaths) totaldeath
FROM covid_death
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY totaldeath DESC;

-- Global Numbers
-- How many people death and infected so far
SELECT CAST(SUM(New_cases) AS bigint) total_cases,
	   CAST(SUM(new_deaths) AS bigint) total_death,
	   (SUM(new_deaths) / SUM(New_cases)) *100 deathpercent
FROM covid_death
WHERE total_deaths IS NOT NULL AND continent IS NOT NULL AND total_deaths IS NOT NULL
;


-- Global Numbers
-- Which months has most death percentage
SELECT EXTRACT(MONTH FROM date) AS Month,  CAST(SUM(New_cases) AS bigint) total_cases,
	   CAST(SUM(new_deaths) AS bigint) total_death,
	   (SUM(new_deaths) / SUM(New_cases)) *100 deathpercent
FROM covid_death
WHERE total_deaths IS NOT NULL AND continent IS NOT NULL AND total_deaths IS NOT NULL
GROUP BY 1
order by 4 DESC;


-- shows Total Population vs Vaccinations 
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations 
FROM  covid_death d
JOIN covid_vaccine v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT null	
ORDER BY 2, 3


-- shows Total Population vs Vaccinations 
SELECT d.continent, d.location, d.date, 
d.population, v.new_vaccinations, 
SUM(v.new_vaccinations) OVER (partition by d.location ORDER BY d.location, d.date) AS runningtotalvac
FROM  covid_death d
JOIN covid_vaccine v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT null	
ORDER BY 2, 3	

-- USE CTE
WITH popvsvac (continent, location, date, population, new_vaccinations, runningtotalvac)
AS 
(
SELECT d.continent, d.location, d.date, 
	   d.population, v.new_vaccinations, 
SUM(v.new_vaccinations) OVER (partition by d.location ORDER BY d.location, d.date) AS runningtotalvac
FROM  covid_death d
JOIN covid_vaccine v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT null	
)	
-- you have to run this query with CTE .
SELECT *, (runningtotalvac/population) *100  FROM popvsvac


WITH popvsvac (continent, location, date, population, new_vaccinations, runningtotalvac)
AS 
(
SELECT d.continent, d.location, d.date, 
	   d.population, v.new_vaccinations, 
SUM(v.new_vaccinations) OVER (partition by d.location ORDER BY d.location, d.date) AS runningtotalvac
FROM  covid_death d
JOIN covid_vaccine v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT null	
)	
-- lets see max vaccination rate
-- you have to run this query with CTE . In here I had wite same CTE again
-- If you dont want this you can use views or temporary tables.
SELECT  location, new_vaccinations, runningtotalvac
, MAX((runningtotalvac/population) *100)
FROM popvsvac
WHERE new_vaccinations IS NOT null
GROUP BY  location, new_vaccinations, runningtotalvac
ORDER BY 4 desc


-- I will create a temporary table for CTE
-- It will valid for session
DROP TABLE IF EXISTS  percentPopulationVacccinated;
CREATE TEMP TABLE percentPopulationVacccinated(

 continent varchar(255), 
 location varchar(255), 
 date date, 
 population bigint,
 new_vaccinations int, 
 runningtotalvac bigint
);
INSERT INTO  percentPopulationVacccinated

SELECT d.continent, d.location, d.date, 
	   d.population, v.new_vaccinations, 
SUM(v.new_vaccinations) OVER (partition by d.location ORDER BY d.location, d.date) AS runningtotalvac
FROM  covid_death d
JOIN covid_vaccine v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT null;

SELECT * FROM  percentPopulationVacccinated

-- create view to store data for later use.
-- It is perminent

CREATE VIEW percentPopulationVacccinated AS
SELECT d.continent, d.location, d.date, 
	   d.population, v.new_vaccinations, 
SUM(v.new_vaccinations) OVER (partition by d.location ORDER BY d.location, d.date) AS runningtotalvac
FROM  covid_death d
JOIN covid_vaccine v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT null	
ORDER BY 2,3

