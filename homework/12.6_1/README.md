# Домашнее задание к занятию 12.6 "Репликация и масштабирование. Часть 1"

---
### Задание 1.

На лекции рассматривались режимы репликации master-slave, master-master, опишите их различия.

*Основное различие репликаций master-slave, master-master - это то что при репликации master-slave:  master — является основным сервером БД, в который поступают все данные и в котором проводятся все измения, а slave является вспомогательным/дублирующим сервером, который копирует все данные с мастера. Репликация master-master копирует данные с одного сервера на другой, в обе стороны, т.е. каждый из этих серверов является как мастером так и слейвом.*

---
### Задание 2.

Выполните конфигурацию Master-Slave репликации (примером можно пользоваться из лекции).

*Приложите скриншоты конфигурации, выполнения работы (состояния и режимы работы серверов).*
![Снимок экрана от 2022-10-29 18-23-37](https://user-images.githubusercontent.com/108893621/198840115-ffe6a89b-eb98-4c97-ac90-34621106c747.png)


---

## Дополнительные задания (со звездочкой*)

### Задание 3*. 

Выполните конфигурацию Master-Master репликации. Произведите проверку.

*Приложите скриншоты конфигурации, выполнения работы (состояния и режимы работы серверов).*
![Снимок экрана от 2022-10-29 19-40-24](https://user-images.githubusercontent.com/108893621/198843112-cbcfeb02-6c87-4db1-8858-c389db84a057.png)

