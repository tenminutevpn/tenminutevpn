build {
  sources = ["source.qemu.image"]

  provisioner "shell" {
    execute_command = "{{ .Vars }} sudo -E bash '{{ .Path }}'"
    inline          = ["sudo apt update", "sudo apt install python3"]
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
