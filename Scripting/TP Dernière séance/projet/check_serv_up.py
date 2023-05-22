import requests
from time import sleep
from os import system
import logging
logging.basicConfig(filename='server.log', level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')
while True:
    try:
        rq = requests.get("http://localhost:80")
        if rq.status_code == 200:
            logging.info("All is running good !")
        else:
            logging.warning("Error in the server")
    except Exception as e:
        system("python3 site/app.py")
        print("Reloading server")
    sleep(10)