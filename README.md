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
