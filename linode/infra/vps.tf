terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
  required_version = "~>1.4.0"
}

# Root from GoDaddy
resource "linode_domain" "puttehi_eu" {
  type      = "master"
  domain    = "puttehi.eu"
  soa_email = "zittingpetteri@gmail.com"
}

# www.puttehi.eu -> puttehi.eu
resource "linode_domain_record" "www" {
  domain_id   = linode_domain.puttehi_eu.id
  name        = "www"
  record_type = "CNAME"
  target      = linode_domain.puttehi_eu.domain
}

# vps.puttehi.eu -> vps
resource "linode_domain_record" "vps" {
  domain_id   = linode_domain.puttehi_eu.id
  name        = "vps"
  record_type = "A"
  target      = linode_instance.vps.ip_address
}

# Get user profile according to token
data "linode_profile" "me" {}

# VM
resource "linode_instance" "vps" {
  label            = "vps"
  image            = "linode/debian11"
  region           = "eu-central"
  type             = "g6-nanode-1"
  authorized_users = [data.linode_profile.me.username]

  group = "personal"
  tags  = ["personal", "vps", "nanode"]
}
