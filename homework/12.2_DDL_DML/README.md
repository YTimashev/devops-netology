# Домашнее задание к занятию 12.2 "Работа с данными (DDL/DML)"

---

Задание можно выполнить как в любом IDE, так и в командной строке.

### Задание 1.
1.1 Поднимите чистый инстанс MySQL версии 8.0+. Можно использовать локальный сервер или контейнер Docker.
```
sudo apt install mysql-server mysql-client -y
```

1.2 Создайте учетную запись sys_temp.
```
CREATE USER 'sys_temp'@'localhost' IDENTIFIED BY 'password';
```

1.3 Выполните запрос на получение списка пользователей в Базе Данных. (скриншот)
![Снимок экрана от 2022-10-16 17-08-01](https://user-images.githubusercontent.com/108893621/196039994-2135f297-16ca-465c-b419-1c8c263ab425.png)

1.4 Дайте все права для пользователя sys_temp. 
```
GRANT ALL PRIVILEGES ON *.* TO 'sys_temp'@'localhost';
```

1.5 Выполните запрос на получение списка прав для пользователя sys_temp. (скриншот)
![Снимок экрана от 2022-10-16 17-39-57](https://user-images.githubusercontent.com/108893621/196041864-2e3cd1a9-a660-433f-bf57-d290fc815aa6.png)


1.6 Переподключитесь к базе данных от имени sys_temp.

Для смены типа аутентификации с sha2 используйте запрос: 
```sql
ALTER USER 'sys_test'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
```
1.6 По ссылке https://downloads.mysql.com/docs/sakila-db.zip скачайте дамп базы данных.

1.7 Восстановите дамп в базу данных.
![Снимок экрана от 2022-10-16 21-29-36](https://user-images.githubusercontent.com/108893621/196052115-5da4ae1c-51e1-4cf9-a5b6-31cefb9a1362.png)

1.8 При работе в IDE сформируйте ER-диаграмму получившейся базы данных. При работе в командной строке используйте команду для получения всех таблиц базы данных. (скриншот)
![Снимок экрана от 2022-10-16 21-35-01](https://user-images.githubusercontent.com/108893621/196052131-d0bef999-c5ea-4187-b3e0-916e364ea63f.png)

*Результатом работы должны быть скриншоты обозначенных заданий, а так же "простыня" со всеми запросами.*


### Задание 2.
Составьте таблицу, используя любой текстовый редактор или Excel, в которой должно быть два столбца, в первом должны быть названия таблиц восстановленной базы, во втором названия первичных ключей этих таблиц. Пример: (скриншот / текст)
```
Название таблицы           | Название первичного ключа
_ _ _ _ _ _ _ _ _ _ _ _ _ _|_ _ _ _ _ _ _ _ _ _ _ _ _ _
actor                      | actor_id 
actor_info                 |
address                    | address_id 
category                   | category_id
city                       | city_id 
country                    | country_id 
customer                   | customer_id
customer_list              | 
film                       | film_id 
film_actor                 | actor_id, film_id  
film_category              | film_id, category_id
film_list                  | 
film_text                  | film_id 
inventory                  | inventory_id
language                   | language_id
nicer_but_slower_film_list |
payment                    | payment_id
rental                     | rental_id 
sales_by_film_category     |
sales_by_store             |
staff                      | staff_id
staff_list                 |
store                      | store_id
```


## Дополнительные задания (со звездочкой*)

### Задание 3.*
3.1 Уберите у пользователя sys_temp права на внесение, изменение и удаление данных из базы sakila.
```
REVOKE INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP ON sakila.* FROM 'sys_temp'@'localhost'
```

3.2 Выполните запрос на получение списка прав для пользователя sys_temp. (скриншот)
![Снимок экрана от 2022-10-16 23-08-16](https://user-images.githubusercontent.com/108893621/196055849-1e0248a5-458e-4cb3-beb2-b74410996c86.png)

*Результатом работы должны быть скриншоты обозначенных заданий, а так же "простыня" со всеми запросами.*

