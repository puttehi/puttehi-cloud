terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      # no version lock
    }
  }
  required_version = "~>1.4.0"
}

# Configure the Linode Provider
provider "linode" {
  # token is read from LINODE_TOKEN env var
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

