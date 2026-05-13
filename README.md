\# Домашнее задание «Отказоустойчивость в облаке»



\## Terraform Playbook



Использованы файлы:

\- provider.tf

\- variables.tf

\- main.tf

\- outputs.tf



\## Скриншоты



\### Балансировщик и целевая группа

<img width="3837" height="1252" alt="Снимок экрана 2026-05-08 203657" src="https://github.com/user-attachments/assets/ffebc2f6-21ff-470c-a1fe-1c1f8e811623" />

<img width="2645" height="2042" alt="груп" src="https://github.com/user-attachments/assets/76a0dac1-e838-4d02-80ce-80405c72ced9" />



\### Страница nginx

<img width="3832" height="2035" alt="nginx-page" src="https://github.com/user-attachments/assets/8eccae8b-2770-4d4f-a593-7c681cb3dc99" />

---

# Задание 2* (со звёздочкой)

## Terraform Playbook

Использованы файлы:

- task2-star/main.tf
- task2-star/provider.tf
- task2-star/variables.tf
- task2-star/outputs.tf
- task2-star/metadata.yaml

## Что было реализовано

- Instance Group
- Load Balancer
- Health Check
- Автоматическая установка nginx через cloud-init (metadata.yaml)

## Скриншоты

### Балансировщик Active

![img](task2-star/lb-active.png)

### Target Group Healthy

![img](task2-star/healthy.png)

### Nginx через балансировщик

![img](task2-star/nginx.png)



