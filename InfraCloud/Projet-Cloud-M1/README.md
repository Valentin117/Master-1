## **Projet Infrastructre Cloud - 03/10/2022**

#### **Membres du projet**

- Pierre Da Silva
- Antoine Zachariades
- Valentin Malo
- Clément Osche

#### **Objectif**

Notre projet a pour objectif la mise en place d'un site web redondé sur deux Cloud Provider différent.
Les deux Cloud Provider sont Azure et Scaleway.
Sur Azure est mis en place un serveur web et sur Scaleway est mis en place un serveur web, une base de données, un serveur permettant la redondance entre les deux serveurs web, et un load balancer.
A terme, l'objectif final serait de mettre en place une réplication en temps réel entre 2 bases de données qui seront chacune sur leur propre Cloud Provider.

#### **Cloud Provider : Scaleway et Microsoft Azure**

* Sur Scaleway
    * 1 adresse IP publique pour le NFS
    * 1 adresse IP publique pour le Wordpress 1
    * 1 instance serveur NFS
    * 1 instance serveur Wordpress 1
    * 1 base de données 1
    * 1 load balancer
    * 1 adresse IP publique pour le load balancer

* Sur Microsoft Azure
    * 1 adresse IP publique pour le Wordpress 2
    * 1 instance serveur Wordpress 2

* Sur Name.com
    * Enregistrement DNS des adresses IP Wordpress 1, Wordpress 2, serveur NFS et du Load Balancer 

* Dernière fonctionnalité à mettre en place

**Mise en place d'une réplication *en temps réel* entre les 2 bases de données.**

---

#### **Description du projet**

Dans un premier temps, le Terraform et le Powershell Azure CLI vont déployer tout ce qu'il nous faut pour construire nos infrastructures sur les 2 Cloud Provider.

***On a tout d'abord, 3 adresses IP publiques qui sont créées en amont et qui seront utilisées pour mettre en place l'enregistrement DNS :***

* 2 adresses IP publiques sur Scaleway
* 1 adresse IP publique sur Azure

:warning:*Pour se faire, il faut des adresses IP **fixes**. C'est pour cette raison, qu'on a crée des adresses IP publiques qui auront la même IP et ne seront pas supprimées de Scaleway et Azure avant la fin du projet.*:warning:

Le Terraform est construit sur l'ID des adresses IP publiques fixes de Scaleway et l'adresse IP publique de l'instance Wordpress d'Azure.
Name.com est utilisé pour la réservation du nom du domaine, et pour l'enregistrement DNS des IP publiques réservés sur Scaleway et Azure.

***Le Terraform se poursuit et configure comme demandé nos instances et notre base de données :***

* Les instances serveur NFS et Wordpress 1 vont récupérer une des 2 adresses IP disponibles en utilisant que l'ID des adresses.

* L'instance NFS quand à elle, durant sa création, va exécuter un script qui va installer NFS et va ajouter à sa liste d'adresses IP publique les 2 IP des instances Wordpress (de Scaleway et Azure).
Grâce à ceci, une réplication va pouvoir se faire entre les 2 instances Wordpress en simultanée. Comme ça, en cas de coupure d'une instance, l'autre puisse toujours fonctionner et accéder au Wordpress. C'est une mise en commun des fichiers/documents avec différents serveurs.

* L'instance 1 Wordpress, lors de sa création (Ubuntu), va exécuter un script qui va installer Apache, PHP, Wordpress ainsi que sa configuration. Mais aussi le script va le connecter à l'instance NFS.

Une fois la connexion établie, l'instace NFS va répliquer le dossier Wordpress afin qu'il soit accéssible par l'autre instance 2 Wordpress.

* La base de données se crée sans rien de plus.

***Le Powershell Azure CLI se poursuit et configure notre groupe de ressources :***

* L'instance 2 Wordpress va récupérer l'adresse IP disponible en utilisant le nom de la ressource lié à l'adresse IP publique.

* L'instance 2 Wordpress, lors de sa création (Ubuntu), va exécuter un script identique à celui pour l'instance 1 Wordpress sauf qu'il n'installe pas Wordpress. Il se connecte aussi à l'instance NFS et réplique le dossier Wordpress.
C'est grâce au serveur NFS qu'il va répliquer l'instance 1 Wordpress et obtenir tous les fichiers afin d'accéder au Wordpress.

---

#### **Essayer notre projet**

Si vous souhaitez exécuter notre Terraform et notre Powershell :

* 