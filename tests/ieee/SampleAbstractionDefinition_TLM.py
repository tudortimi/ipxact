#!/bin/env python

import sys
import os
dir = os.path.dirname(__file__)
sys.path.append(os.path.join(dir, '../..'))


import ipxact

xml = open(os.path.join(dir, 'xml/SampleAbstractionDefinition_TLM.xml'), 'r')
abstrDef = ipxact.CreateFromDocument(xml.read())

assert abstrDef.vendor == 'accellera.org'
assert abstrDef.library == 'Sample'
assert abstrDef.name == 'SampleAbstractionDefinition_TLM'
assert abstrDef.version == '1.0'

assert abstrDef.busType.vendor == "accellera.org"
assert abstrDef.busType.library == "Sample"
assert abstrDef.busType.name == "SampleBusDefinitionExtension"
assert abstrDef.busType.version == "1.0"
assert abstrDef.ports != None
assert len(abstrDef.ports.port) == 1

port0 = abstrDef.ports.port[0]
assert port0.logicalName == 'Transport'
assert port0.transactional.onMaster.presence == 'optional'
assert port0.transactional.onMaster.initiative == 'provides'
assert port0.transactional.onMaster.kind.value() == 'simple_socket'
assert port0.transactional.onMaster.busWidth.value() == '8'
assert port0.transactional.onMaster.protocol.protocolType.value() == ipxact.protocolTypeType.tlm
assert port0.transactional.onMaster.protocol.payload.name == 'tlm2'
assert port0.transactional.onMaster.protocol.payload.type == 'generic'
assert port0.transactional.onSlave.initiative == 'requires'
assert port0.transactional.onSlave.kind.value() == 'simple_socket'
assert port0.transactional.onSlave.protocol.protocolType.value() == ipxact.protocolTypeType.tlm
assert port0.transactional.onSlave.protocol.payload.name == 'tlm2'
assert port0.transactional.onSlave.protocol.payload.type == 'generic'

assert abstrDef.description == 'Example TLM abstraction definition used in the IP-XACT standard.'
