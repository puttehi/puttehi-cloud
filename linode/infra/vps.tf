terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
  required_version = "~>1.4.0"
}

provider "linode" {
  # token = ... #env: LINODE_TOKEN
}

# Root from GoDaddy
resource "linode_domain" "puttehi_eu" {
  type      = "master"
  domain    = "puttehi.eu"
  soa_email = "zittingpetteri@gmail.com"
}

# puttehi.eu -> instance
resource "linode_domain_record" "root_to_instance" {
  domain_id   = linode_domain.puttehi_eu.id
  name        = linode_domain.puttehi_eu.domain # Used as "@" in web GUI
  record_type = "A"
  target      = linode_instance.vps.ip_address
  ttl_sec     = 300
}

# *.puttehi.eu -> puttehi.eu
# www. (public)
# vps. (private)
# anything-new. (...)
resource "linode_domain_record" "wildcard_to_root" {
  domain_id   = linode_domain.puttehi_eu.id
  name        = "*"
  record_type = "CNAME"
  target      = linode_domain.puttehi_eu.domain
  ttl_sec     = 300
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
