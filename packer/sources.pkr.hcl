source "qemu" "image" {
  vm_name      = local.name
  iso_url      = var.image_url
  iso_checksum = var.image_checksum
  format       = var.image_format

  qemu_binary  = var.qemu_binary
  machine_type = var.qemu_machine
  accelerator  = var.qemu_accelerator
  firmware     = "${path.root}/efi/edk2-${var.image_arch}.fd"
  headless     = var.qemu_headless
  net_device   = var.qemu_network
  memory       = var.vm_memory
  cpus         = var.vm_cpus
  cpu_model    = var.vm_cpu_model

  cd_content = {
    "meta-data" = templatefile("${path.root}/cloud-init/meta-data", {
      instance_id    = var.image_name,
      local_hostname = var.image_name,
    })
    "user-data" = templatefile("${path.root}/cloud-init/user-data", {
      ssh_username   = var.ssh_username,
      ssh_public_key = file(var.ssh_public_key),
    })
  }
  cd_label = "cidata"

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

  iso_target_path  = "${var.image_cache}/${local.name}"
  output_directory = var.image_output
}
