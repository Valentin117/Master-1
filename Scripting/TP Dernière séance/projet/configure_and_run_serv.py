from os import system, chdir
system("sudo apt-get update")
system("sudo apt-get install tree")
system("sudo apt-get install python3-pip")
system("sudo pip install requests")
system("sudo pip install flask")
system("sudo pip install pandas")
system("mkdir site")
chdir("site")
system("mkdir static")
system("mkdir templates")
system("touch templates/index.html")
with open("app.py", "w") as file:
    file.write('''
from flask import Flask, render_template
from os import listdir
import os

app = Flask(__name__)
@app.route("/")
def hello_world():
    return "<p>Hello World!</p>"

@app.route("/images")
def show_images():
    # images_dir = "./static"
    # images = [f for f in os.listdir(images_dir)]
    return render_template("index.html",images=["1.png","2.png"])
    # return render_template("index.html",images=images)

app.run(host="0.0.0.0",port=80)
    ''')

system('echo "@reboot python3 site/app.py" | crontab -')