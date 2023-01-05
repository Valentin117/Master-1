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

