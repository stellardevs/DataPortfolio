-- Global numbers and Global Death percentage 

SELECT 
SUM(new_cases) as total_cases, 
SUM(cast(new_deaths as int)) as total_deaths,
    CASE 
        WHEN SUM(new_cases) = 0 THEN 0 
        ELSE SUM(CAST(new_deaths AS INT)) * 100.0 / SUM(new_cases) 
    END AS DeathPercentage
FROM master.dbo.CovidDeath
--WHERE location like '%states%'
WHERE continent is not null 
--GROUP By date
ORDER by 1,2



-- Find Total Death Count per Continent

SELECT location, 
SUM(cast(new_deaths as int)) as TotalDeathCount
FROM master.dbo.CovidDeath
WHERE continent is null 
and location not in ('World', 'European Union', 'International', '%income%' )
and location not like '%income%'
GROUP by location
ORDER by TotalDeathCount desc



-- Percent of Population Infected FROM beginning of covid

SELECT 
    Location, 
    Population, 
    MAX(total_cases) AS HighestInfectionCount,  
    MAX(total_cases*100.0/population) AS PercentPopulationInfected
FROM master.dbo.CovidDeath
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC



-- Percent of Population Infected per day per country

SELECT 
    Location, 
    Population,
    date, 
    MAX(total_cases) as HighestInfectionCount,  
    Max(total_cases *100.0/population) as PercentPopulationInfected
FROM  master.dbo.CovidDeath
GROUP by Location, Population, date
ORDER by PercentPopulationInfected desc