# Выполнено ДЗ №3

## Основное ДЗ

- Запускаем агент и добавляем в него свой ключ, подключаемся к удалённой машине через бастион

```bash
ssh-add ~/.ssh/otus2023
ssh -A -J appuser@130.193.48.215 appuser@10.128.0.33

```
- Упрощаем работу, добавляя алиасы для хостов

# Add to ~/.ssh/config
```
### The Bastion Host
Host bastion-yandex
  HostName 130.193.48.215
  User appuser
  IdentityFile ~/.ssh/otus2023
  ForwardAgent yes

### The Remote Host
Host someinternalhost
  HostName 10.128.0.33
  User appuser
  ProxyJump bastion-yandex

```
- Создали и установили Впн сервер для Yandex.Cloud


bastion_IP = 130.193.48.215
someinternalhost_IP = 10.128.0.33

## Дополнительное задание

- Настроен ssl сертификат для панели упраления  Впн сервером.

# Выполнено ДЗ №4 Деплой тестового приложения

## Основное ДЗ

### Данные для подключения к Monolith Reddit

```
testapp_IP = 84.252.131.182
testapp_port = 9292
```

#### Самостоятельная работа
- Скрипт `install_ruby.sh` содержит команды по установке Ruby;
- Скрипт `install_mongodb.sh` содержит команды по установке MongoDB;
- Скрипт `deploy.sh` содержит команды скачивания кода, установки зависимостей через bundler и запуск приложения;
- Скрипт `reddit.sh` содержит команду для автоматического развертывания с использованием cloud-config файла `cloudconfig-metadata.yaml`.

#### Дополнительное задание
Создан cloudconfig для автоматизации деплоя приложения Monolith Reddit при помощи Cloud-init. Пример файла `cloudconfig-metadata.yaml` ниже.

```
#cloud-config
ssh_pwauth: false
users:
  - name: yc-user
    gecos: YandexCloud User
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzbZxD8hTETvFCn51PFT7VcBvUNhUR1bvwZJH/6FNDo4iyncCLWx9hSt8UfhDXv3zsWN5B8lfULsjhiEGG059c4stEQmPA/jrGJudmEWbEs+k66eo1p55QXFBVtd1IvapXW/j22z8t+FUqPxCoHn97LoJiS1q0pSQQxIk5+sCIfMzn/bxrKKnitokbwvO5Qik9tautttL0AVle9zCPFVw4kXzr47hpP1dh2f+rhnGUTIxQ7LZ2hE+Sd0ctP0PfPI7RbBWDQUcv38c+M7xucYH1wBqJSiDUgFbJTJt1RF2BB21MdFhCEc9GHKpW4Wpi0/Q9yHwbiyifwLzddZw+mMcXgXHoHtgUFnZO/cjwb+2qk0uVRZxUi1Qh9/smF8nWImtphJCwiA1G+K7kA/EAZ7pV4dk9InRvBIVNMkOr2M3igZzD8krVhnSQ7Sl/r1pRxc1hmMAs3dp6MjFEeljCcc6ux78iRrlcwdPXNtAEGaL2KaSyBWOTDrrddelM6HO9boM= root@by-otus-msqo1"
package_update: true
package_upgrade: true
packages:
  - git
  - build-essential
  - mongodb
  - ruby-full
  - ruby-bundler

runcmd:
  - systemctl start mongodb
  - systemctl enable mongodb
  - cd /home/yc-user
  - git clone -b monolith https://github.com/express42/reddit.git
  - cd reddit && bundle install
  - puma -d
```

#### ВМ разворачивается в Yandex.Cloud при помощи CLI команды (скрипт `reddit.sh`):

```
yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=otus-network-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --metadata-from-file user-data=cloudconfig-metadata.yaml

```

# Выполнено ДЗ №5

## Основное ДЗ

### В процессе сделано:

    Установлен и настроен Packer
    Создан сервисный аккаунт
    Созданы pkr.hcl & json конфигурационные файлы
    Созданы файлы для переменных
    Добавлены в .gitignore
    Подготовил  шаблоны для создания образов Fry и Bake
    Создал образы и проверил их работу
    Создал скрипт  для создания VM config-scripts/create-reddit-vm.sh

 Созданные образы:
```
> yc compute image list
+----------------------+------------------------+-------------+----------------------+--------+
|          ID          |          NAME          |   FAMILY    |     PRODUCT IDS      | STATUS |
+----------------------+------------------------+-------------+----------------------+--------+
| fd89d1psr2l0rh8rcsi1 | reddit-base-09-03-2023 | reddit-base | f2entqq6l8h6pr5irof0 | READY  |
| fd8cbesgcg5s4i5co53r | reddit-full-09-03-2023 | reddit-full | f2entqq6l8h6pr5irof0 | READY  |
+----------------------+------------------------+-------------+----------------------+--------+
```
# Выполнено ДЗ №6:

