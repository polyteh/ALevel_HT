use HumanResources;
--��������������� � �������� ������� ������ ������� � ����������� �����������
--������������ � �������� ������� �� �������� ������ (�� ������ ����� �������)
SELECT d.id, d.Name, -- ��� ������������
       (SELECT COUNT(1) FROM Employee WHERE DepartmentId = d.Id)
           AS [Employees in departments] 
FROM Department d order by [Name] DESC;

--������� ������ �����������, ���������� ���������� ����� ������� ��� � ����������������� ������������
SELECT e.name,e.salary as Employeesalary,
(select boss.salary from Employee  boss  where boss.id=e.ChiefId) as DepartmentBossSalary,
(select boss.name from Employee  boss  where boss.id=e.ChiefId) as BossName,
(select d.name from department d where d.id=e.DepartmentId) as Department
from employee e where e.Salary>
(
Select boss.salary from Employee  boss  where boss.id=e.ChiefId
) order by [Department];
go

--select e.name from employee e where e.ChiefId=
--(
--select boss.id from Employee boss where boss.Name='Bob'
--);

--������� ������ �������, ���������� ����������� � ������� �� ��������� 3 �������
-- Cleaning (�� ��� �� ��������� �������� � ������������� �� �� ����������)
-- ��� ��� ������: � ��� ���� ����� (SELECT COUNT(1) FROM Employee WHERE DepartmentId = d.Id): ���� ��� ��� ������ � ������, ������ ��� ������ � where. � ����� ���-�� ����� �� ������ �������?
SELECT d.id, d.Name, -- ��� ������������
       (SELECT COUNT(1) FROM Employee WHERE DepartmentId = d.Id)
           AS [Employees in departments] 
FROM Department d  WHERE  (SELECT COUNT(1) FROM Employee WHERE DepartmentId = d.Id)<3

--����� ������ ������� � ������������ ��������� ��������� �����������
--������ 1
SELECT TOP 1 d.id, d.name,
(SELECT SUM(Salary) FROM Employee e WHERE e.DepartmentId=d.id GROUP BY e.DepartmentId ) as AverageDepartmentSalary
FROM department d
-- ������ 2
SELECT (SELECT d.Name from Department d WHERE d.Id = DepartmentId), SUM(Salary) -- ��� ������������ � ����� �������� �� ����
FROM Employee
GROUP BY DepartmentId;

SELECT TOP 1 (SELECT d.Name from Department d WHERE d.Id = DepartmentId), SUM(Salary) -- ��� ������������ � ������������ ����� ���������
FROM Employee
GROUP BY DepartmentId; 

--������� ������ �����������, �� ������� ������������ ������������, ����������� � ���-�� ������
--���� � ��������� ����� ��������� �������, �� ������ ������ ��� ���������, ������� �� �������� � ������������, �� �� ��� �� ���, ����� �������
--��� ��������� �������� ��� �� ����������, ��� � � ���� ��� ��������
SELECT emp.Id,(SELECT d.name FROM department d WHERE d.id=emp.DepartmentId) as Department, emp.Name 
FROM Employee emp 
WHERE emp.DepartmentId!=(SELECT boss.DepartmentId FROM employee boss WHERE boss.Id=emp.ChiefId)

--SQL-������, ����� ����� ������ ����� ������� �������� ���������
SELECT TOP 1 e.Name, e.salary FROM(SELECT TOP 2 emp.salary,emp.Name FROM Employee emp ORDER BY Salary DESC) AS e ORDER BY salary ASC
--��� �������� ������������
SELECT e.name, e.salary FROM employee e ORDER BY salary DESC
