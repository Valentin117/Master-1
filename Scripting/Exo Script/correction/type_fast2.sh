#!/bin/bash

dico=$(cat liste_francais.txt)
nb_lines=$(cat liste_francais.txt | wc -l )
nb_correct_answers=0

while [ $nb_correct_answers -lt 10 ]; do
index_line=$((RANDOM%nb_lines))
random_word=$(head -n $index_line liste_francais.txt | tail -1)
echo "Ecrivez : $random_word"
read try
if [[ $try == $random_word ]]; then
    echo "Bravo !"
    nb_correct_answers=$(($nb_correct_answers + 1))
else
    echo "Dommage !"
fi
echo "Nombre de bonnes réponses : $nb_correct_answers"
done