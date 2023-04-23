SELECT *
FROM [PortfolioProject].[dbo].[CovidDeaths]
order by 3,4

SELECT *
FROM PortfolioProject..CovidVaccinations
order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

--Looking at total cases vs total deaths ( What percentage of population got covid)

Select location, date, CONVERT(float, total_deaths) as total_deaths, CONVERT(float, total_cases) as total_cases, 
(CONVERT(float, total_deaths)/CONVERT(float, total_cases))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

--Looking at countries with highest infection rate compated to population

Select location, population, MAX(CONVERT(float, total_cases)) as HighestInfectionCount,
MAX(CONVERT(float, total_cases)/CONVERT(float, population)) as PercentPopulationInfected
from PortfolioProject..CovidDeaths
Where continent is not null
group by location, population 
order by PercentPopulationInfected desc

--Looking at countries with highest death count

Select location, MAX(CONVERT(float, total_deaths)) as TotalDeathCount
from PortfolioProject..CovidDeaths
Where continent is not null
group by location
order by TotalDeathCount desc

--Looking at continents with highest death count
Select location, MAX(CONVERT(float, total_deaths)) as TotalDeathCount
from PortfolioProject..CovidDeaths
Where continent is null
group by location
order by TotalDeathCount desc

--GLOBAL NUMBERS
Select SUM(CAST(new_cases as float)) as TotalGlobalCases , SUM(CAST(new_deaths as float)) as TotalGlobalDeaths
--SUM(CAST(new_deaths as float))/ SUM(CAST(new_cases as float))*100
from PortfolioProject..CovidDeaths
Where continent is not null
--group by date
--order by 1,2

--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) 
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) 
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)

select *, (RollingPeopleVaccinated/population)*100
from PopvsVac 


--TEMP TABLE


Create Table #PercentPopulationVaccinated 
(
continent nvarchar(255),
Location nvarchar(255),
date datetime, 
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert into  #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) 
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


--Creating view to store data for later visualizations

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null