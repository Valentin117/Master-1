def get_state(grille):
    chaine = ""
    for ligne in grille:
        chaine = chaine + ligne[0] + ligne[1] + ligne[2]
    return chaine

def coup_valide(grille):
    for