## Основное ДЗ

### В процессе сделано:

- Установлен terraform
- Настроено использование токена сервисного аккаунта
- Создан основной файл main.tf и настроен удобный вывод ip виртуальных машин output.tf
- Чувствительные данные вынесены  в файлы переменных
- В .gitignore добавлены исключения


## Дополнительное задание

- Создан lb.tf для балансировщика и группы распределения
- Внесены изменения в основной файл для учёта нескольких виртуальных машин и созданы новые переменные




# Выполнено Домашнее задание №7:

## Основное ДЗ

### В процессе сделано:
    1. Создана ветка terraform-2
    2. Сборка packer разбита на создание образа отдельно для базы данных и отдельно для приложения
    3. Конфигурация terraform также разделена на отдельные файлы.
    4. Изучены аттрибуты ресурсов и их использование
    3. Перенос конфигурации в отдельные модули, создание отдельных окружений для prod и stage
    4. Выполнена проверка доступности по ssh


## Как запустить проект:

``` bash
terraform/prod> terraform apply
terraform/stage> terraform apply
```
## Как проверить работоспособность:

	Например, перейти по ссылке http://158.160.33.208:9292/

## Дополнительное задание

  (*) Настроено хранение файла состояния в s3 bucket
  Инициализация:

  ```bash
  terraform init -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY"
  ```
  Если необходимо перенести файлы в другую папку:

  ```bash
  terraform init -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY" -reconfigure
  ```
(**) Исправлены provisioner, исправлен конфигурационный файл базы данных и приложению передаёться ссылка на базу данных.


# Выполнено Домашнее задание №8:

## Основное ДЗ

### В процессе сделано:
    1. Создана ветка ansible-2
    2. Поднимаем инфраструктуру при помощи  cd terraform/stage; terraform apply
    3. Создаем статический ansible/inventory в формате ini
    4. Проверяем ansible app -i ./inventory -m ping; ansible db -i ./inventory -m ping
    5. Создаем ./ansible.cfg, переносим в него inventory, remote_user, private_key_file. Это позволяет убрать из статического inventory соответствующие поля.
    6. Группируем хосты в inventory, можно использовать групповые комманды ansible app -m ping
    7. Конвертируем inventory в yaml формат, проверяем ansible all -m ping -i inventory.yml
    8. Проверяем работу и сравниваем поведение модулей ansible: command, shell, systemd, service, git
    9. Создаем playbook clone.yml для клонирования git-репозитория
    10. Запускаем ansible-playbook clone.yml и фактически клонирование не происходит, поскольку код уже находиться в указанном месте.
    11. Выполняем ansible app -m command -a 'rm -rf ~/reddit'; ansible-playbook clone.yml которое теперь приводит к клонированию.
    12. Написал output.tf создание динамического инвентори  в  формате yml для ansible


# Выполнено Домашнее задание №9:

## Основное ДЗ

### В процессе сделано:

    Были освоены handlers, templates, tags
    Изучен подход один плейбук, один сценарий.
    Изучен подход один плейбук, много сценариев.
    Изучен подход несколько плейбуков.
    Пересобраны packer образы и на их основе терраформом подняты инстансы.
    На поднятых инстансах плэйбуком, включающим в себя другие, было развёрнута база и приложение.


Как запустить проект:

packer build -var-file=packer/variables.json packer/db.json
packer build -var-file=packer/variables.json packer/app.json
terraform apply
ansible-playbook site.yml

## Дополнительное ДЗ

Инвентори генерируеться средствами terraform из шаблона
Также установлен плагин для генерации динамического инвентори.

cd ansible
mkdir -p plugins/inventory
curl https://raw.githubusercontent.com/st8f/community.general/yc_compute/plugins/inventory/yc_compute.py | \
  sed -e 's/community\.general\.yc_compute/yc_compute/g' > plugins/inventory/yc_compute.py
pip install yandexcloud

```
[defaults]
# inventory = ./inventory_prod.yml
# inventory = ./inventory_stage.yml
# inventory = ./inventory_yc.yml
inventory = inventory_yc.yml
remote_user = appuser
private_key_file = /home/swenum/.ssh/otus2023
host_key_checking = False
retry_files_enabled = False


inventory_plugins=./plugins/inventory

[inventory]
enable_plugins = yc_compute
```
