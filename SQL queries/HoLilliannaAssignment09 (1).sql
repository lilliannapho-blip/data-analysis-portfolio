--*  BusIT 103           Assignment   #9              DUE DATE :  Consult course calendar
							
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task.  

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., SuneelPratimaAssignment09.sql). 
	Submit your file to the instructor through the course site.  
	
	Class standard: All KEYWORDS such as SELECT, FROM, WHERE, INNER JOIN and so on must be in all capital letters and on separate lines. */


Use AdventureWorksDW2012

--Note 1:  When the task does not specify sort order, it is your responsibility to order the information 
--         so that is easy to interpret.
--Note 2:  The questions are numbered. 1.a., 1.b., 2.a., 2.b., etc to remind you of the steps in developing and 
--         testing your queries/subqueries. The first steps will not require subqueries unless specified. The last step in every sequence 
--         will require a subquery, regardless of whether the result can be created using another method. 

-- 1.a. List the average sales amount quota for employees at AdventureWorks. Use AVG. (2 points)
--      587202.4539

SELECT AVG(fsq.SalesAmountQuota) AS 'AverageSalesAmountQuota'
FROM [dbo].[FactSalesQuota] fsq;


-- 1.b. List the average sales amount quota for employees at AdventureWorks for 2008. (2 points)
--      541470.5882

SELECT AVG(fsq.SalesAmountQuota) AS 'AverageSalesAmountQuota'
FROM [dbo].[FactSalesQuota] fsq
WHERE fsq.CalendarYear = '2008';


--1.c. List the name, title, and hire date for AdventureWorks employees 
--     whose sales quota for 2008 is higher than the average for all employees for 2008.
--     Be sure to use an appropriate sort. (4 points)
--     16 Rows
--     Hint - Might want to use WHERE clause Twice!!! Once for inner query and once for outer query.
--     USE UNCorrelated Subquery

SELECT e.FirstName, e.LastName, e.HireDate 
FROM [dbo].[DimEmployee] e
INNER JOIN [dbo].[FactSalesQuota] fsq
ON e.EmployeeKey = fsq.EmployeeKey
WHERE fsq.CalendarYear = '2008' AND fsq.SalesAmountQuota >
	(SELECT AVG(fsq1.SalesAmountQuota) AS 'AverageSalesAmountQuota'
	FROM [dbo].[FactSalesQuota] fsq1
	WHERE fsq1.CalendarYear = '2008')
ORDER BY e.LastName, e.FirstName;



-- 2.a.  List the average LIST PRICE of a bike sold by AdventureWorks. (1 point)
--       1 row  

SELECT AVG(p.ListPrice) AS 'AverageListPrice'
FROM [dbo].[DimProduct] p
INNER JOIN [dbo].[DimProductSubcategory] ps
ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
INNER JOIN [dbo].[DimProductCategory] pc
ON ps.ProductCategoryKey = pc.ProductCategoryKey
WHERE pc.ProductCategoryKey = '1';


-- 2.b. List all products in the Bikes category that have a list price higher than
--      the average list price of a bike.  Show product alternate key, product name,
--      and list price in the results set. Order the information so it is easy to understand. (4 points)
--      50 rows
--      UnCorrelated subquery

SELECT p.EnglishProductName, p.ProductAlternateKey, p.ListPrice
FROM [dbo].[DimProduct] p
INNER JOIN [dbo].[DimProductSubcategory] ps
ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
INNER JOIN [dbo].[DimProductCategory] pc
ON ps.ProductCategoryKey = pc.ProductCategoryKey
WHERE pc.ProductCategoryKey = '1' AND p.ListPrice>
	(SELECT AVG(p1.ListPrice) AS 'AverageListPrice'
	FROM [dbo].[DimProduct] p1
	INNER JOIN [dbo].[DimProductSubcategory] ps1
	ON p1.ProductSubcategoryKey = ps1.ProductSubcategoryKey
	INNER JOIN [dbo].[DimProductCategory] pc1
	ON ps1.ProductCategoryKey = pc1.ProductCategoryKey
	WHERE pc1.ProductCategoryKey = '1')
ORDER BY p.ListPrice;


-- 3.a. Find the average yearly income all customers in the customer table. (2 points)
--      57,305.7779

SELECT AVG(c.YearlyIncome) AS 'AverageYearlyIncome'
FROM [dbo].[DimCustomer] c;


-- 3.b. Find all males in the customers table with an income less than or the same as the average
--      income of all customers. List last name, a comma and space, and first name in one column and yearly income. (4 points)
--      4404 rows
--      UnCorrelated subquery

