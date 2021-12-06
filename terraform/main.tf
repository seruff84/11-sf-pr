terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}

resource "yandex_compute_instance" "vm" {
  for_each        = var.vms
  name            = "${each.value.hostname}-${each.value.role}"

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores         = each.value.vm_cores
    memory        = each.value.vm_memory
    core_fraction = 20
  }
  labels = {
    ansible-group = each.value.role
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image[each.key].id
      size     = each.value.vm_disk
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  metadata = {
    user-data   = templatefile("userdata.tpl", {
      ssh_key_user    = var.ssh_pub_user
      ssh_key_ansible = var.ssh_pub_ansible
    })
  }
  connection {
    host        = self.network_interface[0].nat_ip_address
    type        = "ssh"
    user        = "seruff"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
  inline = ["sudo hostnamectl set-hostname ${each.value.hostname}-${each.value.role}"]
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

