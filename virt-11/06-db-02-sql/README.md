# Домашнее задание к занятию "2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду 
```
$ docker run --name psql-12 -e POSTGRES_PASSWORD=tim -v "$(pwd)/pgdata":/var/lib/postgresql/data -v "$(pwd)/backups:/tmp/backup -d postgres:12 
```

или docker-compose манифест.
```
version: "3.9"
services:
  postgres:
    image: postgres:12
    container_name: psql-12
    environment:
      POSTGRES_PASSWORD: "tim"
    volumes:
      - ./backups:/tmp/backup
      - ./pgdata:/var/lib/postgresql/data
```
```
$ docker-compose up -d
$ docker exec -it psql-12 bash
```
## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
```
root@b3bda4696227:/# createdb test_db -U tim  # создаем базу данных

root@b3bda4696227:/# psql -d test_db -U tim   # переходим в созданую базу данных
psql (12.14 (Debian 12.14-1.pgdg110+1))
Type "help" for help.

test_db=# CREATE USER "test-admin-user";      # создаем пользователя test-admin-user 
CREATE ROLE
```

- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
>Таблица orders:
  >- id (serial primary key)
  >- наименование (string)
  >- цена (integer)
```
test_db=# CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    наименование varchar(200) NOT NULL,
    цена integer);
CREATE TABLE
```

>Таблица clients:
  >- id (serial primary key)
  >- фамилия (string)
  >- страна проживания (string, index)
  >- заказ (foreign key orders)
```
test_db=# CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    фамилия varchar(200) NOT NULL,
    "страна проживания" varchar(200),
    заказ integer,
    FOREIGN KEY (заказ) REFERENCES orders(id)
    );
CREATE TABLE

test_db=# CREATE INDEX country_index ON clients ("страна проживания");
CREATE INDEX
```

- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
```
test_db=# GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "test-admin-user";
GRANT
```

- создайте пользователя test-simple-user  
```
test_db=# CREATE USER "test-simple-user"; 
CREATE ROLE
```

- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
```
test_db=# GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO "test-simple-user";
GRANT
```

Приведите:
- итоговый список БД после выполнения пунктов выше,
```
test_db=# \l
                             List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges 
-----------+-------+----------+------------+------------+-------------------
 postgres  | tim   | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | tim   | UTF8     | en_US.utf8 | en_US.utf8 | =c/tim           +
           |       |          |            |            | tim=CTc/tim
 template1 | tim   | UTF8     | en_US.utf8 | en_US.utf8 | =c/tim           +
           |       |          |            |            | tim=CTc/tim
 test_db   | tim   | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)
```

- описание таблиц (describe)
```
test_db=# \d orders
                                       Table "public.orders"
    Column    |          Type          | Collation | Nullable |              Default               
--------------+------------------------+-----------+----------+------------------------------------
 id           | integer                |           | not null | nextval('orders_id_seq'::regclass)
 наименование | character varying(200) |           | not null | 
 цена         | integer                |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=# \d clients
                                         Table "public.clients"
      Column       |          Type          | Collation | Nullable |               Default               
-------------------+------------------------+-----------+----------+-------------------------------------
 id                | integer                |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | character varying(200) |           | not null | 
 страна проживания | character varying(200) |           |          | 
 заказ             | integer                |           |          | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "country_index" btree ("страна проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
```

- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
```
test_db=# SELECT grantee, table_catalog, table_name, privilege_type FROM information_schema.table_privileges WHERE table_name IN ('orders','clients');
```
- список пользователей с правами над таблицами test_db
```
     grantee      | table_catalog | table_name | privilege_type 
------------------+---------------+------------+----------------
 tim              | test_db       | orders     | INSERT
 tim              | test_db       | orders     | SELECT
 tim              | test_db       | orders     | UPDATE
 tim              | test_db       | orders     | DELETE
 tim              | test_db       | orders     | TRUNCATE
 tim              | test_db       | orders     | REFERENCES
 tim              | test_db       | orders     | TRIGGER
 test-admin-user  | test_db       | orders     | INSERT
 test-admin-user  | test_db       | orders     | SELECT
 test-admin-user  | test_db       | orders     | UPDATE
 test-admin-user  | test_db       | orders     | DELETE
 test-admin-user  | test_db       | orders     | TRUNCATE
 test-admin-user  | test_db       | orders     | REFERENCES
 test-admin-user  | test_db       | orders     | TRIGGER
 test-simple-user | test_db       | orders     | INSERT
 test-simple-user | test_db       | orders     | SELECT
 test-simple-user | test_db       | orders     | UPDATE
 test-simple-user | test_db       | orders     | DELETE
 tim              | test_db       | clients    | INSERT
 tim              | test_db       | clients    | SELECT
 tim              | test_db       | clients    | UPDATE
 tim              | test_db       | clients    | DELETE
 tim              | test_db       | clients    | TRUNCATE
 tim              | test_db       | clients    | REFERENCES
 tim              | test_db       | clients    | TRIGGER
 test-admin-user  | test_db       | clients    | INSERT
 test-admin-user  | test_db       | clients    | SELECT
 test-admin-user  | test_db       | clients    | UPDATE
 test-admin-user  | test_db       | clients    | DELETE
 test-admin-user  | test_db       | clients    | TRUNCATE
 test-admin-user  | test_db       | clients    | REFERENCES
 test-admin-user  | test_db       | clients    | TRIGGER
 test-simple-user | test_db       | clients    | INSERT
 test-simple-user | test_db       | clients    | SELECT
 test-simple-user | test_db       | clients    | UPDATE
 test-simple-user | test_db       | clients    | DELETE
(36 rows)
```


## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|
```
test_db=# INSERT INTO
orders (наименование, цена) VALUES
('Шоколад', 10),
('Принтер', 3000),
('Книга', 500),
('Монитор', 7000),
('Гитара', 4000);
INSERT 0 5
```

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

```
test_db=# INSERT INTO
clients (фамилия, "страна проживания") VALUES
('Иванов Иван Иванович', 'USA'),
('Петров Петр Петрович', 'Canada'),
('Иоган Себастьян Бах', 'Japan'),
('Ронни Джеймс Дио', 'Russia'),
('Ritchi Blackmore', 'Russia');
INSERT 0 5
```

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.
```
test_db=# SELECT COUNT (*) FROM orders;
 count 
-------
     5
(1 row)

test_db=# SELECT COUNT (*) FROM clients;
 count 
-------
     5
(1 row)
```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.
```
test_db=# UPDATE clients SET заказ=(select id from orders where наименование='Книга') WHERE фамилия='Иванов Иван Иванович';
UPDATE 1
test_db=# UPDATE clients SET заказ=(select id from orders where наименование='Монитор') WHERE фамилия='Петров Петр Петрович';
UPDATE 1
test_db=# UPDATE clients SET заказ=(select id from orders where наименование='Гитара') WHERE фамилия='Иоган Себастьян Бах';
UPDATE 1
```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
```
test_db=# SELECT * FROM clients WHERE заказ IS NOT NULL;
 id |       фамилия        | страна проживания | заказ 
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоган Себастьян Бах  | Japan             |     5
(3 rows)
``` 
Подсказк - используйте директиву `UPDATE`.

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.
```
test_db=# EXPLAIN SELECT * FROM clients WHERE заказ IS NOT NULL;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..10.90 rows=90 width=844)
   Filter: ("заказ" IS NOT NULL)
(2 rows)
```
  >Структура плана запроса представляет собой дерево узлов плана. Данный запрос считывает данные таблицы clients методом последовательного чтения/сканирования Seq Scan. Первое значение определяет приблизительные затраты, прежде чем начнется этап вывода данных. Следующее значение показывает приблизительную общую стоимость, предпологая что узел плана выполнился до конца и вернул все доступные строки. Число строк (rows), которые должен вывести узел плана. width - средний размер строк (в байтах) выводимых узлом плана. Записи сравниваются с условием S NOT NULL - при выполнении вводиться результат.


## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
```
root@b3bda4696227:/# pg_dump -U tim test_db > /tmp/backup/test_db.dump
```

Остановите контейнер с PostgreSQL (но не удаляйте volumes).
```
root@b3bda4696227:/# exit         # выходим из контейнера
$ docker stop psql-12             # останавливаем
```

Поднимите новый пустой контейнер с PostgreSQL.
```
$ docker run --name psql-12-copy -e POSTGRES_PASSWORD=tim -d postgres:12
```

Восстановите БД test_db в новом контейнере.
```
$ docker cp $(pwd)/backups/test_db.dump psql-12-copy:/tmp/          # копируем в новый контейнер

$ docker exec -it psql-12-copy bash                                 # заходим в новый контейнер

root@41954d61f884:/# createdb test_db -U postgres                   # создаем в новом контейнере базу данных

root@943ab88eba5c:/# psql -U postgres test_db < /tmp/test_db.dump   # заливаем базу данных
```

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

---