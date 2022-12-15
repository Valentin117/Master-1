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

a. Qu’apporte le fichier docker-compose par rapport aux commandes docker run ? Pourquoi est-il intéressant ? (cf. ce qui a été présenté pendant le cours)



b. Quel moyen permet de configurer (premier utilisateur, première base de
données, mot de passe root, …) facilement le conteneur mysql au lancement ?


