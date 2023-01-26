USE Pubs19118133
GO

INSERT INTO jobs
(job_desc,min_lvl,max_lvl)
VALUES('Proofreader',25 ,100)


SET IDENTITY_INSERT jobs ON 
INSERT INTO jobs 
(job_id,job_desc,min_lvl,max_lvl)
VALUES(16,'Office Assistant', 25,100)

INSERT INTO sales 
SELECT stor_id,'P3087b','19930704',qty, payterms,title_id
FROM sales 
WHERE ord_num = 'P3087a'

INSERT INTO employee
(emp_id,fname,minit,lname,job_id,job_lvl,pub_id,hire_date)
VALUES('JPD57355M','John','P','Davis',15,35,'9952','20010228')

INSERT INTO publishers
(pub_id,pub_name,city,state,country)
VALUES('9934','Random House Inc.','New York','NY','USA')

UPDATE authors 
SET address = '13 Howard St.'
WHERE au_lname = 'Gringlesby'

UPDATE employee
SET job_lvl = job_lvl * 1.1
WHERE job_id  = (SELECT job_id FROM jobs WHERE job_desc = 'Designer')
	AND job_lvl * 1.1 < (SELECT max_lvl FROM jobs WHERE job_desc = 'Designer')

UPDATE employee 
SET job_lvl = job_lvl * 1.1 
FROM employee e INNER JOIN jobs j ON e.job_id=j.job_id
WHERE J.job_desc = 'Designer' AND job_lvl * 1.1 <max_lvl

UPDATE employee
SET job_lvl = (SELECT MAX(job_lvl) FROM employee WHERE job_id = 7)
WHERE job_id = 7

UPDATE stores
SET stor_address = '74 Lark Ave.'
WHERE stor_address = 'News & Brews'

DELETE FROM jobs 
WHERE job_desc = 'Office Assistant'

DELETE FROM publishers 
WHERE pub_name  = 'Random House Inc.'

