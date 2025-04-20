module "openstack-neutron" {
  source = "./modules/step_cert_app"

  secret_mount_path   = local.secret_mount_path
  step_cert_auth_path = local.step_cert_auth_path
  consul_mount_path   = local.consul_mount_path
  consul_datacenter   = local.consul_datacenter_homelab

  name = "openstack-neutron"
  allowed_common_names = [
    "openstack-neutron-1.us-homelab1.hl.rmb938.me",
    "openstack-neutron-2.us-homelab1.hl.rmb938.me",
    "openstack-neutron-3.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.91/32",
    "192.168.23.92/32",
    "192.168.23.93/32",
  ]

  vault_policy_extra = <<EOT
path "pki_openstack_postgres_intermediate/issue/user-neutron" {
  capabilities = ["update"]
}
path "pki_openstack_rabbitmq_intermediate/issue/user-neutron" {
  capabilities = ["update"]
}
path "pki_openstack_ovn_ovsdb_intermediate/issue/user-neutron-controller" {
  capabilities = ["update"]
}

path "${local.secret_mount_path}/openstack-keystone/service-users/neutron" {
  capabilities = ["read"]
}
EOT
}
