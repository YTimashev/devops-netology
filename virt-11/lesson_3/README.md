# Домашнее задание к занятию "3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

---

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
```
tim@tim:~$ sudo docker login -u timoha1971
Password: 

Login Succeeded
```


- выберете любой образ, который содержит веб-сервер Nginx;

```Поиск образа nginx```
```
tim@tim:~$ sudo docker search nginx
NAME                                              DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
nginx                                             Official build of Nginx.                        17948     [OK]                 
bitnami/nginx                                     Bitnami nginx Docker Image                      150                  [OK]
ubuntu/nginx                                      Nginx, a high-performance reverse proxy & we…   75                   
...
```

```Скачиваем образ nginx```
```
tim@tim:~$ sudo docker pull nginx
Using default tag: latest
latest: Pulling from library/nginx
8740c948ffd4: Pull complete 
d2c0556a17c5: Pull complete 
c8b9881f2c6a: Pull complete 
693c3ffa8f43: Pull complete 
8316c5e80e6d: Pull complete 
b2fe3577faa4: Pull complete 
Digest: sha256:b8f2383a95879e1ae064940d9a200f67a6c79e710ed82ac42263397367e7cc4e
Status: Downloaded newer image for nginx:latest
docker.io/library/nginx:latest
```

- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```html
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```

```Оформляем Dockerfile```
```
# Dockerfile

FROM nginx

# Можно сразу перезаписать index.html
# RUN echo '<html><head>Hey, Netology</head><body><h1>I`m DevOps Engineer!</h1></body></html>' > /usr/share/nginx/html/index.html

# либо залить файлы сайта/приложения в папку
COPY html/ /usr/share/nginx/html

# открываем порты в контейнере
EXPOSE 80
```

```Создаем форк```
```
$ docker build -t timoha1971/netnginxtest2:1 .
```

Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.
```
$ docker push timoha1971/netnginxtest2:1 
```

```Ссылка на образ в репозитории [DockerHub](https://hub.docker.com/layers/timoha1971/netnginxtest2/1/images/sha256-b0ad8eba353df232d5ee254c971f3620977de984cb0329c59814e919ffa599d8?context=repo)```


```Запускаем контейнер с пробросом на 8082 порт хоста:```
```
docker run -d -p 8082:80 --name web2 timoha1971/netnginxtest2:1
```

Открываем в браузере

![Снимок экрана от 2023-01-18 21-06-57](https://user-images.githubusercontent.com/108893621/213268525-4edf057a-608f-49e6-8663-bc7eafc4f2c0.png)



## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.


---
