###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "<your_ssh_ed25519_key>"
  description = "ssh-keygen -t ed25519"
}


###yandex_compute_image

variable "vm_web_image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "name web image"
}

###yandex_compute_instance
variable "vm_web_instance" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "name web instance"
}


variable "vm_web_platform" {
  type        = string
  default     = "standard-v1"
  description = "yandex platform id"
}

variable "vm_web_cores" {
  type    = number
  default = 2
}

variable "vm_web_memory" {
  type    = number
  default = 1
}

variable "vm_web_core_fraction" {
  type    = number
  default = 5
}


variable "vm_serial-port-enable" {
  type    = number
  default = 1
}


variable "vm_web_resources" {
  description = "объединение переменных блока resources"
  type        = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
}

/*
variable "metadata" {
  description = "объединение переменных блока metadata"
  type        = map(string)
  default = {
    vm_serial-port-enable = 1
    vms_ssh_root_key      = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKWZ5haQeaI7k+wV4Q11BPmemh7n7SR4SlIsz3QmDc0g tim@tim"
  }
}
*/
