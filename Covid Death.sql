drop table if exists World_covid;
repair table world_covid;

Create table World_covid(
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
#View table content
select *
from world_covid
WHERE length(continent) > 0; 

#View covid death by country
select Location, date, total_cases, new_cases, total_deaths, population
from world_covid
WHERE length(continent) > 0 
order by 1,2;

#Table showing percentage of COVID deaths by country in ascending order
select Distinct Location, min(date), max(date),
count(total_cases) as total_cases_countries, 
count(new_cases) as total_new_cases,
count(total_deaths) as total_ann_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
from world_covid 
WHERE length(continent) > 0 
Group by 1
Order by 1; 

select Distinct Location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
from world_covid 
WHERE length(continent) > 0 
Order by 1; 

select location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
from world_covid
WHERE length(continent) > 0 
Order by 1,2;

#Table showing percentage of COVID deaths in Nigeria in ascending order
select location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
from world_covid
where location like '%Nigeria%'
Order by 1,2;

#Table showing percentage of COVID deaths in Italy in ascending order
select location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
from world_covid
where location like '%Italy%'
Order by 1,2;

#Table showing percentage of COVID deaths in the UK in ascending order
select location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
from world_covid
where location like '%Kingdom%'
Order by 1,2;

select distinct location, date, population,total_cases, total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
from world_covid
where location like '%Kingdom%'
Order by 1,2;

#Table showing percentage of population infected in the UK in ascending order
select location, date, total_cases, population,
(total_cases/population)*100 as Percentagepolulationinfected
from world_covid
where location like '%Kingdom%'
Order by 1,2;

#highest infection rate
select Location, population, 
max(total_cases) as highestinfectioncount,
max((total_cases/population))*100 as Percentagepolulationinfected
from world_covid
WHERE length(continent) > 0 
Group by 1,2
Order by Percentagepolulationinfected desc;

#Countries with highest death count per population
select Location,
max((total_deaths)) as TotalDeathCount
from world_covid
WHERE length(continent) > 0 
Group by 1
Order by TotalDeathCount desc;

#Total Death by continents
select continent,
max((total_deaths)) as TotalDeathCount
from world_covid
WHERE length(continent) > 0 
Group by 1
Order by TotalDeathCount desc;

select location,
max((total_deaths)) as TotalDeathCount
from world_covid
WHERE continent is not null
Group by 1
Order by TotalDeathCount desc;

#showing the continent with the highest deathcount
#Death by continents
select continent,
max((total_deaths)) as TotalDeathCount
from world_covid
WHERE length(continent) > 0 
Group by 1
Order by TotalDeathCount desc;

select distinct continent, location, population 
from world_covid
WHERE length(continent) > 0 
group by 1,2;

#Global numbers
select date, total_cases, total_deaths,
(total_deaths/population)*100 as DeathPercentage
from world_covid
WHERE length(continent) > 0 
group by 1
order by 1,2;

#Percentage of deaths across 2020 by country
select date, sum(new_cases) as case_sum, sum(new_deaths) as death_sum,
sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from world_covid
WHERE length(continent) > 0 
group by 1
order by 1,2;

select date, location, sum(new_cases) as case_sum, sum(new_deaths) as death_sum,
sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from world_covid
WHERE length(continent) > 0 
group by 1,2
order by 1,2;

select date, sum(new_cases) as case_sum, sum(new_deaths) as death_sum,
sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from world_covid
WHERE length(continent) > 0 
group by 1
order by 1,2;

select date, sum(new_cases) as case_sum, sum(new_deaths) as death_sum,
sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from world_covid
WHERE length(continent) > 0 
order by 1,2;
