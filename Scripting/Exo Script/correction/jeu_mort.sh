nombre_lancers=$1
somme_des=0
for ((i = 0 ; i < $nombre_lancers ; i++)); do
    de1=$((RANDOM % 20 + 1))
    de2=$((RANDOM % 20 + 1))	
    echo "Lancer $i : $de1 et $de2"
    if [[ $de1 -eq $de2 ]]; then
        echo "Vous êtes mort !"
        exit 0
    fi
    somme_des=$(($somme_des + $de1 + $de2))
done

echo "Voici le score cumule obtenu : $somme_des !"