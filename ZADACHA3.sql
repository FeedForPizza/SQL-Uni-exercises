USE Pubs19118133
GO

SELECT *
FROM authors
WHERE state = 'CA' AND contract = 'True'

SELECT *
FROM authors
WHERE city  = 'Oakland'

SELECT *
FROM employee
WHERE job_id = 9 AND fname LIKE 'Mar%'

SELECT *
FROM employee 
WHERE fname LIKE 'Ann%'

SELECT fname, lname, job_lvl 
FROM employee
WHERE job_lvl BETWEEN 150 AND 200

SELECT fname,lname, job_lvl
FROM employee
WHERE job_lvl > 200

SELECT fname, lname, job_id 
FROM employee
WHERE job_id in (6,12,14)

SELECT fname, lname, job_id
FROM employee
WHERE job_id > 9 AND job_id != 12 AND job_id != 14 AND job_id !=15

SELECT title, year(pubdate) AS Year_Of_Publication, price, (ytd_sales * price) AS Sales_Value
FROM titles

SELECT (fname+''+minit+''+lname)AS FullName, year(hire_date) AS Year_Of_Hire
FROM employee

SELECT DISTINCT city, state 
FROM authors

SELECT DISTINCT type
FROM titles

SELECT fname, lname, job_id 
FROM employee
WHERE job_id = 5 
ORDER BY fname, lname ASC 

SELECT au_fname,au_lname, phone
FROM authors
WHERE contract  = 'True'
ORDER BY au_fname, au_lname ASC

SELECT job_desc, fname, lname, hire_date
FROM jobs j INNER JOIN employee e ON j.job_id = e.job_id
ORDER BY job_desc ASC, hire_date DESC 


SELECT (t.pubdate) AS Date_Of_publishing, title,price,pub_name AS publisher_name
FROM titles t INNER JOIN publishers p ON t.pub_id = p.pub_id
ORDER BY publisher_name DESC

SELECT e.fname,e.lname,e.hire_date,j.job_desc,p.pub_name
FROM jobs j INNER JOIN employee e ON j.job_id = e.job_id
			INNER JOIN publishers p ON e.pub_id = p.pub_id
WHERE YEAR(e.hire_date) = 1990

SELECT title, pub_name AS publisher_name, city, state AS State_name
FROM titles t INNER JOIN publishers p ON t.pub_id= p.pub_id
				INNER JOIN states s ON S.state_id = P.state

SELECT job_desc, min_lvl, max_lvl, AVG(e.job_lvl) as AVG_LVL
FROM jobs j INNER JOIN employee e ON j.job_id = e.job_id
GROUP BY job_desc, min_lvl, max_lvl
ORDER BY job_desc

SELECT title, type, COUNT(ta.au_id) AS num_of_aut
FROM titles t  INNER JOIN titleauthor ta ON t.title_id = ta.title_id
GROUP BY title, type
ORDER BY title 

SELECT title, price, SUM(qty) AS qty_sum
FROM titles t LEFT OUTER JOIN sales s ON t.title_id = s.title_id
GROUP BY title, price

SELECT job_desc, SUM(e.job_id)
FROM jobs j LEFT JOIN employee e ON j.job_id = e.job_id
GROUP BY job_desc

SELECT title, stor_name, state, sum(qty) as QTY_SUM 
FROM titles t INNER JOIN sales s ON t.title_id = s.title_id
			INNER JOIN stores st ON s.stor_id = st.stor_id
GROUP BY title, st.stor_name, st.state
HAVING SUM(qty) >= 50
ORDER BY title

SELECT job_desc, pub_name, AVG(job_lvl)
FROM jobs j INNER JOIN employee e ON j.job_id = e.job_id
			INNER JOIN publishers p ON p.pub_id = e.pub_id
GROUP BY job_desc, pub_name
HAVING AVG(job_lvl) > 200 