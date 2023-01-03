# **Projet Conteneurisation**
# TP2 - DOCKER

## Mise en pratique - Docker Application Express JS

<br>
-------------------
### 1. Récupérer le zip TP-2-Docker.zip sur Moodle

<br>
Initialiser un nouveau repository git qui vous permettra de sauvegarder les fichiers créés pendant le TP. Vous enverrez un zip du repository à la fin du TP avec vos réponses aux questions / exécutions et résultats sur la console dans un fichier Markdown.
<br>

**Utilisez git progressivement ! (Ne pas faire qu'un seul commit à la fin)**

<br>

-------------------

### 2. Compléter le Dockerfile afin de builder correctement l'application contenu dans src/

a. Une option de npm vous permet de n’installer que ce qui est nécessaire. 
Quelle est cette option ? Quelle bonne pratique Docker permet t-elle derespecter ?

<br>

Afin d'installer que les modules qui sont nécessaires à l'application, on peut utiliser dans le Dockerfile une option ```production``` de npm.

**Dockerfile au départ :**
```
FROM node:12-alpine3.9

...

CMD ["node", "src/index.js"]
```

**Dockerfile après changement :**
```
FROM node:12-alpine3.9

COPY . .

# Permet d'installer les modules que l'on a besoin
RUN npm install --production

CMD ["node", "src/index.js"]
```

Cette option, va permettre d'installé les modules qui sont listés dans la section ```dependencies``` du fichier ```package.json```, ce qui va permettre d'installer seulement les modules nécessaires à l'application (sans superflux). Ce qui permettra de limiter la taille du conteneur ainsi que les performances de celui-ci (conteneur et application).

```
{
  "name": "docker-tp2",
  "version": "1.0.0",
  "description": "",
  "main": "src/index.js",
  "author": "Ynov",
  "dependencies": {
    "express": "^4.16.1",
    "mysql": "2.18.1"
  },
  "devDependencies": {
    "eslint": "^6.3.0",
    "jest": "^24.9.0"
  }
}
```

-------------------

### 3. A l'aide de la commande docker build, créer l'image ma_super_app

<br>

Afin de pouvoir créer l'image avec la commande ```docker build```, il faut utiliser une option supplémentaire ```-f``` qui va permettre d'utiliser le fichier Dockerfile mis à notre disposition. Pour cette option, il faut indiquer le chemin menant à notre fichier Dockerfile.
Et l'option ```-t``` permet de donner un nom à notre image.

```
docker build -f Dockerfile -t ma_super_app .
```

Après utilisation de la commande, on obtient notre image ma_super_app . Si l'on veut, on peut démarrer un conteneur à partir de cette image en utilisant la commande ```docker run```

```
docker run ma_super_app
```

-------------------

### 4. Compléter le fichier docker-compose.yml afin d'exécuter ma_super_app avec sa base de données
<br>

/!\ **Utiliser correctement les variables d’environnement afin de configurer la base de données et l’application** /!\

<br>

Afin de pouvoir exécuter une application qui va nécessité une base de données en utilisant Docker Compose, il va falloir séparer le docker-compose.yml en 2 services (```db``` et ```app```).

**docker-compose.yml au départ :**
```
version: '3.9'
  services:
    node:
      ...

    mysql:
      ...

```

**docker-compose.yml après changement :**
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
  app:
    image: "ma_super_app"
    links:
      - mysql:db
    ports:
      - "3000:3000"
    depends_on:
      - mysql:db
```

Une fois le fichier prêt, pour l'exécuter, il faut utiliser la commande ```docker-compose up``` dans le même répertoire que le fichier. Cela va permettre de créer le conteneur utilisant les 2 services en simultanés.
Pour arrêter notre application, on réutilise le commande ci-dessus mais on remplace ```up```  par ```down```.