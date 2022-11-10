# Домашнее задание к занятию 12.5 "Реляционные базы данных: Индексы"

### Задание 1.

Напишите запрос к учебной базе данных, который вернет процентное отношение общего размера всех индексов к общему размеру всех таблиц.
```sql
SELECT SUM(DATA_LENGTH) AS 'DB_LENGTH_b', SUM(INDEX_LENGTH) AS INDEX_LENGTH_b, SUM(INDEX_LENGTH) / SUM(DATA_LENGTH) * 100 AS Percentage_index
    FROM  INFORMATION_SCHEMA.PARTITIONS
    WHERE TABLE_SCHEMA = 'sakila';
```
```
+-------------+----------------+------------------+
| DB_LENGTH_b | INDEX_LENGTH_b | Percentage_index |
+-------------+----------------+------------------+
|     4374528 |        2392064 |          54.6816 |
+-------------+----------------+------------------+
1 row in set (1,22 sec)
```
### Задание 2.

Выполните explain analyze следующего запроса:
```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```
- перечислите узкие места,
    - первое что бросается в глаза при анализе запроса, это опрос таблиц которые ни каким образом не влияют на выдачу, в тоже время как я понимаю затрачиваются ресурсы на их опрос. я бы исключил из запроса таблицы  ```film```  и ```inventory```. В таблице  ```payment``` более 15 000 строк а по столбцу ```payment_date``` отстутсвуют ключи (key) - добавим функциональный индекс по ```DATE```.
- оптимизируйте запрос (внесите корректировки по использованию операторов, при необходимости добавьте индексы).
    - думаю конечный запрос c добавленным индексом ```ALTER TABLE payment ADD INDEX idx_payment_date ((DATE(payment_date)));``` должен выглядеть так:
        ```sql
        select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id)
        from payment p, customer c
        where date(p.payment_date) = '2005-07-30' and p.customer_id = c.customer_id;
        ```

## Дополнительные задания (со звездочкой*)
Эти задания дополнительные (не обязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. Вы можете их выполнить, если хотите глубже и/или шире разобраться в материале.

### Задание 3*.

Самостоятельно изучите, какие типы индексов используются в PostgreSQL. Перечислите те индексы, которые используются в PostgreSQL, а в MySQL нет.

*Приведите ответ в свободной форме.
