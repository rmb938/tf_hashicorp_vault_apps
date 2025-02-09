provider "vault" {
  address = "https://hl-us-homelab1-hashi-vault-1.tailnet-047c.ts.net:8200"
}

provider "consul" {
  scheme  = "https"
  address = "hl-us-homelab1-hashi-consul-1.tailnet-047c.ts.net:8501"
}
