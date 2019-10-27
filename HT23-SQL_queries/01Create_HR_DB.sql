--DROP DATABAse if exists test
Create database HumanResources --создали базу данных
use HumanResources -- переключились на созданную базу
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
	Salary money NOT NULL DEFAULT(0) check(Salary>=0),-- зарплата больше/равна нулю
	DepartmentId int NOT NULL	
);
go
-- внешний ключ что ChiefID связан с Id
-- что будет с ChiefId подчиненного, если я удалю запись начальника?
-- что в данном контексте значит WITH CHECK? если мы пытаемся вставить новую строку, у которой ChiefID указывает на несуществующий iD, то запись не добавится и мы получим ошибку?
-- WITH CHECK OPTION will make sure that all INSERT and UPDATE statements executed against the view meet the restrictions in the WHERE clause, 
--and that the modified data in the view remains visible after INSERT and UPDATE statements.
ALTER TABLE Employee WITH CHECK ADD FOREIGN KEY (ChiefId) REFERENCES Employee (Id);
ALTER TABLE Employee WITH CHECK ADD FOREIGN KEY(DepartmentId) REFERENCES Department (Id);
--имя департмента тоже уникальное
ALTER TABLE department ADD UNIQUE (Name);