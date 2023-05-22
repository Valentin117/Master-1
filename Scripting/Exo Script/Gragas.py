conso_horaire_gragas = 1
conso_horaire_ornn = conso_horaire_gragas / 3
conso_horaire_olaf = conso_horaire_ornn / 2
conso_total = conso_horaire_gragas + conso_horaire_ornn + conso_horaire_olaf
print(conso_total)
temps_uneheure = 60 / conso_total
if temps_uneheure > 42:
    print("Echec de la quête!")
else:
    print("VICTOIRE DES IVROGNES!")
    print("Quête réussie en ")
    print(temps_uneheure, "min")