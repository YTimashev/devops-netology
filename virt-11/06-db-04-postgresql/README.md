# Домашнее задание к занятию "4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
```
# docker-compose.yml
version: "3.9"
services:
  postgres:
    image: postgres:13
    container_name: psql-13
    environment:
      POSTGRES_PASSWORD: "postgres"
    volumes:
      - ./pgdata:/var/lib/postgresql/data
``` 
```
$ docker-compose up -d
```
Подключитесь к БД PostgreSQL используя `psql`.
```
$ docker exec -it psql-13 /bin/bash
root@c23204881348:/#  psql -U postgres
psql (13.10 (Debian 13.10-1.pgdg110+1))
Type "help" for help.
```
Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:

- вывода списка БД - ``` \l[+] # list databases ```
``` 
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)
```
- подключения к БД - ```\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}```
```
postgres=# \c postgres
You are now connected to database "postgres" as user "postgres".
```
- вывода списка таблиц - ```\dt[S+] [PATTERN]     # list tables```
```
postgres=# \dtS
                    List of relations
   Schema   |          Name           | Type  |  Owner   
------------+-------------------------+-------+----------
 pg_catalog | pg_aggregate            | table | postgres
 pg_catalog | pg_am                   | table | postgres
 pg_catalog | pg_amop                 | table | postgres
 pg_catalog | pg_amproc               | table | postgres
 ...
```

- вывода описания содержимого таблиц - ```\d[S+]  NAME     # describe table, view, sequence, or index```
```
postgres=# \dS+ pg_am
                                  Table "pg_catalog.pg_am"
  Column   |  Type   | Collation | Nullable | Default | Storage | Stats target | Description 
-----------+---------+-----------+----------+---------+---------+--------------+-------------
 oid       | oid     |           | not null |         | plain   |              | 
 amname    | name    |           | not null |         | plain   |              | 
 amhandler | regproc |           | not null |         | plain   |              | 
 amtype    | "char"  |           | not null |         | plain   |              | 
Indexes:
    "pg_am_name_index" UNIQUE, btree (amname)
    "pg_am_oid_index" UNIQUE, btree (oid)
Access method: heap
```

- выхода из psql - ```\q    # quit psql```

## Задача 2

Используя `psql` создайте БД `test_database`.
```
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.
```
$ docker cp ./backups/test_dump.sql psql-13:/tmp                          # копируем файл дампа в контейнер

$ docker exec -it psql-13 bash                                            # заходим в контейнер

root@20c2f2f216d3:/# psql -U postgres test_database < /tmp/test_dump.sql  # заливаем БД
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE
```
Перейдите в управляющую консоль `psql` внутри контейнера.
```
root@20c2f2f216d3:/# psql -U postgres
psql (13.10 (Debian 13.10-1.pgdg110+1))
Type "help" for help.
```
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
```
postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".

test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```
Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.
```
test_database=# SELECT attname, avg_width FROM pg_stats WHERE tablename='orders';
 attname | avg_width 
---------+-----------
 id      |         4
 title   |        16
 price   |         4
(3 rows)
```

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.
```
BEGIN;                                                           # открываем транзакцию
CREATE TABLE orders_1 (LIKE orders);                             # Создаем таблицу orders_1 со структурой таблицы orders
INSERT INTO orders_1 SELECT * FROM orders WHERE price >499;      # Вставлем в таблицу orders_1 из таблицы orders столбца/колонки price значения >499
DELETE FROM orders WHERE price >499;                             # Удаляем из таблицы orders столбца/колонки price значения >499

CREATE TABLE orders_2 (LIKE orders);                             # Создаем таблицу orders_2 со структурой таблицы orders
INSERT INTO orders_2 SELECT * FROM orders WHERE price <=499;     # Вставлем в таблицу orders_2 из таблицы orders столбца/колонки price значения <=499
DELETE FROM orders WHERE price <=499;                            # Удаляем из таблицы orders столбца/колонки price значения <=499
COMMIT;                                                          # Закрываем транзакцию
```
```
test_database=# select * from orders_1;
 id |       title        | price 
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=# select * from orders_2;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)

test_database=# select * from orders;
 id | title | price 
----+-------+-------
(0 rows)
```
Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
  >Да можно, для этого необходимо назначить секционирование (PARTITION BY) таблиц по какому либо значению, в нашем случае по диапазону.
  >Есть еще интересный [способ] (https://habr.com/ru/company/oleg-bunin/blog/309330/).

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.
```
pg_dump -U postgres -d test_database > /tmp/test_db.sql
```
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?
  >Первое что приходит на ум, это взять и добавить ограничение `UNIQUE` на столбец/поле `title` таблицы `orders` в бэкап файле - но думаю это не верное решение. Правильно как мне кажеться добавить уникальный индекс в таблицу  `orders` полю `title`
```
# CREATE UNIQUE INDEX title_unique_index ON public.orders USING btree (title);
```
---
