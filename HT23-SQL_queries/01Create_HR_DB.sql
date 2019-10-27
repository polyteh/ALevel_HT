--DROP DATABAse if exists test
Create database HumanResources --������� ���� ������
use HumanResources -- ������������� �� ��������� ����
go
create table department
(
	Id int Identity(1,1) primary key,
	Name nvarchar(100) unique not null
)
go
CREATE TABLE Employee
(
	Id int IDENTITY(1,1) PRIMARY KEY,
	ChiefId int NULL,
	Name nvarchar(100) unique NOT NULL,
	Salary money NOT NULL DEFAULT(0) check(Salary>=0),-- �������� ������/����� ����
	DepartmentId int NOT NULL	
);
go
-- ������� ���� ��� ChiefID ������ � Id
-- ��� ����� � ChiefId ������������, ���� � ����� ������ ����������?
-- ��� � ������ ��������� ������ WITH CHECK? ���� �� �������� �������� ����� ������, � ������� ChiefID ��������� �� �������������� iD, �� ������ �� ��������� � �� ������� ������?
-- WITH CHECK OPTION will make sure that all INSERT and UPDATE statements executed against the view meet the restrictions in the WHERE clause, 
--and that the modified data in the view remains visible after INSERT and UPDATE statements.
ALTER TABLE Employee WITH CHECK ADD FOREIGN KEY (ChiefId) REFERENCES Employee (Id);
ALTER TABLE Employee WITH CHECK ADD FOREIGN KEY(DepartmentId) REFERENCES Department (Id);
--��� ����������� ���� ����������
ALTER TABLE department ADD UNIQUE (Name);