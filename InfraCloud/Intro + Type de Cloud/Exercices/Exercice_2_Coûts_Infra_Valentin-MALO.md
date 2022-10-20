# Exercice 2 - 13 Octobre 2022
## Calcul des couts d'une infrastructure as a Service en fonction de differents Cloud Provider

<br>

## Presentation des 3 types d'infrastructure :

## Infrastructure 1
+ 1 serveur avec les ressources suivantes :
    - 16 Go de RAM minimum
    - 4 vCPU
    - 100 Go de stockage disque

<br>

## Infrastructure 2
+ 6 serveurs avec les ressources suivantes :
    - 6 Go de RAM minimum
    - 3 vCPU
    - 20 Go de stockage disque par serveur
+ **Particularite :** 3 serveurs sont eteints la nuit de 22h a 6h du matin

<br>

## Infrastructure 3
+ 3 serveurs avec les ressources suivantes :
    - 4 Go de RAM minimum
    - 2 vCPU
    - 50 Go de stockage disque par serveur
+ 1 load balancer qui repartit 5 Mb/s de donnees equitablement vers les 3 serveurs ci-dessus
+ 1 service de base de donnees manage
    - 10 Go de RAM minimum
    - 2 vCPU

<br>

## Voici les 4 différents Cloud Provider :
+ AWS (Amazon Web Services)
+ GCP (Google Cloud Platform)
+ Azure (Microsoft Cloud Azure)
+ Scaleway

<br>

# 1. Cout des infrastructures chez AWS
*Lien pour l'estimation* : [AWS Cost](https://calculator.aws/#/addService) <br> <br>


+ Infrastructure 1 :
> *TOTAL* : **67,40 HT USD/mois**

<br>

+ Infrastructure 2 :
    - **214,79 USD HT/mois** pour 3 serveurs qui fonctionnent H24
    - **146,46 USD HT/mois** pour 3 serveurs qui fonctionnent et s'arretent de 22h a 6h du matin
> *TOTAL* : 214,79 + 146,46 = **301,04 USD HT/mois**

<br>

+ Infrastructure 3 :
    - **69,30 USD HT/mois** pour 3 serveurs
    - **291,74 USD HT/mois** pour un load balancer qui repartit 5 Mb/s entre les 3 serveurs
    - **33,12 USD HT/mois** pour un serveur de base de donness manage
> *TOTAL* : 69,30 + 291,74 + 33,12 = **394,16 USD HT/mois**

<br>

# 2. Cout des infrastructures chez GCP
*Lien pour l'estimation* : [GCP Cost](https://cloud.google.com/products/calculator?hl=fr) <br> <br>

1. Infrastructure 1 :
    - Type d'instance : n2d-custom-4-16384 (16 Go de RAM + 4 vCPU)
        * **125€43/mois** pour 1 serveur
    - Stockage disque : Standard Disk de 100 Go
        * **4€84/mois** pour 1 serveur
> *TOTAL* : 125€43 + 4€84 = **130€27/mois**

