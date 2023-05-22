#!/bin/bash
type1=$1
type2=$2
message_pas_efficace="C'est pas très efficace..."
message_tres_efficace="C'est super efficace !"
message_efficace="C'est efficace !"
if [[ $type1 == "fire" && $type2 == "plant" ]]; then
    echo $message_tres_efficace
elif [[ $type1 == "plant" && $type2 == "water" ]]; then
    echo $message_tres_efficace
elif [[ $type1 == "water" && $type2 == "fire" ]]; then
    echo $message_tres_efficace
elif [[ $type1 == "water" && $type2 == "plant" ]]; then
    echo $message_pas_efficace
elif [[ $type1 == "plant" && $type2 == "fire" ]]; then
    echo $message_pas_efficace
elif [[ $type1 == "fire" && $type2 == "water" ]]; then
    echo $message_pas_efficace
else
    echo $message_efficace
fi