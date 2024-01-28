--select Location,date, total_cases, new_cases,total_deaths, new_deaths,population
--from CovidDeaths
--order by 1,2
-- continents and locations invloved in the database
select distinct(location)
from coviddeaths

select distinct(continent)
from CovidDeaths

select location
from CovidDeaths 
group by location

-- looking at total cases versus total deaths
select continent,Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from CovidDeaths
where continent is not null and location = 'India'
order by 1,2,3

select distinct(location)
from CovidDeaths
where location like 'I%'

--looking at total cases versus population
 select continent,location,date,population,total_cases, (total_cases/population) *100 as populationpercent
 from CovidDeaths
 where continent is not null 
 order by 1,2,3

 -- Looking at maximum infection rate compared to population
 select location,population, max(total_cases) as highestinfectioncount, max((total_cases/population)) *100 as percentpopulationpercent
 from CovidDeaths
 where continent is not null
 Group by Location,population
 order by 1,2

 --Looking at highest death count per population
 select location, population,max(cast(total_deaths as int)) as deathcount
 from CovidDeaths
 where continent is not null
 group by location,population
 order by deathcount desc


 --things based on continent
 select continent,max(cast(total_deaths as int)) as deathcount
 from CovidDeaths
 where continent is not null
 group by continent
 order by deathcount desc

 --Global numbers of cases and dates on a given date
 select date,sum(new_cases)as totcases,sum(cast(new_deaths as int)) as totdeaths
 from coviddeaths
 where continent is not null
 group by date
 order by 1


 --total population versus total vaccines taken
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
 from CovidDeaths dea
 join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 1,2,3




 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over  (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
 from CovidDeaths dea
 join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 1,2,3

 --using CTE finding the percentage ogf people vaccinated and population

 with popvsvac (continent, Location, date, population, new_vaccinations,rollingpeoplevaccinated)
 as
  (select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over  (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
 from CovidDeaths dea
 join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 1,2,3
 )
 select * ,(rollingpeoplevaccinated/population) *100 as percentvaccinated
 from popvsvac

 --using temp table
 drop table if exists #percentageofvaccinated
 create table #percentageofvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
 )

 Insert into  #percentageofvaccinated
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over  (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
 from CovidDeaths dea
 join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 1,2,3

 select * ,(rollingpeoplevaccinated/population) *100 
 from #percentageofvaccinated

 --creating a view
 create view vaccineview as
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over  (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
 from CovidDeaths dea
 join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 1,2,3


