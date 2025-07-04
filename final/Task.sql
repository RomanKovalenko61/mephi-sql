--База данных 1

CREATE TYPE vehicle_type AS ENUM ('Car', 'Motorcycle', 'Bicycle');
-- Создание таблицы Vehicle
CREATE TABLE Vehicle
(
    maker VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    type  vehicle_type NOT NULL,
    PRIMARY KEY (model)
);

CREATE TYPE transmission_type AS ENUM ('Automatic', 'Manual');
-- Создание таблицы Car
CREATE TABLE Car
(
    vin             VARCHAR(17)       NOT NULL,
    model           VARCHAR(100)      NOT NULL,
    engine_capacity DECIMAL(4, 2)     NOT NULL, -- объем двигателя в литрах
    horsepower      INT               NOT NULL, -- мощность в лошадиных силах
    price           DECIMAL(10, 2)    NOT NULL, -- цена в долларах
    type            transmission_type NOT NULL, -- тип трансмиссии
    PRIMARY KEY (vin),
    FOREIGN KEY (model) REFERENCES Vehicle (model)
);

CREATE TYPE moto_type AS ENUM ('Sport', 'Cruiser', 'Touring');
-- Создание таблицы Motorcycle
CREATE TABLE Motorcycle
(
    vin             VARCHAR(17)    NOT NULL,
    model           VARCHAR(100)   NOT NULL,
    engine_capacity DECIMAL(4, 2)  NOT NULL, -- объем двигателя в литрах
    horsepower      INT            NOT NULL, -- мощность в лошадиных силах
    price           DECIMAL(10, 2) NOT NULL, -- цена в долларах
    type            moto_type      NOT NULL, -- тип мотоцикла
    PRIMARY KEY (vin),
    FOREIGN KEY (model) REFERENCES Vehicle (model)
);

CREATE TYPE type_type AS ENUM ('Mountain', 'Road', 'Hybrid');
-- Создание таблицы Bicycle
CREATE TABLE Bicycle
(
    serial_number VARCHAR(20)    NOT NULL,
    model         VARCHAR(100)   NOT NULL,
    gear_count    INT            NOT NULL, -- количество передач
    price         DECIMAL(10, 2) NOT NULL, -- цена в долларах
    type          type_type      NOT NULL  -- тип велосипеда
);

--Скрипт наполнения базы данными
-- Вставка данных в таблицу Vehicle
INSERT INTO Vehicle (maker, model, type)
VALUES ('Toyota', 'Camry', 'Car'),
       ('Honda', 'Civic', 'Car'),
       ('Ford', 'Mustang', 'Car'),
       ('Yamaha', 'YZF-R1', 'Motorcycle'),
       ('Harley-Davidson', 'Sportster', 'Motorcycle'),
       ('Kawasaki', 'Ninja', 'Motorcycle'),
       ('Trek', 'Domane', 'Bicycle'),
       ('Giant', 'Defy', 'Bicycle'),
       ('Specialized', 'Stumpjumper', 'Bicycle');

SELECT *
FROM Vehicle;

-- Вставка данных в таблицу Car
INSERT INTO Car (vin, model, engine_capacity, horsepower, price, type)
VALUES ('1HGCM82633A123456', 'Camry', 2.5, 203, 24000.00, 'Automatic'),
       ('2HGFG3B53GH123456', 'Civic', 2.0, 158, 22000.00, 'Manual'),
       ('1FA6P8CF0J1234567', 'Mustang', 5.0, 450, 55000.00, 'Automatic');

SELECT *
FROM Car;

-- Вставка данных в таблицу Motorcycle
INSERT INTO Motorcycle (vin, model, engine_capacity, horsepower, price, type)
VALUES ('JYARN28E9FA123456', 'YZF-R1', 1.0, 200, 17000.00, 'Sport'),
       ('1HD1ZK3158K123456', 'Sportster', 1.2, 70, 12000.00, 'Cruiser'),
       ('JKBVNAF156A123456', 'Ninja', 0.9, 150, 14000.00, 'Sport');

SELECT *
FROM Motorcycle;

-- Вставка данных в таблицу Bicycle
INSERT INTO Bicycle (serial_number, model, gear_count, price, type)
VALUES ('SN123456789', 'Domane', 22, 3500.00, 'Road'),
       ('SN987654321', 'Defy', 20, 3000.00, 'Road'),
       ('SN456789123', 'Stumpjumper', 30, 4000.00, 'Mountain');

SELECT *
FROM Bicycle;

