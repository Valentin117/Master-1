Ecrire dans un fichier fusion.txt le contenu des fichiers one, two, three, four, five :
```sh
ls one two three four five > fusion.txt
```

Compte les mots dans le fichier *fichier.txt* :
```sh
ls | wc -L fichier.txt
```
Compte les lignes dans le fichier *fichier.txt* :
```sh
ls | wc -l fichier.txt
```

Liste les mots commençant par *cor* :
```sh
grep -E ^cor fichier1
```
```sh
cat fichier1 | grep -oE "^(cor).*"
```

Liste les mots commençant par *ba* et finissant et *e* dans le fichier *word2* :
```sh
grep -E "^ba.*e$" word2
```

Liste les mots qui ont exactement 5 lettres :
```sh
grep -oE "^.{5}$" word3
```

Liste les mots qui contiennent uniquement des voyelles :
```sh
grep -oE "^[aeiouy]+$" word4
```

Liste les mots qui alternent successivement consonnes et voyelles :
```sh
grep -oE "^([^aeiouy][aeiouy])+[^aeiouy]?$" word5
```

Lister les mots commençant par *z* et finissant par un *e* :
```sh
grep -oE "^(z).*(eéèêë)$" dico.txt
```

Ecrire tous les mots qui commencent par *z* et qui finissent par *e* dans un fichier *z-e.txt* :
```sh
grep -oE "^(z).*(eéèêë)$" dico.txt >> z-e.txt
```

Afficher le nombre de mots dans le fichier *z-e.txt* :
```sh
cat z-e.txt | wc -l
```

Afficher le nombre de commandes **grep** que vous avez utilisé depuis le début :
```sh
history | grep "grep"
```

Récupérer avec une requête *curl* seulement les pays qui commencent par “Al” dans cet URL "*https://www.atlas-monde.net/tous-les-pays/*" :

```sh
curl https://www.atlas-monde.net/tous-les-pays/
```

```sh
grep -E ">Al.*<" index.html
```

Créer un script bash qui crée un dossier *test_bash*, et qui crée trois fichiers à l’intérieur *1.txt*, *2.txt*, *3.txt* puis qui copie le dossier *test_bash* vers un autre dossier *test_bash_2* :

```sh
#!/bin/bash
mkdir ./test_bash
touch test_bash/1.txt
touch test_bash/2.txt
touch test_bash/3.txt
mkdir test_bash_2
cp -r test_bash test_bash_2/test_bash
```

créer l'alias *cree_deux_dossiers* qui lance le script de l’exercice précédent

```sh
alias cree_deux_dossiers='bash script.sh'
```





