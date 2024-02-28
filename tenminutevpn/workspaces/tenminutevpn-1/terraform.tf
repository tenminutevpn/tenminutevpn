terraform {
  backend "s3" {
    endpoint = "s3.andreygubarev.cloud"
    region   = "us-east-1"
    bucket   = "tenminutevpn"
    key      = "tenminutevpn-1.tfstate"

    profile = "s3.andreygubarev.cloud"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
