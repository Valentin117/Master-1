sudo apt-get update
sudo apt-get install tree
sudo apt-get install python3 python3-pip
sudo pip install requests
sudo pip install flask
mkdir web
touch web/app_flask.py
touch web/blocked_ip.txt

cat <<EOF > web/app_flask.py
from flask import Flask

app = Flask(__name__)
@app.route("/")
def check_ip():
    return f"Connecté avec l'adresse {request.remote_addr}"

app.run()
EOF
