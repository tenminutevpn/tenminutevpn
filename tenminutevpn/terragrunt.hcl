inputs = merge(
  yamldecode(file("${get_terragrunt_dir()}/terraform.tfvars.yaml")),
  yamldecode(sops_decrypt_file("${get_terragrunt_dir()}/terraform.tfvars.sops.yaml")),
)
