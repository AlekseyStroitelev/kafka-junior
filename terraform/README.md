# Terraform
---

1. Изменить значения `cloud_id` и `folder_id` в `variables.tf` на соответствующие в вашем `yandex cloud`.

2. Создать сервис-аккаунт в вашем `yandex cloud` и сгенерировать для него `Авторизованный ключ`.

3. Сгенерировать ключи для подключения к серверам по SSH.

4. Проинициализировать terraform `terraform init` и запустить `terraform apply`.

5. После создания инфраструктуры необходимо запустить скрипт `gen_inventory.sh` для генерации файла `inventory.yml` который будет создан в каталоге `ansible`.

6. После генерации инвентаря можно переходить к следующему этапу по развертыванию и настройке кластера с помощью [Ansible](https://github.com/AlekseyStroitelev/kafka-junior/blob/main/ansible/README.md)

---

<p align="center">
  <img src="https://github.com/AlekseyStroitelev/kafka-junior/blob/main/pictures/terraform_logo.png"/>
</p>