drop table if exists World_covid_vacc;
repair table world_covid_vacc;

Create table World_covid_vacc(
iso_code varchar(10),	
continent varchar(20),	
location varchar(20),	
date date not null,	
population	bigint(10),
total_cases	int(10),
new_cases int(10),
new_cases_smoothed decimal(5,3),	
total_deaths int(10),
new_deaths int(10),
new_deaths_smoothed decimal(5,3),	
total_cases_per_million	decimal(5,3),
new_cases_per_million decimal(5,3),	
new_cases_smoothed_per_million decimal(5,3),	
total_deaths_per_million decimal(5,3),	
new_deaths_per_million	decimal(5,3),
new_deaths_smoothed_per_million	decimal(5,3),
reproduction_rate decimal(5,3),	
icu_patients int(10),	
icu_patients_per_million decimal(5,3),	
hosp_patients int(10),	
hosp_patients_per_million decimal(5,3),	
weekly_icu_admissions int(10),	
weekly_icu_admissions_per_million decimal(5,3),	
weekly_hosp_admissions int(10),	
weekly_hosp_admissions_per_million decimal(5,3),	
new_tests int(10),	
total_tests	int(10),
total_tests_per_thousand	decimal(5,3),	
new_tests_per_thousand	decimal(5,3),	
new_tests_smoothed	int(10),
new_tests_smoothed_per_thousand	decimal(5,3),	
positive_rate	decimal(5,4),	
tests_per_case	decimal(5,3),	
tests_units	varchar(20),	
total_vaccinations	bigint(15),
people_vaccinated	bigint(15),
people_fully_vaccinated bigint(15),	
total_boosters	int(10),
new_vaccinations	int(10),
new_vaccinations_smoothed	int(10),
total_vaccinations_per_hundred	decimal(5,3),	
people_vaccinated_per_hundred	decimal(5,3),	
people_fully_vaccinated_per_hundred	decimal(5,3),	
total_boosters_per_hundred	decimal(5,3),	
new_vaccinations_smoothed_per_million int(10),	
new_people_vaccinated_smoothed	int(10),
new_people_vaccinated_smoothed_per_hundred decimal(5,3),		
stringency_index	decimal(5,3),	
population_density	decimal(5,3),	
median_age	decimal(5,2),
aged_65_older	decimal(5,3),	
aged_70_older	decimal(5,3),	
gdp_per_capita	decimal(5,3),	
extreme_poverty	decimal(5,3),	
cardiovasc_death_rate	decimal(5,3),	
diabetes_prevalence	decimal(5,3),	
female_smokers	decimal(5,3),	
male_smokers	decimal(5,3),	
handwashing_facilities	decimal(5,3),	
hospital_beds_per_thousand	decimal(5,3),	
life_expectancy	decimal(5,3),	
human_development_index	decimal(5,3),	
excess_mortality_cumulative_absolute	decimal(5,3),	
excess_mortality_cumulative	decimal(5,3),	
excess_mortality	decimal(5,3),	
excess_mortality_cumulative_per_million decimal(5,3)	
);
/*
load data local infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/owid-covid.data.csv'
into table World_covid
fields terminated by ','
*/

#Join Covid death table with Covid vaccination table
select *
from world_covid
join world_covid_vacc
on world_covid.location=world_covid_vacc.location
and world_covid.date = world_covid_vacc.date;


select continent, location, date, population, new_vaccinations
from world_covid_vacc
WHERE length(continent) > 0 
order by 2,3;

#List of countries with no information on covid vaccination
select continent, location, date, population, new_vaccinations
from world_covid_vacc
WHERE length(continent) > 0 
or new_vaccinations is null 
AND new_vaccinations > 0
order by 2,3;

select continent, location, date, population, new_vaccinations
from world_covid_vacc
WHERE length(continent) > 0 
and new_vaccinations = 0 
order by 2,3;

#List of countries that have been vaccination during 2020
select continent, location, date, population, new_vaccinations
from world_covid_vacc
WHERE length(continent) > 0 
AND new_vaccinations > 0
order by 2,3;

#List of countries that werent vaccination during 2020
select continent, location, date, population, new_vaccinations,
sum(new_vaccinations) over (partition by  location) as Vacc_location
from world_covid_vacc
WHERE length(continent) > 0 
and new_vaccinations = 0 
order by 2,3;

#List of countries that have been vaccination during 2021
select continent, location, date, population, new_vaccinations,
sum(new_vaccinations) over (partition by location) as Vacc_location
from world_covid_vacc
WHERE length(continent) > 0 
and new_vaccinations = 0 
group by continent
order by 2,3;

#Average vaccination of population across year
With PopvsVac (Continent, Location, Date, Population, new_vaccination, RollingPeopleVaccinated) 
as
(
select world_covid.continent, world_covid.location, world_covid.date, world_covid.population, world_covid_vacc.new_vaccinations,
sum(world_covid_vacc.new_vaccinations) over (partition by location order by location) as RollingPeopleVaccinated
from world_covid
join world_covid_vacc
on world_covid.location=world_covid_vacc.location
and world_covid.date = world_covid_vacc.date
WHERE length(world_covid.continent) > 0 
)
Select *
from PopvsVac;

With PopvsVac (Continent, Location, Date, Population, new_vaccination, RollingPeopleVaccinated) 
as
(
select continent, location, date, population, new_vaccinations,
sum(world_covid_vacc.new_vaccinations) over (partition by location order by location) as RollingPeopleVaccinated
from world_covid_vacc
WHERE length(continent) > 0 
)
Select *
from PopvsVac;

#Moving average of vaccination percentage of population across year
With PopvsVac (Continent, Location, Date, Population, new_vaccination, RollingPeopleVaccinated) 
as
(
select distinct continent, location, date, population, new_vaccinations,
sum(world_covid_vacc.new_vaccinations) over (partition by location order by location) as RollingPeopleVaccinated
from world_covid_vacc
WHERE length(continent) > 0 
)
Select *, (RollingPeopleVaccinated/Population)*100 as VaccinationacrossYear
from PopvsVac;

#Temp table
Drop table if exists $PercentPopulationVaccinated;
create table $PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
date date,
population int(20),
new_vaccination int(10),
RollingPeopleVaccinated int(10)
);
Insert into $PercentPopulationVaccinated
select continent, location, date, population, new_vaccinations,
sum(world_covid_vacc.new_vaccinations) over (partition by location order by location) as RollingPeopleVaccinated
from world_covid_vacc
WHERE length(continent) > 0 ;
Select *, (RollingPeopleVaccinated/Population)*100 as VaccinationacrossYear
from $PercentPopulationVaccinated;

#creating view to stroe data for later visulaisation
create view PercentPopulationVaccinated as 
select continent, location, date, population, new_vaccinations,
sum(world_covid_vacc.new_vaccinations) over (partition by location order by location) as RollingPeopleVaccinated
from world_covid_vacc
WHERE length(continent) > 0 ;