*Lien* : [Infrastructure 1](https://cloud.google.com/products/calculator/#id=e9471255-5268-49bb-8425-4ba7a0a4ca42)

<br>

2. Infrastructure 2 :
    - Pour 3 serveurs qui fonctionnent H24
        * Type d'instance : n2d-custom-4-6144 (6 Go de RAM + 4 vCPU *car 3 vCPU impossible chez GCP*)
            + **294€22/mois** pour 3 serveurs
        * Stockage disque : Standard Disk de 20 Go
            + **0€97/mois** par serveur
            + **2€90/mois** pour 3 serveurs
    > *TOTAL 1* : 294€22 + 2€90 = **297€13/mois** pour 3 serveurs (qui fonctionnent H24)

    *Lien 1* : [Infrastructure 2.1](https://cloud.google.com/products/calculator/#id=bd46b614-ec86-4416-9229-173a280dcccf)

    - Pour 3 serveurs qui fonctionnent et s'arretent de 22h a 6h du matin
        * Memes caracteristiques que les 3 premiers serveurs sauf qu'ils ne fonctionnent seulement 16h dans la journee
        * Type d'instance : n2d-custom-4-6144 (6 Go de RAM + 4 vCPU *car 3 vCPU impossible chez GCP*)
            + **216€61/mois** pour 3 serveurs qui tournent 16h
        * Stockage disqie : Standard Disk de 20 Go
            + **0€97/mois** par serveur
            + **2€90/mois** pour 3 serveurs

    > *TOTAL 2* : 216€61 + 2€90 = **219€51/mois** pour 3 serveurs (qui ne fonctionnent que 16h, car ils sont eteints de 22h a 6h du matin)

    *Lien 2* : [Infrastructure 2.1](https://cloud.google.com/products/calculator/#id=0f404fc4-573f-4ec4-a483-9e19c7fe15ea)


> *TOTAL FINAL* : 297€13 + 219€51 = **516€64/mois** pour 6 serveurs dont 3 qui tournent 16h

*Lien final* : [Infrastructure 2.3](https://cloud.google.com/products/calculator/#id=761c3bae-cba9-4146-96c9-ea8ef2ef9553)

<br>

3. Infrastructure 3 :
    - Pour 3 serveurs qui fonctionnent H24
        * Type d'instance : n2d-custom-2-4096 (4 Go de RAM + 2 vCPU)
            + **155€32/mois** pour 3 serveurs
        * Stockage disque : Standard Disk de 50 Go
            + **2€42/mois** par serveur
            + **7€26/mois** pour 3 serveurs
    > *TOTAL 1* : 155€32 + 7€26 = **162€58** pour 3 serveurs (qui fonctionnent H24)
    
    *Lien 1* : [Infrastructure 3.1](https://cloud.google.com/products/calculator/#id=776ff88c-fc66-4fb5-baf9-acc3791549e1)

    - Pour un load balancer qui repartit 5 Mb/s entre les 3 serveurs
        * 3 regles de transfert et 5 Mb/s
            + **22€28/mois** pour 1 load balancer a 3 regles <br>
*Sachant que 5 regles coutent 0€025/h et chaque regle supplementaire coute 0€01/h*
            + **0€/mois** pour 5 Mb/s <br>
*Le prix de la donnee entrante par le load balancer se paie par Go utilisé et aucun frais supplementaire pour le trafic sortant*
    > *TOTAL 2* : 22€38 + 0€ = **22€38/mois** pour 1 load balancer a 3 regles de transfert et a 5 Mb/s pour 1 mois

    *Lien 2* : [Infrastructure 3.2](https://cloud.google.com/products/calculator/#id=4a06d4d9-924b-4249-b27c-a3557c227208)

    - Pour un serveur de base de donness manage
        * Base de donness : db-custom-2-10240 (8 Go de RAM + 2 vCPU) <br>
*Sachant que j'ai pris un disque de stockage HDD (et non SSD) de 150 Go. Le prix pour 50 Go de stockage revient à 10€ de mois, soit 140€ environ*
            + **150€99/mois** pour 1 serveur de base de donnees
    > *TOTAL 3* : **150€99/mois** pour 1 serveur de base de donnees

    *Lien 3* : [Infrastructure 3.3](https://cloud.google.com/products/calculator/#id=a1b9c1e2-e824-4838-b98d-2861f75d1308)

> *TOTAL FINAL* : 162€58 + 22€28 + 150€99 = **335€85/mois** pour 3 serveurs, 1 load balancer et 1 serveur de base de donnees

*Lien Final* : [Infrastructure 3.4](https://cloud.google.com/products/calculator/#id=da65c25a-2e30-47c3-9fb8-c927e2a2f2db)

<br>

# 3. Cout des infrastructures chez Azure
*Lien pour l'estimation* : [Azure Cost](https://azure.microsoft.com/fr-fr/pricing/calculator/) <br> <br>

+ Infrastructure 1 :
> *TOTAL* : **163,57 $/mois**

<br>

+ Infrastructure 2 :
    - Pour 3 serveurs qui fonctionnent H24 pendant 1 mois
        * 16 Go de RAM + 4 vCPU + 100 Go de stockage
    > *TOTAL 1* : **486,23 $/mois**
    - Pour 3 serveurs qui fonctionnent et s'arretent de 22h a 6h du matin (soit 490h)
        * 16 Go de RAM + 4 vCPU + 100 Go de stockage
    > *TOTAL 2* : **326,39 $/mois**
> *TOTAL FINAL* : 486,23 + 326,39 = **812,62 $/mois**

<br>

+ Infrastructure 3 :
    - Pour 3 serveurs
        * 4 Go de RAM + 2 vCPU + 75 Go de stockage *car 50 Go de sotckage pas disponible*
    > *TOTAL 1* : **202,63$/mois**
    - Pour un load balancer qui repartit 5 Mb/s entre les 3 serveurs
        * 1 regle de transfert
    > *TOTAL 2* : **23,25$/mois**
    - Pour un serveur de base de donness manage
        * Base de donnees MySQL +  2 vCPU + 10 Go de stockage
    > *TOTAL 3* : **63,21 $/mois**
> *TOTAL FINAL* : 202,63 + 23,25 + 63,21 = **289,09 $/mois** pour 3 serveurs, 1 load balancer et 1 serveur de base de donnees manage

<br>

# 4. Cout des infrastructures chez Scaleway
*Lien pour l'estimation* : [Scaleway Cost](https://www.scaleway.com/fr/tarifs/?tags=available,manageddatabases-relationaldatabases-manageddatabaseforpostgresqlandmysql,manageddatabases-memorydatabases-manageddatabaseforredis) <br> <br>

+ Infrastructure 1 :
    - Type d'instance : PRO2-XS (16 Go de RAM + 4 vCPU)
        * 0,11€/h * 24 (pour 24h/journee) = **2,64€/jour**
        * 2,64€/jour * 31 (pour 31 jours ou 1 mois) = **81,84€/mois**
    - Stockage disque : Multi-AZ Storage
        * **0,00127€/mois** pour 1 Go
        * 0,00127 * 100 (pour 100 Go de stockage) = **1,27€/mois** <br>
*Sachant que les 75 premiers Go sont gratuits chaque mois*
        * 0,00127 * 25 (car reste 25 Go de stockage a payer) = **0,3175€/mois**
> *TOTAL* : 81,84 + 0,3175 = **82,16€/mois**

<br>

+ Infrastructure 2 :
    - Pour 3 serveurs qui vont fonctionnes 16h (eteints entre 22h et 6h du matin)
        * Type d'instance : PRO2-XS (16 Go de RAM + 4 vCPU) *car l'option PRO2-XXS (8 Go de RAM + 2 vCPU) ne correspond pas a ce que l'on veut*
        * 0,11€/h * 16 (pour 16h dans la journee) = **1,76€ pour 16h/jour**
        * 1,76€/jour * 31 (pour 31 jours ou 1 mois) = **54,56€/mois** pour 1 serveur
        * 54,56€/mois * 3 (pour 3 serveurs qui fonctionnement seulement 16h par jour) = **163,68€/mois**
    > *TOTAL 1* : **163,68€/mois**
    - Pour 3 serveurs (qui fonctionnent 24h))
        * Type d'instance : PRO2-XS (16 Go de RAM + 4 vCPU) *car l'option PRO2-XXS (8 Go de RAM + 2 vCPU) ne correspond pas a ce que l'on veut*
        * 0,11€/h * 24 (pour 24h/journee) = **2,64€/jour**
        * 2,64€/jour * 31 (pour 31 jours ou 1 mois) = **81,84€/mois** pour 1 serveur
        * 81,84€/mois * 3 (pour 3 serveurs qui fonctionnement 24h) = **245,52€/mois**
    > *TOTAL 2* : **245,52€/mois**
    - Pour le stockage de chaque serveur, soit 20 Go chacun
        * **0,00127€/mois** pour 1 Go
        * 0,00127 * 20 (pour 20 Go de stockage) = **0,0254€/mois** <br>
*Sachant que les 75 premiers Go sont gratuits chaque mois*
        * 120 Go (car 6 serveurs à 20 Go chacun) - 75 Go offerts = 45 Go restant
        * 0,00127 * 45 (pour 45 Go de stockage restant) = **0,05715€/mois** <br>
    > *TOTAL 3* : **0,058€/mois**
> *TOTAL FINAL* : 163,68 + 245,52 + 0,058 = **409,26€/mois** pour 6 serveurs à 20 Go de stockage dont 3 qui fonctionnent que 16h par jour

<br>

+ Infrastructure 3 :
    - Pour 3 serveurs qui fonctionnent H24
        * Type d'instance : PRO2-XXS (8 Go de RAM + 2 vCPU)
        * **0,055€/h** pour 1 serveur avec ce type d'instance
        * 0,055€/h * 24 (pour 24h/journee) = **1,32€/jour**
        * 1,32€/jour * 31 (pour 31 jours ou 1 mois) = **40,92€/mois** pour 1 serveur
        * 40,92€/mois * 3 (pour 3 serveurs) = **122,76€/mois**
    > *TOTAL 1* : **122,76€/mois** pour 3 serveurs
    - Pour le stockage de chaque serveur, soit 50 Go chacun
        * **0,00127€/mois** pour 1 Go
        * 0,00127 * 50 (pour 50 Go de stockage) = **0,0635€/mois** <br>
*Sachant que les 75 premiers Go sont gratuits chaque mois*
        * 150 Go (car 3 serveurs à 50 Go chacun) - 75 Go offerts = 75 Go restant
        * 0,00127 * 75 (pour 75 Go de stockage restant) = **0,09525€/mois** <br>
    > *TOTAL 2* : **0,09525€/mois** pour 50 Go par serveur (3 serveurs)
    - Pour 1 load balancer qui doit répartir 5 Mb/s entre les 3 serveurs
        * Type de load balancer : Load balancer 200 (c'est le minimum)
        * **0,014€/h** pour 1 load balancer
        * 0,014€/h * 24 (pour 24h/journee) = **0,336€/jour**
        * 0,336€/jour * 31 (pour 31 jours ou 1 mois) = **10,416€/mois** pour 1 load balancer
    > *TOTAL 3* : **10,416€/mois** pour 1 load balancer
    - Pour 1 serveur de base de donnees manage a 10 Go de RAM et 2 vCPU
        * **0,1233€/h** pour 1 serveur de BDD
        * 0,1233€/h * 24 (pour 24h/journee) = **0,2466€/jour**
        * 0,2466€/jour * 31 (pour 31 jours ou 1 mois) = **7,6€/mois** pour 1 serveur de BDD
    > *TOTAL 4* : **7,6€/mois** pour 1 serveur de BDD
> *TOTAL FINAL* : 122,76 + 0,09525 + 10,416 + 7,6 = **140,87€/mois** pour 3 serveurs, 1 load balancer et 1 serveur de BDD