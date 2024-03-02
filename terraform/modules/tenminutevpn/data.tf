data "digitalocean_region" "this" {
  slug = "fra1"
}

data "github_release" "this" {
  owner      = "10minutevpn"
  repository = "10minutevpn"

  retrieve_by = "tag"
  release_tag = "v0.1.0rc0"
}
