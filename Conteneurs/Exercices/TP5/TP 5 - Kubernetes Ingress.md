# TP 5 - Kubernetes Ingress

## 1. Installer Kind et créer votre premier cluster

Suivre cette documentation : https://kind.sigs.k8s.io/docs/user/quick-start/

Commandes d'installation sous Linux : 

```
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

```
kind create cluster --name kind-1
```

![](https://i.imgur.com/lWlX7Lr.png)


Afin de lister les clusters kind, il faut utiliser la commande `kind get clusters` ou `kind get pods`.

Pour intéragir avec les différents clusters, il faut utiliser la commande suivante : 

```
kubectl cluster-info --context kind-<name du cluster kind>
kubectl cluster-info --context kind-kind-2
```

Afin de supprimer les clusters kind, il faut utiliser la commande `kind delete cluster`.

## 2. Installer le Nginx ingress Controller

Suivre cette documentation : https://kind.sigs.k8s.io/docs/user/ingress/#ingress-nginx

Executer les commandes suivantes en une seule fois : 

```
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF
```

Maintenant, il faut installer Nginx Ingress PODS avec un cluster via la commande suivante `kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml`.

![](https://i.imgur.com/fEZspi3.png)

Avec la commande `kubectl get pods -A` : 

![](https://i.imgur.com/7MlkKpV.png)

On va essayer de voir si l'Ingress est fonctionnel avec les commandes suivantes : 

```
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
```

![](https://i.imgur.com/wNeW6V5.png)

On re fait la commande `kubectl get pods -A` : 

![](https://i.imgur.com/iz645nK.png)

A ce moment là, il faut créer un fichier `ingress.yaml` : 

```
kind: Pod
apiVersion: v1
metadata:
  name: foo-app
  labels:
    app: foo
spec:
  containers:
  - command:
    - /agnhost
    - netexec
    - --http-port
    - "8080"
    image: registry.k8s.io/e2e-test-images/agnhost:2.39
    name: foo-app
---
kind: 
apiVersion: v1
metadata:
  name: foo-service
spec:
  selector:
    app: foo
  ports:
  # Default port used by the image
  - port: 8080
---
kind: Pod
apiVersion: v1
metadata:
  name: bar-app
  labels:
    app: bar
spec:
  containers:
  - command:
    - /agnhost
    - netexec
    - --http-port
    - "8080"
    image: registry.k8s.io/e2e-test-images/agnhost:2.39
    name: bar-app
---
kind: Service
apiVersion: v1
metadata:
  name: bar-service
spec:
  selector:
    app: bar
  ports:
  # Default port used by the image
  - port: 8080
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
spec:
  rules:
  - http:
      paths:
      - pathType: Prefix
        path: /foo(/|$)(.*)
        backend:
          service:
            name: foo-service
            port:
              number: 8080
      - pathType: Prefix
        path: /bar(/|$)(.*)
        backend:
          service:
            name: bar-service
            port:
              number: 8080
---
```

Pour réaliser notre déploiement, il faut utiliser la commande `kubectl apply -f ingress.yaml`.

![](https://i.imgur.com/EoA9Bp0.png)

Afin de lister les deploiements, il faut utiliser la commande `kubectl get deployments -A` (ou `kubectl get pods -A`).

Afin de supprimer un déploiment, il faut utiliser la commande `kubectl delete deployement <name> --namespace=<namespace de deploiement>`.

Il faut maintenant tester le résultat : 

```
curl localhost
```

Il faut éditer le fichier `hosts` et ajouter notre DNS : 

![](https://i.imgur.com/4LXuBPj.png)

```
curl ingress-tp
```

![](https://i.imgur.com/097Llew.png)

Should output "foo-app" : `curl localhost/foo/hostname`

Should output "bar-app" : `curl localhost/bar/hostname`

## 3. Compléter le schéma suivant avec des objets Kubernetes

![](https://i.imgur.com/7A9wzOs.png)

## 4. Builder et publier (à partir de l’image nginx) sur le DockerHub, une image docker pour chacun des sites web présent sur le schéma précédent. Vous devez avoir 3 images (une par magasin tacos, pizzas et burgers)

Création d'un Dockerfile pour les 3 sites (pizza, tacos et burgers) : 

*C'est à dire que l'on va créer 3 dossiers pour chaque site, avec chacun leur Dockerfile et leur index.html.*

```
FROM nginx:latest
COPY index.html /usr/share/nginx/html
```

Le Dockerfile sera identique à tous les sites, seul le `index.html` va être différent.

Création d'un fichier `index.html` pour chaque site : 

- **Site Pizza**

```
<!DOCTYPE html>
<html>
<head>
  <title>Pizza</title>
