import psutil
import time
import logging

logging.basicConfig(filename='check_bad_programs.log', level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')

list_programs_kill = ['Teams.exe', 'Messenger.exe', 'Discord.exe']

while True:
    disk_usage = psutil.disk_usage('/')
    percent_disk = disk_usage.percent

    for proc in psutil.process_iter():
        if proc.name() in list_programs_kill:
            proc.kill()
            logging.warning(f'Le programme {proc.name()} a été tué !')
        else:
            logging.info("Aucun programme n'a ete arrete !")

    if percent_disk > 70:
        logging.warning("L'espace disque maximal est presque atteint, arrêtez des processus")
    elif percent_disk > 80:
        logging.critical("L'espace disque maximal est atteint,, arrêtez TOUT")
        
    time.sleep(5)