CREATE FUNCTION BGDay (@date date)
RETURNS nvarchar(10)
as 
begin 
	declare @bgday nvarchar(10)
	set @bgday = FORMAT(@date, 'dddd', 'bg-bg')
	RETUrN @bgday
end 

declare @date date, 
		@day tinyint = 1 
SET @date = GetDate()
WHILE @day<8
BEGIN 
	PRINT dbo.BGDay(@date)
	set @day = @day +1 
	set @date = DateAdd(dd,1,@date)
end

drop function dbo.Emp_name

create function dbo.Emp_name (@emp_id char(9))
returns varchar(35)
as 
begin 
	declare @emp_name varchar(35)
	select @emp_name = fname +' '+minit+' '+ lname 
	from employee
	where emp_id = @emp_id
	IF @emp_name is null 
		set @emp_name = ' '
	ELSE 
		SET @emp_name = REPLACE(@emp_name,' ','  ')
	RETURN @emp_name
END

Select dbo.Emp_name('FFFF') as fullname 

SELECT emp_id, dbo.Emp_name(emp_id) as fullname 
FROM employee
where year(hire_date) <= 1993

create function dbo.Au_name(@au_id varchar(11))
returns varchar(35)
as 
begin 
	declare @au_name varchar(35)
	select @au_name = au_fname + ' ' + au_lname
	from authors
	where au_id = @au_id 
	IF @au_name IS NULL 
	SET @au_name = ''
	RETURN @au_name 
end

select au_id, dbo.Au_name(au_id) as fullname 
from authors
where state = 'CA'
ORDER BY fullname

drop function Avg_job_lvl

create function dbo.avg_job_lvl (@job_desc varchar(50))
returns money 
as 
begin 
	declare @avg_job_lvl money 
	select @avg_job_lvl = avg(cast(job_lvl as money))
	from employee e
		inner join jobs j on e.job_id = j.job_id
	where job_desc = @job_desc 
	IF @avg_job_lvl IS NULL 
		SET @avg_job_lvl = 0 
	return @avg_job_lvl
end

select dbo.avg_job_lvl('Designer') as newcolon

select job_id, job_desc, dbo.avg_job_lvl(job_desc) as newcolon 
from jobs

select emp_id,dbo.Emp_name(emp_id) as fullname, e.job_lvl,job_desc
from employee e inner join jobs j on e.job_id = j.job_id
where job_lvl > dbo.avg_job_lvl(job_desc)

drop function dbo.sum_title_sales
create function dbo.sum_title_sales(@title_id varchar(6))
returns money 
as 
begin 
	declare @sts money 
	select @sts = qty * price 
	from titles t inner join sales s on t.title_id = s.title_id
	where t.title_id = @title_id
	IF @sts IS NULL 
	SET @sts = 0 
	RETURN @sts 
END

select title_id,title,price, dbo.sum_title_sales(title_id) as sumtitle
from titles

create function dbo.sum_title_qty (@state char(2))
RETURNS TABLE 
AS 
RETURN 
(SELECT t.title, st.stor_name, st.state, SUM(qty) AS sum_qty
from sales s inner join stores st on s.stor_id = st.stor_id
			inner join titles t on t.title_id = s.title_id
WHERE state LIKE @state
GROUP BY t.title, st.stor_name, st.state)

SELECT * FROM dbo.sum_title_qty('WA')







