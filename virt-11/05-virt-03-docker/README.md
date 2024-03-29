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
```
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

Ссылка на образ в репозитории [DockerHub](https://hub.docker.com/layers/timoha1971/netnginxtest2/1/images/sha256-b0ad8eba353df232d5ee254c971f3620977de984cb0329c59814e919ffa599d8?context=repo)


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
    >В данном случае правильнее будет использовать физический сервер, т.к. высокая нагрузка и монолитность приложения требуют время для запуска и несколько процессов.
   
- Nodejs веб-приложение;
    >Здесь Docker как мне кажется будет оптимальным решением. удобство в развертывании приложения, лёгкий вес, масштабирование.

- Мобильное приложение c версиями для Android и iOS;
    >Думаю здесь также преимущества в выборе докера очевидны - быстрое развёртывание, лёгкость масштабирование.

- Шина данных на базе Apache Kafka;
    >Здесь правильным выбором как мне кажется будет физические либо виртуальные серверы - более надежнее сохранение данных.

- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
    >Docker - очень удобно и просто раскидать все по контейнерам. 

- Мониторинг-стек на базе Prometheus и Grafana;
    >Вполне подходит Docker. Есть готовые решения/образы, простота и удобство, масштабировать и быстрота развертывания.

- MongoDB, как основное хранилище данных для java-приложения;
    >Здесь наверно выбор бы сделал в пользу физических или виртуальных серверов - сложность администрирования MongoDB в контейнере, высокая вероятность утраты данных при потере контейнера.

- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
    >как мне кажеться там где производиться постоянная работа с данными и их сохранением Docker будет не лучшим решением. Правильнее будет использовать физические/виртуальные серверы.


## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
```
$ docker run -v /data:/data --name centosdata -d -t centos
```

- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
```
$ docker run -v /data:/data --name ubuntudata -d -t ubuntu
```

```
$ docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
307cda67efcc   centos    "/bin/bash"   13 minutes ago   Up 13 minutes             centosdata
83d70d3824a4   ubuntu    "bash"        14 minutes ago   Up 14 minutes             ubuntudata
```

- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
```
$ docker exec -it centosdata /bin/bash
[root@307cda67efcc /]# touch /data/test_centos.txt
[root@307cda67efcc /]# vi /data/test_centos.txt
[root@307cda67efcc /]# exit
exit
```

- Добавьте еще один файл в папку ```/data``` на хостовой машине;
```
$ sudo touch /data/host_test.txt
$ sudo vim /data/host_test.txt
```

- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.
```
$ docker exec -it ubuntudata /bin/bash
root@83d70d3824a4:/# ls -l /data
total 8
-rw-r--r-- 1 root root 14 Jan 18 20:31 host_test.txt
-rw-r--r-- 1 root root 17 Jan 18 20:26 test_centos.txt
```



## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

```Собираем из предложенного нам Dockerfile - образ, в котором будет выполняться Ansible```
```
$ docker build -t timoha1971/netansible2:2.10.0 .
```

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

```Выгружаем Docker-образ в публичный реестр```
```
$ docker login -u timoha1971
Password: 

Login Succeeded
```
```
$ docker push timoha1971/netansible2:2.10.0
The push refers to repository [docker.io/timoha1971/netansible2]
463cd33dd141: Pushed 
306e5055322b: Pushed 
63493a9ab2d4: Mounted from library/alpine 
2.10.0: digest: sha256:6ec46b46fec702ed4243695e828ad9f570810e551dd8c3a4c94b8be055c51774 size: 947
```
Ссылка на [образ](https://hub.docker.com/repository/docker/timoha1971/netansible2/tags?page=1&ordering=last_updated)
```
$ docker run timoha1971/netansible2:2.10.0
ansible-playbook [core 2.14.1]
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.9/site-packages/ansible
  ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible-playbook
  python version = 3.9.16 (main, Dec 10 2022, 13:47:19) [GCC 10.3.1 20210424] (/usr/bin/python3)
  jinja version = 3.1.2
  libyaml = False
  ```
---
