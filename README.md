1. Скопировать private.auto.tfvars в корень репозитория
2. Создать с помощью terraform инфраструктуру
    terraform init
    terraform apply
3. Установить wordpress на сервера
    cd ./ansible/
    ansible-playbook provision.yml
