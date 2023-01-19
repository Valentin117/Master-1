# Correction du TP1 Docker

## Question 1
L'installation de docker et docker-compose se fait en suivant les liens de documentation fourni dans le TP

```bash
$ docker -v
Docker version 20.10.7, build f0df350

$ docker-compose -v 
docker-compose version 1.29.1, build c34c88b2
```

Pour la suite de ce TP (et l'utilisation de docker en général), il est préferrable d'ajouter votre utilisateur au groupe Docker. 
Cela permet d'utiliser docker sans être root ou utiliser sudo. Il faut se déconnecter de la session pour que la modification soit prise en compte

```bash
$ sudo adduser $(whoami) docker
```

## Question 2

Voici les commandes git qui sont utiles pour créer votre repo et utiliser correctement celui-ci

```bash
# Se créer un nouveau répertoire et utiliser ce répertoire
$ mkdir TP-Docker && cd TP-Docker

# Vous permet d'initialiser un nouveau repo git dans le repertoire courant
$ git init

# Par la suite à la fin de chaque question vous pouvez utiliser la commande suivante (depuis la racine de votre dépôt git)
$ git commit -am "Question X"

# Pour voir les différents commits présent dans votre repo
$ git log --oneline

# Puis pour aller à l'état du répertoire lors d'une question précise vous pouvez utiliser
$ git checkout [CHECKSUM_COMMIT]
$ git checkout master # Pour revenir au repository complet
```

## Question 3.d

Récupérer l'image nginx et vérifier sa présence en local

```bash
$ docker pull nginx

$ docker image ls
REPOSITORY       TAG          IMAGE ID       CREATED         SIZE
nginx            latest       4146b18ae794   6 days ago     65.7MB
```

La documentation de l'image nginx officielle est disponible sur le Docker Hub : https://hub.docker.com/_/nginx

Créer un conteneur à partir de l'image nginx et servir le fichier html créé
```bash
$ docker run --name my_nginx -p 8080:80 -v $PWD/html:/usr/share/nginx/html -d nginx
```
Explications concernant la commande précédente :
- `docker run` - Permet de démarrer un conteneur à partir d'une image. L'image utilisée est le dernier paramètre de la commande ici `nginx`
- `--name` - Permet de nommer votre conteneur pour le retrouver plus facilement. Ici votre conteneur s'appelle `my_nginx`
- `-p 8080:80` - Connecte le port 8080 de votre local avec le port 80 du conteneur
- `-v <PATH_LOCAL>:<PATH_CONTAINER>` - Crée un montage des fichiers présent dans <PATH_LOCAL> vers <PATH_CONTAINER>
- `-d` - Exécute le conteneur en background (mode detach)

Ouvrez firefox à l'url localhost:8080. Votre page HTML est servie !

Visualiser le conteneur en cours d'exéction (l'option `-a` permet de visualiser tous les conteneurs, y compris ce qui sont arrêtés)
```bash
$ docker container ls
$ docker ps -a
```

Supprimer le conteneur précédemment créé
```bash
# L'option -f permet de le supprimer même si le conteneur est démarré
$ docker container rm -f my_nginx
$ docker rm -f my_nginx

$ docker container stop my_nginx && docker container rm my_nginx
$ docker stop my_nginx && docker rm my_nginx
```

## Question 3.e

```bash
$ docker run -p 8080:80 --name my_nginx -d nginx
```
Rien de nouveau par rapport à la commande de la question 3.d. Il manque seulement le volume qui est remplacé par une copie dans la commande suivante

```bash
$ docker cp html/* my_nginx:/usr/share/nginx/html/
```
Fonctionnement de `docker cp` (Similaire à la commande linux `cp`)
Le premier argument est le fichier ou repertoire à copier
Le second argument représente la destination

Au moins un des deux arguments doit être un conteneur
Pour copier depuis ou vers un conteneur l'argument est composé de deux parties séparé par `:`
```bash
<NOM_DU_CONTENEUR>:<PATH_DANS_LE_CONTENEUR>
```


## Question 4

Build le conteneur décrit dans le fichier Dockerfile
```bash
$ docker build -t siteweb .
```
Explications concernant la commande précédente :
- `docker build` - Permet de constuire une image
- `-t siteweb` - Donne le nom `siteweb` à notre image
- `-f Dockerfile` - Cette option est par défaut. Si votre Dockerfile a un autre nom il faut le spécifier ici !
- `.` - Signifie que le contexte dans lequel sera build cette image est le repertoire courant. Autrement dit, tout ce qui est copié dans l'image le sera de manière relative au reperoire courant


On instancie notre image dans un conteneur
```bash
$ docker run -p 8080:80 --name my_siteweb -d siteweb
```
Contrairement à la question 3, pas d'étape supplémentaire pour consulter notre site web sur localhost:8080. L'image qui a été utilisé pour démarrer le conteneur contient tout ce qu'il faut !

### Question 4.c

Voici les avantages et inconvénients des deux méthodes précédentes :
- Volume :
  - Permet d'éditer des fichiers tout en disposant de l'environnement nécessaire à l'exécution
  - Le conteneur est décoréllé des fichiers applicatifs. Pour envoyer la configuration sur un autre environnement il faut transférer l'image et le code source indépendamment
  - Idéal dans un environnement de développement 
- Image :
  - Pratique pour partager, livrer  directement une application   
  - L'image est immuable, il est difficile de faire des modifications sans volume
  - Idéal dans un environnement de production / preproduction

## Question 5

Récupérer les images depuis le Docker Hub
```bash
$ docker pull mysql

$ docker pull phpmyadmin
```

Exécuter les conteneurs
```bash
$ docker run --name mysql_container -p 3306:3306 -e MYSQL_DATABASE=ynov -e MYSQL_USER=user -e MYSQL_PASSWORD=pwd -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql

$ docker run --name phpmyadmin_container --link mysql_container -e PMA_HOST=mysql_container -p 8080:80 -d phpmyadmin
```
L'option `--link` permet de relier d'un point de vue réseau le conteneur phpmyadmin avec le conteneur mysql
Les options `-e` permettent de passer des valeurs à des variables d'environnements. Ces variables d'environnements permettent de configurer les conteneurs lors de l'exécution. L'effet des différentes variables d'environnement est décrit sur le Docker Hub

## Question 6

Le fichier `docker-compose.yml` permet de décrire les conteneurs, appelés service dans le cas de docker-compose, qui définissent une application.
```bash
# Démarre tous les conteneurs tel que spécifié dans le fichier docker-compose.yml
$ docker-compose up

# Arrête les conteneurs
$ docker-compose stop
```

Les avantages de ce fichier sont les suivants :
- Permet de tracer ce qui est fait (le fichier peut être versionné avec le code source)
- Le fichier utilise la syntaxe YAML qui rend la configuration plus lisible que les lignes de commande docker