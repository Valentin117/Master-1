# Création Groupe de ressources
echo "Création Groupe de ressources Projet_Cloud01"
az group create --name Projet_Cloud01 --location francecentral

# Création Adresse IP publique
echo "Création d'une Adresse IP publique"
az network public-ip create --name public_ip_02 --resource-group Projet_Cloud01 --location francecentral --version IPv4 --sku Stardard --zone 1

# Création Réseau virtuel
echo "Création d'un Réseau virtuel"
az network vnet create --name vnet_02 --resource-group Projet_Cloud01