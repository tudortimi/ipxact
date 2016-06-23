#!/bin/env python

import sys
sys.path.append('../..')


import ipxact

file_path = 'xml/st.com/SPG/tlm_tac/2.0/tlm_tac.xml'
xml = open(file_path, 'r')

abstrDef = ipxact.CreateFromDocument(xml.read())

assert abstrDef.vendor == 'st.com'
assert abstrDef.library == 'SPG'
assert abstrDef.name == 'tlm_tac'
assert abstrDef.version == '2.0'

assert abstrDef.busType.library == "AMBA2"
assert abstrDef.busType.name == "APB"
assert abstrDef.busType.vendor == "amba.com"
assert abstrDef.busType.version == "r2p0_4"

assert abstrDef.ports != None
assert len(abstrDef.ports.port) == 1

port0 = abstrDef.ports.port[0]
assert port0.logicalName == "tac_if"
assert port0.transactional != None
assert port0.transactional.onMaster.initiative == "requires"
assert port0.transactional.onMaster.protocol.protocolType.value() == "tlm"
assert port0.transactional.onSlave.initiative == "provides"
assert port0.transactional.onSlave.protocol.protocolType.value() == "tlm"
