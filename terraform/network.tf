#VPC
resource "yandex_vpc_network" "kafka" {
  name = var.vpc_name
}

#Subnets
resource "yandex_vpc_subnet" "kafka-subnet" {
  name           = "kafka-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.kafka.id
  v4_cidr_blocks = ["10.45.1.0/24"]
}
