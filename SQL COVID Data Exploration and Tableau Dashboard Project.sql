/*
Covid 19 Data Exploration and Tableau Project

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types, Tableau Dashboard

*Conducted end-to-end data analysis project using global Excel COVID-19 datasets to uncover trends in 
 infection rates, death rates, and vaccination progress.
*Utilized SQL techniques including joins, CTEs, temporary tables, etc, to calculate key metrics such as death percentage,
 infection rate by population, and rolling vaccination totals.
*Developed an interactive Tableau dashboard to present global and country-level insights including,
 highest infection rates relative to population, total death counts by country and continent, and global
 daily case and death trends.

*/

Select *
From CovidDeaths
Where continent is not null 
order by 3,4



-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Where continent is not null 
order by 1,2




-- Looking at the Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract COVID in your country
select
location,
date,
total_cases,
total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%states%'
order by 1,2


-- Looking at the Total Cases vs Population
-- Shows what percentage of population got COVID
select
location,
date,
total_cases,
population,
(total_cases/population)*100 as PercentPopulationInfected
from CovidDeaths
where location like '%states%'
order by 1,2


-- Looking at countries with the highest infection rate compared to population
select
location,
max(total_cases) as HighestInfectionCount,
population,
max((total_cases/population))*100 as PercentPopulationInfected
from CovidDeaths
--where location like '%states%'
group by location, population
order by PercentPopulationInfected desc


-- Showing the countries with the highest death count per population
select
location,
max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%states%'
where continent is not null
group by location
order by TotalDeathCount desc


-- LETS BREAK THINGS DOWN BY CONTINENET

-- Showing the continents with the highest death count per population
select
continent,
max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc


-- Global Numbers

select
date,
sum(new_cases) as total_cases,
sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
--where location like '%states%'
where continent is not null
group by date
order by 1,2

select
sum(new_cases) as total_cases,
sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
--where location like '%states%'
where continent is not null
order by 1,2





-- Looking at total population vs vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
select 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from CovidDeaths dea
join CovidVaccinations vac 
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3



-- USING CTE to perform Calculation on Partition By in previous query
with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) as (
select 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from CovidDeaths dea
join CovidVaccinations vac 
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select 
*, 
(RollingPeopleVaccinated/Population)*100 
from PopvsVac



-- USING TEMP TABLE to perform Calculation on Partition By in previous query
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated (
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from CovidDeaths dea
join CovidVaccinations vac 
	on dea.location = vac.location and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select 
*, 
(RollingPeopleVaccinated/Population)*100 
from #PercentPopulationVaccinated



-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as 
select 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from CovidDeaths dea
join CovidVaccinations vac 
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select * from PercentPopulationVaccinated



Create View CountriesHighestDeathCount as
select
location,
max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%states%'
where continent is not null
group by location
--order by TotalDeathCount desc

Select * from CountriesHighestDeathCount
order by TotalDeathCount desc



Create View ContinentsHighestDeathCount as
select
continent,
max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
--order by TotalDeathCount desc

Select * from ContinentsHighestDeathCount
order by TotalDeathCount desc






/*

Queries used for Tableau Covid 19 Dataset Project

*/



-- 1. 

Select 
SUM(new_cases) as total_cases, 
SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select 
location, 
SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.

Select 
Location, 
Population, MAX(total_cases) as HighestInfectionCount,  
Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select 
Location, 
Population,date, MAX(total_cases) as HighestInfectionCount,  
Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc
