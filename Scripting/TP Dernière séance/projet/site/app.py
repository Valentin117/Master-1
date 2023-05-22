
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