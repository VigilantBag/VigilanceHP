"""
swat-s1 utils.py
"""

from minicps.utils import build_debug_logger

PLC_SAMPLES = 100000000     # set the number of samples to be taken for the mainloop
PLC_PERIOD_SEC = 0.04       # plc update period in seconds
PATH = 'swat_s1_db.sqlite'  # set the path for the sqlite data file
NAME = 'swat_s1'            # name the network

# set the variable types for each column
SCHEMA = """
CREATE TABLE swat_s1 (
    name            TEXT NOT NULL,
    pid             INTEGER NOT NULL,
    value           TEXT,
    PRIMARY KEY (name, pid)
);
"""

# insert the intial values into the db
SCHEMA_INIT = """
    INSERT INTO swat_s1 VALUES ('L001', 0, '1');
    INSERT INTO swat_s1 VALUES ('SW101', 0, '1');
"""

# Set the state of the network
STATE = {
    'name' : NAME,
    'path' : PATH
}

# Set the IPs of the PLC's on the network
IP = {
    'plc0' : '192.168.56.105',
    'plc1' : '192.168.56.106',
    'attacker' : '192.168.56.110',
}

# Set the mac addresses of the PLC's on the network
MAC = {
    'plc0': '00:1D:9C:C6:A0:60',
    'plc1': '00:1D:9C:C7:B0:70',
    'attacker': 'AA:AA:AA:AA:AA:AA',
}

# Set the netmask of the network
NETMASK = '/24'

# TODO
PLC0_DATA = {
    'TODO' : 'TODO'
}

PLC1_DATA = {
    'TODO' : 'TODO'
}

# Extract plc0 address from ip
PLC0_ADDR = IP['plc0']

# Extract plc1 address from ip
PLC1_ADDR = IP['plc1']

# Information marking which PLC the information is comming from 
PLC0_TAGS = (
    ('L001', 0, 'INT'),
)
PLC1_TAGS = (
    ('S001', 0, 'INT'),
)

# Infrastructure for broadcasting information from PLC0 to the network
PLC0_SERVER = {
    'address' : PLC0_ADDR,
    'tags' : PLC0_TAGS
}

# Infrastructure for broadcasting information from PLC1 to the network
PLC1_SERVER = {
    'address' : PLC1_ADDR,
    'tags' : PLC1_TAGS
}
# Infrastructure for the protocol PLC0 
PLC0_PROTOCOL = {
    'name' : 'enip',
    'mode' : 1,
    'server' : PLC0_SERVER
}

# Infrastructure for the protocol PLC1 
PLC1_PROTOCOL = {
    'name' : 'enip',
    'mode' : 1,
    'server' : PLC1_SERVER
}
