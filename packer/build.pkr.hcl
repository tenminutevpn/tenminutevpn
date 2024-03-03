build {
  sources = ["source.qemu.image"]

  provisioner "ansible" {
    playbook_file = "${path.root}/../ansible/playbook.yaml"
    galaxy_file   = "${path.root}/../ansible/requirements.yaml"
    roles_path    = "${path.root}/../ansible/roles/"

    user = "root"
  }

  provisioner "shell" {
    inline = [
      "cloud-init clean --logs --seed",
    ]
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
