build {
  sources = ["source.qemu.image"]

  provisioner "ansible" {
    playbook_file = "${path.root}/provisioner/playbook.yaml"
    galaxy_file   = "${path.root}/provisioner/requirements.yaml"
    roles_path    = "${path.root}/provisioner/roles/"

    user = "root"
  }

  post-processor "compress" {
    compression_level = 6
    output            = "${var.image_output}/${local.name}.gz"
  }

  post-processor "checksum" {
    checksum_types = ["sha512"]
    output         = "${var.image_output}/SHA512SUMS"
  }
}
