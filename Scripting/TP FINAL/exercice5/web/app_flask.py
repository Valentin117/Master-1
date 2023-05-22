from flask import Flask, request

app = Flask(__name__)

with open('/home/valentin/Documents/web/blocked_ip.txt') as f:
    blocked_ip = f.readlines()
@app.route("/")
def check_ip():
    blocked = request.remote_addr
    if blocked in blocked_ip:
        return "Accès refusé"
    else:
        return f"Connecté avec l'adresse {blocked}"
app.run()
