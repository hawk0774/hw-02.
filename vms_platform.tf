###ssh vars

variable "vm_web_vms_ssh_public_root_key" {
  type        = string
  default     = "*"
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
# db_vm
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "Name of the VM"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
}

variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
}

variable "vpc_name_db" {
  type        = string
  default     = "develop_b"
  description = "VPC network & subnet name"
}

variable "db_cidr" {
  type        = list(string)
  default     = ["10.0.3.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_db_core_fraction" {
  type        = number
  default     = 20
  description = "Core fraction for the VM"
}

variable "vm_db_cores" {
  type        = number
  default     = 2
  description = "Number of cores for the VM"
}

variable "vm_db_memory" {
  type        = number
  default     = 2
  description = "Memory size (in GB) for the VM"
}

variable "vm_db_image" {
  type        = string
  default     = "ubuntu-2004-lts"
}

variable "vm_db_disk" {
  type        = string
  default     = "fd8g8ldvgac83b18nvhq"
}

variable "vm_db_nat" {
  type        = bool
  default     = true
}

variable "vm_db_serial_port_enable" {
  type        = string
  default     = "1"
}

variable "vm_db_ssh_keys" {
  type        = string
  default     = "*"
}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
}
