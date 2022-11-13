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

        while count < PLC_SAMPLES:
           
            # print the count 
            print(count)

            # get the status of the light
            light_status = int(self.get(L001))

            # get the status of the light switch
            switch_status = int(self.get(SW101))
            
            print
            print
            print("Light status: ", light_status)
            
            # The next line changes the orientation of the switch each count to mimic someone flipping it on or off. It can be commented out to pull data from the switch itself rather mimic the switch being turned on or off.
            switch_status = count % 2
            print("Switch status: ", switch_status)
            print
            print

            # update the network with the status of the switch
            self.send(SW101, switch_status, PLC1_ADDR)

            if switch_status == 1:
                print("The light will be switched on.")
                self.set(L001, 1)
                self.send(L001, 1, PLC0_ADDR)
            else:
                print("The light will be switched off.")
                self.set(L001, 0)
                self.send(L001, 0, PLC0_ADDR)
            
            count += 1

# does something...that I don't quite understand yet--possibly with the database

if __name__ == "__main__":
    plc1 = SwatPLC1(
        name='plc1',
        state=STATE,
        protocol=PLC1_PROTOCOL,
        memory=PLC1_DATA,
        disk=PLC1_DATA)
