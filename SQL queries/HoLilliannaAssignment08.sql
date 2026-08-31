--*  BusIT 103           Assignment   #8              DUE DATE :  Consult course calendar
							
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task. 
--Each task must be accomplished using some type of OUTER JOIN. 

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., SuneelPratimaAssignment08.sql). 
	Submit your file to the instructor through the course site.  
	
	Class standard: All KEYWORDS such as SELECT, FROM, WHERE, INNER JOIN and so on must be in all capital letters and on separate lines. */


Use AdventureWorksDW2012;

--IMPORTANT NOTE: Only one LEFT OUTER JOIN is to be used for each task. 
--The use of more than one LEFT OUTER JOIN per task will cause points to be TAKEN OFF.

--NOTE:  When the task does not specify sort order, it is your responsibility to order the information
--    so that is easy to interpret.


--  1.  List all Sales Reasons that have not been associated with an internet sale. (4 points)
--      Hint:  Use factInternetSalesReason and dimSalesReason. 
--		3 Rows

SELECT sr.SalesReasonName
FROM [dbo].[DimSalesReason] sr
LEFT OUTER JOIN [dbo].[FactInternetSalesReason] fsr
ON sr.SalesReasonKey = fsr.SalesReasonKey
WHERE fsr.SalesReasonKey IS NULL


--2.    List all internet sales that do not have at least 1 sales reason associated.
--      List SalesOrderNumber, SalesOrderLineNumber and the order date. (4 points)
--      Hint:  Use factInternetSales and factInternetSalesReason. 
--		6429 rows
		
SELECT fis.SalesOrderNumber, fis.SalesOrderLineNumber, fis.OrderDate
FROM [dbo].[FactInternetSales] fis
LEFT OUTER JOIN [dbo].[FactInternetSalesReason] fsr
ON fis.SalesOrderNumber = fsr.SalesOrderNumber
WHERE fsr.SalesOrderNumber IS NULL;

--  3.  List all promotions that have not been associated with a reseller sale. (4 points)
--		4 Rows

SELECT p.EnglishPromotionName
FROM [dbo].[DimPromotion] p
LEFT OUTER JOIN [dbo].[FactResellerSales] fr
ON p.PromotionKey = fr.PromotionKey
WHERE fr.PromotionKey IS NULL;


--4.    Find any cities in which AdventureWorks has no customers
--      List city, state/province, and the English country/region name
--      List each city only one time. Sort by country, state, and city. (4 points)
--		303 Rows

SELECT DISTINCT g.City, g.StateProvinceName, g.EnglishCountryRegionName
FROM [dbo].[DimGeography] g
LEFT OUTER JOIN [dbo].[DimCustomer] c
ON g.GeographyKey = c.GeographyKey
WHERE c.GeographyKey IS NULL;


--5.    Find any cities in which AdventureWorks has no resellers
--      List city, state/province, and the English country/region name
--      List each city only one time. Sort by country, state, and city. (4 points)
--		133 Rows

SELECT DISTINCT g.City, g.StateProvinceName, g.EnglishCountryRegionName
FROM [dbo].[DimGeography] g
LEFT OUTER JOIN [dbo].[DimReseller] r
ON g.GeographyKey = r.GeographyKey
WHERE r.GeographyKey IS NULL
ORDER BY g.EnglishCountryRegionName, g.StateProvinceName, g.City;


--6.    Write a query to determine if there are any product categories that do not have 
--      related sub categories. (4 points)
--		0 Rows

SELECT pc.EnglishProductCategoryName 
FROM [dbo].[DimProductCategory] pc
LEFT OUTER JOIN [dbo].[DimProductSubcategory] ps
ON pc.ProductCategoryKey = ps.ProductCategoryKey
WHERE ps.ProductCategoryKey IS NULL;


--7.    Find all promotions and any related internet sales. List unique instances of the 
--      english promotion name, customer first and last name, and the order date.
--      Sort by the promotion name. Be sure to list all promotions even if there is no related sale. (4 points)
--		29199 Rows

