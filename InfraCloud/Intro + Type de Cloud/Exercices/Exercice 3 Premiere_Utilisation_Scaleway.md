## TP Première utilisation de Scaleway - 20 Octobre 2022

#### **Pour chacun des cas, mettre en place l'infrastructure à l’aide de votre compte et des services Scaleway. Vous effectuerez la mise en place à l’aide de la console dans un premier temps puis via le CLI Scaleway dans un second temps.**

#### Important :

* Après avoir fait valider que votre cas est fonctionnel, penser à supprimer toutes les ressources de ce cas !
* Les ressources non éteintes et inutiles coûtent de l’argent et démontreront la non maîtrise de la compétence associée !
* Pour chaque cas, vous ajouterez au compte-rendu les commande Scaleway (scw) associé à la mise en place

***Avant de démarrer vous devez me fournir sur Teams les adresses mail de votre groupe de TP afin que je vous ajoute sur Scaleway***

#### Compétences mises en oeuvre dans ce TP

* Utiliser les fonctionnalités du Cloud pour mettre en service, dimensionner et distribuer
une infrastructure de calcul
* Utiliser les services et les outils permettant d'automatiser la mise en service et le
déploiement de l’infrastructure
* Optimiser l’efficacité d’une infrastructure Cloud afin d’améliorer les performances,
diminuer les coûts et éviter le gaspillage

#### Lien : [Scaleway](https://console.scaleway.com/organization)

<br>

### Cas n°1 : Une base de données managée et un serveur

<br>

* Vous installez une base de données à l’aide du service correspondant sur Scaleway.
A l’aide d’une machine dans le cloud Scaleway (la moins chère possible), vous vous
connectez à cette base de données, vous y créez une base avec une table (user: nom,
prénom, mail).
* Ajoutez 5 ou 6 user dans la table associée. Faire une sauvegarde de la base de données via Scaleway (dans la console puis via la ligne de commande scw). Supprimer les utilisateurs. Restaurer la base de données à l’aide de la sauvegarde faite précédemment (dans la console puis via la ligne de commande scw).

<br>

#### Création et configuration de l'instance base de données

<br>

| Moteur de base de données | Mysql |
| ------------- |:-------------:|
| Région | Paris |
|Configuration| Standalone (1 nœud) |
| Type de noeud | Développement : DB-DEV-S ( 2 vCPU, 2 Go de mémoire (RAM), 1 noeud ) |
| Type de stockage et capacité | Stockage SSD local à 5 Go |
| Configuration de sauvegarde | Sauvegarde automatisé dans une région différente |
| Nom de l'instance | rdb-valentin-clement |
| Prix | 0,01384 € par heure |

