use Super_store

-- show all customers from Los Angeles, how many money they spend totally, how many positions they bought
SELECT ctr.CustomerName, SUM(pur.PurshaseSales) as [Total Amount], COUNT(1) AS [Total Items]
from PURSHASE pur 
LEFT OUTER JOIN [address] adr ON pur.PurshasePostalID=adr.PostalCode
LEFT OUTER JOIN [Customer] ctr ON pur.PurshaseCustomerID=ctr.CustomerId
WHERE adr.CityId=(SELECT ct.CityId FROM city ct where ct.CityName='Los Angeles')
GROUP BY ctr.CustomerName

--sales by city
SELECT (SELECT ct.CityName FROM [city] ct where ct.CityId=adr.CityId) AS [City work with], SUM(pur.PurshaseSales)
from PURSHASE pur 
LEFT OUTER JOIN [address] adr ON pur.PurshasePostalID=adr.PostalCode
GROUP BY adr.CityId

--which orders had Furniture like table in the order
SELECT pur.PurshaseOrderID, prod.ProductName
FROM PURSHASE pur
LEFT OUTER JOIN [Product] prod ON pur.PurshaseProductID=prod.ProductId
LEFT OUTER JOIN [ProductCategory] prodCat ON prod.ProductCategoryKeyId=prodCat.ProductCategoryKeyId 
WHERE prodCat.ProductCategoryName='Furniture' AND prod.ProductSubCategoryKeyId=(SELECT prodSubCat.ProductSubCategoryKeyId FROM [ProductSubCategory] prodSubCat WHERE prodSubCat.ProductSubCategoryName='Tables')

