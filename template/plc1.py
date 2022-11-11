"""
swat-s1 plc1.py

This script will mimic a lever, which will turn plc0 on or off
"""

from minicps.devices import PLC

from utils import PLC1_DATA, STATE, PLC1_PROTOCOL
from utils import PLC_PERIOD_SEC, PLC_SAMPLES
from utils import IP

import time

PLC0_ADDR = IP['plc0']
PLC1_ADDR = IP['plc1']

L001 = ('L001', 0)
SW101 = ('SW101', 0)

class SwatPLC1(PLC):
    
    def pre_loop(self, sleep=0.1):
        print('DEBUG: swat-s1 plc1 enters pre_loop')
        time.sleep(sleep)

    def main_loop(self):
        """plc1 main loop.
            - reads sensors value
            - drives actuators according to the control strategy
            - updates its enip server
        """

        print('DEBUG: swat-s1 plc1 enters main_loop.')
        print('\n')

        count = 0

        while(count <= PLC_SAMPLES):
            # sw101 recieves it's updated state
            sw101 = float(self.get(SW101))
            # sw101 updates the network with it's state
            self.send(SW101, sw101, PLC1_ADDR)
            
            # if the switch is turned on, send the signal to the light to turn on 
            if SW101 < 1:
                print('The switch has been turned on.')
                print('Now the light will be switched on.')
                
                # PLC1 informs PLC0 to turn on the light
                self.set(L001, 1) 
                self.send(L001, 1, PLC0_ADDR)
            
            # if the switch is turned off, send the signal to turn the light off
            elif SW101 > 0:
                print('The switch has been turned off.')
                print('Now the light will be switched off.')

                # PLC1 informs PLC0 to turn off the light
                self.set(L001, 0)
                self.send(L001, 0, PLC0_ADDR)
            
            # print a separator, increase the count, and sleep for the remainder of the plc period
            print("***********************************************")
            time.sleep(PLC_PERIOD_SEC)
            
            # turn the light back on
            self.set(L001, 1)
            self.send(L001, 1, PLC0_ADDR)
            count += 1

    print('DEBUG swat plc1 shutdown')

# does something...that I don't quite understand yet--possibly with the database
if __name__ == "__main__":
    plc1 = SwatPLC1(
        name='plc1',
        state=STATE,
        protocol=PLC1_PROTOCOL,
        memory=PLC1_DATA,
        disk=PLC1_DATA)
