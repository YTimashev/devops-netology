# Домашнее задание к занятию "5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
```dockerfile
FROM centos:7

ENV PATH=/usr/lib:/usr/lib/jvm/jre-11/bin:$PATH

EXPOSE 9200 9300

RUN yum install wget -y 
RUN yum install perl-Digest-SHA -y 
RUN yum install java-11-openjdk-devel -y 
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.14.0-linux-x86_64.tar.gz && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.14.0-linux-x86_64.tar.gz.sha512 
RUN shasum -a 512 -c elasticsearch-7.14.0-linux-x86_64.tar.gz.sha512 && \ 
    tar -xzf elasticsearch-7.14.0-linux-x86_64.tar.gz

RUN rm elasticsearch-7.14.0-linux-x86_64.tar.gz && \
    rm elasticsearch-7.14.0-linux-x86_64.tar.gz.sha512

ADD elasticsearch.yml /elasticsearch-7.14.0/config/

ENV ES_JAVA_HOME=/elasticsearch-7.14.0/jdk/
ENV ES_HOME=/elasticsearch-7.14.0
RUN groupadd elastic && useradd -g elastic elastic

RUN mkdir /var/lib/logs && \
    chown elastic:elastic /var/lib/logs && \
    mkdir /var/lib/data && \
    chown elastic:elastic /var/lib/data && \
    chown -R elastic:elastic /elasticsearch-7.14.0

USER elastic
CMD ["/elasticsearch-7.14.0/bin/elasticsearch"]
```
```bash
$ docker build -t timoha1971/esc:7 .

$ docker push timoha1971/esc:7

$ docker run --rm -d --name esc7 -p 9200:9200 timoha1971/esc:7

$ curl -X GET 'http://localhost:9200/'
```
- ссылку на образ в репозитории dockerhub
  >[Ссылка на образ в](https://hub.docker.com/repository/docker/timoha1971/esc/general)

- ответ `elasticsearch` на запрос пути `/` в json виде
```json
{
  "name" : "netology_test",
  "cluster_name" : "docker_cluster",
  "cluster_uuid" : "BcEZe8GzQbaGnGJuSfRtQA",
  "version" : {
    "number" : "7.14.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "dd5a0a2acaa2045ff9624f3729fc8a6f40835aa1",
    "build_date" : "2021-07-29T20:49:32.864135063Z",
    "build_snapshot" : false,
    "lucene_version" : "8.9.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```
Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

```bash
$ curl -X PUT "localhost:9200/ind-1" -H 'Content-Type: application/json' -d'
```
```json
{
    "settings": {
        "index": {
            "number_of_shards": 1,
            "number_of_replicas": 0
        }
    }
}
'
```
  >Пример добавления индексов

```json
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}
```
  >Ответ на создание индекса

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
```bash
$ curl -X GET "localhost:9200/_cat/indices/ind-*?v=true&s=index&pretty"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 OrPel7eSThq5eDibsbRIvw   1   0          0            0       208b           208b
yellow open   ind-2 sB-2ZqL9QI6-y4KMJxkjgQ   2   1          0            0       416b           416b
yellow open   ind-3 PU3wcARWSU6hGFxekxJVFw   4   2          0            0       832b           832b
```
Получите состояние кластера `elasticsearch`, используя API.
```bash
$ curl -X GET "localhost:9200/_cluster/health?pretty"
```
```json
{
  "cluster_name" : "docker_cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```
Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
  >В лекции было четко акцентировано внимание что, состояние Yellow у индексов по причине наличия в кластере всего одной ноды в сравнение с количеством реплик.

Удалите все индексы.
```bash
$ curl -X DELETE localhost:9200/ind-1 localhost:9200/ind-2 localhost:9200/ind-3
{"acknowledged":true}{"acknowledged":true}{"acknowledged":true}
```
**Важно**
При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.
```bash
$ docker exec -ti esc /bin/bash
[elastic@bc5196192096 /]$ mkdir elasticsearch-7.14.0/snapshots
[elastic@8eb44dd7b620 /]$ vi elasticsearch-7.14.0/config/elasticsearch.yml # добавляем в файл строку: "path.repo: /elasticsearch-7.14.0/snapshots"
[elastic@8eb44dd7b620 /]$ exit
$ docker restart esc 
```
Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.
```bash
$ curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/elasticsearch-7.14.0/snapshots"
  }
}
'
```
  >Запрос
```json
{
  "acknowledged" : true
}
```
  >результат вызова

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.
```bash
$ curl -X PUT "localhost:9200/test" -H 'Content-Type: application/json' -d'
{
    "settings": {
        "index": {
            "number_of_shards": 1,
            "number_of_replicas": 0
        }
    }
}
'
```
```json
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}
```
```bash
$ curl -X GET "localhost:9200/_cat/indices/test?v=true&s=index&pretty"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  PT4WyeF_R4mr2Pz4AGTPwg   1   0          0            0       208b           208b
```
[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.
```bash
curl -X PUT "localhost:9200/_snapshot/netology_backup/my_snapshot?wait_for_completion=true&pretty"
```
```json
{
  "snapshot" : {
    "snapshot" : "my_snapshot",
    "uuid" : "-zhGEU3vQGC7aDrQNq1aWw",
    "repository" : "netology_backup",
    "version_id" : 7140099,
    "version" : "7.14.0",
    "indices" : [
      ".geoip_databases",
      "test"
    ],
    "data_streams" : [ ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2023-02-26T17:55:28.482Z",
    "start_time_in_millis" : 1677434128482,
    "end_time" : "2023-02-26T17:55:30.484Z",
    "end_time_in_millis" : 1677434130484,
    "duration_in_millis" : 2002,
    "failures" : [ ],
    "shards" : {
      "total" : 2,
      "failed" : 0,
      "successful" : 2
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      }
    ]
  }
}
```
**Приведите в ответе** список файлов в директории со `snapshot`ами.
```bash
$ docker exec -ti esc /bin/bash
[elastic@8eb44dd7b620 /]$ ls -lah elasticsearch-7.14.0/snapshots/
total 56K
drwxrwxr-x 3 elastic elastic 4.0K Feb 26 17:55 .
drwxr-xr-x 1 elastic elastic 4.0K Feb 26 16:51 ..
-rw-r--r-- 1 elastic elastic  829 Feb 26 17:55 index-0
-rw-r--r-- 1 elastic elastic    8 Feb 26 17:55 index.latest
drwxr-xr-x 4 elastic elastic 4.0K Feb 26 17:55 indices
-rw-r--r-- 1 elastic elastic  28K Feb 26 17:55 meta--zhGEU3vQGC7aDrQNq1aWw.dat
-rw-r--r-- 1 elastic elastic  438 Feb 26 17:55 snap--zhGEU3vQGC7aDrQNq1aWw.dat
```
Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.
```bash
[elastic@8eb44dd7b620 /]$ exit
exit

$ curl -X DELETE localhost:9200/test
{"acknowledged":true}

$ curl -X PUT "localhost:9200/test-2" -H 'Content-Type: application/json' -d'
{
    "settings": {
        "index": {
            "number_of_shards": 1,
            "number_of_replicas": 0
        }
    }
}
'
{"acknowledged":true,"shards_acknowledged":true,"index":"test-2"}
```
```bash
$ curl -X GET "localhost:9200/_cat/indices/test*?v=true&s=index&pretty"
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 ZjZvZ6TrRam3Y2MXfHR0mA   1   0          0            0       208b           208b
```
[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 
**Приведите в ответе** запрос к API восстановления и итоговый список индексов.
```bush
$ curl -X POST "localhost:9200/_snapshot/netology_backup/my_snapshot/_restore?pretty" -H 'Content-Type: application/json' -d'
{
  "indices": "*",
  "include_global_state": true
}
'
```
```json
{
  "accepted" : true
}
```
```bash
$ curl -X GET "localhost:9200/_cat/indices/test*?v=true&s=index&pretty"
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test   VfEjyL8lT8uWNutHV1IV_Q   1   0          0            0       208b           208b
green  open   test-2 ZjZvZ6TrRam3Y2MXfHR0mA   1   0          0            0       208b           208b
```

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---
