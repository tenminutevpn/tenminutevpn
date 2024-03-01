build {
  sources = ["source.qemu.image"]

  provisioner "ansible" {
    playbook_file = "${path.root}/ansible/playbook.yaml"
    user = "root"
  }

  post-processor "compress" {
    compression_level = 9
    output = "${var.image_output}/${local.name}.gz"
  }

  post-processor "checksum" {
    checksum_types = [ "sha512" ]
    output = "${var.image_output}/SHA512SUMS"
  }
}
