# Інфраструктурне Розгортання Застосунку

## Мета

У цьому завданні потрібно:

1. Перевірити готовність компонентів інфраструктури.
2. Зібрати та перевірити Terraform-модулі.
3. Провести розгортання за допомогою `terraform apply`.
4. Перевірити доступність сервісів через порт-форвардинг.
5. Продемонструвати CI/CD за допомогою Jenkins та Argo CD.
6. Налаштувати моніторинг з використанням Grafana та Prometheus.

---

## Підготовка

Більшість компонентів вже були створені в попередніх завданнях, включаючи `main.tf`. Для зручності та дотримання принципів розділення обов’язків, застосунок винесено в окремий репозиторій:

---

## Кроки розгортання

### 1. Ініціалізація S3 backend

- Закоментуйте `backend.tf` і зайві модулі в `main.tf`.
- Запустіть:

```bash
terraform init
terraform apply
```

### 2. Основне розгортання

- Розкоментуйте всі модулі.
- Запустіть повторну ініціалізацію:

```bash
terraform init -reconfigure
terraform apply
```

### 3. Налаштування `kubectl`

```bash
aws eks --region eu-central-1 update-kubeconfig --name eks-cluster-demo
```

---

## CI/CD

- У Jenkins запустіть `seed-job`.
- Після цього застосунок завантажиться в ECR.
- Argo CD підхопить зміни та задеплоїть їх в кластер.

---

## Моніторинг

### Встановлення Prometheus:

```bash
helm install prometheus prometheus-community/prometheus --namespace monitoring
```

Перегляд Prometheus:

```bash
export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace monitoring port-forward $POD_NAME 9090
```

### Встановлення Grafana:

```bash
helm install grafana grafana/grafana --namespace monitoring --create-namespace --set adminPassword=admin123
```

Перегляд Grafana:

```bash
export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace monitoring port-forward $POD_NAME 3000
```

---

## Доступ до сервісів (порт-форвардинг)

```bash
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
kubectl port-forward svc/argocd-server 8081:443 -n argocd
kubectl port-forward svc/grafana 3000:80 -n monitoring
```
