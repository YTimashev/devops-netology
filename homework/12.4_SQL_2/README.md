# Домашнее задание к занятию 12.4 "Реляционные базы данных: SQL. Часть 2"

Задание можно выполнить как в любом IDE, так и в командной строке.

### Задание 1.

Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей и выведите в результат следующую информацию: 
- фамилия и имя сотрудника из этого магазина,
- город нахождения магазина,
- количество пользователей, закрепленных в этом магазине.
```
SELECT 
st.store_id AS id_store, 
ct.city AS store_city, 
CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
COUNT(c.store_id) AS total_customers
FROM store st
JOIN address ad ON ad.address_id = st.address_id
JOIN city ct ON ct.city_id = ad.city_id
JOIN staff s ON s.staff_id = st.store_id
JOIN customer c ON c.store_id = st.store_id
GROUP BY c.store_id HAVING COUNT(c.store_id) > 300; 
```
```
+----------+------------+--------------+-----------------+
| id_store | store_city | staff_name   | total_customers |
+----------+------------+--------------+-----------------+
|        1 | Lethbridge | Mike Hillyer |             326 |
+----------+------------+--------------+-----------------+
1 row in set (0,00 sec)
```

### Задание 2.

Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.
```
SELECT COUNT(f.film_id) AS moreAVGlength
FROM film f
WHERE f.length > (SELECT AVG(length) FROM film);
```
```
+---------------+
| moreAVGlength |
+---------------+
|           489 |
+---------------+
1 row in set (0,00 sec)
```

### Задание 3.

Получите информацию, за какой месяц была получена наибольшая сумма платежей и добавьте информацию по количеству аренд за этот месяц.
```
SELECT MONTH(payment_date) AS month, SUM(amount) AS amount, COUNT(rental_id) AS total_rental
FROM payment
GROUP BY month
ORDER BY amount DESC LIMIT 1;
```
```
+-------+----------+--------------+
| month | amount   | total_rental |
+-------+----------+--------------+
|     7 | 28368.91 |         6709 |
+-------+----------+--------------+
1 row in set (0,01 sec)
```
## Дополнительные задания (со звездочкой*)

### Задание 4*.

Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку «Премия». Если количество продаж превышает 8000, то значение в колонке будет «Да», иначе должно быть значение «Нет».
```
SELECT p.staff_id AS SID, 
CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
COUNT(amount) AS total_payment,
  CASE
    WHEN COUNT(amount) > 8000 THEN 'Да'
    WHEN COUNT(amount) < 8000 THEN 'Нет'
      END AS 'Премия' 
FROM payment p
JOIN staff s ON s.staff_id = p.staff_id
GROUP BY p.staff_id;
```
```
+-----+--------------+---------------+--------------+
| SID | staff_name   | total_payment | Премия       |
+-----+--------------+---------------+--------------+
|   1 | Mike Hillyer |          8054 | Да           |
|   2 | Jon Stephens |          7990 | Нет          |
+-----+--------------+---------------+--------------+
2 rows in set (0,02 sec)
```
### Задание 5*.

Найдите фильмы, которые ни разу не брали в аренду.
```
SELECT f.title
FROM film f
LEFT JOIN inventory i ON i.film_id = f.film_id
LEFT JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.rental_id IS NULL;
```
```
+------------------------+
| title                  |
+------------------------+
| ACADEMY DINOSAUR       |
| ALICE FANTASIA         |
| APOLLO TEEN            |
| ARGONAUTS TOWN         |
| ARK RIDGEMONT          |
| ARSENIC INDEPENDENCE   |
| BOONDOCK BALLROOM      |
| BUTCH PANTHER          |
| CATCH AMISTAD          |
| CHINATOWN GLADIATOR    |
| CHOCOLATE DUCK         |
| COMMANDMENTS EXPRESS   |
| CROSSING DIVORCE       |
| CROWDS TELEMARK        |
| CRYSTAL BREAKING       |
| DAZED PUNK             |
| DELIVERANCE MULHOLLAND |
| FIREHOUSE VIETNAM      |
| FLOATS GARDEN          |
| FRANKENSTEIN STRANGER  |
| GLADIATOR WESTWARD     |
| GUMP DATE              |
| HATE HANDICAP          |
| HOCUS FRIDA            |
| KENTUCKIAN GIANT       |
| KILL BROTHERHOOD       |
| MUPPET MILE            |
| ORDER BETRAYED         |
| PEARL DESTINY          |
| PERDITION FARGO        |
| PSYCHO SHRUNK          |
| RAIDERS ANTITRUST      |
| RAINBOW SHOCK          |
| ROOF CHAMPION          |
| SISTER FREDDY          |
| SKY MIRACLE            |
| SUICIDES SILENCE       |
| TADPOLE PARK           |
| TREASURE COMMAND       |
| VILLAIN DESPERATE      |
| VOLUME HOUSE           |
| WAKE JAWS              |
| WALLS ARTIST           |
+------------------------+
43 rows in set (0,03 sec)
```
