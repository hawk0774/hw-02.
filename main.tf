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
#  name        = var.vm_web_name
  name        = local.vm_web_instance_name
  platform_id = var.vm_web_platform_id

  resources {
    core_fraction = var.vms_resources.web.core_fraction
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
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

  metadata = var.vms_metadata
}
#  metadata = {
#    "serial-port-enable" = var.vm_web_serial_port_enable
#    "ssh-keys"           = var.vm_web_vms_ssh_public_root_key
#  }
#}
 
#db
resource "yandex_vpc_subnet" "develop_b" {
  name           = var.vpc_name_db
  zone           = var.vm_db_zone
  network_id     = yandex_vpc_network.develop.id  
  v4_cidr_blocks = var.db_cidr               
}

resource "yandex_compute_instance" "platform_db" {
 # name        = var.vm_db_name
  name        = local.vm_db_instance_name
  platform_id = var.vm_db_platform_id
  zone        = var.vm_db_zone

  resources {
    core_fraction = var.vms_resources.db.core_fraction
    cores         = var.vms_resources.db.cores
    memory        = var.vms_resources.db.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_db_disk
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_b.id
    nat       = var.vm_db_nat
  }

  #metadata = {
  #  "serial-port-enable" = var.vm_web_serial_port_enable
  #  "ssh-keys"           = var.vm_web_vms_ssh_public_root_key
  #}

  metadata = var.vms_metadata

  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
}
