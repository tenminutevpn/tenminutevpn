### Image ####################################################################
variable "image_name" {
  type    = string
  default = "tenminutevpn"
}

variable "image_arch" {
  type = string
}

variable "image_url" {
  type = string
}

variable "image_checksum" {
  type = string
}

variable "image_format" {
  type    = string
  default = "raw"
}

variable "image_output" {
  type = string
}

variable "image_cache" {
  type = string
}

### QEMU #####################################################################
variable "qemu_accelerator" {
  type    = string
  default = "tcg"
}

variable "qemu_headless" {
  type    = string
  default = "true"
}

variable "qemu_network" {
  type    = string
  default = "virtio-net"
}

variable "qemu_machine" {
  type = string
}

### VM #######################################################################

variable "vm_cpus" {
  type    = string
  default = "2"
}

variable "vm_memory" {
  type    = string
  default = "2048"
}

variable "vm_disk" {
  type    = string
  default = "4096"
}

### SSH ######################################################################

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "ssh_private_key" {
  type = string
}

variable "ssh_public_key" {
  type = string
}