SELECT v.model
FROM Car c
         JOIN Vehicle v ON c.model = v.model
WHERE c.type = 'Automatic'
  AND c.price < 30000;

SELECT v.model
FROM Motorcycle m
         JOIN Vehicle v ON m.model = v.model
WHERE m.type = 'Sport'
  AND m.price < 15000;

SELECT v.model
FROM Bicycle b
         JOIN Vehicle v ON b.model = v.model
WHERE b.gear_count > 20
  AND b.price < 4000
ORDER BY v.model;

--База данных 2

-- Создание таблицы Classes

CREATE TYPE classes_type AS ENUM ('Racing', 'Street');
CREATE TABLE Classes
(
    class      VARCHAR(100)  NOT NULL,
    type       classes_type  NOT NULL,
    country    VARCHAR(100)  NOT NULL,
    numDoors   INT           NOT NULL,
    engineSize DECIMAL(3, 1) NOT NULL, -- размер двигателя в литрах
    weight     INT           NOT NULL, -- вес автомобиля в килограммах
    PRIMARY KEY (class)
);

-- Создание таблицы Cars
CREATE TABLE Cars
(
    name  VARCHAR(100) NOT NULL,
    class VARCHAR(100) NOT NULL,
    year  INT          NOT NULL,
    PRIMARY KEY (name),
    FOREIGN KEY (class) REFERENCES Classes (class)
);

-- Создание таблицы Races
CREATE TABLE Races
(
    name VARCHAR(100) NOT NULL,
    date DATE         NOT NULL,
    PRIMARY KEY (name)
);

-- Создание таблицы Results
CREATE TABLE Results
(
    car      VARCHAR(100) NOT NULL,
    race     VARCHAR(100) NOT NULL,
    position INT          NOT NULL,
    PRIMARY KEY (car, race),
    FOREIGN KEY (car) REFERENCES Cars (name),
    FOREIGN KEY (race) REFERENCES Races (name)
);

-- Вставка данных в таблицу Classes
INSERT INTO Classes (class, type, country, numDoors, engineSize, weight)
VALUES ('SportsCar', 'Racing', 'USA', 2, 3.5, 1500),
       ('Sedan', 'Street', 'Germany', 4, 2.0, 1200),
       ('SUV', 'Street', 'Japan', 4, 2.5, 1800),
       ('Hatchback', 'Street', 'France', 5, 1.6, 1100),
       ('Convertible', 'Racing', 'Italy', 2, 3.0, 1300),
       ('Coupe', 'Street', 'USA', 2, 2.5, 1400),
       ('Luxury Sedan', 'Street', 'Germany', 4, 3.0, 1600),
       ('Pickup', 'Street', 'USA', 2, 2.8, 2000);

SELECT *
FROM Classes;

-- Вставка данных в таблицу Cars
INSERT INTO Cars (name, class, year)
VALUES ('Ford Mustang', 'SportsCar', 2020),
       ('BMW 3 Series', 'Sedan', 2019),
       ('Toyota RAV4', 'SUV', 2021),
       ('Renault Clio', 'Hatchback', 2020),
       ('Ferrari 488', 'Convertible', 2019),
       ('Chevrolet Camaro', 'Coupe', 2021),
       ('Mercedes-Benz S-Class', 'Luxury Sedan', 2022),
       ('Ford F-150', 'Pickup', 2021),
       ('Audi A4', 'Sedan', 2018),
       ('Nissan Rogue', 'SUV', 2020);

SELECT *
FROM Cars;

-- Вставка данных в таблицу Races
INSERT INTO Races (name, date)
VALUES ('Indy 500', '2023-05-28'),
       ('Le Mans', '2023-06-10'),
       ('Monaco Grand Prix', '2023-05-28'),
       ('Daytona 500', '2023-02-19'),
       ('Spa 24 Hours', '2023-07-29'),
       ('Bathurst 1000', '2023-10-08'),
       ('Nürburgring 24 Hours', '2023-06-17'),
       ('Pikes Peak International Hill Climb', '2023-06-25');

SELECT *
FROM Races;

-- Вставка данных в таблицу Results
INSERT INTO Results (car, race, position)
VALUES ('Ford Mustang', 'Indy 500', 1),
       ('BMW 3 Series', 'Le Mans', 3),
       ('Toyota RAV4', 'Monaco Grand Prix', 2),
       ('Renault Clio', 'Daytona 500', 5),
       ('Ferrari 488', 'Le Mans', 1),
       ('Chevrolet Camaro', 'Monaco Grand Prix', 4),
       ('Mercedes-Benz S-Class', 'Spa 24 Hours', 2),
       ('Ford F-150', 'Bathurst 1000', 6),
       ('Audi A4', 'Nürburgring 24 Hours', 8),
       ('Nissan Rogue', 'Pikes Peak International Hill Climb', 3);

