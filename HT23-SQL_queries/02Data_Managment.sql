use HumanResources -- ������������� �� ������ ����
go

-- �������� ������ � ������ �� Id
INSERT INTO department (Name) VALUES ('Administration'), ('Cafeteria'), ('Human Resources'), ('Power'), ('Shipping'), ('Accounting'), ('Data processing'), ('Cleaning');
SELECT * FROM Department order by id;
go

-- �� ����� ��� ����� ������� insert ��� ����� values
-- ������������ ��������� INSERT INTO SELECT, ������ ������� https://www.w3schools.com/sql/sql_insert_into_select.asp
-- ���������� ���� ��� ����������
INSERT INTO Employee (ChiefId, Name, DepartmentId)
SELECT NULL, 'Bob', d.Id FROM Department d WHERE Name = 'Administration';
select * from Employee;
--delete from Employee;
go

-- ��� ��������
--INSERT INTO Employee (ChiefId, Name, DepartmentId)
--values
(
--Null,'Bob', (select d.Id from Department d where Name='Administration')
--)
--select * from Employee;
--go

--��� �������
-- ���������� ����������� �� �������, ��������� SELECT �������� Id ���������� ���������
INSERT INTO Employee (ChiefId, Name, DepartmentId)
VALUES (NULL, 'Steve', (SELECT d.Id FROM Department d WHERE Name = 'Cafeteria')),
	   (NULL, 'Gordon', (SELECT d.Id FROM Department d WHERE Name = 'Human Resources')),
	   (NULL, 'Denis', (SELECT d.Id FROM Department d WHERE Name = 'Power')),
	   (NULL, 'John', (SELECT d.Id FROM Department d WHERE Name = 'Shipping')),
	   (NULL, 'Samantha', (SELECT d.Id FROM Department d WHERE Name = 'Accounting')),
	   (NULL, 'Trace', (SELECT d.Id FROM Department d WHERE Name = 'Data processing'));

-- ���������� ��� �������� ���� ��������� ���� �������
SELECT * FROM Employee;
go


-- �������� 3 ������� � ���������� � �������� �� � ������ 'Bob'
-- INSERT �� ��������� ������� ����, ������� ��������� ��� ���������� ��� ������� �����
INSERT INTO Employee (ChiefId, Name, DepartmentId)
-- select top �������� �� ���������� ����� ��� order by ������?
SELECT (SELECT TOP 1 Id FROM Employee WHERE Name != 'Bob'), -- ��������� ��������� �������������� ����������
	   Names.Name, -- ��� �� FROM
	   (SELECT Id FROM Department WHERE Name = 'Administration') -- ��������� ��������� �������������� ������������ 'Administration'
FROM (VALUES ('Raymond'), ('Hannah'), ('Ruby')) AS Names(Name);

SELECT * FROM Employee ORDER BY Name; -- ������� ���������� Employee, ��������������� �� ������� Name
--SELECT * FROM Employee ORDER BY Name DESC; -- ������� ���������� Employee, ��������������� �� ������� Name � �������� �������
--SELECT * FROM Employee ORDER BY NEWID(); -- ������� ���������� Employee, ��������������� � ��������� �������, NEWID() - ��������� UNIQUEIDENTIFIER (GUID), ������ ���������� ���������� �� ��������������� GUID'��
go

-- ��� �������, # ����� ������ ������� ����������, ��� ��� ���������
CREATE TABLE #names (Name nvarchar(100) UNIQUE);
INSERT INTO #names VALUES ('Lionel'), ('Kermit'), ('Hayden'), ('Rashad'), ('Kimberly'), ('Thaddeus'), ('Brynn'), ('Madonna'), ('Eagan'), ('Rudyard'), ('Aidan'), ('Kim'), ('Oscar'), ('Stewart'), ('Kirk'), ('Keith'), ('Blaine'), ('Eden'), ('Aubrey'), ('Lydia'), ('Rhea'), ('Shelby'), ('Haviva'), ('Miranda'), ('Dorian'), ('Reuben'), ('Michael'), ('Joy'), ('Thane'), ('Cynthia'), ('Chanda'), ('Macey'), ('Fay'), ('Ryder'), ('Olivia'), ('Imelda'), ('Marah'), ('Eric'), ('Denise'), ('Clark'), ('Cheryl'), ('Tyrone'), ('Otto'), ('Dakota'), ('Nora'), ('Neville'), ('Adena'), ('Hiram'), ('Cally'), ('Lois'), ('Cassandra'), ('Herman'), ('Len'), ('Walker'), ('Fiona'), ('Graiden'), ('Hamilton'), ('Cruz'), ('Axel'), ('Velma'), ('Mariam'), ('Jin'), ('Colt'), ('Kaitlin'), ('Frances'), ('Britanni'), ('Linus'), ('Wayne'), ('Knox'), ('Hyacinth'), ('Yael'), ('Lesley'), ('Jaime'), ('Aline'), ('Dalton'), ('Irene'), ('Scarlet'), ('Mariko'), ('Brady'), ('Blair'), ('Madeson'), ('Jena'), ('Josephine'), ('Joel'), ('Moana'), ('Colton'), ('Abbot'), ('Aristotle'), ('Perry'), ('Phillip'), ('Kamal'), ('Lamar'), ('Steel');
go

-- �������, �� �������
-- ��������� �����������
DECLARE @currentName nvarchar(100) = (SELECT TOP 1 Name from #names); -- ������� ���������� � �������� � ��� ������ ��� �� ��������� �������
DECLARE @departmentId int, @chiefId int; -- �������� ���������� ��� �������� ���������������
-- ���� while
WHILE @currentName IS NOT NULL -- ���� ����� �� ��������� ������� �� ����������
BEGIN
	SELECT TOP 1 @chiefId = Id, @departmentId = DepartmentId FROM Employee ORDER BY NEWID(); -- ������� 1 ���������� Employee � �������� ��� Id � DepartmentId � @����������; 
	--����������� �� ���������� ���� ��������� ��� ����� ���� ������������ ��� �����?
	INSERT INTO Employee (ChiefId, Name, DepartmentId) VALUES (@chiefId, @currentName, @departmentId); -- �������� ������ �������� � ������ �� ����������
	DELETE FROM #names WHERE Name = @currentName; -- ������� ������� ��� �� ��������� ������� ����
	-- � ��� ����� ����� SET, ���� �� ������ ��� ���� ����������?? SET �� ������ �� ������, �� ��� � �� ��������� ����������?
	 SET @currentName = (SELECT TOP 1 Name from #names); -- ������� ��������� ��� �� ������� ��� NULL ���� ����� �����������
END;
DROP TABLE #names;
go

SELECT * FROM Employee ORDER BY Name;

-- ��������� ��������� �������� ��������� �������
UPDATE Employee -- �������
SET Salary = CAST(ABS(CHECKSUM(NewId())) AS MONEY) % 100000 / 100 + 500 -- �� ����� ����� ������� � ���������, ���������� ����� � �������� [500.00; 1500.00]
WHERE Salary = 0; -- ���������� ������ ��� � ���� �������� 0
go

SELECT * FROM Employee ORDER BY Name;

-- ���������� �� ���������� ��������� ������
SELECT * FROM Employee ORDER BY Salary;