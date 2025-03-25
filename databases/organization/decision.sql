/*
Задача 1
Найти всех сотрудников, подчиняющихся Ивану Иванову (с EmployeeID = 1), включая их подчиненных и подчиненных подчиненных.
Для каждого сотрудника вывести следующую информацию:
    - EmployeeID: идентификатор сотрудника.
    - Имя сотрудника.
    - ManagerID: Идентификатор менеджера.
    - Название отдела, к которому он принадлежит.
    - Название роли, которую он занимает.
    - Название проектов, к которым он относится (если есть, конкатенированные в одном столбце через запятую).
    - Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце через запятую).
Если у сотрудника нет назначенных проектов или задач, отобразить NULL.

Требования:
    - Рекурсивно извлечь всех подчиненных сотрудников Ивана Иванова и их подчиненных.
    - Для каждого сотрудника отобразить информацию из всех таблиц.
    - Результаты должны быть отсортированы по имени сотрудника.
    - Решение задачи должно представлять из себя один sql-запрос и задействовать ключевое слово RECURSIVE.
 */

with RECURSIVE recursiveCTE AS
                   (SELECT employeeid, name, managerid, departmentid, roleid
                    FROM employees
                    WHERE employeeid = 1

                    UNION ALL

                    SELECT e.employeeid, e.name, e.managerid, e.departmentid, e.roleid
                    FROM employees e
                             JOIN recursiveCTE r on e.managerid = r.employeeid)
SELECT employeeid                             as EmployeeID,
       name                                   as EmployeeName,
       managerid                              as ManagerID,
       departmentname                         as DepartmentName,
       rolename                               as RoleName,
       string_agg(DISTINCT projectname, ', ') as ProjectNames,
       string_agg(DISTINCT taskname, ', ')    as TaskNames
FROM recursiveCTE
         JOIN departments d USING (departmentid)
         JOIN roles USING (roleid)
         JOIN projects p USING (departmentid)
         LEFT JOIN tasks t on t.assignedto = employeeid
GROUP BY employeeid, name, managerid, departmentname, rolename, projectname
ORDER BY name;

/*
Задача 2
Найти всех сотрудников, подчиняющихся Ивану Иванову с EmployeeID = 1, включая их подчиненных и подчиненных подчиненных.
Для каждого сотрудника вывести следующую информацию:
    - EmployeeID: идентификатор сотрудника.
    - Имя сотрудника.
    - Идентификатор менеджера.
    - Название отдела, к которому он принадлежит.
    - Название роли, которую он занимает.
    - Название проектов, к которым он относится (если есть, конкатенированные в одном столбце).
    - Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце).
    - Общее количество задач, назначенных этому сотруднику.
    - Общее количество подчиненных у каждого сотрудника (не включая подчиненных их подчиненных).
Если у сотрудника нет назначенных проектов или задач, отобразить NULL.
*/

with RECURSIVE recursiveCTE AS
                   (SELECT employeeid, name, managerid, departmentid, roleid
                    FROM employees
                    WHERE employeeid = 1

                    UNION ALL

                    SELECT e.employeeid, e.name, e.managerid, e.departmentid, e.roleid
                    FROM employees e
                             JOIN recursiveCTE r on e.managerid = r.employeeid)
SELECT employeeid                             as EmployeeID,
       name                                   as EmployeeName,
       r.managerid                            as ManagerID,
       departmentname                         as DepartmentName,
       rolename                               as RoleName,
       string_agg(DISTINCT projectname, ', ') as ProjectNames,
       string_agg(DISTINCT taskname, ', ')    as TaskNames,
       count(assignedto)                      as TotalTasks,
       coalesce(totalSubordinates, 0)         as TotalSubordinates
FROM recursiveCTE r
         JOIN departments d USING (departmentid)
         JOIN roles USING (roleid)
         JOIN projects p USING (departmentid)
         LEFT JOIN tasks t on t.assignedto = employeeid
         LEFT JOIN (SELECT managerid, count(*) as totalSubordinates
                    FROM employees
                    GROUP BY managerid) as count_subordinates
                   on employeeid = count_subordinates.managerid
GROUP BY employeeid, name, r.managerid, departmentname, rolename, projectname, totalSubordinates
ORDER BY name;

/*
Задача 3
Найти всех сотрудников, которые занимают роль менеджера и имеют подчиненных (то есть число подчиненных больше 0).
Для каждого такого сотрудника вывести следующую информацию:
    - EmployeeID: идентификатор сотрудника.
    - Имя сотрудника.
    - Идентификатор менеджера.
    - Название отдела, к которому он принадлежит.
    - Название роли, которую он занимает.
    - Название проектов, к которым он относится (если есть, конкатенированные в одном столбце).
    - Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце).
    - Общее количество подчиненных у каждого сотрудника (включая их подчиненных).
Если у сотрудника нет назначенных проектов или задач, отобразить NULL.
 */

