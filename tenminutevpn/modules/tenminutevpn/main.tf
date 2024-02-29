resource "digitalocean_custom_image" "this" {
  name    = "debian-bookworm"
  url     = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.raw"
  distribution = "Debian"
  regions = [data.digitalocean_region.this.slug]
}