SELECT *
FROM Results;


SELECT car
FROM Results
WHERE race IN ('Indy 500', 'Le Mans')
ORDER BY race, position
LIMIT 1;

SELECT Classes.class
FROM Cars
         JOIN Results ON Cars.name = Results.car
         JOIN Classes ON Cars.class = Classes.class
GROUP BY Classes.class
ORDER BY COUNT(DISTINCT Results.race) DESC, Classes.class
LIMIT 1;

SELECT Classes.class
FROM Cars
         JOIN Results ON Cars.name = Results.car
         JOIN Classes ON Cars.class = Classes.class
GROUP BY Classes.class
ORDER BY AVG(Results.position), Classes.class
LIMIT 1;

-- База данных 3

-- Создание таблицы Hotel
CREATE TABLE Hotel
(
    ID_hotel INT PRIMARY KEY,
    name     VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL
);

CREATE TYPE room_type AS ENUM ('Single', 'Double', 'Suite');
-- Создание таблицы Room
CREATE TABLE Room
(
    ID_room  INT PRIMARY KEY,
    ID_hotel INT,
    type     room_type      NOT NULL,
    price    DECIMAL(10, 2) NOT NULL,
    capacity INT            NOT NULL,
    FOREIGN KEY (ID_hotel) REFERENCES Hotel (ID_hotel)
);

-- Создание таблицы Customer
CREATE TABLE Customer
(
    ID_customer INT PRIMARY KEY,
    name        VARCHAR(255)        NOT NULL,
    email       VARCHAR(255) UNIQUE NOT NULL,
    phone       VARCHAR(20)         NOT NULL
);

-- Создание таблицы Booking
CREATE TABLE Booking
(
    ID_booking     INT PRIMARY KEY,
    ID_room        INT,
    ID_customer    INT,
    check_in_date  DATE NOT NULL,
    check_out_date DATE NOT NULL,
    FOREIGN KEY (ID_room) REFERENCES Room (ID_room),
    FOREIGN KEY (ID_customer) REFERENCES Customer (ID_customer)
);

-- Вставка данных в таблицу Hotel
INSERT INTO Hotel (ID_hotel, name, location)
VALUES (1, 'Grand Hotel', 'Paris, France'),
       (2, 'Ocean View Resort', 'Miami, USA'),
       (3, 'Mountain Retreat', 'Aspen, USA'),
       (4, 'City Center Inn', 'New York, USA'),
       (5, 'Desert Oasis', 'Las Vegas, USA'),
       (6, 'Lakeside Lodge', 'Lake Tahoe, USA'),
       (7, 'Historic Castle', 'Edinburgh, Scotland'),
       (8, 'Tropical Paradise', 'Bali, Indonesia'),
       (9, 'Business Suites', 'Tokyo, Japan'),
       (10, 'Eco-Friendly Hotel', 'Copenhagen, Denmark');

INSERT INTO Room (ID_room, ID_hotel, type, price, capacity)
VALUES (1, 1, 'Single', 150.00, 1),
       (2, 1, 'Double', 200.00, 2),
       (3, 1, 'Suite', 350.00, 4),
       (4, 2, 'Single', 120.00, 1),
       (5, 2, 'Double', 180.00, 2),
       (6, 2, 'Suite', 300.00, 4),
       (7, 3, 'Double', 250.00, 2),
       (8, 3, 'Suite', 400.00, 4),
       (9, 4, 'Single', 100.00, 1),
       (10, 4, 'Double', 150.00, 2),
       (11, 5, 'Single', 90.00, 1),
       (12, 5, 'Double', 140.00, 2),
       (13, 6, 'Suite', 280.00, 4),
       (14, 7, 'Double', 220.00, 2),
       (15, 8, 'Single', 130.00, 1),
       (16, 8, 'Double', 190.00, 2),
       (17, 9, 'Suite', 360.00, 4),
       (18, 10, 'Single', 110.00, 1),
       (19, 10, 'Double', 160.00, 2);

