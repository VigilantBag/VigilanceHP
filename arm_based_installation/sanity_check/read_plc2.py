from pymodbus.client import ModbusTcpClient
import time

ip_addr = "*.*.*.*" # replace the IP with the PLC's IP_Addr

# Connect to the client
client = ModbusTcpClient(ip_addr)

# If connection established read the value stored in the holding_registers every 0.3 seconds for ever
if client.connect() is True:
    while True:
        coils_values = client.read_coils(0,4)
        print("Coil Value: " + str(coils_values.bits[0]) + ' ' + str(coils_values.bits[1]) + ' ' + str(coils_values.bits[2]) + ' ' + str(coils_values.bits[3]))
        time.sleep(0.3)