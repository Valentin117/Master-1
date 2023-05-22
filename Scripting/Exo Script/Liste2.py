liste1 = [".","X","."]
liste2 = [".","O","."]
liste3 = ["X",".","."]
listes = [liste1,liste2,liste3]
print("MORPION")
print("_______")
for ligne in listes:
    print("|"+ligne[0]+"|"+ligne[1]+"|"+ligne[2]+"|")
liste1[0]="O"
liste3[2]="O"
chaine = ""
for ligne in listes:
    chaine = chaine + ligne[0] + ligne[1] + ligne[2]
print(listes)
print(chaine)