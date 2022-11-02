variable "project_id" {
  type        = string
  default = "0c1671e0-2f42-4ed2-8799-14f144ecb947"
}

terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
  zone   = "fr-par-1"
  region = "fr-par"
  access_key = "SCW06N2ZKQN9DTFD8DF4"
  secret_key = "c1b7d567-865d-4c74-9a01-8f78b653e42c"
  project_id = "0c1671e0-2f42-4ed2-8799-14f144ecb947"
}

resource "scaleway_instance_ip" "ip2" {}

resource "scaleway_instance_security_group" "main" {
  inbound_default_policy  = "drop" # By default we drop incoming traffic that do not match any inbound_rule.
  outbound_default_policy = "drop" # By default we drop outgoing traffic that do not match any outbound_rule.
}

resource "scaleway_rdb_acl" "main" {
  instance_id = scaleway_rdb_instance.main.id
  acl_rules {
    ip = "51.15.131.221/32"
    description = "Accès autorisé seulement par le serveur"
  }
}

resource "scaleway_rdb_instance" "main" {
  name           = "rdb-valentin-clement"
  node_type      = "DB-DEV-S"
  engine         = "MySQL-8"
  is_ha_cluster  = true
  disable_backup = true
  user_name      = "Administrateur"
  password       = "Sixter64!"
  region         = "fr-par"
}

resource "scaleway_instance_security_group" "web" {
  inbound_default_policy  = "drop" # By default we drop incoming traffic that do not match any inbound_rule.
  outbound_default_policy = "accept" # By default we drop outgoing traffic that do not match any outbound_rule.

  inbound_rule {
    action = "accept"
    port   = 80
  }

  inbound_rule {
    action = "accept"
    port   = 22
    ip_range = "85.169.101.162/32"
  }
}

resource "scaleway_instance_ip" "ip" {}

resource "scaleway_instance_server" "web" {
  name = "scw-valentin-clement"
  type = "DEV1-S"
  image = "ubuntu_jammy"
  ip_id = scaleway_instance_ip.ip.id
}

