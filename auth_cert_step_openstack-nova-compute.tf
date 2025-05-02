module "openstack-nova-compute" {
  source = "./modules/step_cert_app"

  secret_mount_path   = local.secret_mount_path
  step_cert_auth_path = local.step_cert_auth_path
  consul_mount_path   = local.consul_mount_path
  consul_datacenter   = local.consul_datacenter_homelab

  name = "openstack-nova-compute"
  allowed_common_names = [
    "roxas.rmb938.me",
    "sora.rmb938.me",
    "openstack-compute-1.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.12/32",
    "192.168.23.10/32",
    "192.168.23.100/32",
  ]

  vault_policy_extra = <<EOT
path "pki_openstack_rabbitmq_intermediate/issue/user-nova-compute" {
  capabilities = ["update"]
}
path "pki_openstack_ovn_ovsdb_intermediate/issue/user-neutron-compute" {
  capabilities = ["update"]
}
path "pki_openstack_ovn_ovsdb_intermediate/issue/user-ovn-controller" {
  capabilities = ["update"]
}

path "${local.secret_mount_path}/openstack-keystone/service-users/nova-compute" {
  capabilities = ["read"]
}
EOT
}
