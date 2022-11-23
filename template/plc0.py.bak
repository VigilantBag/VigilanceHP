"""
swat-s1 plc0
"""

from minicps.devices import PLC

from utils import IP, PLC_SAMPLES, PLC_PERIOD_SEC
from utils import STATE, PLC0_PROTOCOL, PLC0_DATA

import time

# Set up the device
PLC0_ADDR = IP['plc0']

# Light
L001 = ('L001', 0)

class swatPLC0(PLC):
    
    def pre_loop(self, sleep=0.1):
        print('DEBUG: swat-s1 plc0 enters pre_loop')
        print('\n')
        
        time.sleep(sleep)

    def main_loop(self):
        """plc0 main loop
                - reads the switch value from the network
                - turns on or off the light
        """
        
        print('DEBUG: swat-s1 plc0 enters main_loop')
        print('\n')
        
        count = 0
        while (count <= PLC_SAMPLES):

            l001 = float(self.get(L001))
            print("DEBUG PLC0 - recieved l001: %f" % l001)
            if l001 != 0:
                self.send(L001, l001, PLC0_ADDR)
            
            time.sleep(PLC_PERIOD_SEC)
            count += 1

if __name__ == "__main__":
    
    plc0 = swatPLC0(
        name = 'plc0',
        state = STATE,
        protocol = PLC0_PROTOCOL,
        memory = PLC0_DATA,
        disk = PLC0_DATA)
