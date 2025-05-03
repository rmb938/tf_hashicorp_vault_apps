module "openstack-octavia" {
  source = "./modules/step_cert_app"

  secret_mount_path   = local.secret_mount_path
  step_cert_auth_path = local.step_cert_auth_path
  consul_mount_path   = local.consul_mount_path
  consul_datacenter   = local.consul_datacenter_homelab

  name = "openstack-octavia"
  allowed_common_names = [
    "openstack-octavia-1.us-homelab1.hl.rmb938.me",
    "openstack-octavia-2.us-homelab1.hl.rmb938.me",
    "openstack-octavia-3.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.94/32",
    "192.168.23.95/32",
    "192.168.23.96/32",
  ]

  vault_policy_extra = <<EOT
path "pki_openstack_postgres_intermediate/issue/user-octavia" {
  capabilities = ["update"]
}
path "pki_openstack_rabbitmq_intermediate/issue/user-octavia" {
  capabilities = ["update"]
}
path "pki_openstack_ovn_ovsdb_intermediate/issue/user-octavia-controller" {
  capabilities = ["update"]
}

path "${local.secret_mount_path}/openstack-keystone/service-users/octavia" {
  capabilities = ["read"]
}
EOT
}
