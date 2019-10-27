use HumanResources;
--ќтсортированный в обратном пор€дке список отделов с количеством сотрудников
--отсортировал в обратном пор€дке по названию отдела (не совсем пон€л условие)
SELECT d.id, d.Name, -- им€ департамента
       (SELECT COUNT(1) FROM Employee WHERE DepartmentId = d.Id)
           AS [Employees in departments] 
FROM Department d order by [Name] DESC;

--¬ывести список сотрудников, получающих заработную плату большую чем у непосредственного руководител€
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

--¬ывести список отделов, количество сотрудников в которых не превышает 3 человек
-- Cleaning (мы ему не назначили шлавного и соотвественно он не заполн€лс€)
-- вот тут вопрос: € два раза делаю (SELECT COUNT(1) FROM Employee WHERE DepartmentId = d.Id): один раз дл€ данных в строку, второй дл€ работы в where. ј можно как-то сжать до одного запроса?
SELECT d.id, d.Name, -- им€ департамента
       (SELECT COUNT(1) FROM Employee WHERE DepartmentId = d.Id)
           AS [Employees in departments] 
FROM Department d  WHERE  (SELECT COUNT(1) FROM Employee WHERE DepartmentId = d.Id)<3

--Ќайти список отделов с максимальной суммарной зарплатой сотрудников
--способ 1
SELECT TOP 1 d.id, d.name,
(SELECT SUM(Salary) FROM Employee e WHERE e.DepartmentId=d.id GROUP BY e.DepartmentId ) as AverageDepartmentSalary
FROM department d
-- способ 2
SELECT (SELECT d.Name from Department d WHERE d.Id = DepartmentId), SUM(Salary) -- им€ департамента и обща€ зарплата по нему
FROM Employee
GROUP BY DepartmentId;

SELECT TOP 1 (SELECT d.Name from Department d WHERE d.Id = DepartmentId), SUM(Salary) -- им€ департамента с максимальной общей зарплатой
FROM Employee
GROUP BY DepartmentId; 

--¬ывести список сотрудников, не имеющих назначенного руководител€, работающего в том-же отделе
--если € правильно пон€л заполение таблицы, то только первых три персонажа, которых ма добавили в администраци, но их шеф не Ѕоб, будут выбраны
--все остальные получали тот же департмент, что и у шефа при создании
SELECT emp.Id,(SELECT d.name FROM department d WHERE d.id=emp.DepartmentId) as Department, emp.Name 
FROM Employee emp 
WHERE emp.DepartmentId!=(SELECT boss.DepartmentId FROM employee boss WHERE boss.Id=emp.ChiefId)

--SQL-запрос, чтобы найти вторую самую высокую зарплату работника
SELECT TOP 1 e.Name, e.salary FROM(SELECT TOP 2 emp.salary,emp.Name FROM Employee emp ORDER BY Salary DESC) AS e ORDER BY salary ASC
--дл€ проверки правильности
SELECT e.name, e.salary FROM employee e ORDER BY salary DESC
