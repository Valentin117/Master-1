#!/bin/bash

sudo apt-get update
sudo apt-get install tree
sudo apt-get install python3 python3-pip
sudo pip install requests
sudo pip install flask
mkdir web
touch web/app_flask.py
touch web/blocked_ip.txt
touch web/blocked_ip.json

cat <<EOF > web/blocked_ip.json
{
"127.0.0.1":"Hello there localhost",
"191.74.9.76":"Hey James !",
"191.74.10.66":"Hey Sarah !"
}
EOF

cat <<EOF > web/app_flask.py
from flask import Flask, request
import json

app = Flask(__name__)

with open('/home/valentin/Documents/web/blocked_ip.json') as json_file:
    blocked_ip = json.load(json_file)
@app.route("/")
def check_ip():
    blocked = request.remote_addr
    if blocked in blocked_ip:
        return "Accès refusé"
    else:
        return f"Connecté avec l'adresse {blocked}"
app.run()
EOF

chmod +x web/app_flask.py
python3 web/app_flask.py
