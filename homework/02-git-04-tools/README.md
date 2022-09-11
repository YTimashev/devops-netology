# Домашнее задание к занятию «2.4. Инструменты Git»

Для выполнения заданий в этом разделе давайте склонируем репозиторий с исходным кодом 
терраформа https://github.com/hashicorp/terraform 

В виде результата напишите текстом ответы на вопросы и каким образом эти ответы были получены. 

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.
- команда `git show --pretty=oneline aefea` покажет полный хеш и комментарий коммита


2. Какому тегу соответствует коммит `85024d3`?
- узнать какому тегу соответсвует коммит, можно командой `git show 85024d3 --oneline --no-patch`
```
$ git show 85024d3 --oneline --no-patch
85024d3100 (tag: v0.12.23) v0.12.23
```



3. Сколько родителей у коммита `b8d720`? Напишите их хеши.
- посмотреть родословную коммита можно несколькими способами:
- в виде дерева командой `git log b8d720 --pretty=format:'%h %s' --graph`
```
$ git log b8d720 --pretty=format:'%h %s' --graph
*   b8d720f834 Merge pull request #23916 from hashicorp/cgriggs01-stable
|\  
| * 9ea88f22fc add/update community provider listings
|/  
*   56cd7859e0 Merge pull request #23857 from hashicorp/cgriggs01-stable
|\  
| * ffbcf55817 [Website]add checkpoint links
|/  
* 58dcac4b79 v0.12.19
* 472d958b10 Update CHANGELOG.md
```
- а также командой `git show b8d720^` и `git show b8d720^2`
```
$ git show b8d720^ --pretty=oneline --no-patch
56cd7859e05c36c06b56d013b55a252d0bb7e158 Merge pull request #23857 from hashicorp/cgriggs01-stable
```
```
$ git show b8d720^2 --pretty=oneline --no-patch
9ea88f22fc6269854151c571162c5bcf958bee2b add/update community provider listings
```

4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами  v0.12.23 и v0.12.24.

- Подобрал несколько комманд, самая оптимальная как мне кажется `git log v0.12.23...v0.12.24 --pretty=oneline`
```
$ git log v0.12.23...v0.12.24 --pretty=oneline
33ff1c03bb960b332be3af2e333462dde88b279e (tag: v0.12.24) v0.12.24
b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links
3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md
6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is unreachable
5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting started guide's old location
06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md
d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terraform login on Windows
4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md
dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md
225466bc3e5f35baa5d07197bbc079345b77525e Cleanup after v0.12.23 release
```

5. Найдите коммит в котором была создана функция `func providerSource`, ее определение в коде выглядит 
так `func providerSource(...)` (вместо троеточего перечислены аргументы).

- Найти коммит в коде которого определение функции функции выглядит как `func providerSource(...)` можно с помощью команды `git log -S 'func providerSource('` 


6. Найдите все коммиты в которых была изменена функция `globalPluginDirs`.

- Команда `git grep "globalPluginDirs"` поможет найти файл в котором функция `globalPluginDirs`.
- команда `git log -L :globalPluginDirs:plugins.go` отразит историю изменения функции


7. Кто автор функции `synchronizedWriters`? 

-  Найти коммиты в которых использовалась функция `synchronizedWriters` с помoщью команды  `git log -SsynchronizedWriters --pretty=oneline`
-  Далее пробежаться по коммитам командой `git show`

 
---

