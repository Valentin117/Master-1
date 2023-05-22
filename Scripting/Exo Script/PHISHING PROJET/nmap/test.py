import nmap
import socket

print("""
Option 1 : TCP Connect Scan\n
Option 2 : UDP Scan\n
Option 3 : Comprehensive Scan\n
Option 4 : OS Detection\n
Option 5 : Version Detection\n
Option 6 : Ping Scan\n
""")
input_user = input("Quel scan vous voulez faire [1-6] ?\n")
argument = ""
if input_user == "1":
    argument = "-sS"
elif input_user == "2":
    argument = "-sU"
elif input_user == "3":
    argument = "-sC"
elif input_user == "4":
    argument = "-O"
elif input_user == "5":
    argument = "-sV"
elif input_user == "6":
    argument = "-sP"

nm = nmap.PortScanner()
ip_site = socket.gethostbyname('Val117.pythonanywhere.com')
nm.scan(ip_site, arguments = argument)
info_nmap = nm[ip_site]
print(info_nmap)