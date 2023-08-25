# Выполнено ДЗ №4 Деплой тестового приложения


## Выполнено:

 - [x] Основное ДЗ
 - [x] Задание со *

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