SELECT CONCAT(c.LastName, + ', '+ c.FirstName) AS 'Name', c.YearlyIncome
FROM [dbo].[DimCustomer] c
WHERE c.Gender = 'M' AND c.YearlyIncome <=
	(SELECT AVG(c1.YearlyIncome) AS 'AverageYearlyIncome'
	FROM [dbo].[DimCustomer] c1)
ORDER BY c.YearlyIncome;


-- 4.a. List the product name and list price for the bike named Road-150 Red, 48 (2 points)
--      3,578.27

SELECT p.EnglishProductName, p.ListPrice
FROM [dbo].[DimProduct] p
WHERE p.EnglishProductName = 'Road-150 Red, 48';

-- 4.b. List the product name and price for each product that has a price greater than or 
--	    equal to that of the Road-150 Red, 48. Be sure you are using the subquery not an actual value. (5 points)
--      5 rows
--      USE UnCorrelated Subquery

SELECT p.EnglishProductName, p.ListPrice
FROM [dbo].[DimProduct] p
WHERE p.ListPrice >=
	(SELECT p1.ListPrice
	FROM [dbo].[DimProduct] p1
	WHERE p1.EnglishProductName = 'Road-150 Red, 48');


-- 5.a.	List the names of resellers and the product names of products they sold. 
--      Elimate duplicate rows. Use an appropriate sort.  (3 points)
 --     20463 rows

 SELECT DISTINCT r.ResellerName, p.EnglishProductName
 FROM [dbo].[DimReseller] r
 INNER JOIN [dbo].[FactResellerSales] rs
 ON r.ResellerKey = rs.ResellerKey
 INNER JOIN [dbo].[DimProduct] p
 ON rs.ProductKey = p.ProductKey;


-- 5.b.	List only one time the names of all resellers who sold a cable lock.  
--      Use the IN predicate and a subquery to accomplish the task. Use an appropriate sort. (5 points)
--      93 rows	
--      USE UnCorrelated Subquery

SELECT DISTINCT r.ResellerName
FROM [dbo].[DimReseller] r
INNER JOIN [dbo].[FactResellerSales] rs
ON r.ResellerKey = rs.ResellerKey
INNER JOIN [dbo].[DimProduct] p
ON rs.ProductKey = p.ProductKey
INNER JOIN [dbo].[DimProductSubcategory] ps
ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
WHERE ps.ProductSubcategoryKey IN 
	(SELECT p1.ProductSubcategoryKey
	FROM [dbo].[DimProduct] p1
	WHERE p1.ProductSubcategoryKey = '34')
ORDER BY ResellerName;


-- 6.a. Find the unique customers from the Survey Response fact table. (2 points)
--      1656 ROWS

SELECT DISTINCT fsr.CustomerKey
FROM [dbo].[FactSurveyResponse] fsr
INNER JOIN [dbo].[DimCustomer] c
ON fsr.CustomerKey = c.CustomerKey;


-- 7.a. Find the number of times the CustomerKey appears in the Internet Sales Fact table. (2 points)
--      Use COUNT()
--      60,398

SELECT COUNT(fis.CustomerKey) AS 'CustomerKeys'
FROM [dbo].[FactInternetSales] fis;

-- 8.  List all resellers whose annual sales exceed the average annual sales for resellers whose Business Type is "Specialty Bike Shop". 
Show Business type, Reseller Name, and annual sales.  Use appropriate subqueries. (6 points)
--     396 Rows
--     Use Uncorrelated sub query

SELECT r.BusinessType, r.ResellerName, r.AnnualSales
FROM [dbo].[DimReseller] r
WHERE r.AnnualSales >
	(SELECT AVG(r1.AnnualSales) AS 'AverageAnnualSales'
	FROM [dbo].[DimReseller] r1
	WHERE r1.BusinessType = 'Specialty Bike Shop')
ORDER BY r.ResellerName;


--9. Subqueries can be nested 32 deep. Try your hand at nesting a subquery within a subquery. (6 points)
--   State the purpose of the query and then try.

List mountain bikes that cost more than the average list price of mountain bikes and weigh MORE than 2.84 lbs .
show product name, list price and weight


SELECT p.EnglishProductName, p.ListPrice, p.Weight
FROM [dbo].[DimProduct] p
WHERE p.ListPrice >
	(SELECT AVG(p1.ListPrice) 'AS AverageListPrice'
	FROM [dbo].[DimProduct] p1
	INNER JOIN [dbo].[DimProductSubcategory] ps
	ON p1.ProductSubcategoryKey = ps.ProductSubcategoryKey
	WHERE ps.EnglishProductSubcategoryName = 'Mountain Bikes' AND p1.Weight IN
		(SELECT p2.Weight
		FROM [dbo].[DimProduct] p2
		WHERE p2.Weight > '2.84'))
ORDER BY p.Weight;

		
	






