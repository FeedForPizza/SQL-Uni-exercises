USE Pubs19118133
Go

SELECT job_desc, (SELECT COUNT(*)
					FROM employee e
					WHERE j.job_id = e.job_id) AS Num_of_emp
FROM jobs j 


SELECT title, type, (SELECT COUNT(*)
					FROM titleauthor ta
					WHERE t.title_id = ta.title_id) AS Count_Of_Authors
FROM titles t

SELECT title, type 
FROM titles t
WHERE (SELECT COUNT(*)
		FROM titleauthor ta
		WHERE t.title_id = ta.title_id) > 1

SELECT title, type 
FROM titles t 
WHERE title_id NOT IN (SELECT s.title_id FROM sales s)

SELECT title, type 
FROM titles t 
WHERE NOT EXISTS (SELECT * FROM sales s
					WHERE t.title_id = s.title_id)

SELECT title, type 
FROM titles t
WHERE (SELECT COUNT(*)
		FROM sales s 
		WHERE t.title_id = s.title_id ) = 0

SELECT au_fname, au_lname
FROM authors au
WHERE au_id NOT IN (SELECT t.au_id  FROM titleauthor t )

SELECT au_fname, au_lname
FROM authors au
WHERE NOT EXISTS(SELECT * FROM titleauthor ta
				WHERE ta.au_id = au.au_id)

SELECT au_fname, au_lname
FROM authors au
WHERE (SELECT COUNT(*) 
		FROM titleauthor ta
		WHERE ta.au_id = au.au_id) = 0

SELECT title, type, price 
FROM titles
WHERE type = 'Psychology' AND price > ANY (SELECT price FROM titles WHERE type = 'business')

SELECT fname, lname, job_lvl
FROM employee
WHERE job_id = 5 AND job_lvl > ANY(SELECT job_lvl 
									FROM employee
									WHERE job_id = 6 )

SELECT title, price, type 
FROM titles
WHERE type = 'Psychology' AND price > ALL (SELECT price FROM titles WHERE type = 'Business')

SELECT fname, lname, job_lvl
FROM employee 
WHERE job_id = 5 AND job_lvl > ALL (SELECT job_lvl FROM employee WHERE job_id = 6)

SELECT job_desc, job_id
FROM jobs j 
WHERE EXISTS (SELECT * 
				FROM employee e
				WHERE e.job_id = j.job_id)

SELECT state_id, state_name
FROM states s
WHERE EXISTS (SELECT * FROM stores st WHERE s.state_id = st.state )

SELECT ord_num,ord_date,must_be_paid  = 
			CASE payterms 
				WHEN 'On invoice' THEN ord_date
				WHEN 'Net 30' THEN ord_date+30
				WHEN 'Net 60' THEN ord_date+60
			END
FROM sales 

SELECT pub_id, pub_name, 
		CASE country 
		WHEN 'USA' THEN 'From USA'
		ELSE 'Outside USA'
		END AS USA_or_not
FROM publishers

SELECT au_fname, au_lname,  
		CASE contract 
		WHEN 'True' THEN 'Author has a contract'
		ELSE 'Author doesn''t have a contract'
		END AS Authors_with_contract
FROM authors

SELECT state
FROM publishers
WHERE country = 'USA'
UNION 
SELECT state 
FROM stores

SELECT state
FROM publishers
WHERE country = 'USA'
INTERSECT
SELECT state
FROM stores

SELECT state 
FROM publishers
WHERE country = 'USA'
EXCEPT 
SELECT state 
FROM stores

SELECT city 
FROM publishers
UNION 
SELECT city 
FROM stores

SELECT city 
FROM publishers
INTERSECT
SELECT city 
FROM stores

SELECT city 
FROM publishers
EXCEPT
SELECT city
FROM stores

CREATE VIEW EmployeeView
AS 
SELECT e.emp_id,e.fname,e.minit, e.lname,e.job_lvl,j.job_id, j.job_desc,p.pub_id,p.pub_name 
FROM employee e INNER JOIN jobs j ON e.job_id = j.job_id
				INNER JOIN publishers p ON e.pub_id = p.pub_id


CREATE VIEW SalesView
AS
SELECT s.ord_num,s.ord_date,s.qty,t.title_id,t.title,st.stor_id,st.stor_name
FROM sales s INNER JOIN titles t ON s.title_id = t.title_id
			INNER JOIN stores st ON st.stor_id = s.stor_id


ALTER VIEW EmployeeView 
AS 
SELECT e.emp_id,e.fname,e.minit, e.lname,e.job_lvl,j.job_id, j.job_desc,p.pub_id,p.pub_name
FROM employee e INNER JOIN jobs j ON e.job_id = j.job_id
				INNER JOIN publishers p ON e.pub_id = p.pub_id
WHERE country = 'USA'

ALTER VIEW SalesView 
AS
SELECT s.ord_num,s.ord_date,s.qty,t.title_id,t.title,st.stor_id,st.stor_name, t.price
FROM sales s INNER JOIN titles t ON s.title_id = t.title_id
			INNER JOIN stores st ON st.stor_id = s.stor_id


DROP VIEW EmployeeView

CREATE VIEW EmployeeView 
AS 
SELECT emp_id, fname, minit, lname, job_lvl, e.job_id, job_desc, e.pub_id,pub_name
FROM jobs j INNER JOIN employee e ON j.job_id = e.job_id
			INNER JOIN publishers p ON e.pub_id = p.pub_id

SELECT fname, lname, pub_name
FROM EmployeeView
WHERE job_desc = 'Designer'
ORDER BY fname, lname 

SELECT title, ord_num,qty,price,(qty*price) AS VALUE 
FROM SalesView
WHERE stor_id = '7131'
ORDER BY title, ord_num

SELECT au_fname, au_lname, ta.royaltyper, title, SUM(qty*price) AS SumOf
FROM authors a INNER JOIN titleauthor ta ON a.au_id = ta.au_id
				INNER JOIN SalesView sv ON sv.title_id = ta.title_id
GROUP BY au_fname,au_lname, royaltyper,title
ORDER BY au_fname,au_lname,title 

DROP VIEW SalesView

