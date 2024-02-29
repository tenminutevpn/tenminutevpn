source "qemu" "bookworm" {
  # accelerator      = "kvm"
  boot_command     = []
  disk_compression = true
  disk_interface   = "virtio"
  disk_image       = true
  disk_size        = var.disk_size
  format           = var.format
  headless         = var.headless
  iso_checksum     = var.iso_checksum
  iso_url          = var.iso_url
  net_device       = "virtio-net"
  output_directory = "dist/${var.name}${var.version}.${var.format}"
  qemuargs = [
    ["-m", "${var.ram}M"],
    ["-smp", "${var.cpu}"],
    ["-cdrom", "boot/cidata.iso"],
    ["-bios", "boot/uefi/edk2-x86_64.fd"],
  ]

  shutdown_command       = "echo '${var.ssh_password}' | sudo -S shutdown -P now"

  communicator           = "ssh"
  ssh_username           = var.ssh_username
  ssh_private_key_file   = var.ssh_private_key
  ssh_timeout            = "10m"
}
