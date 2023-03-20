# Домашнее задание к занятию "Введение в Terraform"

### Цель задания

1. Установить и настроить Terrafrom.
2. Научиться использовать готовый код.

------

### Чеклист готовности к домашнему заданию

1. Скачайте и установите актуальную версию **terraform**(не менее 1.3.7). Приложите скриншот вывода команды ```terraform --version```
```bash
$ terraform --version
Terraform v1.3.7
on linux_amd64
```

2. Скачайте на свой ПК данный git репозиторий. Исходный код для выполнения задания расположен в директории **01/src**.
```bash
$ git clone https://github.com/netology-code/ter-homeworks.git
```

3. Убедитесь, что в вашей ОС установлен docker
```bash
$ docker --version
Docker version 20.10.22, build 3a2c30b
```

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Установка и настройка Terraform  [ссылка](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#from-yc-mirror)
2. Зеркало документации Terraform  [ссылка](https://registry.tfpla.net/browse/providers) 
3. Установка docker [ссылка](https://docs.docker.com/engine/install/ubuntu/) 
------

### Задание 1

1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте. 
2. Изучите файл **.gitignore**. В каком terraform файле допустимо сохранить личную, секретную информацию?
   > личную секретную информацию необходимо хранить в файле ```personal.auto.tfvars```

3. Выполните код проекта. Найдите  в State-файле секретное содержимое созданного ресурса **random_password**. Пришлите его в качестве ответа.
```json
"result": "odSqJuGHskm7kDz1"
```

4. Раскомментируйте блок кода, примерно расположенный на строчках 29-42 файла **main.tf**.
Выполните команду ```terraform -validate```. Объясните в чем заключаются намеренно допущенные ошибки? Исправьте их.
> в первой ошибке необходимо дополнительно задать имя ресурса - ```resource "docker_image"```

> во второй ошибке опять же проблемы из за неверного имени ресурса ```resource "docker_container" "1nginx"``` , имя должно начинаться с буквы или подчеркивания
   
>Код с учетом исправлений:
```
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx_1" {
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 8000
  }
}
```

5. Выполните код. В качестве ответа приложите вывод команды ```docker ps```
```bash
$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                  NAMES
f7e1cde2645d   904b8cb13b93   "/docker-entrypoint.…"   23 seconds ago   Up 16 seconds   0.0.0.0:8000->80/tcp   example_odSqJuGHskm7kDz1
```

6. Замените имя docker-контейнера в блоке кода на ```hello_world```, выполните команду ```terraform apply -auto-approve```.
Объясните своими словами, в чем может быть опасность применения ключа  ```-auto-approve``` ? 
>Команда ```terraform apply -auto-approve``` вносит изменения в инфраструктуре без одобрения/подтверждения пользователя, такие действия могут могут привести к полной потере данных. Документация Терраформ рекомендует не прибегать к данной команде, а использовать свой plan file т.к. он позволяет анализировать все изменения до их применения.

8. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**. 
```bash
$ terraform destroy
```
```
# terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.3.7",
  "serial": 13,
  "lineage": "a85b53f4-9266-018e-d4d8-a6e1a46504b4",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```

9. Объясните, почему при этом не был удален docker образ **nginx:latest** ?(Ответ найдите в коде проекта или документации)
>в параметрах ресурса ```resource "docker_image" "nginx"``` мы указали параметр   ```keep_locally = true``` - хранить локально

------

## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.**   Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой дополнительные (необязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. 

### Задание 2*

1. Изучите в документации provider [**Virtualbox**](https://registry.tfpla.net/providers/shekeriev/virtualbox/latest/docs/overview/index) от 
shekeriev.
2. Создайте с его помощью любую виртуальную машину.

В качестве ответа приложите plan для создаваемого ресурса.
```
$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # virtualbox_vm.vm1 will be created
  + resource "virtualbox_vm" "vm1" {
      + cpus   = 1
      + id     = (known after apply)
      + image  = "https://app.vagrantup.com/shekeriev/boxes/centos-8-minimal/versions/0.3/providers/virtualbox.box"
      + memory = "512 mib"
      + name   = "centos-8"
      + status = "running"

      + network_adapter {
          + device                 = "IntelPro1000MTServer"
          + ipv4_address           = (known after apply)
          + ipv4_address_available = (known after apply)
          + mac_address            = (known after apply)
          + status                 = (known after apply)
          + type                   = "nat"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.