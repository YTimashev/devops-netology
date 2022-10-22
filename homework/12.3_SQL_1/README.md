# Домашнее задание к занятию 12.3 "Реляционные базы данных: SQL. Часть 1"

---

Задание можно выполнить как в любом IDE, так и в командной строке.

### Задание 1.

Получите уникальные названия районов из таблицы с адресами, которые начинаются на “K” и заканчиваются на “a”, и не содержат пробелов.
```
SELECT DISTINCT district FROM address WHERE district LIKE 'K%a' AND district NOT LIKE '% %';
```
```
+-----------+
| district  |
+-----------+
| Kanagawa  |
| Kalmykia  |
| Kaduna    |
| Karnataka |
| Kütahya   |
| Kerala    |
| Kitaa     |
+-----------+
7 rows in set (0,00 sec)
```

### Задание 2.

Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись в промежуток с 15 июня 2005 года по 18 июня 2005 года **включительно**, и стоимость которых превышает 10.00.
```
SELECT payment_id, amount, CAST(payment_date AS DATE) FROM payment WHERE amount > 10.00 AND payment_date BETWEEN '2005-06-15' AND '2005-06-19';
```
```
+------------+--------+----------------------------+
| payment_id | amount | CAST(payment_date AS DATE) |
+------------+--------+----------------------------+
|        908 |  10.99 | 2005-06-15                 |
|       7017 |  10.99 | 2005-06-17                 |
|       8272 |  11.99 | 2005-06-17                 |
|      12888 |  10.99 | 2005-06-18                 |
|      13892 |  10.99 | 2005-06-16                 |
|      14620 |  10.99 | 2005-06-15                 |
|      15313 |  10.99 | 2005-06-17                 |
+------------+--------+----------------------------+
7 rows in set (0,02 sec)
```
### Задание 3.

Получите последние 5 аренд фильмов.
```
SELECT rental_id, rental_date FROM rental ORDER BY rental_date DESC, rental_id LIMIT 5;
```
```
+-----------+---------------------+
| rental_id | rental_date         |
+-----------+---------------------+
|     11496 | 2006-02-14 15:16:03 |
|     11541 | 2006-02-14 15:16:03 |
|     11563 | 2006-02-14 15:16:03 |
|     11577 | 2006-02-14 15:16:03 |
|     11593 | 2006-02-14 15:16:03 |
+-----------+---------------------+
5 rows in set (0,02 sec)
```
### Задание 4.

Одним запросом получите активных покупателей, имена которых Kelly или Willie. 

Сформируйте вывод в результат таким образом:
- все буквы в фамилии и имени из верхнего регистра переведите в нижний регистр,
- замените буквы 'll' в именах на 'pp'
```
mysql> SELECT customer_id, LOWER(REPLACE(first_name, 'LL', 'PP')), LOWER (last_name), active
    -> FROM customer 
    -> WHERE first_name = 'Kelly' AND active = 1 OR first_name = 'Willie' AND active = 1;
```
```
+-------------+----------------------------------------+-------------------+--------+
| customer_id | LOWER(REPLACE(first_name, 'LL', 'PP')) | LOWER (last_name) | active |
+-------------+----------------------------------------+-------------------+--------+
|          67 | keppy                                  | torres            |      1 |
|         219 | wippie                                 | howell            |      1 |
|         359 | wippie                                 | markham           |      1 |
|         546 | keppy                                  | knott             |      1 |
+-------------+----------------------------------------+-------------------+--------+
4 rows in set (0,00 sec)
```

## Дополнительные задания (со звездочкой*)

### Задание 5*.

Выведите Email каждого покупателя, разделив значение Email на 2 отдельных колонки: в первой колонке должно быть значение, указанное до @, во второй значение, указанное после @.

```
SELECT email,
LOWER (SUBSTRING_INDEX(email, '@', 1)) AS email_,
SUBSTRING_INDEX(email, '@', -1) AS _email
FROM customer
LIMIT 10;
```
```
+-------------------------------------+------------------+--------------------+
| email                               | email_           | _email             |
+-------------------------------------+------------------+--------------------+
| MARY.SMITH@sakilacustomer.org       | mary.smith       | sakilacustomer.org |
| PATRICIA.JOHNSON@sakilacustomer.org | patricia.johnson | sakilacustomer.org |
| LINDA.WILLIAMS@sakilacustomer.org   | linda.williams   | sakilacustomer.org |
| BARBARA.JONES@sakilacustomer.org    | barbara.jones    | sakilacustomer.org |
| ELIZABETH.BROWN@sakilacustomer.org  | elizabeth.brown  | sakilacustomer.org |
| JENNIFER.DAVIS@sakilacustomer.org   | jennifer.davis   | sakilacustomer.org |
| MARIA.MILLER@sakilacustomer.org     | maria.miller     | sakilacustomer.org |
| SUSAN.WILSON@sakilacustomer.org     | susan.wilson     | sakilacustomer.org |
| MARGARET.MOORE@sakilacustomer.org   | margaret.moore   | sakilacustomer.org |
| DOROTHY.TAYLOR@sakilacustomer.org   | dorothy.taylor   | sakilacustomer.org |
+-------------------------------------+------------------+--------------------+
10 rows in set (0,00 sec)
```

### Задание 6.*
Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: первая буква должна быть заглавной, остальные строчными.
