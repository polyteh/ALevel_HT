use Super_store

-- fill country table
--SELECT DISTINCT imp.Country from ImportedData imp
INSERT INTO Country (CountryName)
SELECT DISTINCT imp.Country from ImportedData imp
go

-- fill city table
--SELECT DISTINCT imp.City from ImportedData imp
INSERT INTO City (CityName)
SELECT DISTINCT imp.City from ImportedData imp
go

-- fill state table
--SELECT DISTINCT imp.state from ImportedData imp
INSERT INTO [State] (StateName)
SELECT DISTINCT imp.state from ImportedData imp
go

-- fill region table
--SELECT DISTINCT imp.region from ImportedData imp
INSERT INTO Region (RegionName)
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
Select DISTINCT imp.[Postal Code] , (SELECT CountryID from [country] where CountryName=imp.Country), (SELECT CityID from [city] where cityname=imp.City),
(SELECT StateID from [state] where StateName=imp.state),(SELECT regionID from [region] where regionName=imp.region)			
from ImportedData imp
go

--select to compare with excel (works)
/*
SELECT  adr.postalCode, ctr.CountryName, ct.CityName, st.StateName, reg.RegionName
FROM address adr
LEFT OUTER JOIN country ctr ON adr.countryID = ctr.CountryId
LEFT OUTER JOIN city ct ON adr.cityID = ct.cityID
LEFT OUTER JOIN [state] st ON adr.stateID = st.StateId
LEFT OUTER JOIN [region] reg ON adr.regionID = reg.RegionId
*/

-- fill segment customer table from imported data
--SELECT DISTINCT imp.segment from ImportedData imp
INSERT INTO segmentCustomer (segmentName)
SELECT DISTINCT imp.segment from ImportedData imp
go

-- fill customer table, using customerID and name from imported table and ID customer segment from previous filled table
INSERT INTO Customer(CustomerId,CustomerName,CustomerSegmentId)
Select DISTINCT imp.[Customer ID] , imp.[Customer Name],(SELECT segmentId from [segmentCustomer] where segmentName=imp.Segment)			
from ImportedData imp
go

--select to compare with excel (works)
/*
SELECT ctr.CustomerId, ctr.CustomerName, segCtr.segmentName
FROM customer ctr
LEFT OUTER JOIN [segmentCustomer] segCtr ON ctr.CustomerSegmentId=segCtr.segmentId
*/

-- fill product category table
--SELECT DISTINCT imp.category from ImportedData imp
INSERT INTO [ProductCategory] (ProductCategoryName)
SELECT DISTINCT imp.category from ImportedData imp
go

-- fill product subcategory table
--SELECT DISTINCT imp.[Sub-Category] from ImportedData imp
INSERT INTO [ProductSubCategory] (ProductSubCategoryName)
SELECT DISTINCT imp.[Sub-Category] from ImportedData imp
go

--fill product table, using productID and productName from imported data and category and subcategory ID from previous filled tables
INSERT INTO [Product] (ProductId,ProductCategoryKeyId,ProductSubCategoryKeyId,ProductName)
SELECT DISTINCT imp.[Product ID], (SELECT prCat.ProductCategoryKeyId FROM [ProductCategory] prCat WHERE prCat.ProductCategoryName=imp.Category),
(SELECT prSubCat.ProductSubCategoryKeyId FROM [ProductSubCategory] prSubCat WHERE prSubCat.ProductSubCategoryName=imp.[Sub-Category]),imp.[Product Name]
from ImportedData imp

-- fill ship mode subcategory table
--SELECT DISTINCT imp.[Ship Mode] from ImportedData imp
INSERT INTO [ShipMode] (ShipModeName)
SELECT DISTINCT imp.[Ship Mode] from ImportedData imp
go

--fill order details table
INSERT INTO orderDet (OrderID,OrderDate,ShipDate,OrderShipModelID)
SELECT DISTINCT imp.[Order ID],imp.[Order Date],imp.[Ship Date],(SELECT shM.ShipModeId FROM [ShipMode] shM WHERE shM.ShipModeName=imp.[Ship Mode])
from ImportedData imp

--main table
INSERT INTO PURSHASE (PurshaseOrderID,PurshaseCustomerID,PurshasePostalID,PurshaseProductID,PurshaseSales,PurchaseQuantity,PurchaseDiscount,PurchaseProfit)	
SELECT 
(SELECT ord.OrderID FROM [orderDet] ord where ord.OrderID=imp.[Order ID]), 
(SELECT cust.CustomerId FROM [Customer] cust where cust.CustomerId=imp.[Customer ID]),
(SELECT addr.PostalCode FROM [address] addr where addr.PostalCode=imp.[Postal Code]),
(SELECT prod.ProductId FROM [Product] prod where prod.ProductId=imp.[Product ID]),
imp.Sales,imp.Quantity,imp.Discount,imp.Profit
from ImportedData imp



