#On met le nom du notre fichier avec la fonction ici position.py
# et on importe la fonction
from position import position_win
grille = [
    [".","X","."],
    [".","O","."],
    ["X",".",""]
]
print(position_win(grille))