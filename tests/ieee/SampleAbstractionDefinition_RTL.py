#!/bin/env python

import sys
import os
dir = os.path.dirname(__file__)
sys.path.append(os.path.join(dir, '../..'))


import ipxact

xml = open(os.path.join(dir, 'xml/SampleAbstractionDefinition_RTL.xml'), 'r')
abstrDef = ipxact.CreateFromDocument(xml.read())

assert abstrDef.vendor == 'accellera.org'
assert abstrDef.library == 'Sample'
assert abstrDef.name == 'SampleAbstractionDefinition_RTL'
assert abstrDef.version == '1.0'

assert abstrDef.busType.vendor == "accellera.org"
assert abstrDef.busType.library == "Sample"
assert abstrDef.busType.name == "SampleBusDefinitionExtension"
assert abstrDef.busType.version == "1.0"
assert abstrDef.ports != None
assert len(abstrDef.ports.port) == 4

port0 = abstrDef.ports.port[0]
assert port0.logicalName == 'Data'
assert port0.displayName == 'Data Bus'
assert port0.description == 'The data bus'
assert port0.wire.qualifier.isData == True
assert port0.wire.onMaster.presence == 'required'
assert port0.wire.onMaster.width.value() == '8'
assert port0.wire.onMaster.direction == 'out'
assert len(port0.wire.onMaster.modeConstraints.timingConstraint) == 1
assert port0.wire.onMaster.modeConstraints.timingConstraint[0].clockName == 'Clk'
assert port0.wire.onSlave.width.value() == '8'
assert port0.wire.onSlave.direction == 'in'

# TODO Is this a legal expression since it doesn't have a radix?
assert port0.wire.defaultValue.value() == "'ff"

port1 = abstrDef.ports.port[1]
assert port1.logicalName == 'Address'
assert port1.displayName == 'Address Bus'
assert port1.description == 'The address bus'
assert port1.wire.qualifier.isAddress == True
assert port1.wire.onMaster.presence == 'required'
assert port1.wire.onMaster.direction == 'out'
assert port1.wire.onSlave.width.value() == '8'
assert port1.wire.onSlave.direction == 'in'
assert port1.wire.defaultValue.value() == "'ff"

port2 = abstrDef.ports.port[2]
assert port2.logicalName == 'Clk'
assert port2.wire.qualifier.isClock == True
assert len(port2.wire.onSystem) == 1
assert port2.wire.onSystem[0].group == 'SystemSignals'
assert port2.wire.onSystem[0].width.value() == '1'
assert port2.wire.onSystem[0].direction == 'out'
assert port2.wire.onMaster.presence == 'optional'
assert port2.wire.onMaster.width.value() == '1'
assert port2.wire.onMaster.direction == 'in'
assert port2.wire.onSlave.presence == 'optional'
assert port2.wire.onSlave.width.value() == '1'
assert port2.wire.onSlave.direction == 'in'
assert port2.wire.requiresDriver.value() == True
assert port2.wire.requiresDriver.driverType == 'singleShot'

port3 = abstrDef.ports.port[3]
assert port3.isPresent.value() == 'UsingParity'
assert port3.logicalName == 'Parity'
assert port3.wire.onMaster.presence == 'required'
assert port3.wire.onMaster.width.value() == '1'
assert port3.wire.onMaster.direction == 'out'
assert port3.wire.onSlave.presence == 'required'
assert port3.wire.onSlave.width.value() == '1'
assert port3.wire.onSlave.direction == 'in'

assert abstrDef.description == 'Example RTL abstraction definition used in the IP-XACT standard.'
assert abstrDef.parameters != None
assert len(abstrDef.parameters.parameter) == 1

param0 = abstrDef.parameters.parameter[0]
assert param0.parameterId == 'UsingParity'
assert param0.type == 'bit'
assert param0.resolve == 'generated'
assert param0.name == 'UsingParity'
assert param0.description == 'Set to true if parity interface being used.'
assert param0.value_.value() == '0'
