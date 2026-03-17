#AKHQ server
resource "yandex_compute_instance" "akhq" {
  count    = var.akhq_resources.akhq.count
  name     = "akhq-server-${count.index + 1}"
  hostname = "akhq-server-${count.index + 1}"
  resources {
    cores         = var.akhq_resources.akhq.core
    memory        = var.akhq_resources.akhq.memory
    core_fraction = var.akhq_resources.akhq.fraction
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
    role    = "akhq-server"
    service = "kafka-ui"
  }
}
