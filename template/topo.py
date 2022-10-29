"""
swat-s1 topology
"""

from mininet.topo import Topo

from utils import IP, MAC, NETMASK


class SwatTopo(Topo):

    """SWaT 2 plcs + attacker + private dirs."""

    def build(self):

        switch = self.addSwitch('s1')

        plc0 = self.addHost(
            'plc0',
            ip=IP['plc0'] + NETMASK,
            mac=MAC['plc0'])
        self.addLink(plc0, switch)

        plc1 = self.addHost(
            'plc1',
            ip=IP['plc1'] + NETMASK,
            mac=MAC['plc1'])
        self.addLink(plc1, switch)

        attacker = self.addHost(
            'attacker',
            ip=IP['attacker'] + NETMASK,
            mac=MAC['attacker'])
        self.addLink(attacker, switch)
