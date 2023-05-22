from state import get_state
from state import coup_valide
grille = [
    ["O","X","."],
    [".","O","."],
    ["X",".",""]
]
print(get_state(grille))
print(coup_valide(grille))