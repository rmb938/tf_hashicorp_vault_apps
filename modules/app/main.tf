terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
    }
    consul = {
      source = "hashicorp/consul"
    }
  }
}

resource "vault_policy" "policy" {
  name = var.name

  policy = <<EOT
# DEFAULT
path "${var.secret_mount_path}/consul/encrypt_key" {
  capabilities = ["read"]
}

# APP SPECIFIC
path "${var.local.consul_mount_path}/creds/${var.name}" {
  capabilities = ["read"]
}

path "${var.secret_mount_path}/${var.name}/*" {
  capabilities = ["read", "list"]
}

# APP EXTRA
${var.vault_policy_extra}
EOT
}

resource "consul_acl_policy" "policy" {
  name  = var.name
  rules = <<-RULE
# DEFAULT
# Allow listing all kvs
key_prefix "" {
  policy = "list"
}
# Allow reading all kvs
key_prefix "" {
  policy = "read"
}
# Allow reading all nodes
node_prefix "" {
  policy = "read"
}
# Allow reading all services
service_prefix "" {
  policy = "read"
}

# Allow all apps to register node exporter
service "prometheus-node-exporter" {
  policy = "write"
}

# APP SPECIFIC
service_prefix "${var.name}" {
  policy = "write"
}

# APP EXTRA
${var.consul_policy_extra}
    RULE
}
