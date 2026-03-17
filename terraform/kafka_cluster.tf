#Kafka servers
resource "yandex_compute_instance" "kafka" {
  count    = var.kafka_resources.kafka.count
  name     = "kafka-server-${count.index + 1}"
  hostname = "kafka-server-${count.index + 1}"
  resources {
    cores         = var.kafka_resources.kafka.core
    memory        = var.kafka_resources.kafka.memory
    core_fraction = var.kafka_resources.kafka.fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.kafka-subnet.id
    nat        = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("./id_rsa.pub")}"
  }

  labels = {
    role = "kafka-server"
  }
}

#Data
data "yandex_compute_image" "ubuntu" {
  family = var.family
}