SELECT DISTINCT p.EnglishPromotionName, CustSales.FirstName, CustSales.LastName, CustSales.OrderDate
FROM [dbo].[DimPromotion] p
LEFT OUTER JOIN
	(SELECT c.FirstName, c.LastName, fis.PromotionKey, fis.OrderDate
	FROM [dbo].[DimCustomer] c
	INNER JOIN [dbo].[FactInternetSales] fis
	ON c.CustomerKey = fis.CustomerKey) AS CustSales
ON p.PromotionKey = CustSales.PromotionKey
ORDER BY p.EnglishPromotionName;



--8.    Find all promotions and any related reseller sales. List unique instances of the english 
--      promotion name, reseller name, and the order date.
--      Sort by the promotion name. Be sure to list all promotions even if there is no related sale. (4 points)
--		5174 Rows

SELECT DISTINCT p.EnglishPromotionName, ResellerSales.ResellerName, ResellerSales.OrderDate
FROM [dbo].[DimPromotion] p
LEFT OUTER JOIN
	(SELECT r.ResellerName, frs.OrderDate, frs.PromotionKey
	FROM [dbo].[DimReseller] r
	INNER JOIN [dbo].[FactResellerSales] frs
	ON r.ResellerKey = frs.ResellerKey) AS ResellerSales
ON p.PromotionKey = ResellerSales.PromotionKey
ORDER BY p.EnglishPromotionName;


--9.    List reseller name for resellers who have not sold any bikes. (4 points)
--		114 Rows

SELECT r.ResellerName
FROM [dbo].[DimReseller] r
LEFT OUTER JOIN 
	(SELECT frs.ResellerKey, pc.EnglishProductCategoryName
	FROM [dbo].[DimProductCategory] pc
	INNER JOIN [dbo].[DimProductSubcategory] ps
	ON pc.ProductCategoryKey = ps.ProductCategoryKey
	INNER JOIN [dbo].[DimProduct] p
	ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
	INNER JOIN [dbo].[FactResellerSales] frs
	ON p.ProductKey = frs.ProductKey
	WHERE pc.EnglishProductCategoryName = 'Bikes') AS ResellerBikes
ON r.ResellerKey = ResellerBikes.ResellerKey
WHERE ResellerBikes.ResellerKey IS NULL;


--10.   List all male customers and any clothing they have purchased over the internet.
--      List customer alternate key, customer last name, customer first name, 
--      product alternate key, and product name.  Be sure to include male customers who have not 
--      purchased clothing. (4 points)
--		10497 Rows

SELECT c.CustomerAlternateKey, c.LastName, c.FirstName, ProductSales.ProductAlternateKey,
ProductSales.EnglishProductName
FROM [dbo].[DimCustomer] c
LEFT OUTER JOIN 
	(SELECT p.ProductAlternateKey, p.EnglishProductName, p.ProductKey, fis.CustomerKey, pc.EnglishProductCategoryName
	FROM [dbo].[DimProductCategory] pc
	INNER JOIN [dbo].[DimProductSubcategory] ps
	ON pc.ProductCategoryKey = ps.ProductCategoryKey
	INNER JOIN [dbo].[DimProduct] p
	ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
	INNER JOIN [dbo].[FactInternetSales] fis
	ON p.ProductKey = fis.ProductKey
	WHERE pc.EnglishProductCategoryName = 'Clothing' ) AS ProductSales
ON c.CustomerKey = ProductSales.CustomerKey
WHERE c.Gender = 'M';


--11.   In your own words, write a business question that you can answer by querying the data warehouse 
--      and using an outer join.
--      Then write the SQL query that will provide the information that you are seeking. (10 points)
List products that have not been bought by customers. list unique english product names.

SELECT DISTINCT p.EnglishProductName
FROM [dbo].[DimProduct] p
LEFT OUTER JOIN
	(SELECT c.FirstName, c.LastName, fis.ProductKey
	FROM [dbo].[DimCustomer] c 
	INNER JOIN [dbo].[FactInternetSales] fis
	ON c.CustomerKey = fis.CustomerKey) AS CustProduct
ON p.ProductKey = CustProduct.ProductKey
WHERE CustProduct.ProductKey IS NULL;







	


