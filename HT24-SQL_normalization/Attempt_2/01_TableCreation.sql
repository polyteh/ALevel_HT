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
)
--drop table ProductCategory
------------------------------------------------------
--create table for product subcategory
create table ProductSubCategory
(
	Id int Identity(1,1) primary key,
	[Name] nvarchar(50) unique not null,
	ProductParentCategoryId int not null,
	CONSTRAINT FK_ProductCategory_To_ProductSubCategoryKey FOREIGN KEY (ProductParentCategoryId)  REFERENCES ProductCategory (Id),
	CONSTRAINT UK_ProductCategory UNIQUE ([Name],ProductParentCategoryId)
)
--drop table ProductSubCategory
------------------------------------------------------
--create table for product 
create table Product
(
	Id nvarchar(40) primary key,
	ProductSubCategoryId int  not null,
	[Name] nvarchar(255) not null,
	[Price] money,
	CONSTRAINT FK_Product_To_ProductSubCategoryKey FOREIGN KEY (ProductSubCategoryId)  REFERENCES ProductSubCategory (Id)
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
------------------------------------------------------
--create table for OrderDetails
--unique order numbers are stored here
create table OrderDet
(
	ID nvarchar(40) primary key,
	OrderDate datetime2 not null,
	ShipDate datetime2,
	OrderShipModelID int,
	CONSTRAINT FK_Order_To_OrderShipModel FOREIGN KEY (OrderShipModelID)  REFERENCES ShipMode (Id)
)
--drop table OrderDet
------------------------------------------------------
--create table for OrderList
--many-to-many list to store details about each order
create table OrderList
(
	OrderListId int Identity(1,1) primary key, --do we really need it?
	OrderListOrderID nvarchar(40) not null,
	OrderListProductId nvarchar(40) not null,
	OrderListSales money,
	OrderSalesQuantity int,
	OrderSalesDiscoint float,
	OrderSalesProfit money,
	CONSTRAINT FK_OrderListOrderID_To_OrderID FOREIGN KEY (OrderListOrderID) REFERENCES OrderDet (ID),
	CONSTRAINT FK_OrderListProductId_To_ProductId FOREIGN KEY (OrderListProductId) REFERENCES Product (Id),
)
--drop table OrderList
------------------------------------------------------
--create final PURSHASE table
-- add PurshaseSales as a summ of sales in the specific order
create table PURSHASE
(
	PurchaseId int Identity(1,1) primary key,
	PurshaseOrderID nvarchar(40) not null,
	PurshaseCustomerID nvarchar(20) not null,
	PurshasePostalID int not null,
	PurshaseSales money,--do we need this one as a sum from items in order list?
	CONSTRAINT FK_PURSHASE_To_Order FOREIGN KEY (PurshaseOrderID)  REFERENCES Orderdet (id),
	CONSTRAINT FK_PURSHASE_To_CUSTOMER FOREIGN KEY (PurshaseCustomerID)  REFERENCES customer (id),
	CONSTRAINT FK_PURSHASE_To_POSTAL FOREIGN KEY (PurshasePostalID)  REFERENCES [address] (postalcode),

)
--drop table PURSHASE
---add CHECK!!!!