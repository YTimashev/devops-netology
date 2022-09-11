# Домашнее задание к занятию «2.4. Инструменты Git»

Для выполнения заданий в этом разделе давайте склонируем репозиторий с исходным кодом 
терраформа https://github.com/hashicorp/terraform 

В виде результата напишите текстом ответы на вопросы и каким образом эти ответы были получены. 

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.

- команда `git show --pretty=oneline aefea` покажет полный хеш и комментарий коммита

`git show --pretty=oneline aefea
aefead2207ef7e2aa5dc81a34aedf0cad4c32545 Update CHANGELOG.md
    ......`


1. Какому тегу соответствует коммит `85024d3`?



1. Сколько родителей у коммита `b8d720`? Напишите их хеши.


1. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами  v0.12.23 и v0.12.24.

- Подобрал несколько комманд но самая оптимальная по моему мнению `git log v0.12.23...v0.12.24 --oneline`

`git log v0.12.23...v0.12.24 --oneline
33ff1c03bb (tag: v0.12.24) v0.12.24
b14b74c493 [Website] vmc provider links
3f235065b9 Update CHANGELOG.md
6ae64e247b registry: Fix panic when server is unreachable
5c619ca1ba website: Remove links to the getting started guide's old location
06275647e2 Update CHANGELOG.md
d5f9411f51 command: Fix bug when using terraform login on Windows
4b6d06cc5d Update CHANGELOG.md
dd01a35078 Update CHANGELOG.md
225466bc3e Cleanup after v0.12.23 release`


1. Найдите коммит в котором была создана функция `func providerSource`, ее определение в коде выглядит 
так `func providerSource(...)` (вместо троеточего перечислены аргументы).

- Найти коммит в коде которого определение функции функции выглядит как `func providerSource(...)` можно с помощью команды `git log -S 'func providerSource('` 


1. Найдите все коммиты в которых была изменена функция `globalPluginDirs`.

- Команда `git log -S globalPluginDirs` покажет все комиты в которых менялась функция `globalPluginDirs`.


1. Кто автор функции `synchronizedWriters`? 

-  Найти коммиты в которых использовалась функция `synchronizedWriters` с помoщью команды  `git log -SsynchronizedWriters`

 
---

