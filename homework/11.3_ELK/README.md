# Домашнее задание к занятию 11.3 "ELK"

---

### Задание 1. Elasticsearch. 

Установите и запустите elasticsearch, после чего поменяйте параметр cluster_name на случайный. 

*Приведите скриншот команды 'curl -X GET 'localhost:9200/_cluster/health?pretty', сделанной на сервере с установленным elasticsearch. Где будет виден нестандартный cluster_name*
![Снимок экрана от 2022-10-02 20-10-32](https://user-images.githubusercontent.com/108893621/193632476-f1d00f39-3166-486f-8326-14bbf9237735.png)

---

### Задание 2. Kibana.

Установите и запустите kibana.

*Приведите скриншот интерфейса kibana на странице http://<ip вашего сервера>:5601/app/dev_tools#/console, где будет выполнен запрос GET /_cluster/health?pretty*
![Снимок экрана от 2022-10-02 21-34-20](https://user-images.githubusercontent.com/108893621/193632529-b5f70fc4-0399-4db0-928e-39e100144406.png)

---

### Задание 3. Logstash.

Установить и запустить Logstash и Nginx. С помощью Logstash отправить access-лог nginx в Elasticsearch. 

Приведите скриншот интерфейса kibana, на котором видны логи nginx.*
*![Снимок экрана от 2022-10-06 22-36-51](https://user-images.githubusercontent.com/108893621/194404132-aaaef301-3d53-48f6-ba91-649a8980f4f0.png)

---

### Задание 4. Filebeat. 

Установить и запустить Filebeat. Переключить поставку логов Nginx с Logstash на Filebeat. 

*Приведите скриншот интерфейса kibana, на котором видны логи nginx, которые были отправлены через Filebeat.*
![Снимок экрана от 2022-10-06 21-30-25](https://user-images.githubusercontent.com/108893621/194391321-e91ee315-0661-49bb-a2c0-41477ddb4dd9.png)


