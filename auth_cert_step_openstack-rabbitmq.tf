module "openstack-rabbitmq" {
  source = "./modules/step_cert_app"

  secret_mount_path   = local.secret_mount_path
  step_cert_auth_path = local.step_cert_auth_path
  consul_mount_path   = local.consul_mount_path
  consul_datacenter   = local.consul_datacenter_homelab

  name = "openstack-rabbitmq"
  allowed_common_names = [
    "openstack-rabbitmq-1.us-homelab1.hl.rmb938.me",
    "openstack-rabbitmq-2.us-homelab1.hl.rmb938.me",
    "openstack-rabbitmq-3.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.73/32",
    "192.168.23.74/32",
    "192.168.23.75/32",
  ]

  vault_policy_extra = <<EOT
path "pki_openstack_rabbitmq_intermediate/roles" {
  capabilities = ["read", "list"]
}

path "pki_openstack_rabbitmq_intermediate/issue/server" {
  capabilities = ["update"]
}

path "pki_openstack_rabbitmq_cluster_intermediate/issue/user-cli" {
  capabilities = ["update"]
}
EOT
}
