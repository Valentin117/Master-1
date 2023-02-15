# TP CLUSTER KUBERNETES - 02/02/2023

Voici la doc qu'il faut suivre pour réaliser le TP : [Kubernetes Cluster](https://arcahub.github.io/kube-install-tuto/introduction.html)

Il sera nécessaire pour le TP de faire un clone d'un répository pour le Terraform : [Kubernetes Install Tuto](https://github.com/Arcahub/kube-install-tuto)

## Déployer le cluster :

Le première objectif de l'exercice est d'installer 2 instances Scaleway, une qui sera notre Controle Management (gérer le cluster en amont) et deux qui seront nos Worker, qui gêreront les applications liés au cluster.

1. Création de notre clé SSH sur notre machine

`ssh keygen`

2. (Obligatoire) Création d'une clé API pour l'utilisation de Scaleway en CLI et pour l'exécution du Terraform

Lien pour créer votre clé API : [Clé API Scaleway](https://console.scaleway.com/project/credentials)

Pour finaliser la connexion entre votre machine et Scaleway, saisissez les commandes suivantes : 

```
apt install curl
sudo curl -o /usr/local/bin/scw -L "https://github.com/scaleway/scaleway-cli/releases/download/v2.6.0/scaleway-cli_2.6.0_linux_amd64"
sudo chmod +x /usr/local/bin/scw
```

Une fois l'installation de Scaleway CLI installé, saisissez la commande `scw init` puis entrez les identifiants demandés (secret-key).

A partir de ce moment là, vous pourrez exécuter les commandes suivantes plus tard pour démarrer votre Terraform : 

+ scw init
+ scw plan
+ scw apply
+ scw destroy

Créer une instance Scaleway : 

+ Via l'interface graphique de Scaleway
+ Via des commandes CLI

Une fois les 2 instances créés, pour vous connectez à une de vos instances, utilisez la commande récupéré sur l'interface de votre instance : 

![](https://i.imgur.com/PpfFqxv.png)

## Installation de Kubernetes sur les 3 instances

1. Préparation du noeud

Préparation du noeud en activant les modules réseaux nécéssaire : 

```
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
```

2. Installation de containerd

Pour installer containerd, il faut ajouter le référentiel docker dans le gestionnaire de paquets : 

```
# Install required packages for https repository
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl
# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# Add Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# Update package manager index
sudo apt-get update
```

Ceci fait, vous pouvez exécuter la commande `sudo apt-get install -y containerd.io` pour installer containerd.

Une fois l'installation terminé, il faut configurer containerd pour utiliser le pilote `systemd cgroup` : 

```
sudo mkdir -p /etc/containerd
sudo containerd config default > /etc/containerd/config.toml
```

Maintenant sur les 3 instances, il faut éditer le fichier `config.toml` dans le chemin `/etc/containerd/` : 

`sudo nano /etc/containerd/config.toml`

Trouver la section `[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]` puis la valeur `SystemCgroup`.

Une fois trouvé, la valeur par défaut est défini sur `false`. Remplacez `false` par `true`.

![](https://i.imgur.com/7YTqs0l.png)

Une fois le changement effectué, sauvegardez puis exécutez la commande `sudo systemctl restart containerd`.

3. Vérification de l'installation de containerd

Exécutez les commandes suivantes pour vérifier l'installation : 

```
ctr images pull docker.io/library/hello-world:latest
sudo ctr run --rm docker.io/library/hello-world:latest hello-world
ctr images rm docker.io/library/hello-world:latest
```

Le message ci-dessous doit vous être affiché :

![](https://i.imgur.com/jh3p3Wt.png)

4. Installation de kubeadm, kubelet et kubectl

Pour les 3 installations, il faut utiliser le gestionnaire de paquets Ubuntu : 

```
# Install required packages for https repository
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
# Add Kubernetes’s official GPG key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# Add Kubernetes repository
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
# Update package manager index
sudo apt-get update
# Install kubeadm, kubelet and kubectl with the exact same version or else components could be incompatible
sudo apt-get install -y kubelet=1.25.0-00 kubeadm=1.25.0-00 kubectl=1.25.0-00
# Hold the version of the packages
sudo apt-mark hold kubelet kubeadm kubectl
```

La dernière ligne permet d'éviter les mises à jour automatique de nos composants requis pour Kubernetes par le gestionnaire de paquets.

## Configuration du noeud de plan de notre instance Controler

1. Initialisation de notre noeud Controler

Pour nos instances sur Scaleway, on utilise des IP publiques. Afin d'initialiser le noeud de notre Controler avec kubeadm, il faut exécuter la commande suivante : 

```
sudo kubeadm init --control-plane-endpoint 51.158.183.133:6443
```

Dans la commande il s'agit de l'IP publique suivi du port par défaut 6443.

2. Configuration de `kubeconig`

Ensuite, il faut configurer kubeconfig afin de pouvoir utiliser les commandes `kubectl`.

Avec les commandes qui vont suivre, on va copier le fichier de configuration se trouvant dans son emplacement par défaut, le copier dans un autre emplacement et modifier les propriété du fichier : 

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

3. Vérification

Afin de vérifier que cela est fonctionnel, exécutez la commande `kubectl get nodes` : 

![](https://i.imgur.com/sAk3VaY.png)

4. Installation plugin CNI (Container Netxork Interface)

Poursuivons en installant le plugin CNI  afin de permettre aux Pods de communiquer entre eux.

En saisissant la commande `kubectl get pods --all-namespaces`, vous devrez avoir plus `kube-system`, 7 en tout dont 2 en attente.

![](https://i.imgur.com/BzqwzGm.png)

Pour palier à se problème, le plugin CNI est un plugin réseau qui va permettre à nos Pods de communiquer.

Dans notre cas, nous utiliserons le plugin `Weave Net`. Executez la commande `kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml` pour réaliser son installation.

Puis les commandes suivantes : 

```
kubectl -n kube-system wait pod -l name=weave-net --for=condition=Ready --timeout=-1s
kubectl get pods -l name=weave-net -n kube-system
```

![](https://i.imgur.com/fE0M3a2.png)

5. Vérification

Après un temps d'attente, on peut refaire la commande `kubectl get nodes` et `kubectl get pods --all-namespaces`.

![](https://i.imgur.com/b9dOfIF.png)

![](https://i.imgur.com/sGaWaYo.png)

Les 2 Pods qui étaient avant en attente, sont maintenant prêtes et un nouveau Pod s'est ajouté.

6. Ajout des instances Worker au cluster de notre instance Controler

Sur l'instance Controler, exécutez la commande `kubeadm token create --print-join-command` : 

![](https://i.imgur.com/KBR5nZO.png)

Faites un copier du résultat : 

```
kubeadm join 51.158.183.133:6443 --token jbdtzc.i489ucb60mlmjx6l --discovery-token-ca-cert-hash sha256:59d7d6dd97f333cea399a3377ce83a8b88f949079e2b7f44899847fab4044144
```

Ensuite avec cette commande, il faut l'exécuter sur nos 2 instances Worker afin qu'il rejoigne le cluster : 

![](https://i.imgur.com/kQVswr9.png)

On peut vérifier que cela est fonctionnel sur l'instance Controler (Master) avec la commande `kubectl get nodes` :

![](https://i.imgur.com/CyGlCVo.png)

On remarque qu'on a installé précédement un plugin CNI afin que notre noeud soit prêt et pour que l'on puisse ajouter nos Pods au cluster.

## Les Pods statiques

1. Afficher les Pods statiques

Exécutez la commande `sudo ls /etc/kubernetes/manifests` : 

![](https://i.imgur.com/v2nyJ6p.png)

Pour vérifier si un Pod s'exécute dans l'espace de nom `kube-system`, on utilise la commande `kubectl get pods --namespace=kube-system` : 

![](https://i.imgur.com/0kRboHv.png)

2. Jouons avec les Pods statiques

On va détruire le Pod `kube-apiserver` avec une commande `kubectl` : 

```
# kubectl delete pod <kube-apiserver-pod-name> --namespace=kube-system
kubectl delete pod kube-apiserver-scw-instance-master --namespace=kube-system
```

![](https://i.imgur.com/ckIq8cm.png)

On peut voir qu'après la suppression, la Pod a été recréer instantanément.

On va donc essayer de supprimer directemnt le fichier du Pod `kube-apiserver` : 

```
# We only move the file to another location to be able to restore it later, what's important is that the file is deleted from the static pod directory
sudo mv /etc/kubernetes/manifests/kube-apiserver.yaml ~/kube-apiserver.yaml
```

On exécute la commande `kubectl get pods --namespace=kube-system` pour vérifier et on constate que l'on a une erreur car `kubectl` ne peut pas contacter le serveur API.

![](https://i.imgur.com/FyfkTf9.png)

On va donc faire une restoration de notre fichier avec la commande suivante : 

```
sudo mv ~/kube-apiserver.yaml /etc/kubernetes/manifests/kube-apiserver.yaml
```

Puis on re-essaye de vérifier avec `kubectl get pods --namespace=kube-system` : 

![](https://i.imgur.com/v1yvDry.png)

On peut voir que `kubectl` refonctionne.

3. Création d'un nouveau fichier Pod dans le dossier des Pods statiques

Le fichier va être créé automatiquement en exécutant le bloc de commande suivant : 

```
sudo tee /etc/kubernetes/manifests/nginx.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: nginx-test
  namespace: default
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
EOF
```

On peut vérifier que notre Pod Nginx est disponible avec la commande `kubectl get pods --namespace=default` : 

![](https://i.imgur.com/0OFueYE.png)

On va nettoyer tout ça avec la commande `sudo rm /etc/kubernetes/manifests/nginx.yaml`.

## Les certificats

1. 

## Création d'un 1er déploiement