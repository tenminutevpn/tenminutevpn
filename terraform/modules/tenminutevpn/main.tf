resource "digitalocean_custom_image" "this" {
  name         = "tenminutevpn"
  url          = one([for item in data.github_release.this.assets : item if item.name == "debian-12.raw.gz"]).browser_download_url
  distribution = "Debian"
  regions      = [data.digitalocean_region.this.slug]
}