</head>
<body>
  <h1>Liste des Pizza</h1>
  <ul>
    <li>La Pizza del Padre</li>
    <li>La chaud devant</li>
    <li>Pizza 10 fromages</li>
  </ul>
</body>
</html>
```

- **Site Tacos**

```
<!DOCTYPE html>
<html>
<head>
  <title>Tacos</title>
</head>
<body>
  <h1>Liste de Tacos</h1>
  <ul>
    <li>Taco de carne asada</li>
    <li>Taco de camarón</li>
    <li>Taco de pollo</li>
    <li>Taco de chorizo</li>
  </ul>
</body>
</html>
```

- **Site Burgers**

```
<!DOCTYPE html>
<html>
<head>
  <title>Burgers</title>
</head>
<body>
  <h1>Liste des Burgers</h1>
  <ul>
    <li>En 2 crocs !</li>
    <li>Big Mag</li>
    <li>Le GIANT</li>
  </ul>
</body>
</html>
```

Une fois les `index.html` prêts, il faut faire les commandes suivantes dans chaque dossier : 

```
docker build -t eatsout:pizza .
docker build -t eatsout:tacos .
docker build -t eatsout:burgers .
```

![](https://i.imgur.com/j5QLmiZ.png)

![](https://i.imgur.com/VriGtpR.png)

![](https://i.imgur.com/ysxtEfy.png)

Il faut maintenant se connecter à son compte Docker : 

*Si ce n'est pas fait, il vous fait créer un compte sur Docker-Hub et valider la vérification de mail*

```
docker login -u <username>
```

Maintenant que la connexion est établi, on va taguer les images Docker avant de les push sur Docker-Hub : 

```
docker tag eatsout:pizza valentin117/eatsout:pizza
docker tag eatsout:tacos valentin117/eatsout:tacos
docker tag eatsout:burgers valentin117/eatsout:burgers
```

Une fois fait, on va push sur Docker-Hub les images Docker : 

```
docker push valentin117/eatsout:pizza
docker push valentin117/eatsout:tacos
docker push valentin117/eatsout:burgers
```

![](https://i.imgur.com/WGOy3K3.png)

![](https://i.imgur.com/1tk59kI.png)

![](https://i.imgur.com/PolJYH5.png)

A la fin, il doit y avoir ceci sur le Docker-Hub : 

![](https://i.imgur.com/ujqOlvV.png)

![](https://i.imgur.com/cR1Nnjk.png)

## 5. Ecrire les fichiers yaml vous permettant de déployer sur votre cluster kind installé en local les composants décrits sur le schéma de la question 3 et les images crées à la question 4

Pour la suite, il va falloir créer 2 nouveaux fichiers pour déployer le cluster ainsi que les images et leurs services associés et l'Ingress.

Création d'un fichier `services.yaml` qui va contenir nos 3 services : 

```
apiVersion: v1
kind: Service
metadata:
  name: pizza-services
spec:
  selector:
    app: pizza
  ports:
  - name: http
    port: 80
    targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pizza-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: pizza
  template:
    metadata:
      labels:
        app: pizza
    spec:
      containers:
      - name: pizza
        image: valentin117/eatsout:pizza
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: tacos-services
spec:
  selector:
    app: tacos
  ports:
  - name: http
    port: 80
    targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tacos-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tacos
  template:
    metadata:
      labels:
        app: tacos
    spec:
      containers:
      - name: tacos
        image: valentin117/eatsout:tacos
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: burgers-services
spec:
  selector:
    app: burgers
  ports:
  - name: http
    port: 80
    targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: burgers-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: burgers
  template:
    metadata:
      labels:
        app: burgers
    spec:
      containers:
      - name: burgers
        image: valentin117/eatsout:burgers
        ports:
        - containerPort: 80
