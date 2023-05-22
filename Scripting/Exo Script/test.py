from argparse import Namespace
from tracemalloc import stop
import psutil
import logging
from time import sleep
logging.basicConfig(filename='trace.log', level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')
PROCNAMES = ["Messenger.exe", "Discord.exe"]
for proc in psutil.process_iter():
    try:
        process_name = proc.name()
        for processus in PROCNAMES:
            if process_name == processus:
                logging.info(f"Arret du processus {process_name} inutile !")
                proc.kill()
    except Exception as e:
        pass

network =  psutil.net_io_counters()
t0reference = network.bytes_recv/10000000
print(f"T0 Reference : {t0reference}")
while True:
    sleep(10)
    network =  psutil.net_io_counters()
    t1reference = network.bytes_recv/10000000
    print(f"T1 Reference : {t1reference}")
    if t1reference > float(100):
        logging.warning(f"Trafic sortant {t1reference} trop eleve !")
        break
    elif t1reference < float(100):
        logging.warning(f"Trafic sortant {t1reference} correct !")
        break