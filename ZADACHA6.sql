USE Pubs19118133
GO

CREATE FUNCTION [Pubs19118133].BGDay (@date date)
RETURNS nvarchar(10)
AS 
BEGIN 
	DECLARE @bgday nvarchar(10)
	SET @bgday = FORMAT(@date,'dddd','bg-bg')
	RETURN @bgday
END

DECLARE @date date,
@day tinyint = 1 
SET @date = GetDate()
WHILE @day < 8 
BEGIN 
	PRINT dbo.BGDay(@date)
	SET @day = @day +1
	SET @date = DateAdd(dd,1,@date)
END

SELECT fname, lname 
FROM employee
WHERE dbo.BGDay(hire_date) = N'сряда'

CREATE FUNCTION dbo.Emp_name (@emp_id char(9))
RETURNS varchar(35)
AS 
BEGIN
DECLARE @emp_name char(9)
SELECT @emp_name = fname + ' '+ minit + ' '+ lname
FROM employee
WHERE emp_id = @emp_id
IF @emp_name IS NULL 
	SET @emp_name  = '' 
ELSE 
	SET @emp_name = REPLACE(@emp_name, '   ', '   ')
RETURN @emp_name
END

SELECT dbo.Emp_name ('ARD36773F') as fullName 

SELECT dbo.Emp_name ('FFFF') as FullName

SELECT emp_id, dbo.Emp_name(emp_id) AS FULLNAME 
FROM employee
WHERE YEAR(hire_date)<=1993

CREATE FUNCTION dbo.Au_name (@au_id VARchar(11))
RETURNS varchar(35)
AS 
BEGIN 
DECLARE @aut_name char(9)
SELECT @aut_name = au_fname + ' '+ au_lname
FROM authors
WHERE au_id= @au_id
IF @aut_name IS NULL 
	SET @aut_name =''
RETURN @aut_name
END

SELECT au_id, dbo.Au_name(au_id) AS FULLNAME
FROM authors
WHERE state = 'CA'
ORDER BY FULLNAME

CREATE FUNCTION dbo.avg_job_lvl (@job_desc varchar(50))
RETURNS money
AS
BEGIN 
	DECLARE @avg_job_lvl money
	SELECT @avg_job_lvl = AVG(CAST(e.job_lvl as money))
	FROM employee e INNER JOIN jobs j ON e.job_id = j.job_id
	WHERE J.job_desc = @job_desc
	IF @avg_job_lvl IS NULL 
		SET @avg_job_lvl = 0 
	RETURN @avg_job_lvl
END
		

SELECT dbo.avg_job_lvl('Designer') AS AVG_LVL

SELECT job_id, job_desc, dbo.avg_job_lvl(job_desc) as avg_level
FROM jobs

SELECT e.emp_id, dbo.Emp_name(emp_id), e.job_lvl,j.job_desc
FROM employee e INNER JOIN jobs j ON e.job_id = j.job_id
WHERE e.job_lvl > dbo.avg_job_lvl(j.job_desc)

CREATE FUNCTION dbo.sum_title_sales (@title_id varchar(6))
RETURNS money 
AS 
BEGIN 
	DECLARE @sum_title_sales money
	SELECT @sum_title_sales = SUM(qty*price)
	FROM sales s INNER JOIN titles t ON s.title_id = t.title_id
	WHERE t.title_id = @title_id
	IF @sum_title_sales IS NULL 
		SET @sum_title_sales = 0
	RETURN @sum_title_sales
END

SELECT title_id,title, price, dbo.sum_title_sales(title_id)as sumofsales
FROM titles

CREATE FUNCTION dbo.Sum_title_qty(@state char(2))
RETURNS TABLE 
AS 
RETURN 
	(SELECT t.title, st.stor_name,st.state,SUM(s.qty) as SumOfqTY
	FROM titles t INNER JOIN sales s ON t.title_id = s.title_id
					INNER JOIN stores st ON st.stor_id = s.stor_id
	WHERE st.state = @state
	GROUP BY t.title,st.stor_name,st.state)

SELECT * FROM dbo.Sum_title_qty('WA')

CREATE FUNCTION dbo.Avg_job_emp (@job_desc varchar(50))
RETURNS TABLE 
AS 
RETURN 
	(SELECT job_desc,min_lvl,max_lvl,AVG(e.job_lvl) as AVG_LVL
	FROM jobs j INNER JOIN employee e ON j.job_id = e.job_id
	GROUP BY job_desc,min_lvl,max_lvl)

SELECT * FROM dbo.Avg_job_emp('%') 

CREATE FUNCTION dbo.Emp_dataA (@job_desc varchar(50))
RETURNS TABLE 
AS RETURN 
	(SELECT emp_id,fname,minit, lname,job_lvl,j.job_id,job_desc,p.pub_id,pub_name
	FROM employee E inner join jobs j on e.job_id = j.job_id
					inner join publishers p on p.pub_id = e.pub_id
	WHERE J.job_desc LIKE @job_desc)


SELECT * FROM dbo.Emp_data('Publisher')

SELECT * FROM dbo.Emp_dataA('%')

SELECT title,pubdate,fname,lname,e.pub_name
FROM titles t inner join dbo.Emp_data('Editor') e on t.pub_id = e.pub_id
WHERE YEAR(pubdate) = 1991
ORDER BY title

CREATE FUNCTION dbo.Sales_dataAA(@stor_id char(4))
RETURNS TABLE 
AS 
RETURN 
	(SELECT ord_num,ord_date,qty,t.title_id,title,price,st.stor_id,stor_name
	FROM sales s inner join titles t on t.title_id = s.title_id
				inner join stores st on st.stor_id = s.stor_id
	WHERE st.stor_id LIKE @stor_id)


SELECT * FROM dbo.Sales_data('7131')

SELECT * FROM dbo.Sales_dataAA('%')

SELECT au_fname,au_lname,royaltyper,title, SUM(sd.qty*sd.price)as SumOfVal
FROM authors a inner join titleauthor ta on a.au_id = ta.au_id
				inner join dbo.Sales_data('7131') sd on sd.title_id = ta.title_id 
GROUP BY au_fname,au_lname,royaltyper,title
ORDER BY au_fname,au_lname,title