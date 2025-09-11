# Terraform AWS Infrastructure (lesson-5)

## Структура проєкту

- `main.tf` – підключення всіх модулів
- `backend.tf` – конфігурація бекенду S3 + DynamoDB
- `outputs.tf` – вивід ID ресурсів
- `modules/` – окремі модулі для кожного компонента

## Команди

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```
