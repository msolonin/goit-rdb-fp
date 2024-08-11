
-- 1
create schema pandemic;
use pandemic;

-- 2
create table countries (
    id int auto_increment primary key,
    Entity varchar(255),
    Code varchar(10)
) as
select distinct Entity, Code from infectious_cases;

create table infectious as
select ic.year, ic.Number_yaws, ic.polio_cases, ic.cases_guinea_worm,
ic.Number_rabies, ic.Number_malaria, ic.Number_hiv, ic.Number_tuberculosis,
ic.Number_smallpox, ic.Number_cholera_cases, c.id as country_id
from infectious_cases as ic
join countries as c
on ic.Entity = c.Entity;

-- 3
select ic.country_id, c.Entity, avg(ic.Number_rabies) as avg_rabies, min(ic.Number_rabies) as min_rabies,
    max(ic.Number_rabies) as max_rabies,
    sum(ic.Number_rabies) as sum_rabies
from infectious as ic
join countries as c
on ic.country_id = c.id
where ic.Number_rabies is not null and ic.Number_rabies != '' and c.Entity != 'World'
group by country_id
having avg(ic.Number_rabies)
order by avg_rabies desc
limit 10;

-- 4
select *, concat(year, '-01-01') as date, curdate() as now_date, timestampdiff(YEAR, concat(year, '-01-01'), curdate()) as year_difference
from infectious
where year is not null and year != '';

-- 5
drop function if exists dateDifference;
DELIMITER //
create function dateDifference(year_number int)
returns int
deterministic 
no sql
begin
    declare result int;
    set result = timestampdiff(YEAR, concat(year_number, '-01-01'), curdate());
    return result;
end //
DELIMITER ;
select *, dateDifference(year) as year_difference from infectious
