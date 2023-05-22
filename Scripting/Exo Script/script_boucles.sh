#!/bin/bash

# Demander à l'utilisateur combien de lancers de dés effectuer
echo "Combien de lancers de dés voulez-vous effectuer ?"
read nb_lancers

# Initialiser le score total à 0
score_total=0

# Initialiser un tableau vide pour stocker les scores individuels
scores=()

# Effectuer les lancers de dés demandés
for (( i=1; i<=$nb_lancers; i++ ))
do
  # Lancer les deux dés et ajouter la somme des résultats au score total
  dice1=$(( RANDOM % 20 + 1 ))
  dice2=$(( RANDOM % 20 + 1 ))
  sum=$(( dice1 + dice2 ))
  score_total=$(( score_total + sum ))

  # Si un double est obtenu, réinitialiser le score total à 0 et recommencer le jeu
  if [ $dice1 -eq $dice2 ]
  then
    echo "Scor en Double ! Score total réinitialisé à 0."
    score_total=0
    i=0
  fi

  # Stocker le score individuel dans le tableau
  scores+=($sum)
done

# Trier les scores en ordre décroissant et ne garder que la moitié supérieure
sorted_scores=($(printf '%s\n' "${scores[@]}" | sort -rn))

# Afficher les résultats
echo "Score total : $score_total"
