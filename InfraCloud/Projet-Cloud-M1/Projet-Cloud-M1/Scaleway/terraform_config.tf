# Provider Scaleway avec Terraform

variable "project_id" {
  type    = string
  default = "391cf766-a0e3-45ce-83bd-xxxxxxxxxxx"
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
  zone   = "nl-ams-1"
  region = "nl-ams"
  access_key = "SCW06N2ZKQN9DTFD8DF4"
  secret_key = "c1b7d567-865d-4c74-9a01-8f78b653e42c"
  project_id = "0c1671e0-2f42-4ed2-8799-14f144ecb947"
}

# Création Instance Serveur NFS sur Scaleway

# NE JAMAIS COMMENTER LES LIGNES EN DESSOUS --
# resource "scaleway_instance_ip" "public_ipNFS" {}
# --

resource "time_sleep" "wait_120_1" {
  create_duration = "60s"
}

# resource "scaleway_instance_volume" "dataNFS" {
  # size_in_gb = 10
  # type = "b_ssd"
# }

# ip_id récupére l'IP publique et l'ajoute à notre instance via l'ID

resource "scaleway_instance_server" "instanceNFS" {
  name   = "Instance_NFS_Projet"
  image  = "ubuntu_jammy"
  type   = "DEV1-S"
  # ip_id  = scaleway_instance_ip.public_ipNFS.id
  ip_id  = "b81f27eb-cc57-49ef-9d9b-9bbb5c5a7eff"
  zone   = "nl-ams-1"
  depends_on = [time_sleep.wait_120_1]

  # additional_volume_ids = [ scaleway_instance_volume.dataNFS.id ]

  user_data = {
    foo        = "bar"
    cloud-init = file("server_nfs.sh")
  }
}

# Création Instance Serveur 1 sur Scaleway

# NE JAMAIS COMMENTER LES LIGNES EN DESSOUS --
# resource "scaleway_instance_ip" "public_ip" {}
# --

resource "time_sleep" "wait_120" {
  create_duration = "120s"
}

# resource "scaleway_instance_volume" "data1" {
  # size_in_gb = 10
  # type = "b_ssd"
# }

# ip_id récupére l'IP publique et l'ajoute à notre instance via l'ID

resource "scaleway_instance_server" "instance1" {
  name   = "Instance_1_Projet"
  image  = "ubuntu_jammy"
  type   = "DEV1-S"
  # ip_id  = scaleway_instance_ip.public_ip.id
  ip_id  = "06a34dcf-2927-4aee-8b8e-6e9ba4e79923"
  zone   = "nl-ams-1"
  depends_on = [time_sleep.wait_120]

  # additional_volume_ids = [ scaleway_instance_volume.data1.id ]

  user_data = {
    foo        = "bar"
    cloud-init = file("wordpress.sh")
  }
}
# Ajout groupe de sécurité

# Création Instance Base de données sur Scaleway

resource "scaleway_rdb_instance" "bdd1" {
  name              = "wordpress"
  node_type         = "db-dev-s"
  engine            = "MySQL-8"
  is_ha_cluster     = false
  disable_backup    = true
  user_name         = "userbdd"
  password          = "EWiwcs!d!9minG7vsr$Z#$XNbQBwa!WcyBQHz163"
  region            = "nl-ams"
  volume_type       = "bssd"
  volume_size_in_gb = 10
}

# Création Load Balancer sur Scaleway

# NE JAMAIS COMMENTER LES LIGNES EN DESSOUS --
resource "scaleway_lb_ip" "public_ip3" {
   zone = "nl-ams-1"
}
# --

resource "scaleway_lb_backend" "backend1" {
  lb_id            = scaleway_lb.lb1.id
  name             = "backend1"
  forward_protocol = "http"
  forward_port     = "80"

  health_check_tcp {}

  # health_check_http {
   # uri = "/wp-admin/setup-config.php"
  # }

  server_ips = [
    # scaleway_instance_ip.public_ip.address
    # IP Instance serveur 1 Wordpress sur Scaleway - Correspond à l'IP de l'ID 06a34dcf-2927-4aee-8b8e-6e9ba4e79923
    "51.158.175.56",
    # IP Instance serveur 2 Wordpress sur Azure
    "4.233.219.69"
  ]
}

resource "scaleway_lb_frontend" "frontend1" {
  lb_id        = scaleway_lb.lb1.id
  backend_id   = scaleway_lb_backend.backend1.id
  name         = "frontend1"
  inbound_port = "80"
}

resource "scaleway_lb" "lb1" {
  name  = "Load_Balancer_1_Projet"
  ip_id = scaleway_lb_ip.public_ip3.id
  zone  = scaleway_lb_ip.public_ip3.zone
  # zone  = "nl-ams-1"
  type  = "LB-GP-L"
}
