###yandex_compute_image

variable "vm_db_image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "name web image"
}

###yandex_compute_instance
variable "vm_db_instance" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "name web instance"
}


variable "vm_db_platform" {
  type        = string
  default     = "standard-v1"
  description = "yandex platform id"
}

variable "vm_db_cores" {
  type    = number
  default = 2
}

variable "vm_db_memory" {
  type    = number
  default = 2
}

variable "vm_db_core_fraction" {
  type    = number
  default = 20
}

variable "vm_db_resources" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}

