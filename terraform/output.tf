# Выводим IP-адреса созданных машин, чтобы потом использовать их в Ansible
output "instance_ips" {
  value = yandex_compute_instance.kafka[*].network_interface.0.nat_ip_address
}

# Выводим IP адрес AKHQ
output "akhq_ip" {
  value = yandex_compute_instance.akhq[0].network_interface.0.nat_ip_address
}
