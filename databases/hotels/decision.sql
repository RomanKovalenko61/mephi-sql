/*
Задача 1
Определить, какие клиенты сделали более двух бронирований в разных отелях, и вывести информацию о каждом таком клиенте,
включая его имя, электронную почту, телефон, общее количество бронирований, а также список отелей,
в которых они бронировали номера (объединенные в одно поле через запятую с помощью CONCAT).
Также подсчитать среднюю длительность их пребывания (в днях) по всем бронированиям.
Отсортировать результаты по количеству бронирований в порядке убывания.
 */

SELECT name, email, phone, booking_count, hotels, avg_days
FROM (SELECT id_customer, count(DISTINCT id_hotel) as uniq_hotel_id, count(r.id_room) as booking_count
      FROM booking
               JOIN room r on booking.id_room = r.id_room
      GROUP BY id_customer
      HAVING count(DISTINCT id_hotel) <> 1
         AND count(r.id_room) > 2
      ORDER BY id_customer) as search_custmomers
         JOIN customer USING (id_customer)
         JOIN (SELECT booking.id_customer,
                      string_agg(DISTINCT h.name, ', ')           as hotels,
                      avg(check_out_date - booking.check_in_date) as avg_days
               FROM booking
                        JOIN customer c on c.id_customer = booking.id_customer
                        JOIN room r on r.id_room = booking.id_room
                        JOIN hotel h on h.id_hotel = r.id_hotel
               GROUP BY booking.id_customer) as search_hotel
              on search_hotel.id_customer = search_custmomers.id_customer;

/*
Задача 2
Необходимо провести анализ клиентов, которые сделали более двух бронирований в разных отелях и потратили более
500 долларов на свои бронирования. Для этого:

    - Определить клиентов, которые сделали более двух бронирований и забронировали номера в более чем одном отеле.
Вывести для каждого такого клиента следующие данные: ID_customer, имя, общее количество бронирований, общее количество
уникальных отелей, в которых они бронировали номера, и общую сумму, потраченную на бронирования.
    - Также определить клиентов, которые потратили более 500 долларов на бронирования, и вывести для них ID_customer,
имя, общую сумму, потраченную на бронирования, и общее количество бронирований.
    - В результате объединить данные из первых двух пунктов, чтобы получить список клиентов, которые соответствуют
условиям обоих запросов. Отобразить поля: ID_customer, имя, общее количество бронирований, общую сумму,
потраченную на бронирования, и общее количество уникальных отелей.
    - Результаты отсортировать по общей сумме, потраченной клиентами, в порядке возрастания.
*/


-- Подзапрос для первой части задания
SELECT id_customer, name, count(r.id_room) as total_bookings, count(DISTINCT id_hotel) as unique_hotels, sum(price)
FROM booking
         JOIN room r on booking.id_room = r.id_room
         JOIN customer c USING (id_customer)
GROUP BY id_customer, name
HAVING count(DISTINCT id_hotel) <> 1
   AND count(r.id_room) > 2
ORDER BY id_customer;

-- Подзапрос для второй части задания
SELECT id_customer, name, sum(price), count(*)
FROM booking
         JOIN room r on booking.id_room = r.id_room
         JOIN customer c USING (id_customer)
GROUP BY id_customer, name
HAVING sum(price) > 500
ORDER BY id_customer;

-- Итоговый запрос
SELECT query_1.id_customer AS ID_customer, query_1.name AS name, total_bookings, total_spent, unique_hotels
FROM (SELECT id_customer,
             name,
             count(r.id_room)         as total_bookings,
             count(DISTINCT id_hotel) as unique_hotels,
             sum(price)
      FROM booking
               JOIN room r on booking.id_room = r.id_room
               JOIN customer c USING (id_customer)
      GROUP BY id_customer, name
      HAVING count(DISTINCT id_hotel) <> 1
         AND count(r.id_room) > 2) as query_1
         JOIN
     (SELECT id_customer, name, sum(price) as total_spent, count(*)
      FROM booking
               JOIN room r on booking.id_room = r.id_room
               JOIN customer c USING (id_customer)
      GROUP BY id_customer, name
      HAVING sum(price) > 500) as query_2 USING (id_customer)
ORDER BY total_spent;

/*
Задача 3
Вам необходимо провести анализ данных о бронированиях в отелях и определить предпочтения клиентов по типу отелей.
Для этого выполните следующие шаги:

1. Категоризация отелей.
Определите категорию каждого отеля на основе средней стоимости номера:
    «Дешевый»: средняя стоимость менее 175 долларов.
    «Средний»: средняя стоимость от 175 до 300 долларов.
    «Дорогой»: средняя стоимость более 300 долларов.

2. Анализ предпочтений клиентов.
Для каждого клиента определите предпочитаемый тип отеля на основании условия ниже:
    - Если у клиента есть хотя бы один «дорогой» отель, присвойте ему категорию «дорогой».
    - Если у клиента нет «дорогих» отелей, но есть хотя бы один «средний», присвойте ему категорию «средний».
    - Если у клиента нет «дорогих» и «средних» отелей, но есть «дешевые», присвойте ему категорию предпочитаемых отелей «дешевый».

3. Вывод информации.
Выведите для каждого клиента следующую информацию:
    - ID_customer: уникальный идентификатор клиента.
    - name: имя клиента.
    - preferred_hotel_type: предпочитаемый тип отеля.
    - visited_hotels: список уникальных отелей, которые посетил клиент.

4. Сортировка результатов.
Отсортируйте клиентов так, чтобы сначала шли клиенты с «дешевыми» отелями, затем со «средними» и в конце — с «дорогими».
*/

SELECT id_customer                                      as ID_customer,
       name,
       case
           when max(price_range) = 3 then 'Дорогой'
           when max(price_range) = 2 then 'Средний'
           when max(price_range) = 1 then 'Дешевый' end as preferred_hotel_type,
       string_agg(DISTINCT hotel_name, ', ')            as visited_hotels
FROM (SELECT r.id_hotel,
             name               as hotel_name,
             avg(price)         as avg_price,
             case
                 when avg(price) < 175 then 1
                 when avg(price) between 175 and 300 then 2
                 when avg(price) > 300
                     then 3 end as price_range
      FROM hotel
               JOIN room r on hotel.id_hotel = r.id_hotel
      GROUP BY r.id_hotel, name) as query_1
         JOIN (SELECT c.id_customer, name, r.id_hotel
               FROM booking
                        JOIN room r on r.id_room = booking.id_room
                        JOIN customer c on c.id_customer = booking.id_customer
               GROUP BY c.id_customer, name, r.id_hotel) as query_2 USING (id_hotel)
GROUP BY id_customer, name
ORDER BY max(price_range), id_customer;