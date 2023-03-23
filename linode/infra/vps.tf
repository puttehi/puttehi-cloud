terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      # no version lock
    }
    /* godaddy = {
      source = "n3integration/godaddy"
    } */
  }
  required_version = "~>1.4.0"
}

/* # Configure the Linode Provider
provider "linode" {
  # token is read from LINODE_TOKEN env var
} */

/* provider "godaddy" {
  # token is read from GODADDY_API_KEY, GODADY_API_SECRET env vars or asked if not given

} */

/* resource "godaddy_domain_record" "puttehi_eu" {
  // must exist (buy) -> terraform import
  domain = "puttehi.eu"

  // required if provider key does not belong to customer
  # customer = "1234"

  record {
    data     = "@"
    name     = "www"
    port     = 0
    priority = 0
    ttl      = 3600
    type     = "CNAME"
    weight   = 0
  }
  record {
    data     = "Parked"
    name     = "@"
    port     = 0
    priority = 0
    ttl      = 600
    type     = "A"
    weight   = 0
  }
  record {
    data     = "_domainconnect.gd.domaincontrol.com"
    name     = "_domainconnect"
    port     = 0
    priority = 0
    ttl      = 3600
    type     = "CNAME"
    weight   = 0
  }

  // specify any A records associated with the domain
  //addresses = ["192.168.1.2", "192.168.1.3"]

  // specify any custom nameservers for your domain
  // note: godaddy now requires that the 'custom' nameservers are first supplied through the ui
  nameservers = [
    "ns33.domaincontrol.com",
    "ns34.domaincontrol.com",
    "ns1.linode.com",
    "ns2.linode.com",
    "ns3.linode.com",
    "ns4.linode.com",
    "ns5.linode.com"
  ]
} */

resource "linode_domain" "puttehi_eu" {
  type      = "master"
  domain    = "puttehi.eu"
  soa_email = "zittingpetteri@gmail.com"
}

resource "linode_domain_record" "www" {
  domain_id   = linode_domain.puttehi_eu.id
  name        = "www"
  record_type = "CNAME"
  target      = "puttehi.eu"
}

resource "linode_domain_record" "vps" {
  domain_id   = linode_domain.puttehi_eu.id
  name        = "vps"
  record_type = "A"
  target      = linode_instance.vps.ip_address
}

# Create a Linode
resource "linode_instance" "vps" {
  backups_enabled   = false
  boot_config_label = "My Debian 10 Disk Profile"
  booted            = true
  label             = "vps"
  private_ip        = false
  region            = "eu-central"
  shared_ipv4       = []
  tags = [
    "personal",
  ]
  type             = "g6-nanode-1"
  watchdog_enabled = true

  alerts {
    cpu            = 90
    io             = 10000
    network_in     = 10
    network_out    = 10
    transfer_quota = 80
  }

  config {
    kernel       = "linode/grub2"
    label        = "My Debian 10 Disk Profile"
    memory_limit = 0
    root_device  = "/dev/sda"
    run_level    = "default"
    virt_mode    = "paravirt"

    devices {
      sda {
        disk_id    = 63317991
        disk_label = "Debian 10 Disk"
        volume_id  = 0
      }
      sdb {
        disk_id    = 63317992
        disk_label = "512 MB Swap Image"
        volume_id  = 0
      }
    }

    helpers {
      devtmpfs_automount = true
      distro             = true
      modules_dep        = true
      network            = true
      updatedb_disabled  = true
    }
  }

  disk {
    authorized_keys  = []
    authorized_users = []
    filesystem       = "ext4"
    label            = "Debian 10 Disk"
    read_only        = false
    size             = 25088
    stackscript_data = {}
    stackscript_id   = 0
  }
  disk {
    authorized_keys  = []
    authorized_users = []
    filesystem       = "swap"
    label            = "512 MB Swap Image"
    read_only        = false
    size             = 512
    stackscript_data = {}
    stackscript_id   = 0
  }

  timeouts {}
}

