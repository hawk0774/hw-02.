# «Основы Terraform. Yandex Cloud»

### Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git. Убедитесь что ваша версия Terraform ~>1.8.4

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Создайте сервисный аккаунт и ключ. service_account_key_file.
3. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную vms_ssh_public_root_key.
4. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
5. Подключитесь к консоли ВМ через ssh и выполните команду  curl ifconfig.me. Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: "ssh ubuntu@vm_ip_address". Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: eval $(ssh-agent) && ssh-add Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;
6. Ответьте, как в процессе обучения могут пригодиться параметры preemptible = true и core_fraction=5 в параметрах ВМ.


В качестве решения приложите:

* скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
* скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
* ответы на вопросы.

## Решение

![alt text](https://raw.githubusercontent.com/hawk0774/hw-02./main/Screenshot_15.png)

В результате проверки кода в блоке "yandex_compute_instance" найдены следующие ошибки и исправлены:

* В строке platform_id = "standart-v4" правильно писать standard
* Версии v4 нет, могут быть только v1, v2 и v3.
* Cores 1 не может быть, так как минимальное количество виртуальных ядер процессора для всех платформ равно двум (согласно документации).

Параметры preemptible = true - это ,так называемая, прерываемая ВМ, т.е. работает не более 24 часов и может быть остановлена Compute Cloud. Параметр core_fraction = 5 - указывает базовую производительность ядра в процентах. Все эти параметры помогают экономить ресурсы.

![alt text](https://raw.githubusercontent.com/hawk0774/hw-02./main/Screenshot_1.png)

![alt text](https://raw.githubusercontent.com/hawk0774/hw-02./main/Screenshot_2.png)

![alt text](https://raw.githubusercontent.com/hawk0774/hw-02./main/Screenshot_3.png)

### Задание 2

1. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
3. Проверьте terraform plan. Изменений быть не должно. 

* main.tf
   ```
   resource "yandex_vpc_network" "develop" {
    name = var.vpc_name
   }
   resource "yandex_vpc_subnet" "develop" {
    name           = var.vpc_name
    zone           = var.default_zone
    network_id     = yandex_vpc_network.develop.id
    v4_cidr_blocks = var.default_cidr
   }


   data "yandex_compute_image" "ubuntu" {
     family = var.vm_web_image
   }

   resource "yandex_compute_instance" "platform" {
     name        = var.vm_web_name
     platform_id = var.vm_web_platform_id
     resources {
       core_fraction = var.vm_web_core_fraction
       cores         = var.vm_web_cores
       memory        = var.vm_web_memory
   }

   boot_disk {
    initialize_params {
      image_id = var.vm_web_disk
    }
   }

   scheduling_policy {
     preemptible = var.vm_web_preemptible
   }

   network_interface {
     subnet_id = yandex_vpc_subnet.develop.id
     nat       = var.vm_web_nat
   }

   metadata = {
    "serial-port-enable" = var.vm_web_serial_port_enable
    "ssh-keys"           = var.vm_web_vms_ssh_public_root_key
   }
  }
*variables.tf   
```
###cloud vars
variable "cloud_id" {
  type        = string
  default     = ""
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = ""
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = ""
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vm_web_vms_ssh_public_root_key" {
  type        = string
  default     = ""
  description = "ssh-keygen -t ed25519"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Name of the VM"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Platform ID for the VM"
}

variable "vm_web_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Zone where the VM will be created"
}

variable "vm_web_core_fraction" {
  type        = number
  default     = 5
  description = "Core fraction for the VM"
}

variable "vm_web_cores" {
  type        = number
  default     = 2
  description = "Number of cores for the VM"
}

variable "vm_web_memory" {
  type        = number
  default     = 1
  description = "Memory size (in GB) for the VM"
}

variable "vm_web_image" {
  type        = string
  default     = "ubuntu-2004-lts"
}

variable "vm_web_disk" {
  type        = string
  default     = "fd8g8ldvgac83b18nvhq"
  description = "Type of the boot disk"
}

variable "vm_web_nat" {
  type        = bool
  default     = true
  description = "Enable NAT for the VM"
}

variable "vm_web_serial_port_enable" {
  type        = string
  default     = "1"
  description = "Enable serial port for the VM"
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "Enable preemptible flag for the VM"
}
 ```
![alt text](https://raw.githubusercontent.com/hawk0774/hw-02./main/Screenshot_4.png)

### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  ```cores  = 2, memory = 2, core_fraction = 20```. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').  ВМ должна работать в зоне "ru-central1-b"
3. Примените изменения.

* ДЗ продолжил делать на след день, поэтому ip первой тачки отличается, для того чтобы запустить вторую ВМ в другой зоне доступности, ножно создать для нее отдельную подсеть соответственно.

### Задание 4

1. Объявите в файле outputs.tf **один** output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.


### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.
2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
3. Примените изменения.


### Задание 6

1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в единую map-переменную **vms_resources** и  внутри неё конфиги обеих ВМ в виде вложенного map(object).  
   ```
   пример из terraform.tfvars:
   vms_resources = {
     web={
       cores=2
       memory=2
       core_fraction=5
       hdd_size=10
       hdd_type="network-hdd"
       ...
     },
     db= {
       cores=2
       memory=4
       core_fraction=20
       hdd_size=10
       hdd_type="network-ssd"
       ...
     }
   }
   ```
3. Создайте и используйте отдельную map(object) переменную для блока metadata, она должна быть общая для всех ваших ВМ.
   ```
   пример из terraform.tfvars:
   metadata = {
     serial-port-enable = 1
     ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
   }
   ```  
  
5. Найдите и закоментируйте все, более не используемые переменные проекта.
6. Проверьте terraform plan. Изменений быть не должно.

------
