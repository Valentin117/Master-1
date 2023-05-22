bulletin = {"Valentin": 17, "Pierre": 19, "Clement": 14, "Antoine": 14.5}
note_max = -1
note_min = 21
eleve_majo = ""
eleve_mino = ""
for eleve in bulletin:
    print(f"{eleve} : {bulletin[eleve]}")
    note_eleve = bulletin[eleve]
    if note_eleve < note_min :
        note_min = note_eleve
        eleve_mino = eleve
    if note_eleve > note_max :
        note_max = note_eleve
        eleve_majo = eleve
#print("Meilleur élève de la promo :")
#print(eleve_majo, note_max)
print(f"{'Meilleur élève :'} {eleve_majo} : {note_max}")
#print("Pire élève de la promo :")
#print(eleve_mino, note_min)
print(f"{'Pire élève :'} {eleve_mino} : {note_min}")