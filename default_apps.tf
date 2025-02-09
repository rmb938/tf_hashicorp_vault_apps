resource "vault_policy" "default_apps" {
  name = "default_apps"

  policy = <<EOT
path "secret/consul/encrypt_key" {
  capabilities = ["read"]
}
EOT
}

resource "consul_acl_policy" "default_apps" {
  name  = "default_apps"
  rules = <<-RULE
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
    RULE
}
