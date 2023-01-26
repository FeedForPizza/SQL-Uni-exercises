USE Pubs19118133
GO 

DECLARE @job_desc varchar(50)
SET @job_desc = 'Designer'
PRINT @job_desc 

DECLARE @pub_name varchar(40)
SET @pub_name = 'Binnet & Hardley'
PRINT @pub_name

DECLARE @job_id smallint 
SELECT @job_id = job_id
FROM jobs
WHERE job_desc = 'Designer'
PRINT @job_id

DECLARE @pub_id char (4)
SELECT @pub_id = pub_id
FROM publishers
WHERE pub_name = 'New Moon Books'
PRINT @pub_id

DECLARE @job_id smallint 
SELECT @job_id=job_id 
FROM jobs
WHERE job_desc = 'Publisher'
SELECT *
FROM employee
WHERE job_id = @job_id

DECLARE @pub_id char (4)
SELECT @pub_id = pub_id
FROM publishers
WHERE pub_name = 'Binnet & Hardley'
SELECT *
FROM titles
WHERE @pub_id = @pub_id

DECLARE @message nvarchar(50)
SET @message = N'Най-ниското заплащане е '
SELECT @message = @message + CAST(MIN(job_lvl)AS nvarchar(5))
FROM employee
PRINT @message 

DECLARE @message nvarchar(50)
SET @message = N'Най-високата стойност напродажбите е '
SELECT @message = @message + CAST(MAX(ytd_sales)AS nvarchar(10))
FROM titles
PRINT @message 

DECLARE @message nvarchar(50)
SELECT @message = CONVERT(nvarchar(50),hire_date,104)
FROM employee
WHERE lname = 'Muller'
PRINT @message

DECLARE @message nvarchar(50)
SELECT @message = CONVERT(nvarchar(50),pubdate,104)
FROM titles 
WHERE title = 'Life Without Fear'
PRINT @message

DECLARE @title_id varchar(6)
SET @title_id = 'BU1032'
IF(SELECT COUNT(*)
	FROM titleauthor ta
	WHERE @title_id = title_id) > 1
	SELECT title, title_id, N'Книгата има повече от един автор' AS authors 
	FROM titles
	WHERE title_id = @title_id

DECLARE @title_id varchar(6), @authors nvarchar(40)
SET @title_id = 'BU2075'
IF(SELECT COUNT(*)
	FROM titleauthor 
	WHERE title_id = @title_id) > 1
	SET @authors = N'Книгата има повече от един автор'
	ELSE 
	SET @authors =  N'Книгата има само един автор'
SELECT title_id, title,@authors as authors
FROM titles
WHERE title_id = @title_id

DECLARE @pub_id char(4)
SET @pub_id  = '0877'
IF (SELECT COUNT(*)
	FROM titles
	WHERE pub_id = @pub_id) > 1
	SELECT pub_id,pub_name, N'Издателството е издало повече от една книги' as publishers
	FROM publishers
	WHERE pub_id = @pub_id

DECLARE @pub_id char(4), @books nvarchar(40)
SET @pub_id = '1622'
IF(SELECT COUNT(*)
	FROM titles
	WHERE @pub_id = pub_id) > 1
	SET @books =  N'Издателството е издало поне една книга'
ELSE 
	SET @books = N'Издателството не издало нито една книга'
SELECT pub_id,pub_name,@books as publishedBooks 
FROM publishers
WHERE pub_id = @pub_id

DECLARE @title_id varchar(6),@sales nvarchar(40),@qty int 
SET @title_id = 'PS2091'
IF NOT EXISTS(SELECT *
	FROM sales
	WHERE @title_id = title_id) 
SET @sales =  N'Книгата няма продажби.'
ELSE 
BEGIN
	SELECT @qty = SUM(qty)
	FROM sales
	WHERE title_id = @title_id
	SET @sales = N'От книгата са продадени '+ CAST(@qty AS varchar) +' броя.'
END
SELECT title_id,title,@sales AS NumOfBooksSold
FROM titles
WHERE title_id = @title_id

