#!/bin/bash

echo "Nombre de tours"
read nb_rounds

# Initialiser le score total à 0
score_total_j1=0
score_total_j2=0

for (( i=1; i<= $nb_rounds; i++ ))
do
  echo "Joueur 1 : coop ou trahir"
  read choice_j1
  echo "Joueur 2 : coop ou trahir"
  read choice_j2

  if [[ $choice_j1 == "coop" && $choice_j2 == "coop" ]]
    score_total_j1=$(( score_total_j1 + 2 ))
    score_total_j2=$(( score_total_j2 + 2 ))
  elif [[ $choice_j1 == "coop" && $choice_j2 == "trahir" ]]
    score_total_j1=$(( score_total_j1 + 0 ))
    score_total_j2=$(( score_total_j2 + 5 ))
  elif [[ $choice_j1 == "trahir" && $choice_j2 == "coop" ]]
    echo score_total_j1=$(( score_total_j1 + 5 ))
    echo score_total_j2=$(( score_total_j2 + 0 ))
  elif [[ $choice_j1 == "trahir" && $choice_j2 == "trahir" ]]
    echo score_total_j1=$(( score_total_j1 + 0 ))
    echo score_total_j2=$(( score_total_j2 + 0 ))
  fi
done

# Afficher les résultats
echo "Score total du Joueur 1 : $score_total_j1"
echo "Score total du Joueur 2 : $score_total_j2"