# **Projet Conteneurisation**
# TP1 - DOCKER

## 5. Exécuter un serveur web (apache, nginx, …) dans un conteneur docker

a. Récupérer l’image sur le Docker Hub

```
docker pull nginx
```

b. Vérifier que cette image est présente en local

![Image Nginx](https://i.imgur.com/eefc8ns.png)

c. Créer un fichier index.html simple

```
touch index.html
```
```
<!DOCTYPE html>
<html>
<head>
  <title>Mon premier fichier HTML</title>
</head>
<body>
  <h1>Bienvenue sur mon site web !</h1>
  <p>Ceci est mon premier fichier HTML.</p>
</body>
</html>
```

d. Démarrer un conteneur et servir la page html créée précédemment à l’aide d’un volume (option -v de docker run)

```
docker run --name serveur-nginx -d -p 80:80 -v /home/valentin/Documents/Master1/Master-1/Conteneurs/Exercices/TP1/:/usr/share/nginx/html nginx
```

```
docker ps
```

![Docker Nginx Run](https://i.imgur.com/bU1S3dt.png)
<br>
![Nginx Index HTML](https://i.imgur.com/X1Cbd76.png)

e. Supprimer le conteneur précédent et arriver au même résultat que
précédemment à l’aide de la commande docker cp

```
docker stop serveur-nginx
docker rm serveur-nginx
docker run --name serveur-nginx -d -p 80:80 nginx
docker cp /home/valentin/Documents/Master1/Master-1/Conteneurs/Exercices/TP1/index.html serveurnginx:/usr/share/nginx/html/index.html
```

![Page Web Nginx](https://i.imgur.com/8kouyDm.png)
<br>
![Nginx Index HTML](https://i.imgur.com/X1Cbd76.png)

-------------------

## 6. Builder une image

a. A l’aide d’un Dockerfile, créer une image (commande docker build)

```
touch Dockerfile
```

```
FROM nginx:latest

COPY index.html /usr/share/nginx/html
```

```
docker build -t nginx2 .
```

![Build Image](https://i.imgur.com/BbliQAR.png)
<br>
![Docker Images](https://i.imgur.com/FkV9zL7.png)

b. Exécuter cette nouvelle image de manière à servir la page html (commande docker run)

```
docker run -p 80:80 -t nginx2
```

![Docker Run](https://i.imgur.com/v9jdZnP.png)
<br>
![Nginx Index HTML](https://i.imgur.com/X1Cbd76.png)

c. Quelles différences observez-vous entre les procédures 5. et 6. ? Avantages et inconvénients de l’une et de l’autre méthode ? (Mettre en relation ce qui est observé avec ce qui a été présenté pendant le cours)

La différence entre les 2, est que dans la 2nd méthode où l'on construit une image, c'est que l'on peut modifier comme on veut notre Dockerfile et créer tant que l'on veut d'images à partir de ce Dockerfile, on peut donc en faire plusieurs version et les adapter comme on le veut suivant la situation ou le problème que l'on rencontre.
Et on a juste à lancer un container avec la version de l'image que l'on souhaite et on obtient notre container sans passer par des phases de récupération d'image sur Docker Hub.

Un Dockerfile est simplement un fichier de configuration utilisé dans le cas de création d'image Docker, tandis que l'autre méthode (partie 5) utilise des commandes pour copier des fichiers entre un conteneur et un hôte/autre conteneur.

-------------------

## 7. Utiliser une base de données dans un conteneur docker

a. Récupérer les images mysql:5.7 et phpmyadmin/phpmyadmin depuis le Docker Hub

```
docker pull mysql:5.7
docker pull phpmyadmin/phpmyadmin
```

b. Exécuter deux conteneurs à partir des images et ajouter une table ainsi que quelques enregistrements dans la base de données à l’aide de phpmyadmin

```
docker run --name mysql -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7
```

```
docker run --name adminphp -p 80:80 --link mysql:db -d phpmyadmin/phpmyadmin
```

![Containers](https://i.imgur.com/h9RrQbK.png)
<br>
![PhpMyAdmin](https://i.imgur.com/44yZUbe.png)

Connexion à PhpMyAdmin : 
+ Utilisateur : root
+ Mot de passe : root

![Create New Table](https://i.imgur.com/9S0w5vD.png)

-------------------

## 8. Faire la même chose que précédemment en utilisant un fichier docker-compose.yml

```
touch docker-compose.yml
```

```
version: "3.9"
services:
  mysql:
    image: "mysql:5.7"
    environment:
      - MYSQL_ROOT_PASSWORD=root
  adminphp:
    image: "phpmyadmin"
    links:
      - mysql:db
    ports:
      - "80:80"
```

```
docker compose up
```

![Docker Compose](https://i.imgur.com/UPL7iBH.png)
<br>
![PhpMyAdmin](https://i.imgur.com/zhR7oSi.png)

```
docker compose up -d
```

Le -d est une option qui permet d'exécuter la commande en arrière plan et qui nous permet d'avoir toujours la main pour effectuer de nouvelles tâches.

![Arrêt Docker compose et lancent en arrière plan](https://i.imgur.com/k4MMDdJ.png)

a. Qu’apporte le fichier docker-compose par rapport aux commandes docker run ? Pourquoi est-il intéressant ? (cf. ce qui a été présenté pendant le cours)

Le fichier Docker-compose permet de lancer en une seule commande 2 containers en simultané au lieu de lancer chaque container un par un afin qu'il exécute nos images. En utilisant une configuration unique. Cela permet aussi de faciliter la gestion des conteneurs et leur exécution en production car on définit toute la configuration dans un seul fichier et on utilise une seule commande pour exécuter tous les conteneurs.

On peut l'utiliser dans le cas d'application complexe nécessitant plusieurs conteneurs, au lieu d'utiliser plusieurs fois la commande docker run pour chaque conteneur qu'on a besoin.

b. Quel moyen permet de configurer (premier utilisateur, première base de données, mot de passe root, …) facilement le conteneur mysql au lancement ?

Pour configurer facilement un conteneur mysql au lancement, on peut utiliser les variables d'environnement directement dans notre Docker-compose, en utilisant l'option ```environment```.

```
version: "3.9"
services:
  mysql:
    image: "mysql:5.7"
    environment:
      - MYSQL_USER=valentin
      - MYSQL_PASSWORD=malo
      - MYSQL_DATABASE=mysql
      - MYSQL_ROOT_PASSWORD=root
```

-------------------

## 9. Observation de l’isolation réseau entre 3 conteneurs

a. A l’aide de docker-compose et de l’image praqma/network-multitool disponible sur le Docker Hub créer 3 services (web, app et db) et 2 réseaux (frontend et backend).
Les services web et db ne devront pas pouvoir effectuer de ping de l’un vers l’autre.

```
docker pull praqma/network-multitool
```

![Docker Images](https://i.imgur.com/WCaSUxz.png)

```
version: "3.9"
services:
  web:
    image: "praqma/network-multitool"
    networks:
      - frontend
  app:
    image: "praqma/network-multitool"
    networks:
      - frontend
      - backend
  db:
    image: "praqma/network-multitool"
    networks:
      - backend

networks:
  frontend:
  backend:
```

```
docker compose up
```

![Docker Inspect](https://i.imgur.com/nNBesyX.png)

Il est impossible que les 2 services puissent se ping, il ne se trouve pas dans le même réseau. Seulement le servie app peut communiquer avec les 2 autres services car il se trouve dans les 2 réseaux.

b. Quelles lignes du résultat de la commande docker inspect justifient ce comportement ?

```
docker network inspect tp1_web-1 | grep "Network"
docker network inspect tp1_db-1 | grep "Network"
docker network inspect tp1_app-1 | grep "Network"
```

Cf. la capture ci-dessus.

Pour vérifier les différents services (web et db) ne peuvent pas se ping, on utilise la commande ```docker netword inspect``` pour afficher les informations sur les réseaux et services connectés à chacun d'eux.

On peut voir sur la capture ci-dessus, que les 2 services ne se ping pas car les 2 services sont connectés à des réseaux différents (```frontend``` et ```backend```) et ont des IP différentes.

c. Dans quelle situation réelles (avec quelles images) pourrait-on avoir cette configuration réseau ? Dans quel but ?

On pourrait l'utiliser dans le cas d'un multi-cloud, si on utilise plusieurs Cloud Provider, si l'on utilise leur service pour héberger nos différents services.
On peut aussi l'utiliser dans un environnement d'application où l'application serait divisé en plusieurs services qui communiquent entre eux via les réseaux.
