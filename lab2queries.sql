
-- ЛАБОРАТОРНА РОБОТА №2: SQL-ЗАПИТИ
-- Варіант 4: Екскурсії


-- 1. Проста вибірка всіх даних з базових таблиць
SELECT * FROM public.buses ORDER BY bus_id ASC;
SELECT * FROM public.customers ORDER BY customer_id ASC;
SELECT * FROM public.drivers ORDER BY driver_id ASC;
SELECT * FROM public.excursions ORDER BY excursion_id ASC;

-- 2. SELECT з однієї таблиці з використанням сортування, умов AND та OR
-- Виводить список екскурсій, які відповідають певним критеріям дальності/часу або мають велику кількість туристів.
SELECT destination, excursion_date, distance_km, duration_hours, tourists_count
FROM excursions
WHERE (distance_km > 100 AND duration_hours < 12) OR tourists_count > 30
ORDER BY distance_km DESC;

-- 3. SELECT з обчислювальними полями
-- Розраховує розхід пального на 100 км для кожного автобуса.
SELECT plate_number, capacity, gas_per_km, 
       (gas_per_km * 100) AS gas_per_100_km
FROM buses;

-- 4. SELECT з використанням Outer Join
-- Виводить всіх замовників та їхні екскурсії (навіть якщо клієнт ще не замовив жодної екскурсії).
SELECT c.name, e.destination, e.excursion_date
FROM customers c
LEFT OUTER JOIN excursions e ON c.customer_id = e.customer_id;

-- 5. SELECT з використанням операторів LIKE та BETWEEN
-- Шукає клієнтів з українськими номерами та певним діапазоном боргу.
SELECT name, phone, debt_amount
FROM customers
WHERE phone LIKE '+380%' AND debt_amount BETWEEN 100 AND 10000;

-- 6. Складний запит: JOIN, підзапит у FROM, GROUP BY, агрегатні функції COUNT/AVG
-- Рахує статистику для кожного водія: загальна кількість поїздок та середня кількість туристів.
SELECT d.full_name, stats.total_trips, stats.avg_tourists
FROM drivers d
JOIN (
    SELECT driver_id, COUNT(excursion_id) AS total_trips, ROUND(AVG(tourists_count), 1) AS avg_tourists
    FROM excursions
    GROUP BY driver_id
) AS stats ON d.driver_id = stats.driver_id
ORDER BY stats.total_trips DESC;

-- 7. UPDATE на базі кількох таблиць
-- Оновлення суми боргу клієнта на основі кілометражу екскурсії та характеристик автобуса.
UPDATE customers c
SET debt_amount = c.debt_amount + (e.distance_km * b.gas_per_km * 50)
FROM excursions e
JOIN buses b ON e.bus_id = b.bus_id
WHERE c.customer_id = e.customer_id;

-- Перевірка результату оновлення
SELECT name, debt_amount FROM customers;

-- 8. INSERT: додавання нових даних
INSERT INTO drivers (full_name, license_number) 
VALUES ('Сидоров Сидір', 'АХ112233');

SELECT * FROM drivers;

-- 9. DELETE: видалення записів з умовою WHERE
DELETE FROM drivers 
WHERE license_number = 'АХ112233';

SELECT * FROM drivers;