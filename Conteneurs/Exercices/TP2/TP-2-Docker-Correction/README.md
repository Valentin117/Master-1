# Correction du TP1 Docker

## Question 1

Voici les commandes git qui sont utiles pour créer votre repo et utiliser correctement celui-ci

```bash
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

## Question 2.a

L'option `--production` de la commande `npm install` ne permet d'installer que les dépendances nécessaires dans l'image de l'application. De cette manière, les dépendances nécessaires pour le développement ne sont pas installées.

## Question 3

```bash
$ docker build -t ma_super_app .
```

Explications concernant la commande précédente :
- `docker build` - Permet de construire une image à partir d'un Dockerfile. Par défaut (sans spécifier l'option -f) le fichier utiliser se nomme Dockerfile.
- `-t` - Permet de nommer votre image sous la forme <IMAGE>:<TAG> où le TAG représente en général une version données de l'image. Ici l'image s'appelle `ma_super_app` et elle ne possède pas de tag.
- `.` - Spécifie le contexte de build pour l'image. C'est à dire le chemin local depuis lequel sera construite l'image. Toutes les actions COPY ou RUN effectué pendant le build de l'image seront faites à partir de ce chemin.

## Question 4

Après avoir complété le docker-compose.yml, la commande `docker-compose up -d` permet d'éxécuter l'application et sa base de données dans deux conteneurs différents. L'option `-d` permet une exécution détachée (en background). 