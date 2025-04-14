module "openstack-cinder" {
  source = "./modules/step_cert_app"

  secret_mount_path   = local.secret_mount_path
  step_cert_auth_path = local.step_cert_auth_path
  consul_mount_path   = local.consul_mount_path
  consul_datacenter   = local.consul_datacenter_homelab

  name = "openstack-cinder"
  allowed_common_names = [
    "openstack-cinder-1.us-homelab1.hl.rmb938.me",
    "openstack-cinder-2.us-homelab1.hl.rmb938.me",
    "openstack-cinder-3.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.82/32",
    "192.168.23.83/32",
    "192.168.23.84/32",
  ]

  vault_policy_extra = <<EOT
path "pki_openstack_postgres_intermediate/issue/user-cinder" {
  capabilities = ["update"]
}
path "pki_openstack_rabbitmq_intermediate/issue/user-cinder" {
  capabilities = ["update"]
}

path "${local.secret_mount_path}/openstack-keystone/service-users/cinder" {
  capabilities = ["read"]
}
EOT
}
