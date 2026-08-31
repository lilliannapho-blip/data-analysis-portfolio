
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task.  

--Use desired databased
USE AdventureWorksDW2012;

-- 1.a. Find the total number of customers who are single. Be sure to name each derived field. (2 points)
 
SELECT COUNT(c.MaritalStatus) AS SingleCustomers --Select from marital status column and create new column for total count of single customers
FROM [dbo].[DimCustomer] c --Query from the customer dimension table
WHERE c.MaritalStatus = 'S'; --Filter to single marital status

-- Queried a total of 8,473 single customers


--1.b. Find the total number of customers who are married. Be sure to name each derived field. (2 points)

SELECT COUNT(c.MaritalStatus) AS MarriedCustomers
FROM [dbo].[DimCustomer] c
WHERE c.MaritalStatus = 'M';

--Queried 10,011 married custoemrs


--1.c. Find the total children and total cars owned for customers who own homes. (2 points)
	
SELECT SUM(c.TotalChildren) AS TotalChildren, 
SUM(c.NumberCarsOwned) AS TotalCars --Selected and create from two tables
FROM [dbo].[DimCustomer] c
WHERE c.HouseOwnerFlag = '1'

--     TotalChildren	TotalCars
--	   25,648			18,216


--1.d. Find the total children, total cars owned, and average income for customers who own homes. (2 points)  

SELECT SUM(c.TotalChildren) AS TotalChildren, 
SUM(c.NumberCarsOwned) AS TotalCars, AVG(c.YearlyIncome) AS AverageIncome
FROM [dbo].[DimCustomer] c
WHERE c.HouseOwnerFlag = '1'

-- TotalChildren	TotalCars	AvgYearlyIncome
--     25,648			18,216		58,326.6677



--2.a.  List the total dollar amount (SalesAmount) for sales to Resellers. (2 points)

SELECT SUM(frs.SalesAmount) AS TotalSalesAmount
FROM [dbo].[FactResellerSales] frs

--      $80,450,596.9823


--2.b.  List the total dollar amount (SalesAmount) for 2006 sales to Resellers who are value added resellers. (6 points)


SELECT SUM(frs.SalesAmount) AS TotalSalesAmount
FROM [dbo].[FactResellerSales] frs
INNER JOIN [dbo].[DimReseller] r --Joins reseller sales data with the reseller information on reseller key
ON frs.ResellerKey = r.ResellerKey
WHERE YEAR(frs.OrderDate) = 2006 AND r.BusinessType = 'Value Added Reseller' --Filters down to year and business type

--      $10,523,819.7252


--3.  List the average selling price for a mountain bike sold by AdventureWorks over the Internet. (6 points)

SELECT AVG(fis.UnitPrice) AS AverageSellingPrice
FROM [dbo].[FactInternetSales] fis
INNER JOIN [dbo].[DimProduct] p
ON fis.ProductKey = p.ProductKey
INNER JOIN [dbo].[DimProductSubcategory] ps 
ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
WHERE p.ProductSubcategoryKey = '1'

--	  $2,002.5673

--4.a. Find average list price for accessory. (2 points)

SELECT AVG(p.ListPrice) AS AverageListPrice
FROM [dbo].[DimProduct] p
INNER JOIN [dbo].[DimProductSubcategory] ps
ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
INNER JOIN [dbo].[DimProductCategory] pc
ON ps.ProductCategoryKey = pc.ProductCategoryKey
WHERE ps.ProductCategoryKey = '4'

--     $34.2281

--4.b. List all products in the accessories category that have a list price lower than the average list price
--     for an accessory.  Show product alternate key, English product name, and list price.
--	   Order descending by list price. (10 points)
--     25 rows

SELECT P.ProductAlternateKey, p.EnglishDescription, p.ListPrice
FROM [dbo].[DimProduct] p
INNER JOIN [dbo].[DimProductSubcategory] ps
ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
INNER JOIN [dbo].[DimProductCategory] pc
ON ps.ProductCategoryKey = pc.ProductCategoryKey
WHERE ps.ProductCategoryKey = '4' AND p.ListPrice <
	(SELECT AVG(p.ListPrice) AS AverageListPrice --Subquery to calculate the average list price of all products in category 4
	FROM [dbo].[DimProduct] p
	INNER JOIN [dbo].[DimProductSubcategory] ps
	ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
	INNER JOIN [dbo].[DimProductCategory] pc
	ON ps.ProductCategoryKey = pc.ProductCategoryKey
	WHERE ps.ProductCategoryKey = '4')
ORDER BY p.ListPrice DESC 


--5. List the lowest list price, the average list price,  and the highest list price for a helmet. (5 points)		 

SELECT MIN(p.ListPrice) AS LowestPrice, AVG(p.listPrice) AS AveragePrice, MAX(p.ListPrice) AS HighestPrice
FROM [dbo].[DimProduct] p
INNER JOIN [dbo].[DimProductSubcategory] ps
ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
WHERE p.ProductSubcategoryKey = '31'

--   $33.6442,  $34.0928,  $34.99


-- 6. List total Internet sales for product BK-R64Y-42. Show a calculated amount (using a calculation) and a sum amount, they should match. (6 points)

SELECT SUM(fis.OrderQuantity*fis.UnitPrice) AS TotalSales1, SUM (fis.SalesAmount) AS TotalSales2
FROM [dbo].[FactInternetSales] fis
INNER JOIN [dbo].[DimProduct] p
ON fis.ProductKey = p.ProductKey
WHERE p.ProductAlternateKey = 'BK-R64Y-42'

--    CalculatedAmt $334,586.3175   SumSalesAmt $334,586.3175


--7.  In your own words, write a business question that you can answer by querying the data warehouse
--    and using an aggregate function.
--    Then write the complete SQL query that will provide the information that you are seeking. (5 points)

--Find the largest and smallest number of children at home of customers

SELECT MIN(c.[NumberChildrenAtHome]) AS SmallestAmtofChildren, 
MAX(c.[NumberChildrenAtHome]) AS LargestAmtofChildren
FROM [dbo].[DimCustomer] c

--Smallest 0, largest 5