-- Вставка данных в таблицу Customer
INSERT INTO Customer (ID_customer, name, email, phone)
VALUES (1, 'John Doe', 'john.doe@example.com', '+1234567890'),
       (2, 'Jane Smith', 'jane.smith@example.com', '+0987654321'),
       (3, 'Alice Johnson', 'alice.johnson@example.com', '+1122334455'),
       (4, 'Bob Brown', 'bob.brown@example.com', '+2233445566'),
       (5, 'Charlie White', 'charlie.white@example.com', '+3344556677'),
       (6, 'Diana Prince', 'diana.prince@example.com', '+4455667788'),
       (7, 'Ethan Hunt', 'ethan.hunt@example.com', '+5566778899'),
       (8, 'Fiona Apple', 'fiona.apple@example.com', '+6677889900'),
       (9, 'George Washington', 'george.washington@example.com', '+7788990011'),
       (10, 'Hannah Montana', 'hannah.montana@example.com', '+8899001122');

-- Вставка данных в таблицу Booking с разнообразием клиентов
INSERT INTO Booking (ID_booking, ID_room, ID_customer, check_in_date, check_out_date)
VALUES (1, 1, 1, '2025-05-01', '2025-05-05'),    -- 4 ночи, John Doe
       (2, 2, 2, '2025-05-02', '2025-05-06'),    -- 4 ночи, Jane Smith
       (3, 3, 3, '2025-05-03', '2025-05-07'),    -- 4 ночи, Alice Johnson
       (4, 4, 4, '2025-05-04', '2025-05-08'),    -- 4 ночи, Bob Brown
       (5, 5, 5, '2025-05-05', '2025-05-09'),    -- 4 ночи, Charlie White
       (6, 6, 6, '2025-05-06', '2025-05-10'),    -- 4 ночи, Diana Prince
       (7, 7, 7, '2025-05-07', '2025-05-11'),    -- 4 ночи, Ethan Hunt
       (8, 8, 8, '2025-05-08', '2025-05-12'),    -- 4 ночи, Fiona Apple
       (9, 9, 9, '2025-05-09', '2025-05-13'),    -- 4 ночи, George Washington
       (10, 10, 10, '2025-05-10', '2025-05-14'), -- 4 ночи, Hannah Montana
       (11, 1, 2, '2025-05-11', '2025-05-15'),   -- 4 ночи, Jane Smith
       (12, 2, 3, '2025-05-12', '2025-05-14'),   -- 2 ночи, Alice Johnson
       (13, 3, 4, '2025-05-13', '2025-05-15'),   -- 2 ночи, Bob Brown
       (14, 4, 5, '2025-05-14', '2025-05-16'),   -- 2 ночи, Charlie White
       (15, 5, 6, '2025-05-15', '2025-05-16'),   -- 1 ночь, Diana Prince
       (16, 6, 7, '2025-05-16', '2025-05-18'),   -- 2 ночи, Ethan Hunt
       (17, 7, 8, '2025-05-17', '2025-05-21'),   -- 4 ночи, Fiona Apple
       (18, 8, 9, '2025-05-18', '2025-05-19'),   -- 1 ночь, George Washington
       (19, 9, 10, '2025-05-19', '2025-05-22'),  -- 3 ночи, Hannah Montana
       (20, 10, 1, '2025-05-20', '2025-05-22'),  -- 2 ночи, John Doe
       (21, 1, 2, '2025-05-21', '2025-05-23'),   -- 2 ночи, Jane Smith
       (22, 2, 3, '2025-05-22', '2025-05-25'),   -- 3 ночи, Alice Johnson
       (23, 3, 4, '2025-05-23', '2025-05-26'),   -- 3 ночи, Bob Brown
       (24, 4, 5, '2025-05-24', '2025-05-25'),   -- 1 ночь, Charlie White
       (25, 5, 6, '2025-05-25', '2025-05-27'),   -- 2 ночи, Diana Prince
       (26, 6, 7, '2025-05-26', '2025-05-29'); -- 3 ночи, Ethan Hunt

SELECT Customer.name AS customer_name
FROM Booking
         JOIN Room ON Booking.ID_room = Room.ID_room
         JOIN Hotel ON Room.ID_hotel = Hotel.ID_hotel
         JOIN Customer ON Booking.ID_customer = Customer.ID_customer
WHERE (Booking.check_out_date - Booking.check_in_date) > 3
GROUP BY Customer.ID_customer, Customer.name
ORDER BY Customer.name
LIMIT 1;

SELECT Room.type
FROM Room
         JOIN Booking ON Room.ID_room = Booking.ID_room
         JOIN Customer ON Booking.ID_customer = Customer.ID_customer