![img](https://i.imgur.com/ARmq2US.png)
![img](https://i.imgur.com/NOer8aC.png)

<br>

#### Création et configuration de l'instance serveur

<br>

| Instance serveur | Ubuntu |
| ------------- |:-------------:|
| Région | Amsterdam 1 |
| Type d'instance | Développement & Test : DEV1-S ( Coeurs 2x86 64 bits, 2 Go de mémoire (RAM), 20 GO de stockage NVMe, 200 Mbps de bande passante ) |
| Choix de l'image | Ubuntu 22.04 Jammy Jellyfish |
| Type de stockage et capacité | Stockage SSD local à 20 Go |
| Nom de l'instance | scw-valentin-clement |
| Prix | 0,011 € par heure |

![img](https://i.imgur.com/03ey4qi.png)

<br>

#### Commande création de l'instance serveur sur le CLI :

<br>

```
scw instance server create type=DEV1-S zone=nl-ams-1 image=ubuntu_jammy root-volume=l:20G name=scw-valentin-clement ip=new project-id=0c1671e0-2f42-4ed2-8799-14f144ecb947
```

<br>

### Connexion à l'instance de serveur et à l'instance de base données :

<br>

Dans un premier temps, il faut se connecter à notre instance serveur avant de se connecter à notre instance base de données :
```
ssh -i 'C:\Users\ValentinMALO\Key_SSH' root@51.158.177.189
```

Je vais chercher le chemin de ma clé privé afin de me connecter à l'instance serveur.
Une fois la connexion établie, il faut se connecter à l'instance base de données :
```
mysql -h 51.159.112.48 --port 19689 -p -u username
mysql -h 51.159.112.48 --port 19689 -p -u Administrateur
```

Sachant qu' "Administrateur" est notre login sur li'nstance base données.
Sauf que la commande ne va pas marché car sur notre instance serveur, il n'y a pas mysql d'installé. Il faut d'abord installé le client mysql pour se connecter :
```
apt update
apt install mysql-client-core-8.0
mysql -h 51.159.112.48 --port 19689 -p -u Administrateur
```

Ensuite, il faut saisir le mot de passe du login "Administrateur" et on se retrouve connecté à notre instance base de données.

<br>

### Création de la base de données, de la table et des données :

<br>

Une fois connecté, il faut d'abord créer la base de données ou on utilise la base de données existantes (rdb). On la sélectionne et on crée une table en indiquant les champs qu'elle doit contenir :

```
mysql> create database TP3 (si on crée une nouvelle base de données)
mysql> use rdb; (car on utilise la table déjà présente au moment de la création de l'instance base de données)
Database changed
mysql> CREATE TABLE user (nom VARCHAR(40) NOT NULL, prenom VARCHAR(40) NOT NULL, email VARCHAR(100) NOT NULL);
```

![img](https://i.imgur.com/hJ7S984.png)

Comme demandé dans l'énoncé, on crée 5-6 utilisateurs (nom, prénom et email) dans la table de la base de données rdb :

```
mysql>  INSERT INTO user (nom, prenom, email)
        -> VALUES ('malo', 'valentin', 'valentin.malo@ynov.com'),
        -> ('osche', 'clement', 'clement.osche@ynov.com'),
        -> ('dasilva', 'pierre', 'pierre.dasilva@ynov.com'),
        -> ('zachariades', 'antoine', 'antoine.zachariades@ynov.com'),
        -> ('lassalle', 'jean', 'jean-lassalle@gmail.com'),
        -> ('totoro', 'gogo', 'totogo@go.com');
```

On peut voir que les différentes données sont insérés dans la table user :
```
SELECT * FROM user;
```

![img](https://i.imgur.com/SF0o7CH.png)

<br>

### Sauvegarde de la base de données :

<br>

#### Graphiquement / Console Web :

<br>

Dans un premier temps, il faut réaliser une sauvegarde via la console web :

![img](https://i.imgur.com/ADRCIYq.png)
![img](https://i.imgur.com/qiqCJKF.png)

On retrouve à la fin notre sauvegarde de notre base de données / table :

![img](https://i.imgur.com/6sFhAqW.png)

<br>

#### Via le CLI :

<br>

Pour se faire, il faut installer le CLI de Scaleway sur une VM Ubuntu :
```
sudo su (demande de mot de passe)
apt install curl
sudo curl -o /usr/local/bin/scw -L "https://github.com/scaleway/scaleway-cli/releases/download/v2.6.0/scaleway-cli_2.6.0_linux_amd64"
sudo chmod +x /usr/local/bin/scw
```

![img](https://i.imgur.com/Ppp2Wg9.png)

Une fois l'installation faite, on va démarrer le CLI de Scaleway :
```
scw init
```

![img](https://i.imgur.com/lfYPXvI.png)

On demande la secret key pour l'API de Scaleway que l'on obtient après création de celle-ci :

<br>

#### Lien : [Création API Scaleway ](https://console.scaleway.com/iam/users/e4eb60cd-9231-4f1a-8bb4-f01797c55927/credentials)

<br>

![img](https://i.imgur.com/XbPZaev.png)
![img](https://i.imgur.com/vzudEnL.png)
![img](https://i.imgur.com/ZMHIvuv.png)
![img](https://i.imgur.com/0HyRcMi.png)

Une fois le CLI initié, on va pouvoir faire la sauvegarde de la base de données / table :

```
scw rdb backup list
```

![img](https://i.imgur.com/PCCJ34e.png)

Avec la commande précédente, on retrouve la 1ère sauvegarde que l'on a faite depuis la console web.
Reste plus qu'à crée une 2nd sauvegarde mais depuis le CLI de Scaleway :

```
scw rdb backup create instance-id=cf7a4076-6e88-42f0-83c3-cf6815d97316 database-name=rdb name:ReUpload-2-CLI expires-at=2022-10-27T23:00:00+00:00
```
![img](https://i.imgur.com/humtuOs.png)

On constate que notre 2ème sauvegarde a bien été crée avec la commande (en bas de la liste) et sur la console web:
```
scw rdb backup list
```

![img](https://i.imgur.com/z432ZMm.png)
![img](https://i.imgur.com/VU3rkh4.png)

<br>

### Restauration de la base de données :

<br>

#### Suppression de la base de données / table :

<br>

Avant de se faire, nous allons vider notre table user de la base de données rdb afin de prouver que la restauration via la console web ou via le CLI de Scaleway fonctionne :
```
mysql> TRUNCATE TABLE `user`;
Query OK
mysql > select * from user;
Empty set
```

![img](https://i.imgur.com/AQMNiyk.png)

<br>

#### Restauration Graphiquement / Console Web :

<br>

![img](https://i.imgur.com/LIFDVAI.png)
![img](https://i.imgur.com/FbQVJAS.png)

Vérification de la restauration directement avec la commande :
```
select * from user;
```

![img](https://i.imgur.com/q9cwlvn.png)

<br>

#### Restauration via CLI Scaleway :

<br>

Etant donnée que l'on ne connait pas l'ID de notre sauvegarde afin de réaliser la restauration, il faut qu'on liste les différentes sauvegardes et qu'on récupère l'ID (notre sauvegarde réalisé sur le CLI est la dernière de la liste):
```
scw rdb backup list
```

![img](https://i.imgur.com/KHnJ27m.png)

Maintenant que l'on a notre ID de notre sauvegarde, on va pouvoir restaurer la base de données / table avec la commande :

```
scw rdb backup restore bbfb52a5-2492-477f-96d-b1cfd36f62c5 database-name=rdb instance-id=cf7a4076-6e88-42f0-83c3-cf6815d97316
```

![img](https://i.imgur.com/2q7WtRN.png)

Vérification de la restauration directement avec la commande :
```
select * from user;
```

![img](https://i.imgur.com/q9cwlvn.png)

<br>

### Cas n°2 : Utilisation des FaaS pour faire des requêtes sur une base de données

<br>

* En utilisant la base de données du cas n°1, vous effectuez une requête simple (type “SELECT * FROM user;”) à l’aide du service Serverless de Scaleway. Vous créez la fonction Serverless à l’aide du CLI Scaleway.

<br>

#### Création et configuration de l'instance base de données (même que pour le cas n°1)

<br>

| Moteur de base de données | Mysql |
| ------------- |:-------------:|
| Région | Paris |
|Configuration| Standalone (1 nœud) |
| Type de noeud | Développement : DB-DEV-S ( 2 vCPU, 2 Go de mémoire (RAM), 1 noeud ) |
| Type de stockage et capacité | Stockage SSD local à 5 Go |
| Configuration de sauvegarde | Sauvegarde automatisé dans une région différente |
| Nom de l'instance | rdb-valentin-clement |
| Prix | 0,01384 € par heure |

![img](https://i.imgur.com/ARmq2US.png)
![img](https://i.imgur.com/NOer8aC.png)

<br>

### Création de la fonction Serverless

<br>

#### Graphiquement / Console Web :

<br>

Dans un premier temps, il faut créer un namespace dans la partie "Functions Serverless" de Scaleway :

<br>

#### Lien : [Serverless Functions](https://console.scaleway.com/functions/namespaces)

<br>

![img](https://i.imgur.com/5XNepl6.png)

Une fois le namespace en place, il faut créer une fonction Serverless dans celle-ci.
Création d'une fonction en Python (langage de préférence) :

![img](https://i.imgur.com/dWVZt1n.png)

```py
def handle(event, context):
    return {
        "body": {
            "message": 'Hello, world',
        },
        "statusCode": 200,
    }
```

Estimation du coût de la fonction Serverless :

![img](https://i.imgur.com/mP1Hapi.png)

<br>

Et le résultat que renvoie la fonction Serverless via l'URL fournit :

![img](https://i.imgur.com/t7C03lw.png)
![img](https://i.imgur.com/amuOs3u.png)

<br>

#### Via le CLI de Scaleway :

<br>

Création du namespace en ligne de commande depuis le CLI :

```
scw function namespace create name=namespace-CLI-G11
```

![img](https://i.imgur.com/WW7rtaK.png)
![img](https://i.imgur.com/vlQDOuF.png)

<br>

Il faut lister les différents namespace disponibles :

```
scw function namespace list
```

![img](https://i.imgur.com/VjHYN28.png)
![img](https://i.imgur.com/jPvHfsC.png)
![img](https://i.imgur.com/cbrBxl3.png)

<br>

On peut voir aussi la fonction que contient un namespace :

```
scw function function list namespace-id=de6bd341-05b9-4afa-80ee-b5286bd3f938
```

![img](https://i.imgur.com/TpZwmze.png)
![img](https://i.imgur.com/MFv7iCp.png)

Il va falloir utiliser l'ID du namespace afin de créer une fonction Serverless dans celle-ci (le namespace crée à partir du CLI):

```
scw function function create name=functionserverlessfromcli namespace-id=41388c5f-d952-4906-b44e-b2b4082d747a runtime=python310 memory-limit=128
```

![img](https://i.imgur.com/bAyuh5l.png)
![img](https://i.imgur.com/UNQuXtn.png)

Malheureusement, on n'a pas trouvé la solution pour modifier le code de notre fonction en ligne de commande dans le CLI. La fonction est en attente de déploiement sur l'interface Web de Scaleway, cela veut dire que l'on peut la modifier avant de la déployer.

Voici la commande de déploiement de la fonction Serverless depuis le CLI :

```
scw function function deploy function-id=4aa60081-e576-46b1-a717-a267c1abb714 name=functionserverlessfromcli namespace-id=41388c5f-d952-4906-b44e-b2b4082d747a region=fr-par
```

![img](https://i.imgur.com/kzvjE9s.png)

<br>

### Cas n°3 : Un équilibreur de charge qui distribue les requêtes sur 3 instances

<br>

* Vous configurez un Load Balancer qui répartit les requêtes entrantes sur 3 serveurs
(de type DEV1_S) différents. Chacun des serveurs héberge un serveur web (nginx ou
apache au choix) avec une page d’index, cette page doit afficher l’id de l’instance (en
fonction de l’instance qui traite la requête). La création des instances est faite via le CLI
Scaleway.

<br>

#### Création des 3 instances de serveur :

Depuis le CLI de Scaleway, on crée 3 instances de serveurs avec les commandes suivantes :

```
Instance 1 :
            scw instance server create type=DEV1-S zone=nl-ams-1 image=ubuntu_jammy root-volume=l:20G name=scw-valentin-clement-instance-1 ip=new project-id=0c1671e0-2f42-4ed2-8799-14f144ecb947

Instance 2 :
            scw instance server create type=DEV1-S zone=nl-ams-1 image=ubuntu_jammy root-volume=l:20G name=scw-valentin-clement-instance-2 ip=new project-id=0c1671e0-2f42-4ed2-8799-14f144ecb947

Instance 3 :
            scw instance server create type=DEV1-S zone=nl-ams-1 image=ubuntu_jammy root-volume=l:20G name=scw-valentin-clement-instance-3 ip=new project-id=0c1671e0-2f42-4ed2-8799-14f144ecb947
```

![img](https://i.imgur.com/a7gXvAt.png)
![img](https://i.imgur.com/n4z3nal.png)

<br>

#### Création du Load Balancer depuis la console Web de Scaleway :

<br>

Lors de la création du Load Balancer, il faut saisir les adresses IP de nos instances de serveur comme indiqué dans les captures ci-dessous :

![img](https://i.imgur.com/SXSrcnA.png)
![img](https://i.imgur.com/yJ6wfy5.png)

<br>

Résultat final du Load Balancer :

![img](https://i.imgur.com/78qBf14.png)

<br>

#### Connexion en SSH aux 3 instances de serveur :

<br>

On se connecte en SSH grâce au IP présente sur chacune des instances de serveur mais ausis grâce à notre clé SSH privé.

![img](https://i.imgur.com/FIu4Flo.png)

Il faut maintenant installé Apache et faire une édition du site d'accueil d'Apache dans le chemin suivant :

```
/var/www/html/index.html
```

La commande d'installation d'Apache :

```
apt update
apt-get install apache2 -y
```

Cette commande permet d'éditer directement le fichier index.html sans avoir à se rendre à l'intérieur :

```
apt-get install apache2 -y && echo "Instance 1" > /var/www/html/index.html
```

Après installation, il faut personnalisé la pache d'accueil d'Apache :

```
nano /var/www/html/index.html

```

![img](https://i.imgur.com/LZ7Z5wg.png)

Une fois sauvegarder il faut relancer Apache afin que les modifications soient prises en comptes :

```
/etc/init.d/apache2 restart
```

![img](https://i.imgur.com/MyKFwpo.png)

Voici les 3 onglets qui amène à la page d'accueil d'Apache. Il faut saisir l'adresse IP des instances de serveur :

![img](https://i.imgur.com/8TFGLLf.png)

Les captures ci-dessous prouvent qu'on a bien éditer le fichier index.html d'Apache comme demandé :

* Instance 1
![img](https://i.imgur.com/5e85D6k.png)

* Instance 2
![img](https://i.imgur.com/NFuN8kU.png)

* Instance 3
![img](https://i.imgur.com/TOSAYdY.png)