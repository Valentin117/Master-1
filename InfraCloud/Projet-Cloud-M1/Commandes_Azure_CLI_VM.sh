# Création Virtual machine - User : usercloud MDP : ynovtoulouse31!
echo "Création de l'Instance Wordpress 2"
az vm create --name instance_02 --resource-group Projet_Cloud01 --location francecentral --image UbuntuLTS --size Standard_B1ls --authentication-type password --admin-username usercloud --admin-password ynovtoulouse31! --vnet-name vnet_02 --public-ip-address public_ip_02 --custom-data wordpress_2.sh

# Ouverture des ports
echo "Ouverture des ports 80 et 443 en plus sur l'instance"
az vm open-port --port 80,443 --resource-group Projet_Cloud01 --name instance_02