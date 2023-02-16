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

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

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
