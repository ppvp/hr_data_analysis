ALTER SCHEMA public RENAME TO prelim;

-- Checking for duplicate values

with cte as (
select *, row_number() over (partition by employee_id, department, region, education, gender, age, is_promoted, avg_training_score) as dup_rank
from prelim.hr_sql
)
select * from cte
where dup_rank > 1;

-- Number of personnel by department

select department, 
	   count(*) as dep_cnt
from prelim.hr_sql
group by department
order by dep_cnt desc;

-- Number of personnel by region

select region, 
	   count(*) as reg_cnt
from prelim.hr_sql
group by region
order by reg_cnt desc;

-- Number of personnel by gender

select replace(replace(gender, 'm', 'Male'), 'f', 'Female'),
	   count(*) as gen_cnt,
	   round(count(*) * 100.0 / sum(count(*)) OVER (), 2) AS percentage
from prelim.hr_sql
group by gender
order by gen_cnt desc;

-- Number of personnel by age brackets

with cte as (
select
		case when age between 20 and 25 then '20-25' 
			when age between 25 and 30 then '25-30' 
			when age between 30 and 35 then '30-35' 
			when age between 35 and 40 then '35-40' 
			when age between 40 and 45 then '40-45' 
			when age between 45 and 50 then '45-50' 
			when age between 50 and 55 then '50-55' 
			when age between 55 and 60 then '55-60' 
			when age > 60 then '60+'
		else '' end as age_brackets
from prelim.hr_sql
)
select age_brackets, count(*)
from cte
group by age_brackets
order by age_brackets asc;

-- Number of personnel by education [NULL values omitted]

select education, 
	   count(*) as edu_cnt,
	   round(count(*) * 100 / sum(count(*)) over (), 2) as pct_edu
from prelim.hr_sql
where education is not null
group by education
order by edu_cnt desc

-- Average training score by department

select department, round(avg(avg_training_score), 2) as avg_training
from prelim.hr_sql
group by department
order by avg_training desc;

-- Number of personnel by length of service

select length_of_service, count(*) as serv_cnt
from prelim.hr_sql
group by length_of_service
order by length_of_service, serv_cnt desc;

-- Youngest and oldest hire

select min(age - length_of_service) as min_age_join, max(age - length_of_service) as max_age_join
from prelim.hr_sql

-- Recruitment channel distribution

select recruitment_channel, count(*) as rec_cnt
from prelim.hr_sql
group by recruitment_channel
order by rec_cnt desc

-- Number of trainings by department

select department,  count(no_of_trainings) as n_train
from prelim.hr_sql
group by department
order by n_train desc

-- Average age

select ceiling(avg(age)) as avg_age
from prelim.hr_sql

-- Total number of employees

select count(*) as num_emp
from prelim.hr_sql

-- Average tenure

select ceiling(avg(length_of_service)) as average_tenure
from prelim.hr_sql 

