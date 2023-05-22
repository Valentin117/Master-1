nb_pieces_j1=0
nb_pieces_j2=0
for ((i = 0 ; i < 6 ; i++)); do
    echo "_______"
    echo "Tour de jeu $i"
    echo "Choisissez votre stratégie : (1) coopérer, (2) trahir"
    echo "Joueur 1, faites votre choix :"
    read choix_j1
    clear
    echo "Joueur 2, faites votre choix :"
    read choix_j2
    clear
    if [[ $choix_j1 == 1 && $choix_j2 == 1 ]]; then
        echo "Vous avez tous les deux choisi de coopérer"
        nb_pieces_j1=$(($nb_pieces_j1 + 2))
        nb_pieces_j2=$(($nb_pieces_j2 + 2))
    elif [[ $choix_j1 == 2 && $choix_j2 == 2 ]]; then
        echo "Pas de chance ! Vous avez tous les deux choisi de trahir"
    elif [[ $choix_j1 == 1 && $choix_j2 == 2 ]]; then
        echo "Joueur 1 a choisi de coopérer et Joueur 2 a choisi de trahir"
        nb_pieces_j2=$(($nb_pieces_j2 + 5))
    elif [[ $choix_j1 == 2 && $choix_j2 == 1 ]]; then
        echo "Joueur 1 a choisi de trahir et Joueur 2 a choisi de coopérer"
        nb_pieces_j1=$(($nb_pieces_j1 + 5))
    fi
    echo "Joueur 1 : $nb_pieces_j1 pièces"
    echo "Joueur 2 : $nb_pieces_j2 pièces"
    done
    echo "_______"
    echo "Fin de la partie"
    echo "Joueur 1 : $nb_pieces_j1 pièces"
    echo "Joueur 2 : $nb_pieces_j2 pièces"