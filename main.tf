terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.5.0"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "2.21.0"
    }
  }

  backend "gcs" {
    bucket = "rmb-lab-tf_hashicorp_vault_apps"
  }
}

locals {
  secret_mount_path = "secret"
  consul_mount_path = "consul"
}
