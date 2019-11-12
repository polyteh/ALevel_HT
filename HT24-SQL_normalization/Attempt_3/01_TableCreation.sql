use SuperStore_v2
------------------------------------------------------
--create table for counrty name
create table Country
(
	Id int Identity(1,1) primary key,
	[Name] nvarchar(50) unique not null
)
--drop table country
------------------------------------------------------
--create table for city name
create  table City
(
	Id int Identity(1,1) primary key,
	[Name] nvarchar(50) unique not null
)
--drop table city
------------------------------------------------------
--create table for state name
create  table [State]
(
	Id int Identity(1,1) primary key,
	[Name] nvarchar(50) unique not null
)
--drop table [State]
------------------------------------------------------
--create table for region name
create  table  Region
(
	Id int Identity(1,1) primary key,
	[Name] nvarchar(30) unique not null
)
--drop table Region
------------------------------------------------------
--create table for address
create  table  Address
(
	PostalCode int primary key,
	CountryId int not null, 
	CityId int not null,
	StateId int not null,
	RegionId int not null,	
	CONSTRAINT FK_Address_To_Country FOREIGN KEY (CountryId)  REFERENCES Country (Id),
	CONSTRAINT FK_Address_To_City FOREIGN KEY (CityId)  REFERENCES City (Id),
	CONSTRAINT FK_Address_To_State FOREIGN KEY (StateId)  REFERENCES [State] (Id),
	CONSTRAINT FK_Address_To_Region FOREIGN KEY (RegionId)  REFERENCES Region (Id)
)
--drop table Address
------------------------------------------------------
--create table for segment name
create table SegmentCustomer
(
	Id int Identity(1,1) primary key,
	[Name] nvarchar(50) unique not null
)
--drop table segmentCustomer
------------------------------------------------------
--create table for customer
create table Customer
(
	Id nvarchar(20) primary key,
	[Name] nvarchar(100) unique not null,
	CustomerSegmentId int not null,
	CONSTRAINT FK_Customer_To_CustomerSegment FOREIGN KEY (CustomerSegmentId)  REFERENCES segmentCustomer (Id)
)
--drop table Customer
------------------------------------------------------
--create table for product category
create table ProductCategory
(
	Id int Identity(1,1) primary key,
	[Name] nvarchar(50) unique not null,
	ProductParentCategoryId int,
	CONSTRAINT FK_ProductCategory_To_ProductSubCategoryKey FOREIGN KEY (ProductParentCategoryId)  REFERENCES ProductCategory (Id),
)
--drop table ProductCategory
------------------------------------------------------
--create table for product subcategory
/*
create table ProductSubCategory
(
	Id int Identity(1,1) primary key,
	[Name] nvarchar(50) unique not null,
	ProductParentCategoryId int not null,
	CONSTRAINT FK_ProductCategory_To_ProductSubCategoryKey FOREIGN KEY (ProductParentCategoryId)  REFERENCES ProductCategory (Id),
	CONSTRAINT UK_ProductCategory UNIQUE ([Name],ProductParentCategoryId)
)
*/
--drop table ProductSubCategory
------------------------------------------------------
--create table for product 
create table Product
(
	Id nvarchar(40) primary key,
	ProductCategoryId int not null,
	ProductSubCategoryId int  not null,
	[Name] nvarchar(255) not null,
	[Price] money,
	CONSTRAINT FK_Product_To_ProductCategoryKey FOREIGN KEY (ProductCategoryId)  REFERENCES ProductCategory (Id),
	CONSTRAINT FK_Product_To_ProductSubCategoryKey FOREIGN KEY (ProductSubCategoryId)  REFERENCES ProductCategory (Id)
)
--drop table Product
------------------------------------------------------
--create table for ship mode
create table ShipMode
(
	Id int Identity(1,1) primary key,
	[Name] nvarchar(50) unique not null
)
--drop table ShipMode
-----------------------------------------------------
-- add PurshaseSales as a summ of sales in the specific order
create table [Order]
(
	ID nvarchar(40) primary key,
	OrderDate datetime2 not null,
	ShipDate datetime2,
	OrderShipModelID int,
	CustomerID nvarchar(20) not null,
	PostalID int not null,
	CONSTRAINT FK_Order_To_Customer FOREIGN KEY (CustomerID)  REFERENCES customer (id),
	CONSTRAINT FK_Order_To_Postal FOREIGN KEY (PostalID)  REFERENCES [address] (postalcode),
	CONSTRAINT FK_Order_To_OrderShipModel FOREIGN KEY (OrderShipModelID)  REFERENCES ShipMode (Id)
)
--drop table [Order]
---add CHECK!!!!
------------------------------------------------------
--create table for OrderList
--many-to-many list to store details about each order
create table OrderList
(
	OrderID nvarchar(40) not null,
	ProductId nvarchar(40) not null,
	Sales money,
	Quantity int,
	Discoint float,
	Profit money,
	CONSTRAINT FK_OrderListOrderID_To_OrderID FOREIGN KEY (OrderID) REFERENCES [Order] (ID),
	CONSTRAINT FK_OrderListProductId_To_ProductId FOREIGN KEY (ProductId) REFERENCES Product (Id),
)
--drop table OrderList
------------------------------------------------------

