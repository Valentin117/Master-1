#!/bin/bash
page_url=$1
keyword=$2

code_page=$(curl -s $page_url)
nb_mots_presents=$(echo $code_page | grep -Eio $keyword | wc -w)
echo $nb_mots_presents