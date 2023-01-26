USE Pubs19118133
GO

CREATE PROCEDURE TitlesQty 
@state varchar(2) = '%'
AS 
	SELECT title, stor_name,st.state,SUM(s.qty) as SumOfQty
	FROM titles t inner join sales s on t.title_id = s.title_id
					inner join stores st on st.stor_id = s.stor_id
	WHERE st.state LIKE @state 
	GROUP BY title, stor_name,st.state

EXEC TitlesQty @state = 'CA'

EXEC TitlesQty 

CREATE PROCEDURE JobEmpAvg
AS 
	SELECT job_desc,min_lvl,max_lvl,AVG(e.job_lvl) as AVG_JOB_LVL
	FROM jobs j inner join employee e on j.job_id = e.job_id
	GROUP BY job_desc,min_lvl,max_lvl

EXEC JobEmpAvg

CREATE PROCEDURE  AuthorName
@au_id varchar(11),
@au_name varchar(60) = ''OUTPUT
AS 
	SELECT @au_name = au_fname + ' ' + au_lname
	FROM authors
	WHERE au_id  = @au_id
RETURN

DECLARE @author_name varchar(60)
EXEC AuthorName @au_id = '807-91-6654',@au_name = @author_name OUTPUT
PRINT @author_name

CREATE PROCEDURE EmployeeName
@emp_id char(9),
@emp_name varchar(60) = '' OUTPUT
AS
	SELECT @emp_name = fname + ' ' + lname
	FROM employee
	WHERE emp_id = @emp_id
RETURN 


DECLARE @empl_name varchar(60)
EXEC EmployeeName @emp_id = 'KJJ92907F', @emp_name = @empl_name OUTPUT
PRINT @empl_name

CREATE PROCEDURE UpdatePayment
@multiplier numeric(10,4)
AS 
UPDATE employee		
SET job_lvl = CASE 
				when (job_lvl * @multiplier)>
				(SELECT max_lvl FROM jobs WHERE jobs.job_id = employee.job_id)
				then (SELECT max_lvl FROM jobs WHERE jobs.job_id = employee.job_id)
				else CAST((job_lvl*@multiplier)as tinyint)
				end


EXEC UpdatePayment 1.15

EXEC UpdatePayment 0.85

CREATE PROCEDURE UpdatePrice
@multiplier numeric (10,4),
@type char(12)
AS 
UPDATE titles
SET price = price*@multiplier
WHERE @type = type AND price IS NOT NULL

EXEC UpdatePrice 1.20,'Business'

CREATE PROCEDURE InsertPublishers 
@pub_id char(4),
@pub_name varchar(40) = NULL, 
@city varchar(20) = NULL,
@state char(2) = NULL,
@country varchar(30) = NULL
AS 
	BEGIN 
	DECLARE @msg nvarchar(40)
	BEGIN TRY 
		INSERT INTO publishers
		VALUES (@pub_id,@pub_name,@city,@state,@country)
	END TRY 
	BEGIN CATCH 
		SET @msg  = N'Записън не може да бъде добавен.';
		THROW 51000,@msg, 1
	END CATCH
END

EXEC InsertPublishers '1234','New Publisher','Atlanta','GA'

CREATE PROCEDURE InsertStores
@stor_id char(4),
@stor_name varchar(40) = NULL,
@stor_address varchar(40) = NULL,
@city varchar(20) = NULL,
@state char(2) = NULL,
@zip char(5)
AS 
	BEGIN 
	DECLARE @msg nvarchar(40)
	BEGIN TRY 
		INSERT INTO stores
		VALUES(@stor_id, @stor_name,@stor_address,@city,@state,@zip)
	END TRY 
	BEGIN CATCH 
	SET @msg  = N'Cant be added new rows';
	THROW 51000,@msg,1
	END CATCH 
END

EXEC InsertStores '1111','NESHTO SI','NQKYDE SI','SOFIA','CA','55555'

CREATE PROCEDURE DeletePublishers 
@pub_id char(4)
AS 
BEGIN 
	DECLARE @msg nvarchar(40), @exists int 
	SELECT @exists = COUNT(*) FROM publishers
	WHERE pub_id = @pub_id
	IF @exists = 0
		BEGIN 
		SET @msg = N'The row doesnt exist';
		THROW 52000,@msg,1
		RETURN 
		END 
	BEGIN TRY 
		DELETE FROM publishers
		WHERE pub_id = @pub_id
	END TRY 
	BEGIN CATCH 
		SET @msg = N'The row cant be deleted.';
		THROW 53000, @msg,1
	END CATCH 
END

EXEC DeletePublishers '1234' 

EXEC DeletePublishers '0736' 

CREATE PROCEDURE DeleteStores
@stor_id char(4)
AS 
BEGIN 
	DECLARE @msg nvarchar(40), @exists int 
	SELECT @exists = count(*) FROM stores 
	WHERE stor_id = @stor_id 
	IF @exists = 0 
	BEGIN 
	SET @msg = N'The row doesnt exists.';
	THROW 52000,@msg,1
	RETURN 
	END 
	BEGIN TRY 
	DELETE FROM stores
	WHERE stor_id = @stor_id
	END TRY 
	BEGIN CATCH 
	SET @msg = N'The row cant be deleted';
	THROW 53000,@msg,1
	END CATCH 
END

EXEC DeleteStores '1234'
