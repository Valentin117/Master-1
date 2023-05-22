# TP Supervisions

# Devoir final

L'épreuve finale consiste en une expression de besoins et une demande de réalisation sous Zabbix.

Un client demande à ce que son système d'exploitation hébergé chez OVH puisse être surveillé. Ce dernier met à disposition un agent Zabbix *ancienne génération en version 5.0.31*. L'application est installée sur 2 serveurs. Le côté frontal Web et le côté arrière-plan sur un autre serveur.

Il souhaite : 

1. Un contrôle de disponibilité qu'il pourrait idéalement pouvoir couplé avec un suivi des engagements (la construction du suivi des engagements n'est pas demandé)

2. Un contrôle des ressources du système d'exploitation, à savoir suivi des activités CPU, mémoire, disque (suivi des performances et des capacités) et réseau, en utilisant le modèle de surveillance Linux standard

`
Le modèle Linux by Zabbix agent est très utile pour répondre à cette question, dans le sens où toutes les métriques nécessaires à la question 1 et 2 sont regroupés dans ce seul modèle. Pour le bien de ce TP, j'ai effectué un clone complet de ce modèle et renommé le modèle afin qu'il corresponde à mon nom (templateVM). Il va me permettre de répondre à cette question et de pouvoir modifier ce modèle par la suite pour les futures questions.
`

3. Un contrôle de la présence des processus "chronyd", "opaled" et "httpd", sachant qu'il souhaite avoir une alerte de sévérité moyenne en cas d'absence du processus "chronyd" et une alerte critique en cas d'absence du processus "opaled" et une alerte de sévérité haute dans le cas ou le nombre de processus httpd ne serait pas égale à 6.

### Processus CHRONYD :

![](https://i.imgur.com/iTSzvp0.png)

![](https://i.imgur.com/vbZEtHn.png)

`
Il faut réaliser les étapes indiqués dans les captures ci-dessus pour les 2 autres processus.
`

### Processus OPALED :

![](https://i.imgur.com/06odeGP.png)
![](![](https://i.imgur.com/IDHA5A7.png)

### Processus HTTPD :

![](![](https://i.imgur.com/WGe0JEF.png)
![](https://i.imgur.com/WSfihEV.png)

![](https://i.imgur.com/bwRVlBf.png)

4. Un contrôle de la taille fichiers applicatifs /var/log/opale/cosform*.log sans émission d'alerte spécifique**

`
Création d'un nouvel item (Taille fichiers applicatifs) dans notre modèle :
`

![](https://i.imgur.com/Ub35ULm.png)

5. Un contrôle du contenu du fichier /var/log/opale/license.log, où l'on demande une alerte de sévérité haute lors du dépassement de 900 utilisation de licence.**


6. Un tableau de bord, présentant sur :
    1. Une première page les différentes ressources, à savoir CPU, mémoire, disque, réseau, capacité des systèmes de fichiers
    2. Une deuxième page la présentation de la présence ou non des processus, de la taille des fichiers et de la consommation des licences

### 1er Dashboard

#### Utilisation CPU (processus) des 2 hôtes
![](https://i.imgur.com/hfQS7pA.gif)

#### Utilisation RAM (mémoire) des 2 hôtes
![](https://i.imgur.com/w66cooh.gif)

#### Utilisation du disque de l'hôte daspie
![](https://i.imgur.com/vG0MmKZ.gif)

#### Utilisation de l'espace disque de l'hôte daspie
![](https://i.imgur.com/W6TKYYi.gif)

#### Utilisation du trafic Réseaux de l'hôte daspie
![](https://i.imgur.com/qwGqhx0.gif)

#### Ping de l'hôte daspie
![](https://i.imgur.com/tTp7iuC.gif)

#### Nombre de processus en cours de l'hôte daspie
![](https://i.imgur.com/wzvO0zz.gif)

### 2ème Dashboard

