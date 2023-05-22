import socket
import time

# Paramètres du serveur
host = 'Val117.pythonanywhere.com'
# Les ports à scanner
ports = [21, 22, 80, 443]
 # Fichier de log
log_file = 'nmap/port_scan.log'

# Fonction pour scanner les ports ouverts
def port_scan():
    with open(log_file, 'a') as f:
        f.write('Scan effectué le {}\n'.format(time.strftime('%Y-%m-%d %H:%M:%S')))
        for port in ports:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.settimeout(1)
            try:
                s.connect((host, port))
                f.write('Le port {} est ouvert\n'.format(port))
            except:
                f.write('Le port {} est fermé\n'.format(port))
            s.close()

# Planification de la tâche toutes les 10 minutes
while True:
    port_scan()
    time.sleep(600)