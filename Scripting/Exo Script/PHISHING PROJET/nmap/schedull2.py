import nmap
import socket
from time import sleep

ports_ref = []
while True:
    port_actuels = []
    scanner = nmap.PortScanner()
    ip_site = socket.gethostbyname('')
info_nmap = scanner[ip_site]
tcp = info_nmap["tcp"]

if len(ports_ref) == 0:
    for port in tcp:
        ports_ref.append(port)
else:
    for port in tcp:
        ports_actuels.append(port)
    if set(ports_actuels) == set(ports_ref):
        print(f"Pas de changement, les ports actifs sont : {}")
    else:
        print(f"ALERTE ! Changement détecté ! Les ports actifs sont : {}")
    ports_ref = ports_actuels
sleep(2)