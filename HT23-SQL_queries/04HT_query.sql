use HumanResources;
--Отсортированный в обратном порядке список отделов с количеством сотрудников
--отсортировал в обратном порядке по названию отдела (не совсем понял условие)
SELECT d.id, d.Name, -- имя департамента
       (SELECT COUNT(1) FROM Employee WHERE DepartmentId = d.Id)
           AS [Employees in departments] 
FROM Department d order by [Name] DESC;

--Print employee list, which have salary higher, than they boss
--Вывести список сотрудников, получающих заработную плату большую чем у непосредственного руководителя
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

-- print department list, wich has less than 3 employees
--Вывести список отделов, количество сотрудников в которых не превышает 3 человек
-- Cleaning (мы ему не назначили шлавного и соотвественно он не заполнялся)
-- вот тут вопрос: я два раза делаю (SELECT COUNT(1) FROM Employee WHERE DepartmentId = d.Id): один раз для данных в строку, второй для работы в where. А можно как-то сжать до одного запроса?
SELECT d.id, d.Name, -- имя департамента
       (SELECT COUNT(1) FROM Employee WHERE DepartmentId = d.Id)
           AS [Employees in departments] 
FROM Department d  WHERE  (SELECT COUNT(1) FROM Employee WHERE DepartmentId = d.Id)<3

--find departments list with the highest summary salary
--Найти список отделов с максимальной суммарной зарплатой сотрудников
-- print all SUM salary
select * FROM department
SELECT (SELECT d.Name from Department d WHERE d.Id = DepartmentId) AS Department, SUM(Salary) AS SummSalary  -- имя департамента и общая зарплата по нему
FROM Employee
GROUP BY DepartmentId Order BY SummSalary DESC;
--just for test
update Employee
set Salary=15000
where DepartmentId=6

--method 1, NEW
--способ 1
SELECT TOP 1 d.id, d.name,
(SELECT  SUM(Salary) FROM Employee e WHERE e.DepartmentId=d.id GROUP BY e.DepartmentId ) as SumDepartmentSalary
FROM department d ORDER BY SumDepartmentSalary DESC
-- способ 2
--method 2, NEW
SELECT TOP 1 (SELECT d.Name from Department d WHERE d.Id = DepartmentId) AS Department, SUM(Salary) AS SummSalary -- имя департамента с максимальной общей зарплатой
FROM Employee
GROUP BY DepartmentId ORDER BY SummSalary DESC; 
--method 3, NEW
-- Actually, I dont like this solution: how can I improve it?
SELECT d.id, d.name,
(SELECT SUM(Salary) FROM Employee e WHERE e.DepartmentId=d.id GROUP BY e.DepartmentId ) as SumDepartmentSalary
FROM department d 
WHERE (SELECT SUM(Salary) FROM Employee e WHERE e.DepartmentId=d.id GROUP BY e.DepartmentId )>=(SELECT TOP 1
(SELECT  SUM(Salary) FROM Employee e WHERE e.DepartmentId=d.id GROUP BY e.DepartmentId ) as SumDepartmentSalary
FROM department d ORDER BY SumDepartmentSalary DESC)


 

--NEW print employees list, which have not the boss from the same department or have no boss at all
--Вывести список сотрудников, не имеющих назначенного руководителя, работающего в том-же отделе
--если я правильно понял заполение таблицы, то только первых три персонажа, которых ма добавили в администраци, но их шеф не Боб, будут выбраны
--все остальные получали тот же департмент, что и у шефа при создании
SELECT emp.Id,(SELECT d.name FROM department d WHERE d.id=emp.DepartmentId) as Department, emp.Name 
FROM Employee emp 
WHERE emp.DepartmentId!=(SELECT boss.DepartmentId FROM employee boss WHERE boss.Id=emp.ChiefId) OR emp.ChiefId IS NULL

--SQL query to find the second highest employee salary
--SQL-запрос, чтобы найти вторую самую высокую зарплату работника
SELECT TOP 1 e.Name, e.salary FROM(SELECT TOP 2 emp.salary,emp.Name FROM Employee emp ORDER BY Salary DESC) AS e ORDER BY salary ASC
--для проверки правильности
SELECT e.name, e.salary FROM employee e ORDER BY salary DESC

--Вывести список сотрудников, получающих максимальную заработную плату в своем отделе

-- я правильно понимаю, что в первой части SELECT я могу использовать только то, что стоит после groupBy и агрегатные операциии над группой (MAX, AVG)?
--SELECT e.DepartmentId, e.Name, MAX(Salary) as MaxSalary FROM Employee e GROUP BY DepartmentId --вот такое не сработает
SELECT e.DepartmentId, MAX(Salary) as MaxSalary FROM Employee e GROUP BY DepartmentId

SELECT d.Name,MAX(Salary) FROM Employee e 
RIGHT JOIN Department d ON e.DepartmentId = d.Id
group by d.Name

--NEW Print list of employees, which have maximum salary in they department
--Вывести список сотрудников, получающих максимальную заработную плату в своем отделе
SELECT e.Name, e.Salary, (SELECT d.Name FROM department d where d.id=e.DepartmentId) as DepartmentName
FROM Employee e 
where e.Salary>=(SELECT MAX(Salary) as MaxSalary FROM Employee emp where emp.DepartmentId=e.DepartmentId GROUP BY emp.DepartmentId) ORDER BY e.Salary DESC

