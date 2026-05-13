resource "yandex_vpc_network" "network" {
  name = "network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_instance_group" "group" {
  name               = "fixed-ig"
  folder_id          = var.folder_id
  service_account_id = "ajec0efhqcvghjkrsga4"

  instance_template {

    platform_id = "standard-v1"

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"

      initialize_params {
        image_id = var.ubuntu_image
      }
    }

    network_interface {
      network_id = yandex_vpc_network.network.id
      subnet_ids = [yandex_vpc_subnet.subnet.id]
      nat        = true
    }

    metadata = {
      user-data = file("${path.module}/metadata.yaml")
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  allocation_policy {
    zones = [var.zone]
  }

  load_balancer {
    target_group_name = "target-group"
  }
}
resource "yandex_lb_network_load_balancer" "lb" {
  name = "network-load-balancer"

  listener {
    name = "listener"
    port = 80

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.group.load_balancer.0.target_group_id

    healthcheck {
      name = "http"

      http_options {
        port = 80
      }
    }
  }
}