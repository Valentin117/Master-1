from time import sleep
import psutil
network =  psutil.net_io_counters()
print(network.bytes_recv/1000000)
sleep(10)
network =  psutil.net_io_counters()
print(network.bytes_recv/1000000)