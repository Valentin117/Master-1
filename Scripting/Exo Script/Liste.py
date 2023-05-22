liste1 = ["X",".","."]
liste2 = [".","O","."]
liste3 = ["X",".","O"]
listes = [liste1,liste2,liste3]
print("MORPION")
print("_______")
for ligne in listes:
    print("|"+ligne[0]+"|"+ligne[1]+"|"+ligne[2]+"|")
    # print(f"|{ligne[0]}|{ligne[1]}|{ligne[2]}|")