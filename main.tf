resource "yandex_vpc_network" "network" {
  name = "net"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_instance" "vm" {
  count = 2

  name = "nginx-vm-${count.index}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    user-data = <<EOF
#cloud-config
packages:
  - nginx

runcmd:
  - systemctl enable nginx
  - systemctl start nginx
EOF
  }
}

resource "yandex_lb_target_group" "target-group" {
  name = "target-group"

  dynamic "target" {
    for_each = yandex_compute_instance.vm

    content {
      subnet_id = yandex_vpc_subnet.subnet.id
      address   = target.value.network_interface.0.ip_address
    }
  }
}

resource "yandex_lb_network_load_balancer" "lb" {
  name = "network-load-balancer"

  listener {
    name = "http"

    port = 80

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.target-group.id

    healthcheck {
      name = "http"

      http_options {
        port = 80
      }
    }
  }
}