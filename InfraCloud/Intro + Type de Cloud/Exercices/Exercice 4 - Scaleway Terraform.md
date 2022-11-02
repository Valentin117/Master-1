## **TP 4 - Scaleway Terraform, Sécurité et Réseaux**

<br>

**Pour chacun des cas, mettre en place l'infrastructure à l’aide de votre
compte et des services Scaleway. Vous effectuerez la mise en place de
l’infrastructure à l’aide de Terraform (IaC).**

<br>

**Important :**
* Après avoir fait valider que votre cas est fonctionnel, penser à
supprimer toutes les ressources de ce cas !

* Les ressources non éteintes et inutiles coûtent de l’argent et
démontreront la non maîtrise de la compétence associée !

* Pour chaque cas, vous ajouterez au compte-rendu les commande
Scaleway (scw) associé à la mise en place

<br>

### **Prérequis :**

<br>

Avant de réaliser ce TP, vous devez installer Terraform et configurer le provider
scaleway sur la zone fr-par-1. Installer telnet et netcat en local (ou équivalents).

<br>

#### Installation de Terraform sur une VM Ubuntu/Debian :

*Lien : [Install Terraform](https://developer.hashicorp.com/terraform/downloads)*

* Premièrement, il faut installer Terraform sur la VM :

```py
$ apt update
$ wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
$ echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
$ sudo apt update && sudo apt install terraform
```

* Création d'un répertoire sur notre VM afin d'initier Terraform :

```
cd Document
mkdir Master1
cd Master1
mkdir Exercice4
cd Exercice4
```

* Configuration de notre répertoire directory de Terraform :

```
terraform init
```

![img](https://i.imgur.com/tyRX8Br.png)

* Maintenant, il faut configurer notre provider Scaleway sur la zone fr-par-1 :

Création d'un fichier de configuration et tester des commandes de Terraform à vide :

```
nano terraform_config.tf
terraform plan
terraform apply
```

![img](https://i.imgur.com/3H7RzUy.png)

Maintenant, il faut configurer le fichier .tf (car il est vide pour l'instant) en fonction des consignes demandés ci-dessous.


## **Cas n°1 : Bastion et règles de sécurités**

<br>

1. Vous installez une base de données MySQL à l’aide du service correspondant sur Scaleway. Connectez-vous à la base de données et réalisez quelques opérations basiques.
<br>
<br>
2. Créer une instance dans le Cloud Scaleway de type DEV1_S, connectez vous au serveur en SSH et installer netcat et telnet.
<br>
<br>
3. A ce stade, aucune règle de sécurité, vous pouvez accéder à la base de données (port 3306), au serveur en SSH (port 22) ou à un éventuel serveur web (port 80 - HTTP). Vérifier cela avec les commandes netcat et telnet.
<br>
<br>
4. A l’aide des security groups, vous ouvrez au monde entier seulement l’accès HTTP. Bloquer les accès SSH à votre machine uniquement depuis votre IP, et les accès à la base de données seulement depuis le serveur.
<br>
<br>
5. Vérifier les blocages à l’aide des commandes netcat et telnet.
<br>
<br>

## Configuration du fichier terraform_config.tf :

### Configuration de base du fichier .tf :
*Base identique tout le temps*

```
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
```

### Création de l'instance base de données :
*Module ajouté au fichier .tf afin de créer une instance BDD*

```
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
```

![img](https://i.imgur.com/IN2wfHi.png)

<br>

Ensuite, une fois le fichier comprennant le module permettant de créer une instance BDD, il faut deployer notre fichier Terraform :

```
terraform init
terraform plan
terraform apply
```

Il faudra valider avec la réponse "yes".

<br>

![img](https://i.imgur.com/QjWfHUm.png)
![img](https://i.imgur.com/yn5mRDP.png)
![img](https://i.imgur.com/w2K37oZ.png)

<br>

Voici le résultat sur Scaleway pour la création de l'instance BDD :

<br>

![img](https://i.imgur.com/zQZIxze.png)

<br>

* Connection à l'instance de base de données et réalisation d'opérations :

<br>

![img](https://i.imgur.com/LRf5Ve2.png)

<br>

### Création de l'instance serveur :
*Module ajouté au fichier .tf afin de créer une instance serveur*

```
resource "scaleway_instance_ip" "ip" {}

resource "scaleway_instance_server" "web" {
  name = "scw-valentin-clement"
  type = "DEV1-S"
  image = "ubuntu_jammy"
  ip_id = scaleway_instance_ip.ip.id
}
```

![img](https://i.imgur.com/U8zR174.png)

<br>

Voici le résultat sur Scaleway pour la création de l'instance serveur :

<br>

![img](https://i.imgur.com/K0pF40P.png)

<br>

#### Connection à l'instance serveur et installation de netcat & telnet :

Connection via MobaXtern, en saisissant l'adresse IP de mon instance de serveur, le nom d'utilisateur "root" et en indiquant le chemin de la clé SSH privé.

* Installation telnet :

```
apt update
apt install telnetd -y
dpkg -l | grep telnet
systemctl status inetd
```

<br>

![img](https://i.imgur.com/wQsowpL.png)

<br>

* Installation netcat :

```
apt install netcat -y
```

#### Accés à l'instance BDD et instance serveur avec les commandes netcat & telnet :

* Connexion à l'instance base de données via l'instance serveur avec telnet :

```
root@scw-valentin-clement:~# telnet 51.158.57.216 59619
Trying 51.158.57.216...
Connected to 51.158.57.216.
```

<br>

![img](https://i.imgur.com/2HAkHLp.png)

<br>

* Connexion à l'instance serveur via un poste client avec telnet :

```
valentin@valentin-Virtual-Machine:~/Documents/Master1/Exercice4$ telnet 51.15.131.221
Trying 51.15.131.221...
Connected to 51.15.131.221.
Escape character is '^]'.
Ubuntu 22.04 LTS
scw-valentin-clement login:
```

<br>

![img](https://i.imgur.com/kyGPwYR.png)

<br>

* Connexion à l'instance base de données via un poste client avec telnet :

```
valentin@valentin-Virtual-Machine:~/Documents/Master1/Exercice4$ telnet 51.158.57.216 59619
Trying 51.158.57.216...
Connected to 51.158.57.216.
```

<br>

![img](https://i.imgur.com/yoJDVhP.png)

<br>

### Modification du fichier Terraform afin d'ajouter des ACLs et VPC aux instances BDD et serveur :

```
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
```

<br>

![img](https://i.imgur.com/9lWg8uQ.png)

<br>

#### Vérification des groupes de sécurité et ACL ajoutés à l'Instance base de données et l'Instance serveur :

* ACL Instance BDD :

<br>

![img](https://i.imgur.com/xMmYuJD.png)

<br>

* ACL Instance serveur :

<br>

![img](https://i.imgur.com/m1UbCb1.png)
![img](https://i.imgur.com/dvCiK0p.png)

<br>

### Vérification que les règles fonctionnes :

* Connexion à l'instance base de données via l'instance serveur avec telnet :

```
root@scw-valentin-clement:~# telnet 51.158.57.216 59619
Trying 51.158.57.216...
Connected to 51.158.57.216.
```

<br>

![img](https://i.imgur.com/ZdeLF31.png)

<br>

* Connexion à l'instance serveur via un poste client avec telnet :

```
valentin@valentin-Virtual-Machine:~/Documents/Master1/Exercice4$ telnet 51.15.131.221
Trying 51.15.131.221...
Connected to 51.15.131.221.
Escape character is '^]'.
Ubuntu 22.04 LTS
```

<br>

![img](https://i.imgur.com/MG8e1ra.png)

<br>

* Connexion à l'instance base de données via un poste client avec telnet :

```
valentin@valentin-Virtual-Machine:~/Documents/Master1/Exercice4$ telnet 51.158.57.216 59619
Trying 51.158.57.216...
Connected to 51.158.57.216.
```

<br>

![img](https://i.imgur.com/gq5V0rx.png)

<br>

Malheureusement, après un 2nd changement de mon fichier Terraform, les règles s'appliquent mais ne fonctionnent pas.
Car j'arrive à me connecter depuis un poste client à l'Instance BDD alors qu'on ne devrait que depuis l'Instance serveur.

<br>

## **Cas n°2 : Réseaux virtuel privé et gateway**