```

Création d'un fichier `ingress.yaml` qui va regrouper nos 2 sites (pizza et tacos + burgers): 

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: pizza.eatsout.com
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: pizza-services
            port:
              number: 80
  - host: tacosetburgers.eatsout.com
    http:
      paths:
      - pathType: Prefix
        path: "/tacos"
        backend:
          service:
            name: tacos-services
            port:
              number: 80
      - pathType: Prefix
        path: "/burgers"
        backend:
          service:
            name: burgers-services
            port:
              number: 80
```

Avant de faire le déploiement de nos 2 fichiers, il faut modifier encore une fois le fichier `/ect/hosts` : 

![](https://i.imgur.com/lqxg9m8.png)


Il est temps de faire le déploiement avec les commandes suivantes : 

```
kubectl apply -f services.yaml
kubectl apply -f ingress.yaml
```
![](https://i.imgur.com/oiJZrmn.png)

![](https://i.imgur.com/fy8SI78.png)

Maintenant, il faut voir si nos sites fonctionnent avec les commandes suivantes : 

```
curl pizza.eatsout.com
curl tacosetburgers.eatsout.com
curl tacosetburgers.eatsout.com/tacos
curl tacosetburgers.eatsout.com/burgers
```
![](https://i.imgur.com/PZbp1vY.png)

![](https://i.imgur.com/WZCZFtH.png)

![](https://i.imgur.com/pzPvjYK.png)

## 6. Votre magasin de tacos devient très populaire (il va avoir 3 fois plus de commandes).

Il va vous falloir gérer une charge importante sur le Service de commande des burgers.
Comment gérez-vous cela ? Comment vérifier que la charge est bien répartie (avec quelle commande kubectl ?) ?

Pour se faire, on peut augmenter le nombre de ReplicaSet, valeur défini par service dans le fichier `services.yaml`.

Dans notre cas, pour la forte demande de commandes de burgers, on peut changer le ReplicaSet par défaut 1 à 5 : 

```
...
...
...
---
apiVersion: v1
kind: Service
metadata:
  name: burgers-services
spec:
  selector:
    app: burgers
  ports:
  - name: http
    port: 80
    targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: burgers-deployment
spec:
  replicas: 5
  selector:
    matchLabels:
      app: burgers
  template:
    metadata:
      labels:
        app: burgers
    spec:
      containers:
      - name: burgers
        image: valentin117/eatsout:burgers
        ports:
        - containerPort: 80
```

En exécutant la commande `kubectl get all`, on peut voir que le nombre de ReplicaSet a changé de 1 à 5 : 

![](https://i.imgur.com/rEGqkxV.png)

![](https://i.imgur.com/O7uMz37.png)

Les multiples Pods qui viennent d'être générer vont être automatiquement gérer et reconnu par le service associé (burgers-services).

Pour voir les réplications en fonction et plus ample information : 

```
kubectl get rs
```

![](https://i.imgur.com/fuk2vCX.png)

```
kubectl describe rs/<name du ReplicaSet>
```

![](https://i.imgur.com/uvqIH2h.png)

Afin de vérifier que la charge est bien répartie avec les différents Pods, il faut utiliser la commande `kubectl logs -f deploy/burgers-deployment`.
Et en parallèle executer la commande `curl tacosetburgers.eatsout.com/burgers` plusieurs fois.

*Les logs sont en temps réel*

![](https://i.imgur.com/1gtFqoa.png)

On peut voir avec les logs quel est le Pod qui répond aux requêtes `curl` qu'on exécute. Malheureusement, le faible de requête ne permet pas de montrer qu'il y a un changement de Pod dans les logs.