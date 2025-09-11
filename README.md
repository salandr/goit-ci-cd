## Створення DB Subnet Group, Security Group, Parameter Group

Так як DB Subnet Group, Security Group однакові що для звичайної rds, що для аврори, то вони створюються у `shared.tf`. Parameter Group створюється окремо для кожного типу бд у `rds.tf` та `aurora.tf`.

## Приклад використання модуля (module "rds" { ... });

```
module "rds" {
  source = "./modules/rds"
  ...
  name                       = "myapp-db"
  use_aurora                 = true
  aurora_instance_count      = 2
  ...
}
```

## Опис усіх змінних із поясненням

### Основні параметри для створення БД

    name — назва інстансу (або кластера, якщо Aurora);

    engine — тип БД: postgres, mysql, aurora, aurora-mysql, aurora-postgresql;

    engine_version — версія БД;

    instance_class — клас EC2-подібного інстансу (наприклад, db.t3.micro);

    allocated_storage — обсяг у ГБ, якщо це звичайна RDS.

    engine_cluster — тип бази даних, яку буде запускати Aurora. У нашому випадку це aurora-postgresql, тобто Aurora із сумісністю з PostgreSQL. Можна також використати aurora-mysql, якщо потрібно створити кластер на базі MySQL.

    engine_version_cluster — конкретна версія бази даних, яку запускатиме Aurora-кластер. Наприклад, "15.3" означає, що буде розгорнута Aurora PostgreSQL, сумісна з PostgreSQL 15.3. Важливо використовувати лише ті версії, які офіційно підтримуються Aurora (вони відстають від оригінальних релізів PostgreSQL).

    parameter_group_family_aurora — «родина» параметрів для Aurora. Вона має точно відповідати вибраній версії engine. Наприклад, для aurora-postgresql із версією 15.3 потрібно вказати aurora-postgresql15. Це визначає набір доступних параметрів, які можна налаштувати в parameter group.

### Безпека та мережа

    subnet_public_ids — список публічних сабнетів (через модуль vpc);

    vpc_id — вибір мережі (через модуль vpc);

    publicly_accessible — false означає, що БД доступна лише з приватної мережі;

    multi_az — створення резервної репліки в іншій AZ для відмовостійкості.

### Parameter Group

    parameter_group_family — група параметрів, що сумісна з engine / version;

    parameters — словник довільних параметрів, які підуть у parameter_group.

### Архітектурні опції

    use_aurora — якщо true, створюється кластер Aurora (не RDS instance).

## Опис того, як змінити тип БД, engine, клас інстансу тощо

use_aurora - змінити тип БД (true - аврора, false - звичайна rds)

instance_class — клас EC2-подібного інстансу (наприклад, db.t3.micro);

Для звичайної rds:

engine та engine_version - postgres, mysql, aurora, aurora-mysql, aurora-postgresql;

Для аврори:

engine_cluster та engine_version_cluster — тип бази даних, яку буде запускати Aurora. У нашому випадку це aurora-postgresql, тобто Aurora із сумісністю з PostgreSQL. Можна також використати aurora-mysql, якщо потрібно створити кластер на базі MySQL. Плюс версія.
