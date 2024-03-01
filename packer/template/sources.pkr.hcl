source "qemu" "image" {
  vm_name      = local.name
  iso_url      = var.image_url
  iso_checksum = var.image_checksum
  format       = var.image_format

  accelerator = var.qemu_accelerator
  headless    = var.qemu_headless
  net_device  = var.qemu_network
  qemuargs = [
    ["-m", "${var.vm_memory}M"],
    ["-smp", "${var.vm_cpus}"],
    ["-cdrom", "${var.vm_cloudinit}"],
    ["-bios", "${path.root}files/edk2-x86_64.fd"],
  ]

  disk_compression = true
  disk_interface   = "virtio"
  disk_image       = true
  disk_size        = var.vm_disk

  boot_command     = []
  shutdown_command = "shutdown -P now"

  communicator         = "ssh"
  ssh_username         = var.ssh_username
  ssh_private_key_file = var.ssh_private_key
  ssh_timeout          = "10m"

  output_directory = var.image_output
}
