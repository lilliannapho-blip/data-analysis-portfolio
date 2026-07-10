--*  BusIT 103           Assignment   #10              DUE DATE :  Consult course calendar
							
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task.  

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., SuneelPratimaAssignment10.sql). 
	Submit your file to the instructor through the course site.  
	
	Class standard: All KEYWORDS such as SELECT, FROM, WHERE, INNER JOIN and so on must be in all capital letters and on separate lines. */


--  It is your responsibility to provide a meaningful column name for the return value of the function.


USE AdventureWorksDW2012;

-- 1.a. Find the total number of customers who are single. Be sure to name each derived field. (2 points)
--      8473

SELECT COUNT(c.MaritalStatus) AS SingleCustomers
FROM [dbo].[DimCustomer] c
WHERE c.MaritalStatus = 'S';

--1.b. Find the total number of customers who are married. Be sure to name each derived field. (2 points)

SELECT COUNT(c.MaritalStatus) AS MarriedCustomers
FROM [dbo].[DimCustomer] c
WHERE c.MaritalStatus = 'M';


--1.c. Find the total children and total cars owned for customers who own homes. (2 points)
--     TotalChildren	TotalCars
--	   25,648			18,216	

SELECT SUM(c.TotalChildren) AS TotalChildren, 
SUM(c.NumberCarsOwned) AS TotalCars
FROM [dbo].[DimCustomer] c
WHERE c.HouseOwnerFlag = '1'


--     
--1.d. Find the total children, total cars owned, and average income for customers who own homes. (2 points)
--     TotalChildren	TotalCars	AvgYearlyIncome
--     25,648			18,216		58,326.6677

SELECT SUM(c.TotalChildren) AS TotalChildren, 
SUM(c.NumberCarsOwned) AS TotalCars, AVG(c.YearlyIncome) AS AverageIncome
FROM [dbo].[DimCustomer] c
WHERE c.HouseOwnerFlag = '1'



--2.a.  List the total dollar amount (SalesAmount) for sales to Resellers. (2 points)
--      80,450,596.9823

SELECT SUM(frs.SalesAmount) AS TotalSalesAmount
FROM [dbo].[FactResellerSales] frs


--2.b.  List the total dollar amount (SalesAmount) for 2006 sales to Resellers who are value added resellers. (6 points)
--      10,523,819.7252

SELECT SUM(frs.SalesAmount) AS TotalSalesAmount
FROM [dbo].[FactResellerSales] frs
INNER JOIN [dbo].[DimReseller] r
ON frs.ResellerKey = r.ResellerKey
WHERE YEAR(frs.OrderDate) = 2006 AND r.BusinessType = 'Value Added Reseller'



--3.  List the average selling price for a mountain bike sold by AdventureWorks over the Internet. (6 points)
--	  2002.5673

SELECT AVG(fis.UnitPrice) AS AverageSellingPrice
FROM [dbo].[FactInternetSales] fis
INNER JOIN [dbo].[DimProduct] p
ON fis.ProductKey = p.ProductKey
INNER JOIN [dbo].[DimProductSubcategory] ps
ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
WHERE p.ProductSubcategoryKey = '1'

--4.a. Find average list price for accessory. (2 points)
--     34.2281

SELECT AVG(p.ListPrice) AS AverageListPrice
FROM [dbo].[DimProduct] p
INNER JOIN [dbo].[DimProductSubcategory] ps
ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
INNER JOIN [dbo].[DimProductCategory] pc
ON ps.ProductCategoryKey = pc.ProductCategoryKey
WHERE ps.ProductCategoryKey = '4'

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
	(SELECT AVG(p.ListPrice) AS AverageListPrice
	FROM [dbo].[DimProduct] p
	INNER JOIN [dbo].[DimProductSubcategory] ps
	ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
	INNER JOIN [dbo].[DimProductCategory] pc
	ON ps.ProductCategoryKey = pc.ProductCategoryKey
	WHERE ps.ProductCategoryKey = '4')
ORDER BY p.ListPrice DESC


--5. List the lowest list price, the average list price,  and the highest list price for a helmet. (5 points)
--   33.6442  34.0928  34.99		 

SELECT MIN(p.ListPrice) AS LowestPrice, AVG(p.listPrice) AS AveragePrice, MAX(p.ListPrice) AS HighestPrice
FROM [dbo].[DimProduct] p
INNER JOIN [dbo].[DimProductSubcategory] ps
ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
WHERE p.ProductSubcategoryKey = '31'


-- 6. List total Internet sales for product BK-R64Y-42. Show a calculated amount (using a calculation) 
an a sum amount, they should match. (6 points)

--    Included both methods of getting total sales
--    CalculatedAmt 334586.3175   SumSalesAmt 334586.3175

SELECT SUM(fis.OrderQuantity*fis.UnitPrice) AS TotalSales1, SUM (fis.SalesAmount) AS TotalSales2
FROM [dbo].[FactInternetSales] fis
INNER JOIN [dbo].[DimProduct] p
ON fis.ProductKey = p.ProductKey
WHERE p.ProductAlternateKey = 'BK-R64Y-42'


--7.  In your own words, write a business question that you can answer by querying the data warehouse
--    and using an aggregate function.
--    Then write the complete SQL query that will provide the information that you are seeking. (5 points)

Find the largest and smallest number of children at home of customers

SELECT MIN(c.[NumberChildrenAtHome]) AS SmallestAmtofChildren, 
MAX(c.[NumberChildrenAtHome]) AS LargestAmtofChildren
FROM [dbo].[DimCustomer] c