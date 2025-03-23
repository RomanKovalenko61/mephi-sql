/*
Задача 1
Определить, какие автомобили из каждого класса имеют наименьшую среднюю позицию в гонках, и вывести информацию о каждом
таком автомобиле для данного класса, включая его класс, среднюю позицию и количество гонок, в которых он участвовал.
Также отсортировать результаты по средней позиции.
*/


SELECT car as car_name, class as car_class, average_position, race_count
FROM (SELECT DISTINCT ON (class) car, class, position
      FROM results r
               JOIN cars c on r.car = c.name
      ORDER BY class, position) as query_1
         LEFT JOIN
     (SELECT car, avg(position) as average_position, count(car) as race_count
      FROM results
      GROUP BY car) as query_2 USING (car)
ORDER BY average_position;

/*
Задача 2
Определить автомобиль, который имеет наименьшую среднюю позицию в гонках среди всех автомобилей,
и вывести информацию об этом автомобиле, включая его класс, среднюю позицию, количество гонок, в которых он участвовал,
и страну производства класса автомобиля. Если несколько автомобилей имеют одинаковую наименьшую среднюю позицию,
выбрать один из них по алфавиту (по имени автомобиля).
*/

SELECT car as car_name, c.class as car_class, average_position, race_count, country
FROM (SELECT car, avg(position) as average_position, count(car) as race_count
      FROM results
      GROUP BY car
      ORDER BY avg(position), car
      LIMIT 1) as subquery
         JOIN cars c on c.name = subquery.car
         JOIN classes cl on c.class = cl.class;

/*
Задача 3
Определить классы автомобилей, которые имеют наименьшую среднюю позицию в гонках, и вывести информацию о каждом
автомобиле из этих классов, включая его имя, среднюю позицию, количество гонок, в которых он участвовал,
страну производства класса автомобиля, а также общее количество гонок, в которых участвовали автомобили этих классов.
Если несколько классов имеют одинаковую среднюю позицию, выбрать все из них.
*/

SELECT car           AS car_name,
       c.class       AS car_class,
       avg(position) AS average_position,
       count(car)    AS race_count,
       cl.country    AS car_country,
       total_races
FROM results r
         JOIN cars c on r.car = c.name
         JOIN classes cl on c.class = cl.class
         JOIN (SELECT class, count(*) AS total_races
               FROM results
                        JOIN cars c on c.name = results.car
               GROUP BY class) as class_stat on cl.class = class_stat.class
GROUP BY car, c.class, cl.country, total_races
HAVING car IN
       (SELECT name
        FROM cars
        WHERE class IN (SELECT class
                        FROM results
                                 JOIN cars c on results.car = c.name
                        GROUP BY class
                        HAVING avg(position) =
                               (SELECT min(a)
                                FROM (SELECT avg(position) as a
                                      FROM results
                                               JOIN cars c on results.car = c.name
                                      GROUP BY class) as subquery)));

/*
Задача 4
Определить, какие автомобили имеют среднюю позицию лучше (меньше) средней позиции всех автомобилей в своем классе
(то есть автомобилей в классе должно быть минимум два, чтобы выбрать один из них). Вывести информацию об этих автомобилях,
включая их имя, класс, среднюю позицию, количество гонок, в которых они участвовали, и страну производства класса автомобиля.
Также отсортировать результаты по классу и затем по средней позиции в порядке возрастания.
*/

SELECT car           AS car_name,
       cl.class      AS car_class,
       avg(position) AS average_position,
       count(car)    AS race_count,
       country       AS car_country
FROM results
         JOIN cars c on c.name = results.car
         JOIN (SELECT class, avg(position) AS avg_in_class
               FROM results
                        JOIN cars c on c.name = results.car
               GROUP BY class) as class_stat USING (class)
         JOIN classes cl on c.class = cl.class
GROUP BY car, name, cl.class, avg_in_class
HAVING avg(position) < avg_in_class;

/*
Задача 5
Определить, какие классы автомобилей имеют наибольшее количество автомобилей с низкой средней позицией (больше 3.0)
и вывести информацию о каждом автомобиле из этих классов, включая его имя, класс, среднюю позицию, количество гонок,
в которых он участвовал, страну производства класса автомобиля, а также общее количество гонок для каждого класса.
Отсортировать результаты по количеству автомобилей с низкой средней позицией.

С учетом комментария https://t.me/c/2260902125/58/706
*/

SELECT car_name, car_class, average_position, race_count, country as car_country, total_races, low_position_count
FROM (SELECT name                                         as car_name,
             c.class                                      as car_class,
             avg(position)                                as average_position,
             count(name)                                  as race_count,
             avg(avg(position)) over (partition by class),
             count(name) over (partition by c.class) as total_races,
             count(case when avg(position) > 3.0 then 1 end) over (partition by class) as low_position_count
      FROM results r
               JOIN cars c on r.car = c.name
      GROUP BY c.class, name) as subquery
         JOIN classes on classes.class = subquery.car_class
WHERE average_position > 3
ORDER BY low_position_count;