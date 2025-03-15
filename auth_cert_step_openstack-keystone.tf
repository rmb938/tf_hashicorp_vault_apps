module "openstack-keystone" {
  source = "./modules/step_cert_app"

  secret_mount_path   = local.secret_mount_path
  step_cert_auth_path = local.step_cert_auth_path
  consul_mount_path   = local.consul_mount_path
  consul_datacenter   = local.consul_datacenter_homelab

  name = "openstack-keystone"
  allowed_common_names = [
    "openstack-keystone-1.us-homelab1.hl.rmb938.me",
    "openstack-keystone-2.us-homelab1.hl.rmb938.me",
    "openstack-keystone-3.us-homelab1.hl.rmb938.me",
  ]
  token_bound_cidrs = [
    "192.168.23.76/32",
    "192.168.23.77/32",
    "192.168.23.78/32",
  ]

  vault_policy_extra = <<EOT
path "pki_openstack_postgres_intermediate/issue/user-keystone" {
  capabilities = ["update"]
}
path "pki_openstack_keystone_internal_intermediate/issue/server" {
  capabilities = ["update"]
}
path "pki_openstack_keystone_internal_intermediate/issue/user-admin" {
  capabilities = ["update"]
}

path "transit_openstack_keystone_token/sign/token/sha2-384" {
  capabilities = ["create"]
}
path "transit_openstack_keystone_token/verify/token/sha2-384" {
  capabilities = ["create"]
}
path "transit_openstack_keystone_token/keys/token" {
  capabilities = ["read"]
}

path "transit_openstack_keystone_credential/encrypt/credential" {
  capabilities = ["create"]
}
path "transit_openstack_keystone_credential/decrypt/credential" {
  capabilities = ["create"]
}
path "transit_openstack_keystone_credential/keys/credential" {
  capabilities = ["read"]
}
EOT
}