GROUP BY Room.ID_room, Room.type, Room.price
HAVING COUNT(Booking.ID_booking) > 1
ORDER BY COUNT(Booking.ID_booking) DESC, Room.price
LIMIT 1;

SELECT Hotel.name AS hotel_name
FROM Hotel
         JOIN Room ON Hotel.ID_hotel = Room.ID_hotel
         JOIN Booking ON Room.ID_room = Booking.ID_room
WHERE Booking.check_in_date >= CURRENT_DATE - INTERVAL '1 YEAR'
  AND (Booking.check_out_date - Booking.check_in_date) > 3
GROUP BY Hotel.ID_hotel, Hotel.name, Hotel.location
ORDER BY COUNT(DISTINCT Booking.ID_customer) DESC, Hotel.name
LIMIT 1;

-- База данных 4

CREATE TABLE Departments
(
    DepartmentID   INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

CREATE TABLE Roles
(
    RoleID   INT PRIMARY KEY,
    RoleName VARCHAR(100) NOT NULL
);

CREATE TABLE Employees
(
    EmployeeID   INT PRIMARY KEY,
    Name         VARCHAR(100) NOT NULL,
    Position     VARCHAR(100),
    ManagerID    INT,
    DepartmentID INT,
    RoleID       INT,
    FOREIGN KEY (ManagerID) REFERENCES Employees (EmployeeID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments (DepartmentID),
    FOREIGN KEY (RoleID) REFERENCES Roles (RoleID)
);

CREATE TABLE Projects
(
    ProjectID    INT PRIMARY KEY,
    ProjectName  VARCHAR(100) NOT NULL,
    StartDate    DATE,
    EndDate      DATE,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments (DepartmentID)
);

CREATE TABLE Tasks
(
    TaskID     INT PRIMARY KEY,
    TaskName   VARCHAR(100) NOT NULL,
    AssignedTo INT,
    ProjectID  INT,
    FOREIGN KEY (AssignedTo) REFERENCES Employees (EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects (ProjectID)
);

-- Добавление отделов
INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES (1, 'Отдел продаж'),
       (2, 'Отдел маркетинга'),
       (3, 'IT-отдел'),
       (4, 'Отдел разработки'),
       (5, 'Отдел поддержки');

-- Добавление ролей
INSERT INTO Roles (RoleID, RoleName)
VALUES (1, 'Менеджер'),
       (2, 'Директор'),
       (3, 'Генеральный директор'),
       (4, 'Разработчик'),
       (5, 'Специалист по поддержке'),
       (6, 'Маркетолог');

-- Добавление сотрудников
INSERT INTO Employees (EmployeeID, Name, Position, ManagerID, DepartmentID, RoleID)
VALUES (1, 'Иван Иванов', 'Генеральный директор', NULL, 1, 3),
       (2, 'Петр Петров', 'Директор по продажам', 1, 1, 2),
       (3, 'Светлана Светлова', 'Директор по маркетингу', 1, 2, 2),
       (4, 'Алексей Алексеев', 'Менеджер по продажам', 2, 1, 1),
       (5, 'Мария Мариева', 'Менеджер по маркетингу', 3, 2, 1),
       (6, 'Андрей Андреев', 'Разработчик', 1, 4, 4),
       (7, 'Елена Еленова', 'Специалист по поддержке', 1, 5, 5),
       (8, 'Олег Олегов', 'Менеджер по продукту', 2, 1, 1),
       (9, 'Татьяна Татеева', 'Маркетолог', 3, 2, 6),
       (10, 'Николай Николаев', 'Разработчик', 6, 4, 4),
       (11, 'Ирина Иринина', 'Разработчик', 6, 4, 4),
       (12, 'Сергей Сергеев', 'Специалист по поддержке', 7, 5, 5),
       (13, 'Кристина Кристинина', 'Менеджер по продажам', 4, 1, 1),
       (14, 'Дмитрий Дмитриев', 'Маркетолог', 3, 2, 6),
       (15, 'Виктор Викторов', 'Менеджер по продажам', 4, 1, 1),
       (16, 'Анастасия Анастасиева', 'Специалист по поддержке', 7, 5, 5),
       (17, 'Максим Максимов', 'Разработчик', 6, 4, 4),
       (18, 'Людмила Людмилова', 'Специалист по маркетингу', 3, 2, 6),
       (19, 'Наталья Натальева', 'Менеджер по продажам', 4, 1, 1),
       (20, 'Александр Александров', 'Менеджер по маркетингу', 3, 2, 1),
       (21, 'Галина Галина', 'Специалист по поддержке', 7, 5, 5),
       (22, 'Павел Павлов', 'Разработчик', 6, 4, 4),
       (23, 'Марина Маринина', 'Специалист по маркетингу', 3, 2, 6),
       (24, 'Станислав Станиславов', 'Менеджер по продажам', 4, 1, 1),
       (25, 'Екатерина Екатеринина', 'Специалист по поддержке', 7, 5, 5),
       (26, 'Денис Денисов', 'Разработчик', 6, 4, 4),
       (27, 'Ольга Ольгина', 'Маркетолог', 3, 2, 6),
       (28, 'Игорь Игорев', 'Менеджер по продукту', 2, 1, 1),
       (29, 'Анастасия Анастасиевна', 'Специалист по поддержке', 7, 5, 5),
       (30, 'Валентин Валентинов', 'Разработчик', 6, 4, 4);

-- Добавление проектов
INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate, DepartmentID)
VALUES (1, 'Проект A', '2025-01-01', '2025-12-31', 1),
       (2, 'Проект B', '2025-02-01', '2025-11-30', 2),
       (3, 'Проект C', '2025-03-01', '2025-10-31', 4),
       (4, 'Проект D', '2025-04-01', '2025-09-30', 5),
       (5, 'Проект E', '2025-05-01', '2025-08-31', 3);

-- Добавление задач
INSERT INTO Tasks (TaskID, TaskName, AssignedTo, ProjectID)
VALUES (1, 'Задача 1: Подготовка отчета по продажам', 4, 1),
       (2, 'Задача 2: Анализ рынка', 9, 2),
       (3, 'Задача 3: Разработка нового функционала', 10, 3),
       (4, 'Задача 4: Поддержка клиентов', 12, 4),
       (5, 'Задача 5: Создание рекламной кампании', 5, 2),
       (6, 'Задача 6: Обновление документации', 6, 3),
       (7, 'Задача 7: Проведение тренинга для сотрудников', 8, 1),
       (8, 'Задача 8: Тестирование нового продукта', 11, 3),
       (9, 'Задача 9: Ответы на запросы клиентов', 12, 4),
       (10, 'Задача 10: Подготовка маркетинговых материалов', 9, 2),
       (11, 'Задача 11: Интеграция с новым API', 10, 3),
       (12, 'Задача 12: Настройка системы поддержки', 7, 5),
       (13, 'Задача 13: Проведение анализа конкурентов', 9, 2),
       (14, 'Задача 14: Создание презентации для клиентов', 4, 1),
       (15, 'Задача 15: Обновление сайта', 6, 3);


WITH RECURSIVE EmployeeHierarchy AS (SELECT EmployeeID, Name, ManagerID
                                     FROM Employees
                                     WHERE ManagerID = 1 -- Начинаем с менеджера с ID = 1 (Иван Иванов)

                                     UNION ALL

                                     SELECT e.EmployeeID, e.Name, e.ManagerID
                                     FROM Employees e
                                              INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID)

SELECT name
FROM EmployeeHierarchy
ORDER BY name DESC
LIMIT 1;


WITH RECURSIVE EmployeeHierarchy AS (SELECT EmployeeID, Name
                                     FROM Employees
                                     WHERE EmployeeID = 1 -- Начинаем с Ивана Иванова

                                     UNION ALL

                                     SELECT e.EmployeeID, e.Name
                                     FROM Employees e
                                              INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID)

SELECT string_agg(t.TaskName, ', ') AS AssignedTasks
FROM EmployeeHierarchy eh
         LEFT JOIN Tasks t ON eh.EmployeeID = t.AssignedTo
WHERE t.TaskName IS NOT NULL -- Фильтр для сотрудников с назначенными задачами
GROUP BY eh.EmployeeID, eh.Name
ORDER BY eh.Name
LIMIT 1;


SELECT Departments.DepartmentName, COUNT(Tasks.TaskID) AS TaskCount
FROM Departments
         LEFT JOIN Projects ON Departments.DepartmentID = Projects.DepartmentID
         LEFT JOIN Tasks ON Projects.ProjectID = Tasks.ProjectID
WHERE Departments.DepartmentName = 'Отдел продаж' -- Фильтр для Отдела продаж
GROUP BY Departments.DepartmentID
ORDER BY TaskCount DESC
LIMIT 1;
