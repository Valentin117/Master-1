#!/bin/bash

nom_meme="$1"
texte_haut="$2"
texte_bas="$3"

nom_meme=$(shuf -n 1 name_memes.txt)

api_url="http://apimeme.com/meme?meme=$nom_meme&top=$texte_haut&bottom=$texte_bas"

curl "$api_url" > image.png