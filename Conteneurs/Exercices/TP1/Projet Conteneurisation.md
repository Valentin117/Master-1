# **Projet Conteneurisation**
# TP1 - DOCKER

## Exécuter un serveur web (apache, nginx, …) dans un conteneur docker

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

## Builder une image

a. A l’aide d’un Dockerfile, créer une image (commande docker build)



b. Exécuter cette nouvelle image de manière à servir la page html (commande docker run)



c. Quelles différences observez-vous entre les procédures 5. et 6. ? Avantages et inconvénients de l’une et de l’autre méthode ? (Mettre en relation ce qui est observé avec ce qui a été présenté pendant le cours)



-------------------

## Utiliser une base de données dans un conteneur docker

a. Récupérer les images mysql:5.7 et phpmyadmin/phpmyadmin depuis le Docker Hub



b. Exécuter deux conteneurs à partir des images et ajouter une table ainsi que quelques enregistrements dans la base de données à l’aide de phpmyadmin



-------------------

## Faire la même chose que précédemment en utilisant un fichier docker-compose.yml

a. Qu’apporte le fichier docker-compose par rapport aux commandes docker run ? Pourquoi est-il intéressant ? (cf. ce qui a été présenté pendant le cours)



b. Quel moyen permet de configurer (premier utilisateur, première base de
données, mot de passe root, …) facilement le conteneur mysql au lancement ?