DECLARE @pub_id char(4), @books nvarchar (40),@count int 
SET @pub_id = '1622'
IF NOT EXISTS (SELECT *
				FROM titles
				WHERE @pub_id = pub_id)
				SET @books = N' Издателството няма издадени книги.'
ELSE 
	BEGIN 
		SELECT @count = COUNT(*)
		FROM titles
		WHERE pub_id = @pub_id
		SET @books = N'Издателството има издадени '+ CAST(@count AS varchar)+'книги.'
	END
SELECT pub_id, pub_name, @books as Books
FROM publishers
WHERE pub_id = @pub_id

DECLARE @job_id smallint = 1, @count smallint, @job_desc nchar(30),@message nvarchar(80)
WHILE(@job_id < 16 )
BEGIN
	SELECT @job_desc = job_desc
	FROM jobs
	WHERE job_id = @job_id
	SELECT @count = COUNT(*)
	FROM employee
	WHERE job_id = @job_id
	IF @count = 0 
		SET @message = @job_desc + N' - няма назначени служители'
	ELSE 
		SET @message = @job_desc + N' - има назначени ' + CAST(@count as nvarchar)
	PRINT @message 
	SET @job_id = @job_id + 1 
END

DECLARE @job_id smallint = 1, @avg money, @job_desc nchar(30), @message nvarchar(80)
WHILE (@job_id<16)
BEGIN 
	SELECT @job_desc  = job_desc
	FROM jobs 
	WHERE job_id = @job_id
	SELECT @avg = AVG(job_lvl)
	FROM employee
	WHERE job_id = @job_id
	SET @message = @job_desc + N' - средна заплата ' + CAST(@avg AS nvarchar)
	PRINT @message 
	SET @job_id = @job_id +1
END

BEGIN TRY 
	INSERT INTO publishers
	VALUES('1622','Five Lakes Publishing','Chicago','IL','USA')
END TRY 
BEGIN CATCH 
	THROW 51000, N'Записът не може да бъде добавен!',1
END CATCH

BEGIN TRY 
	DELETE FROM states 
	WHERE state_id = 'IL'
END TRY 
BEGIN CATCH 
	THROW 52000, N'Записът не може да бъде изтрит!',1
END CATCH

SELECT job_desc,min_lvl,max_lvl,ROUND(AVG(CAST(job_lvl AS money)),2) AS AVG_LVL 
FROM jobs j INNER JOIN employee e ON j.job_id = e.job_id
GROUP BY job_desc,min_lvl,max_lvl

SELECT type, ROUND(AVG(CAST(ISNULL(price,0)AS money )),2)AS price
FROM titles 
GROUP BY type

SELECT MAX(LEN(REPLACE(CONCAT(fname,' ',minit,' ',lname),'    ','  '))) as FullName
FROM employee

DECLARE @year int, @month tinyint = 1, @date date 
SET @year = YEAR(GETDATE())
SET @date = DATEFROMPARTS(@year,@month,1)
PRINT @year
WHILE @month<13
BEGIN 
		PRINT CAST(FORMAT(@date,'MMMM','bg-bg')AS char(10)) +
		' - '+ CAST(DAY(EOMONTH(@date)) AS char(2)) + ' дни'
	SET @month = @month + 1
	SET @date = DATEADD(mm,1,@date)
END

DECLARE @greeting nvarchar(100),@name nvarchar(80), @time tinyint 
SET @time = CAST(DATEPART(hour, GETDATE())AS tinyint)
SET @greeting = 'Good '+ 
		IIF(@time<12,'morning',
		IIF(@time<17,'afternoon',
		IIF(@time<21,'evening','night')))
SET @name = IIF(CHARINDEX('\',SYSTEM_USER)= 0,
	SYSTEM_USER,
	SUBSTRING(SYSTEM_USER,
	CHARINDEX('\',SYSTEM_USER)+1,80))
SET @greeting = CONCAT(@greeting, ' ', @name + '!')
PRINT @greeting

