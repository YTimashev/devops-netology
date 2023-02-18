# Домашнее задание к занятию "3. MySQL"

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
```
# docker-compose.yml
version: "3.9"
services:
  mysql:
    image: mysql:8
    container_name: mysql-8
    ports:
      - 3306:3306
    volumes:
      - ~/apps/mysql:/var/lib/mysql
      - ./backups:/tmp/backup
    environment:
      - MYSQL_ROOT_PASSWORD=123456
      - MYSQL_PASSWORD=123456
      - MYSQL_USER=tim
      - MYSQL_DATABASE=test_db
```
```
$ docker-compose up -d
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-03-mysql/test_data) и 
восстановитесь из него.
```
$ docker cp ./test_data/test_dump.sql mysql-8:/tmp/  # скопируем бэкап в контейнер

$ docker exec -it mysql-8 /bin/bash                  # зайдем в контейнер

bash-4.4# mysql -p test_db < /tmp/test_dump.sql      # востанавливаем БД
```

Перейдите в управляющую консоль `mysql` внутри контейнера.
```
bash-4.4# mysql -p                              
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 15
Server version: 8.0.32 MySQL Community Server - GPL

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.mysql -p
```

Используя команду `\h` получите список управляющих команд.
Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.
```
mysql> \s
--------------
mysql  Ver 8.0.32 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          10
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.32 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 4 min 42 sec

Threads: 2  Questions: 8  Slow queries: 0  Opens: 137  Flush tables: 3  Open tables: 56  Queries per second avg: 0.028
--------------
```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.
```
mysql> USE test_db
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed

mysql> SHOW TABLES;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)
```
или так 
```
mysql> SHOW TABLES FROM test_db;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.01 sec)
```

**Приведите в ответе** количество записей с `price` > 300.
```
mysql> SELECT COUNT(price) FROM orders WHERE price > 300;
+--------------+
| COUNT(price) |
+--------------+
|            1 |
+--------------+
1 row in set (0.00 sec)
```
В следующих заданиях мы будем продолжать работу с данным контейнером.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя: 
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"
```
mysql> CREATE USER 'test'@'localhost' IDENTIFIED WITH mysql_native_password BY 'test-pass'
    ->     WITH MAX_QUERIES_PER_HOUR 100
    ->     PASSWORD EXPIRE INTERVAL 180 DAY
    ->     FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 1
    ->     ATTRIBUTE '{"fname":"Pretty", "lname":"James"}';
Query OK, 0 rows affected (0.12 sec)
```
Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
```
mysql> GRANT SELECT ON test_db.* TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.09 sec)
```
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.
```
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES where USER = 'test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "Pretty", "lname": "James"} |
+------+-----------+---------------------------------------+
1 row in set (0.02 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.
Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.
```
mysql> use test_db
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SHOW CREATE TABLE orders\G;
*************************** 1. row ***************************
       Table: orders
Create Table: CREATE TABLE `orders` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(80) NOT NULL,
  `price` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
1 row in set (0.00 sec)

ERROR: 
No query specified

```
  >или так
```
mysql> SHOW TABLE STATUS FROM test_db LIKE 'orders'\G;
*************************** 1. row ***************************
           Name: orders
         Engine: InnoDB
        Version: 10
     Row_format: Dynamic
           Rows: 5
 Avg_row_length: 3276
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 0
 Auto_increment: 6
    Create_time: 2023-02-16 19:27:02
    Update_time: NULL
     Check_time: NULL
      Collation: utf8mb4_0900_ai_ci
       Checksum: NULL
 Create_options: 
        Comment: 
1 row in set (0.04 sec)

ERROR: 
No query specified
```
  > есть еще несколько способов узнать тип 'engine'

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
```
mysql> ALTER TABLE orders ENGINE=MyISAM;
Query OK, 5 rows affected (0.64 sec)
Records: 5  Duplicates: 0  Warnings: 0
```
- на `InnoDB`
```
mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (1.24 sec)
Records: 5  Duplicates: 0  Warnings: 0
```
  >время выполнения и запрос на изменения из профайлера 
```
mysql> SHOW PROFILES;
+----------+------------+------------------------------------+
| Query_ID | Duration   | Query                              |
+----------+------------+------------------------------------+
|        1 | 0.00029675 | SELECT DATABASE()                  |
|        2 | 0.00456875 | show databases                     |
|        3 | 0.00343750 | show tables                        |
|        4 | 0.00032375 | SET profiling = 1                  |
|        5 | 0.00086725 | SHOW CREATE TABLE orders           |
|        6 | 0.63654750 | ALTER TABLE orders ENGINE=MyISAM   |
|        7 | 1.23752975 | ALTER TABLE orders ENGINE = InnoDB |
+----------+------------+------------------------------------+
7 rows in set, 1 warning (0.00 sec)
```
  >можно узнать подробно о на что тратилось время в каждом запросе
```
mysql> show profile for query 6;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000146 |
| Executing hook on transaction  | 0.000015 |
| starting                       | 0.000036 |
| checking permissions           | 0.000014 |
| checking permissions           | 0.000014 |
| init                           | 0.000025 |
| Opening tables                 | 0.000691 |
| setup                          | 0.000286 |
| creating table                 | 0.001861 |
| waiting for handler commit     | 0.000025 |
| waiting for handler commit     | 0.046508 |
| After create                   | 0.001541 |
| System lock                    | 0.000048 |
| copy to tmp table              | 0.000255 |
| waiting for handler commit     | 0.000026 |
| waiting for handler commit     | 0.000031 |
| waiting for handler commit     | 0.000078 |
| rename result table            | 0.000167 |
| waiting for handler commit     | 0.175069 |
| waiting for handler commit     | 0.000037 |
| waiting for handler commit     | 0.066716 |
| waiting for handler commit     | 0.000036 |
| waiting for handler commit     | 0.134565 |
| waiting for handler commit     | 0.000037 |
| waiting for handler commit     | 0.064496 |
| end                            | 0.102823 |
| query end                      | 0.040750 |
| closing tables                 | 0.000041 |
| waiting for handler commit     | 0.000066 |
| freeing items                  | 0.000067 |
| cleaning up                    | 0.000081 |
+--------------------------------+----------+
31 rows in set, 1 warning (0.00 sec)

mysql> show profile for query 7;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000154 |
| Executing hook on transaction  | 0.000015 |
| starting                       | 0.000038 |
| checking permissions           | 0.000014 |
| checking permissions           | 0.000013 |
| init                           | 0.000027 |
| Opening tables                 | 0.000406 |
| setup                          | 0.000129 |
| creating table                 | 0.000249 |
| After create                   | 0.431586 |
| System lock                    | 0.000046 |
| copy to tmp table              | 0.000261 |
| rename result table            | 0.002539 |
| waiting for handler commit     | 0.000029 |
| waiting for handler commit     | 0.150871 |
| waiting for handler commit     | 0.000036 |
| waiting for handler commit     | 0.485761 |
| waiting for handler commit     | 0.000039 |
| waiting for handler commit     | 0.068208 |
| waiting for handler commit     | 0.000039 |
| waiting for handler commit     | 0.030092 |
| end                            | 0.001316 |
| query end                      | 0.065415 |
| closing tables                 | 0.000045 |
| waiting for handler commit     | 0.000076 |
| freeing items                  | 0.000068 |
| cleaning up                    | 0.000061 |
+--------------------------------+----------+
27 rows in set, 1 warning (0.00 sec)
```

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

---
