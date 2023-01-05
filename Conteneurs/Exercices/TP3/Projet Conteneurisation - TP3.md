# **Projet Conteneurisation**
# TP3 - DOCKER

## Création d'un environnement de développement Web PHP
<br>
Préparer un fichier docker-compose.yml permettant de créer un environnement de développement Web PHP.

Vous devrez avoir les services suivants :

* Apache
* PHP
* Mysql
* phpmyadmin

Une fois votre environnement docker démarré, vous devez être capable de développer de nouvelles lignes de codes et de les voir en action sans faire de nouvelles actions sur votre environnement Docker.

```
version: '3.9'
services:
  apache:
    image: "httpd:2.4"
    ports:
      - "80:80"
    volumes:
      - ./www:/usr/local/apache2/htdocs
    links:
      - php
  php:
    image: "php:7.2-fpm"
    volumes:
      - ./www:/var/www/html
  mysql:
    image: "mysql:5.7"
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: mysql
      MYSQL_USER: valentin
      MYSQL_PASSWORD: malo
    volumes:
      - ./db:/var/lib/mysql
  phpmyadmin:
    image: "phpmyadmin"
    environment:
      PMA_HOST: mysql
      PMA_USER: valentin
      PMA_PASSWORD: malo
    ports:
      - "8080:80"
```

Lorsque notre fichier docker-compose.yml est prêt à l'emploi, il faut exécuter la commande suivante pour démarrer notre environnement :

```
docker-compose up

# La commande docker-compose up suivi de l'option -d permet de lancer le conteneur en arrière plan, permettant ainsi de continuer à utiliser la machine

docker-compose up -d
```

- Pour accéder à la page de PHPMyAdmin, sur le navigateur il faut saisir l'url suivant : 

```
http://localhost:8080
```

![](https://i.imgur.com/bzF4yU7.png)

- Pour accéder à la page de l'application, sur le navigateur il faut saisir l'url suivant : 

```
http://localhost
```

![](https://i.imgur.com/9Xb7CkM.png)

### Explication des différents services utilisés dans notre ```docker-compose.yml```

Le service Apache utilise l'image Apache ```httpd:2.4```. Il expose le port 80 sur le port 80 de notre machine. Le répertoire que l'on utilise ```./www``` de notre machine est monté sur ```/usr/local/apache2/htdocs``` dans notre conteneur.

Le service PHP utilise l'image ```php:7.2-fpm```. Le répertoire ```./www``` est monté sur ```/var/www/html``` dans notre conteneur.

Le service MySQL utilise l'image MySQL ```mysql:5.7```. Il définit plusieurs variables d'environnement pour la configuration notre mot de passe root, notre base de données et de l'utilisateur. Le répertoire ```./db``` de notre machine hôte est monté sur ```/var/lib/mysql``` dans notre conteneur, afin de pouvoir accéder aux données de notre base de données.

Le service PHPMyAdmin utilise l'image PHPMyAdmin ```phpmyadmin```. Il expose le port 80 sur le port 8080 de notre machine. Il définit aussi des variables d'environnement pour pouvoir se connecter à la base de données MySQL.