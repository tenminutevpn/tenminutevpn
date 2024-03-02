resource "digitalocean_custom_image" "this" {
  name         = "tenminutevpn"
  url          = one([for item in data.github_release.this.assets : item if item.name == "debian-12.raw.gz"]).browser_download_url
  distribution = "Debian"
  regions      = [data.digitalocean_region.this.slug]
}

resource "tls_private_key" "this" {
  algorithm = "ED25519"
}

resource "digitalocean_ssh_key" "this" {
  name       = "tenminutevpn"
  public_key = tls_private_key.this.public_key_openssh
}

resource "digitalocean_droplet" "this" {
  name   = "tenminutevpn"
  image  = digitalocean_custom_image.this.id
  region = data.digitalocean_region.this.slug
  size   = "s-1vcpu-512mb-10gb"
  ssh_keys = [
    digitalocean_ssh_key.this.fingerprint,
  ]
}
