# Домашнее задание к занятию «2.3. Ветвления в Git»

Давайте потренеруемся делать merge и rebase, чтобы понять разницу и научиться решать конфликты.

## Задание №1 – Ветвление, merge и rebase. 

1. Предположим, что есть задача написать скрипт, выводящий на экран параметры его запуска. 
Давайте посмотрим, как будет отличаться работа над этим скриптом с использованием ветвления, мержа и ребейза. 
Создайте в своем репозитории каталог `branching` и в нем два файла `merge.sh` и `rebase.sh` с 
содержимым:
```bash
#!/bin/bash
# display command line options

count=1
for param in "$*"; do
    echo "\$* Parameter #$count = $param"
    count=$(( $count + 1 ))
done
```

Этот скрипт отображает на экране все параметры одной строкой, а не разделяет их.
![Снимок экрана от 2022-09-06 22-43-00](https://user-images.githubusercontent.com/108893621/189186144-3ca3523f-defb-4a7e-95be-d35867b6e7d2.png)


2. Создадим коммит с описанием `prepare for merge and rebase` и отправим его в ветку main. 

#### Подготовка файла merge.sh.
1. Создайте ветку `git-merge`. 
1. Замените в ней содержимое файла `merge.sh` на
```bash
#!/bin/bash
# display command line options

count=1
for param in "$@"; do
    echo "\$@ Parameter #$count = $param"
    count=$(( $count + 1 ))
done
```
![Снимок экрана от 2022-09-06 22-51-22](https://user-images.githubusercontent.com/108893621/189187895-220d530b-14c0-493d-bc6c-5b08926e1be0.png)

3. Создайте коммит `merge: @ instead *` отправьте изменения в репозиторий.
![Снимок экрана от 2022-09-06 22-53-56](https://user-images.githubusercontent.com/108893621/189188082-36b4cead-f606-481c-b202-877e018e74a2.png)

4. И разработчик подумал и решил внести еще одно изменение в `merge.sh` 
```bash
#!/bin/bash
# display command line options

count=1
while [[ -n "$1" ]]; do
    echo "Parameter #$count = $1"
    count=$(( $count + 1 ))
    shift
done
```
Теперь скрипт будет отображать каждый переданный ему параметр отдельно. 
![Снимок экрана от 2022-09-06 23-13-58](https://user-images.githubusercontent.com/108893621/189189103-1f80929b-4164-4534-8659-cc60b7b07bff.png)

5. Создайте коммит `merge: use shift` и отправьте изменения в репозиторий. 
![Снимок экрана от 2022-09-06 23-28-13](https://user-images.githubusercontent.com/108893621/189189212-cab0aac4-55c6-4d12-8f7f-5f77ac27a377.png)

#### Изменим main.
1. Вернитесь в ветку `main`. 
2. Предположим, что кто-то, пока мы работали над веткой `git-merge`, изменил `main`. Для этого
изменим содержимое файла `rebase.sh` на следующее
```bash
#!/bin/bash
# display command line options

count=1
for param in "$@"; do
    echo "\$@ Parameter #$count = $param"
    count=$(( $count + 1 ))
done

echo "====="
```
В этом случае скрипт тоже будет отображать каждый параметр в новой строке. 

3. Отправляем измененную ветку `main` в репозиторий.
![Снимок экрана от 2022-09-06 23-36-02](https://user-images.githubusercontent.com/108893621/189189869-b8ff4057-0154-42e9-b9e1-ec2dd190ccb9.png)

#### Подготовка файла rebase.sh.
1. Предположим, что теперь другой участник нашей команды 
не сделал `git pull`, либо просто хотел ответвиться не от 
последнего коммита в `main`, а от коммита когда мы только создали два файла
`merge.sh` и `rebase.sh` на первом шаге.  
Для этого при помощи команды `git log` найдем хэш коммита `prepare for merge and rebase` 
и выполним `git checkout` на него примерно так:
`git checkout 8baf217e80ef17ff577883fda90f6487f67bbcea` (хэш будет другой).
1. Создадим ветку `git-rebase` основываясь на текущем коммите. 
1. И изменим содержимое файла `rebase.sh` на следующее, тоже починив скрипт, 
но немного в другом стиле
```bash
#!/bin/bash
# display command line options

count=1
for param in "$@"; do
    echo "Parameter: $param"
    count=$(( $count + 1 ))
done

echo "====="
```
4. Отправим эти изменения в ветку `git-rebase`, с комментарием `git-rebase 1`.
5. И сделаем еще один коммит `git-rebase 2` с пушем заменив `echo "Parameter: $param"` 
на `echo "Next parameter: $param"`.

#### Промежуточный итог. 
![Снимок экрана от 2022-09-07 21-31-16](https://user-images.githubusercontent.com/108893621/189190514-e4f63a6f-ce3c-4ddc-9c09-9b0c07bc5fa6.png)

Мы сэмулировали типичную ситуации в разработке кода, когда команда разработчиков 
работала над одним и тем же участком кода, причем кто-то из разработчиков 
предпочитаем делать `merge`, а кто-то `rebase`. Конфилкты с merge обычно решаются достаточно просто, 
а с rebase бывают сложности, поэтому давайте смержим все наработки в `main` и разрешим конфликты. 

Если все было сделано правильно, то на странице `network` в гитхабе, находящейся по адресу 
`https://github.com/ВАШ_ЛОГИН/ВАШ_РЕПОЗИТОРИЙ/network` будет примерно такая схема:
![Снимок экрана от 2022-09-07 21-34-38](https://user-images.githubusercontent.com/108893621/189190614-85c9557a-944d-4651-be85-01e0d74ba14f.png)

#### Merge
Сливаем ветку `git-merge` в main и отправляем изменения в репозиторий, должно получиться без конфликтов:
```bash
$ git merge git-merge
Merge made by the 'recursive' strategy.
 branching/merge.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)
$ git push
#!/bin/bash
Enumerating objects: 1, done.
Counting objects: 100% (1/1), done.
Writing objects: 100% (1/1), 223 bytes | 223.00 KiB/s, done.
Total 1 (delta 0), reused 0 (delta 0), pack-reused 0
```
![Снимок экрана от 2022-09-07 21-41-48](https://user-images.githubusercontent.com/108893621/189190871-1c1c09c0-8e8f-4bf8-876e-905bc65c882b.png)

В результате получаем такую схему:
![Снимок экрана от 2022-09-07 21-42-49](https://user-images.githubusercontent.com/108893621/189190939-1952ed95-e680-4a5a-a97d-9f68b0a3492f.png)


#### Rebase
1. А перед мержем ветки `git-rebase` выполним ее `rebase` на main. Да, мы специально создали
ситуацию с конфликтами, чтобы потренироваться их решать. 
1. Переключаемся на ветку `git-rebase` и выполняем `git rebase -i main`. 
В открывшемся диалоге должно быть два выполненных нами коммита, давайте заодно объединим их в один, 
указав слева от нижнего `fixup`. 
В результате получаем что-то подобное:
```bash
$ git rebase -i main
Auto-merging branching/rebase.sh
CONFLICT (content): Merge conflict in branching/rebase.sh
error: could not apply dc4688f... git 2.3 rebase @ instead *
Resolve all conflicts manually, mark them as resolved with
"git add/rm <conflicted_files>", then run "git rebase --continue".
You can instead skip this commit: run "git rebase --skip".
To abort and get back to the state before "git rebase", run "git rebase --abort".
Could not apply dc4688f... git 2.3 rebase @ instead *
``` 
Если посмотреть содержимое файла `rebase.sh`, то увидим метки, оставленные гитом для решения конфликта:
```bash
cat rebase.sh
#!/bin/bash
# display command line options
count=1
for param in "$@"; do
<<<<<<< HEAD
    echo "\$@ Parameter #$count = $param"
=======
    echo "Parameter: $param"
>>>>>>> dc4688f... git 2.3 rebase @ instead *
    count=$(( $count + 1 ))
done
```
Удалим метки, отдав предпочтение варианту
```bash
echo "\$@ Parameter #$count = $param"
```
сообщим гиту, что конфликт решен `git add rebase.sh` и продолжим ребейз `git rebase --continue`.

И опять в получим конфликт в файле `rebase.sh` при попытке применения нашего второго коммита. 
Давайте разрешим конфликт, оставив строчку `echo "Next parameter: $param"`.

Далее опять сообщаем гиту о том, что конфликт разрешен `git add rebase.sh` и продолжим ребейз `git rebase --continue`.
В результате будет открыт текстовый редактор предлагающий написать комментарий к новому объединенному коммиту:
```
# This is a combination of 2 commits.
# This is the 1st commit message:

Merge branch 'git-merge'

# The commit message #2 will be skipped:

# git 2.3 rebase @ instead * (2)
```
Все строчки начинающиеся на `#` будут проигнорированны. 

После сохранения изменения, гит сообщит
```
Successfully rebased and updated refs/heads/git-rebase
```
![Снимок экрана от 2022-09-07 22-27-29](https://user-images.githubusercontent.com/108893621/189191391-98a93793-a58d-4e0f-91fd-fb6cb6dd86a3.png)

И попробуем выполнить `git push`, либо `git push -u origin git-rebase` чтобы точно указать что и куда мы хотим запушить. 
Эта команда завершится с ошибкой:
```bash
git push
To github.com:andrey-borue/devops-netology.git
 ! [rejected]        git-rebase -> git-rebase (non-fast-forward)
error: failed to push some refs to 'git@github.com:andrey-borue/devops-netology.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```
Это произошло, потому что мы пытаемся перезаписать историю. 
Чтобы гит позволил нам это сделать, давайте добавим флаг `force`:
```bash
git push -u origin git-rebase -f
Enumerating objects: 10, done.
Counting objects: 100% (9/9), done.
Delta compression using up to 12 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 443 bytes | 443.00 KiB/s, done.
Total 4 (delta 1), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (1/1), completed with 1 local object.
To github.com:andrey-borue/devops-netology.git
 + 1829df1...e3b942b git-rebase -> git-rebase (forced update)
Branch 'git-rebase' set up to track remote branch 'git-rebase' from 'origin'.
```
![Снимок экрана от 2022-09-07 22-33-09](https://user-images.githubusercontent.com/108893621/189191717-15242e5e-f876-4d19-bdd7-25c7ee0400d8.png)

Теперь можно смержить ветку `git-rebase` в main без конфликтов и без дополнительного мерж-комита простой перемоткой. 
```
$ git checkout main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.

$ git merge git-rebase
Updating 6158b76..45893d1
Fast-forward
 branching/rebase.sh | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)
 ```
![Снимок экрана от 2022-09-07 22-36-51](https://user-images.githubusercontent.com/108893621/189191871-78b997c2-29e1-4e3e-8b4a-be89c4f02112.png)

https://github.com/YTimashev/devops-netology/network

---


