-*  BusIT 103           Assignment   #11              DUE DATE :  Consult course calendar
							
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task.  

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., SuneelPratimaAssignment11.sql). 
	Submit your file to the instructor through the course site.  
	
	Class standard: All KEYWORDS such as SELECT, FROM, WHERE, INNER JOIN and so on must be in all capital letters and on separate lines. */


--  It is your responsibility to provide a meaningful column name for the return value of the function 
--  and use an appropriate sort order
	

USE AdventureWorksDW2012;

--1.	Display a count of resellers by country
--		Sort from highest to lowest count of resellers, then by country in alphabetical order. (5 points)
--      6 Rows

SELECT g.EnglishCountryRegionName, COUNT (r.ResellerName) AS ResellerName
FROM [dbo].[DimGeography] g 
INNER JOIN [dbo].[DimReseller] r
ON r.GeographyKey = g.GeographyKey
GROUP BY g.EnglishCountryRegionName
ORDER BY g.EnglishCountryRegionName;


--2.	List customer occupations (use EnglishOccupation) and the number of customers having each occupation.
--		First check to see if there are any customers without an occupation.
--		Add the count returned to see if it makes sense. (5 points)
--      5 Rows

SELECT c.EnglishOccupation, COUNT(*) AS TotalCust
FROM [dbo].[DimCustomer] c
GROUP BY c.EnglishOccupation


--3.a.  List all resellers and total sales amount for each.  
--		Show Reseller name, business type, and total sales with the sales showing two decimal places.
--	    Be sure to include resellers for which there are no sales. (5 points)
--      701 Rows

SELECT r.ResellerName, r.BusinessType, ROUND(SUM(frs.SalesAmount), 2) AS TotalSalesAmt
FROM [dbo].[DimReseller] r
LEFT OUTER JOIN [dbo].[FactResellerSales] frs
ON r.ResellerKey = frs.ResellerKey
GROUP BY r.ResellerName, r.BusinessType


--3.b.	Look up the IsNull function. Copy and paste your statement from 3.a. and use the IsNull function to 
--		replace null total sales amounts with 0. (5 points)
--      701 Rows


SELECT r.ResellerName, r.BusinessType, ISNULL(ROUND(SUM(frs.SalesAmount), 2), 0) AS TotalSalesAmt
FROM [dbo].[DimReseller] r
LEFT OUTER JOIN [dbo].[FactResellerSales] frs
ON r.ResellerKey = frs.ResellerKey
GROUP BY r.ResellerName, r.BusinessType


--4.    List resellers and total sales for each.  
--		Show reseller name, business type, and total sales.
--		List only those resellers having sales exceeding $500,000. (6 points)
--      31 Rows

SELECT r.ResellerName, r.BusinessType, SUM(frs.SalesAmount) AS TotalSalesAmt
FROM [dbo].[DimReseller] r
INNER JOIN [dbo].[FactResellerSales] frs
ON r.ResellerKey = frs.ResellerKey
GROUP BY r.ResellerName, r.BusinessType
HAVING SUM(frs.SalesAmount) > 500000


--5.    List resellers and total sales for each for 2008.  
--      Show Reseller name, business type, and total sales.
--      List only those resellers having sales exceeding $150,000. (6 points)
--      10 Rows

SELECT r.ResellerName, r.BusinessType, SUM(frs.SalesAmount) AS TotalSalesAmt
FROM [dbo].[DimReseller] r
INNER JOIN [dbo].[FactResellerSales] frs
ON r.ResellerKey = frs.ResellerKey
WHERE YEAR(frs.OrderDate) = 2008
GROUP BY r.ResellerName, r.BusinessType
HAVING SUM(frs.SalesAmount) > 150000


--6.a.	List the amount of the total sales of reseller sales by business type.
--		First find the business type to determine you have them all. Then create your query. (6 points)
--      3 Rows

SELECT r.BusinessType, SUM(frs.SalesAmount) AS TotalSalesAmt
FROM [dbo].[DimReseller] r
INNER JOIN [dbo].[FactResellerSales] frs
ON r.ResellerKey = frs.ResellerKey
GROUP BY r.BusinessType


--6.b.	Extra credit challenge. +5 No partial credit given. 
--		List the amount of the average the total sales of reseller sales by business type.
--		To do this find the total sales for each reseller first and then find the average
--		of the total of all sales by a reseller within a business type. 
--      3 Rows

SELECT r.BusinessType, AVG(s.TotalSales) AS AvgTotalSales
FROM [dbo].[DimReseller] r
INNER JOIN (
	SELECT frs.ResellerKey, SUM(frs.SalesAmount) AS TotalSales
	FROM [dbo].[FactResellerSales] frs
	GROUP BY frs.ResellerKey) AS s
ON r.ResellerKey = s.ResellerKey
GROUP BY r.BusinessType


--7.	List all customers and the most recent date they placed an order. Do not show the time with the order date. 
--		First find the number of unique customers to determine that your results includes the correct number of customers.
--		Then determine which fields are needed to create accurate information about the customer. (6 points)
--      18484 Rows

SELECT c.FirstName + ' ' + c.LastName AS CustName, CAST(f.RecentOrderDate AS VARCHAR(11)) AS RecentOrderDate
FROM [dbo].[DimCustomer] c
INNER JOIN (
	SELECT fis.CustomerKey, MAX(fis.OrderDate) AS RecentOrderDate
	FROM[dbo].[FactInternetSales] fis
	GROUP BY fis.CustomerKey) AS f
ON c.CustomerKey = f.CustomerKey


--8.    In your own words, write a business question that you can answer by querying the data warehouse
--      and using an aggregate function with the having clause.
--      Then write the complete SQL query that will provide the information that you are seeking. (6 points)

List amount of customers in each city

SELECT g.City, COUNT(c.FirstName) AS TotalCust
FROM [dbo].[DimGeography] g
INNER JOIN [dbo].[DimCustomer] c
ON g.GeographyKey = c.GeographyKey
GROUP BY g.City