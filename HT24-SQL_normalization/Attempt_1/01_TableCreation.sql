use Super_store
------------------------------------------------------
--create table for counrty name
create table country
(
	CountryId int Identity(1,1) primary key,
	CountryName nvarchar(50) unique not null
)
--drop table country
------------------------------------------------------
--create table for city name
create  table city
(
	CityId int Identity(1,1) primary key,
	CityName nvarchar(50) unique not null
)
--drop table city
------------------------------------------------------
--create table for state name
create  table [state]
(
	StateId int Identity(1,1) primary key,
	StateName nvarchar(50) unique not null
)
--drop table [state]
------------------------------------------------------
--create table for region name
create  table  region
(
	RegionId int Identity(1,1) primary key,
	RegionName nvarchar(30) unique not null
)
--drop table region
------------------------------------------------------
--create table for address
create  table  address
(
	PostalCode int primary key,
	CountryId int not null, 
	CityId int not null,
	StateId int not null,
	RegionId int not null,	
	CONSTRAINT FK_Address_To_Country FOREIGN KEY (CountryId)  REFERENCES Country (CountryId),
	CONSTRAINT FK_Address_To_City FOREIGN KEY (CityId)  REFERENCES City (CityId),
	CONSTRAINT FK_Address_To_State FOREIGN KEY (StateId)  REFERENCES [State] (StateId),
	CONSTRAINT FK_Address_To_Region FOREIGN KEY (RegionId)  REFERENCES Region (RegionId)
)
--drop table address
------------------------------------------------------
--create table for segment name
create table segmentCustomer
(
	segmentId int Identity(1,1) primary key,
	segmentName nvarchar(50) unique not null
)
--drop table segmentCustomer
------------------------------------------------------
--create table for customer
create table Customer
(
	CustomerId nvarchar(20) primary key,
	CustomerName nvarchar(100) unique not null,
	CustomerSegmentId int not null,
	CONSTRAINT FK_Customer_To_CustomerSegment FOREIGN KEY (CustomerSegmentId)  REFERENCES segmentCustomer (segmentId)
)
--drop table Customer
------------------------------------------------------
--create table for product category
create table ProductCategory
(
	ProductCategoryKeyId int Identity(1,1) primary key,
	ProductCategoryName nvarchar(50) unique not null
)
--drop table ProductCategory
------------------------------------------------------
--create table for product subcategory
create table ProductSubCategory
(
	ProductSubCategoryKeyId int Identity(1,1) primary key,
	ProductSubCategoryName nvarchar(50) unique not null
)
--drop table ProductSubCategory
------------------------------------------------------
--create table for product 
create table Product
(
	ProductId nvarchar(40) primary key,
	ProductCategoryKeyId int  not null,
	ProductSubCategoryKeyId int  not null,
	ProductName nvarchar(255) unique not null,
	CONSTRAINT FK_Product_To_ProductCategoryKey FOREIGN KEY (ProductCategoryKeyId)  REFERENCES ProductCategory (ProductCategoryKeyId),
	CONSTRAINT FK_Product_To_ProductSubCategoryKey FOREIGN KEY (ProductSubCategoryKeyId)  REFERENCES ProductSubCategory (ProductSubCategoryKeyId)
)
--drop table Product
------------------------------------------------------
--create table for ship mode
create table ShipMode
(
	ShipModeId int Identity(1,1) primary key,
	ShipModeName nvarchar(50) unique not null
)
--drop table ShipMode
------------------------------------------------------
--create table for Order
create table orderDet
(
	OrderID nvarchar(40) primary key,
	OrderDate datetime2 not null,
	ShipDate datetime2,
	OrderShipModelID int,
	CONSTRAINT FK_Order_To_OrderShipModel FOREIGN KEY (OrderShipModelID)  REFERENCES ShipMode (ShipModeId)
)
--drop table orderDet
------------------------------------------------------
--create final PURSHASE table
create table PURSHASE
(
	PurchaseId int Identity(1,1) primary key,
	PurshaseOrderID nvarchar(40) not null,
	PurshaseCustomerID nvarchar(20) not null,
	PurshasePostalID int not null,
	PurshaseProductID nvarchar(40) not null,
	PurshaseSales money not null,
	PurchaseQuantity int not null,
	PurchaseDiscount int,
	PurchaseProfit money,
	CONSTRAINT FK_PURSHASE_To_Order FOREIGN KEY (PurshaseOrderID)  REFERENCES Orderdet (orderid),
	CONSTRAINT FK_PURSHASE_To_CUSTOMER FOREIGN KEY (PurshaseCustomerID)  REFERENCES customer (customerid),
	CONSTRAINT FK_PURSHASE_To_POSTAL FOREIGN KEY (PurshasePostalID)  REFERENCES [address] (postalcode),
	CONSTRAINT FK_PURSHASE_To_PRODUCT FOREIGN KEY (PurshaseProductID)  REFERENCES product (productID)
)
---add CHECK!!!!