My Projekt

В каталоге terraform проигнорированны файлы (terraform/.gitignore):
-Локальные директории .terraform
**/.terraform/*

-Файлы .tfstate
*.tfstate
*.tfstate.*

-Файлы журнала сбоев
crash.log
crash.*.log

-Файлы .tfvars
*.tfvars
*.tfvars.json

-Файлы override (переопределения)
override.tf
override.tf.json
*_override.tf
*_override.tf.json

-Файлы конфигурации
.terraformrc
terraform.rc
