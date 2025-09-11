# CI/CD для Django-застосунку з використанням Terraform, Jenkins, Argo CD та ECR

## Як застосувати Terraform

```bash
cd lesson-8-9
terraform init
terraform apply
```

Terraform створює повну інфраструктуру в AWS:

- VPC, підмережі, Internet Gateway
- EKS кластер
- ECR репозиторій
- Jenkins та Argo CD, встановлені через Helm

Після завершення `terraform apply` виконайте:

```bash
terraform output
```

Це дозволить отримати:

- URL Jenkins
- URL Argo CD
- Паролі до облікових записів

---

## Як перевірити Jenkins job

1. Отримайте URL Jenkins:

```bash
terraform output jenkins_url
```

2. Зробіть порт-форвардинг або перейдіть за LoadBalancer URL:

```bash
kubectl port-forward svc/jenkins -n jenkins 8080:8080
```

Перейдіть в браузері на [http://localhost:8080](http://localhost:8080)

3. Отримайте admin-пароль Jenkins:

```bash
kubectl get secret jenkins -n jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
```

4. Створіть нову pipeline job і вкажіть шлях до `Jenkinsfile`, який має бути у вашому Django-репозиторії

5. При запуску pipeline виконається:

   - Збірка Docker-образу за допомогою **Kaniko**
   - Push у **Amazon ECR**
   - Оновлення `charts/django-app/values.yaml` (з новим тегом)
   - Git push змін у репозиторій Helm

---

## Як побачити результат в Argo CD

1. Отримайте URL Argo CD:

```bash
terraform output argocd_url
```

2. Зробіть порт-форвардинг (якщо потрібен):

```bash
kubectl port-forward svc/argo-cd-argocd-server -n argocd 8081:443
```

Перейдіть в браузері на [https://localhost:8081](https://localhost:8081)

3. Отримайте логін/пароль:

```bash
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
```

Логін: `admin`

4. Після входу ви побачите application `django-app`, створене на основі Helm chart. Argo CD автоматично відслідковує зміни в Git та оновлює кластер.

---

## Схема CI/CD

```text
Developer Push (Jenkinsfile + Dockerfile)
           ↓
      Jenkins (Pipeline)
           ↓
     Build Docker Image (Kaniko)
           ↓
      Push to ECR
           ↓
Update Helm values.yaml + Git Push
           ↓
      Argo CD Git Watcher
           ↓
    Auto-sync to EKS via Helm chart
```

---

Проєкт відповідає вимогам повноцінного GitOps-підходу: автоматичне створення інфраструктури, CI/CD pipeline, та розгортання без ручного втручання.
