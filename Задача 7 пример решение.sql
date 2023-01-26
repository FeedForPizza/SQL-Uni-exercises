CREATE TABLE SeafoodSales
(ProductID INT PRIMARY KEY,
ProductName NVARCHAR(40),
TotalQuantity INT,
AvgPrice money)

INSERT INTO SeafoodSales 
SELECT p.ProductID,p.ProductName,
SUM(od.Quantity) as SumOfQuantity,
AVG(od.UnitPrice) as AvgUnitPrice
FROM Products p INNER JOIN [Order Details] od 
on p.ProductID = od.ProductID
WHERE p.CategoryID=8
GROUP BY p.ProductID,p.ProductName


ALTER TABLE SeafoodSales
ADD Price money


UPDATE SeafoodSales
SET Price=(SELECT p.UnitPrice from Products p where p.ProductID=SeafoodSales.ProductID)



DELETE FROM SeafoodSales WHERE Price<10


CREATE VIEW ProductsView
as
SELECT ProductID,ProductName,c.CategoryName,s.CompanyName,s.Country
from Products p inner join Categories c 
on p.CategoryID=c.CategoryID inner join Suppliers s 
on s.SupplierID=p.SupplierID


SELECT pv.ProductName,pv.CompanyName,pv.Country,SUM(od.Quantity) as [Sum Of Quantity]
FROM ProductsView pv inner join [Order Details] od on od.ProductID=pv.ProductID
WHERE pv.Country in ('Italy','Spain','France')
GROUP BY ProductName,CompanyName,Country
ORDER BY ProductName


CREATE FUNCTION dbo.Sum_Product_Sales (@ProductID INT)
RETURNS money
as begin
DECLARE @ProductSales money
SELECT @ProductSales= (p.UnitPrice*od.Quantity) 
from Products p inner join [Order Details] od 
on p.ProductID=od.ProductID
where p.ProductID=@ProductID
IF @ProductSales is null
set @ProductSales=0
RETURN @ProductSales
end

SELECT p.ProductID,p.ProductName,p.UnitPrice,
dbo.Sum_Product_Sales(p.ProductID) as SumProductSales 
from Products p
WHERE (SELECT COUNT(*) FROM [Order Details] od 
where od.ProductID=p.ProductID)>50



CREATE FUNCTION dbo.Avg_Product_Qty (@Country nvarchar(15))
returns table as return
SELECT p.ProductID,p.ProductName,s.CompanyName,s.Country,CAST(avg(od.Quantity) AS REAL) as [Avg Of Quantity]
from NorthWind.dbo.Products p INNER JOIN NorthWind.dbo.Suppliers s ON
p.SupplierID=s.SupplierID INNER JOIN NorthWind.dbo.[Order Details] od
on p.ProductID=od.ProductID
where country like @country
GROUP BY p.ProductID,ProductName,CompanyName,Country

select * from dbo.Avg_Product_Qty('USA')

select * from dbo.Avg_Product_Qty('%')

DROP TABLE SeafoodSales
DROP VIEW ProductsView
