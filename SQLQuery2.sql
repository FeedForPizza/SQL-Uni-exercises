USE Pubs19118133

DECLARE @job_id smallint 
SELECT @job_id = job_id
FROM jobs
WHERE job_desc = 'Publisher'
SELECT *
FROM employee 
WHERE job_id = @job_id

DECLARE @pub_id char(4)
select @pub_id = pub_id 
from publishers
where pub_name = 'Binnet & Hardley'
select *
from titles 
where pub_id = @pub_id

declare @msg nvarchar(50)
set @msg = N'Най-ниското заплащане е '
select @msg =  @msg + CAST(MIN(JOB_LVL) AS nvarchar(5))
from employee
print @msg

declare @msg nvarchar(50)
set @msg = N'Най-високата стойност на продажбите е '
select @msg = @msg + CAST(MAX(ytd_sales) AS nvarchar(10))
from titles 
print @msg 

declare @msg nvarchar(50)
select @msg = CONVERT(nvarchar(50),hire_date,104)
from employee
where lname = 'Muller'
print @msg

declare @msg nvarchar(50)
select @msg  = CONVERT(nvarchar(50),pubdate,104)
from titles 
where title = 'Life Without Fear'
print @msg 

declare @title_id varchar(6)
set @title_id  = 'BU1032'
IF(select count(*)
	from titleauthor
	where title_id = @title_id)>1 
	select title_id,title, N'Книгата има повече от един автор'AS NumOfAuthors
	from titles
	WHERE @title_id = title_id

declare @title_id varchar(6), @authors nvarchar(40)
set @title_id = 'BU2075'
IF (select count(*)
	from titleauthor
	where title_id = @title_id)>1 
	set @authors = N'Книгата има повече от един автор'
ELSE 
	set @authors = 'Книгата има само един автор'
select title_id,title,@authors as authors
from titles
where title_id = @title_id


declare @pub_id char(4)
set @pub_id = '0877'
IF (select count(*)
	from titles 
	where pub_id = @pub_id) > 1 
	select pub_id,pub_name,N'Издателството е издало повече от една книги' as pub_books
	from publishers
	where pub_id = @pub_id

declare @pub_id char(4), @books nvarchar(40)
set @pub_id = '1622'
IF (SELECT COUNT(*)
	FROM titles
	where pub_id = @pub_id)>1
	set @books  = N'Издателството е издало поне една книга'
ELSE 
	set @books= N'Издателството не издало нито една книга'
select pub_id, pub_name,@books as books 
from publishers
where pub_id = @pub_id


declare @job_id smallint = 1, @count smallint, @job_desc nchar(30), @msg nvarchar(80)
while @job_id<16
	begin 
		select @job_desc  = job_desc 
		from jobs 
		where job_id = @job_id 
		select @count = count(*)
		from employee 
		where job_id = @job_id
		IF @count = 0 
			set @msg = @job_desc + N' - няма назначени служители'
		ELSE 
			set @msg =  @job_desc + N' - има назначени' + CAST(@count as nvarchar)
		print @msg 
		set @job_id = @job_id + 1 
	end

declare @job_id smallint = 1 , @avg money, @job_desc nchar(30),@msg nvarchar(80)
while @job_id < 16 
	begin 
		select @job_desc = job_desc
		from jobs 
		where job_id = @job_id 
		select @avg = avg(job_lvl)
		from employee
		where job_id = @job_id 
		set @msg = @job_desc + N' - средна заплата ' + CAST(@avg as nvarchar)
		print @msg 
		set @job_id = @job_id + 1
	end 

select job_desc, min_lvl, max_lvl, ROUND(AVG(CAST(job_lvl AS money)),2) as avg_job_lvl
from jobs j inner join employee e on j.job_id = e.job_id
GROUP BY job_desc, min_lvl, max_lvl

select type, round(AVG(CAST(ISNULL(price,0) AS money)),2) as avg_price
from titles
GROUP BY type 

select MAX(LEN(REPLACE(CONCAT(fname,' ',minit,' ', lname), ' ','   ')))
from employee

select MAX(LEN(CONCAT(au_fname, ' ', au_lname))) AS MAXNAME,MIN(LEN(CONCAT(au_fname, ' ', au_lname))) AS MINNAME
from authors






