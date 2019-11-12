use SuperStore_v2

-- fill country table
--SELECT DISTINCT imp.Country from ImportedData imp
INSERT INTO Country (Name)
SELECT DISTINCT imp.Country from ImportedData imp
go

-- fill city table
--SELECT DISTINCT imp.City from ImportedData imp
INSERT INTO City (Name)
SELECT DISTINCT imp.City from ImportedData imp
go

-- fill state table
--SELECT DISTINCT imp.state from ImportedData imp
INSERT INTO [State] (Name)
SELECT DISTINCT imp.state from ImportedData imp
go


-- fill region table
--SELECT DISTINCT imp.region from ImportedData imp
INSERT INTO Region (Name)
SELECT DISTINCT imp.region from ImportedData imp
go

--SELECT (SELECT stateName from [state] where stateId=1), (SELECT CityName from [city] where cityId=1)
-- trainy query
/*
Select DISTINCT imp.[Postal Code] , (SELECT CountryID from [country] where CountryName=imp.Country), (SELECT CityID from [city] where cityname=imp.City),
(SELECT StateID from [state] where StateName=imp.state),(SELECT regionID from [region] where regionName=imp.region)			
from ImportedData imp
*/

-- fill address table, using postal code from imported table and ID  of country, city, state and region from previous filled table
INSERT INTO address(PostalCode,CountryId,CityId,StateId,RegionId)
Select DISTINCT imp.[Postal Code] , (SELECT ID from [country] where [Name]=imp.Country), (SELECT ID from [city] where [Name]=imp.City),
(SELECT ID from [state] where [Name]=imp.state),(SELECT ID from [region] where [Name]=imp.region)			
from ImportedData imp
go

--select to compare with excel (works)
/*
SELECT  adr.postalCode, ctr.Name, ct.Name, st.Name, reg.Name
FROM address adr
LEFT OUTER JOIN country ctr ON adr.countryID = ctr.Id
LEFT OUTER JOIN city ct ON adr.cityID = ct.ID
LEFT OUTER JOIN [state] st ON adr.stateID = st.Id
LEFT OUTER JOIN [region] reg ON adr.regionID = reg.Id
*/
-- fill segment customer table from imported data
--SELECT DISTINCT imp.segment from ImportedData imp
INSERT INTO segmentCustomer ([Name])
SELECT DISTINCT imp.segment from ImportedData imp
go

-- fill customer table, using customerID and name from imported table and ID customer segment from previous filled table
INSERT INTO Customer(Id,Name,CustomerSegmentId)
Select DISTINCT imp.[Customer ID] , imp.[Customer Name],(SELECT Id from [segmentCustomer] where [Name]=imp.Segment)			
from ImportedData imp
go

/*
--select to compare with excel (works)
SELECT ctr.Id, ctr.Name, segCtr.Name
FROM customer ctr
LEFT OUTER JOIN [segmentCustomer] segCtr ON ctr.CustomerSegmentId=segCtr.Id
*/

-- fill product category table
--add categories
--SELECT DISTINCT imp.category from ImportedData imp
INSERT INTO [ProductCategory] ([Name],ProductParentCategoryId) 
SELECT DISTINCT imp.category,null from ImportedData imp
go


-- fill product category table
-- add subcatigories
--SELECT DISTINCT imp.[Sub-Category] from ImportedData imp
INSERT INTO [ProductCategory] ([Name],ProductParentCategoryId) 
SELECT DISTINCT imp.[Sub-Category], (SELECT prCat.Id FROM ProductCategory prCat WHERE prCat.Name=imp.Category)
from ImportedData imp
go


--fill product table, using productID and productName from imported data and category and subcategory ID from previous filled tables
INSERT INTO [Product] (Id,ProductCategoryId,ProductSubCategoryId,[Name],Price)
SELECT DISTINCT
imp.[Product ID],
(SELECT prCat.Id FROM [ProductCategory] prCat WHERE prCat.Name=imp.[Category]),
(SELECT prSubCat.Id FROM [ProductCategory] prSubCat WHERE prSubCat.Name=imp.[Sub-Category]),
imp.[Product Name],
CAST ((imp.Sales/imp.Quantity)/(1-imp.Discount) AS MONEY) 
from ImportedData imp

/*
--select one product by id
SELECT * FROM Product
where ID='FUR-CH-100011461'
*/

--select all products from category 'Office Supplies'
/*
SELECT pr.Id,pr.Name,pr.Price,prSubCat.Name AS [SubCategory] from [product] pr
left outer join [ProductCategory] prSubCat
on pr.ProductSubCategoryId=prSubCat.Id
WHERE prSubCat.ProductParentCategoryId=(SELECT cat.Id FROM [ProductCategory] cat Where cat.Name='Office Supplies')
*/

-- fill ship mode subcategory table
--SELECT DISTINCT imp.[Ship Mode] from ImportedData imp
INSERT INTO [ShipMode] (Name)
SELECT DISTINCT imp.[Ship Mode] from ImportedData imp
go


--main order table
INSERT INTO [Order] (ID,OrderDate,ShipDate,OrderShipModelID,CustomerID,PostalID)	
SELECT DISTINCT 
imp.[Order ID], 
imp.[Order Date],
imp.[Ship Date],
(SELECT shpMd.Id FROM ShipMode shpMd WHERE shpMd.Name=imp.[Ship Mode]),
(SELECT cust.Id FROM [Customer] cust where cust.Id=imp.[Customer ID]),
(SELECT addr.PostalCode FROM [address] addr where addr.PostalCode=imp.[Postal Code])
from ImportedData imp 
--WHERE imp.[Order ID]='CA-2014-103849' or imp.[Order ID]='CA-2014-104472'


--fill order list table (many to many)
INSERT INTO OrderList (OrderID,ProductId,Sales,Quantity,Discoint,Profit)
SELECT imp.[Order ID],
(SELECT pr.Id FROM Product pr WHERE pr.Id=imp.[Product ID]),
imp.Sales,
imp.Quantity,
imp.Discount,
imp.Profit
FROM ImportedData imp
--where imp.[Order ID]='CA-2014-103849'


--SELECT COUNT(1) FROM PURSHASE
--SELECT COUNT(1) FROM OrderDet
