provider "vault" {
  address = "https://hashi-vault-1.us-homelab1.hl.rmb938.me:8200"
}

provider "consul" {
  scheme  = "https"
  address = "hashi-consul-1.us-homelab1.hl.rmb938.me:8501"
}
