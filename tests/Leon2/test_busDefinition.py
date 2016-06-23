#!/bin/env python

import sys
sys.path.append('../..')


import ipxact

file_path = 'xml/amba.com/AMBA3/AHBLite/r1p0/AHBLite.xml'
xml = open(file_path, 'r')

busDef = ipxact.CreateFromDocument(xml.read())

assert busDef.vendor == 'amba.com'
assert busDef.library == 'AMBA3'
assert busDef.name == 'AHBLite'
assert busDef.version == 'r1p0_6'

assert busDef.directConnection == False
assert busDef.isAddressable == True

# FIXME I don't like that it returns a string representation of one, when it would
# be possible to return a number
assert busDef.maxMasters.value() == '1'

assert busDef.systemGroupNames != None
assert len(busDef.systemGroupNames.systemGroupName) == 2
assert busDef.systemGroupNames.systemGroupName[0].value() == "ahb_clk"
assert busDef.systemGroupNames.systemGroupName[1].value() == "ahb_reset"
