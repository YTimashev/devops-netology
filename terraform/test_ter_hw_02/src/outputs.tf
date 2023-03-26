output "external_ip_address_web" {
  value       = yandex_compute_instance.platform.network_interface.0.nat_ip_address
  description = "vm external ip"
}

output "external_ip_address_db" {
  value       = yandex_compute_instance.platform2.network_interface.0.nat_ip_address
  description = "vm external ip"
}
