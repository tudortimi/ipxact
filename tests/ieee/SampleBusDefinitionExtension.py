#!/bin/env python

import sys
import os
dir = os.path.dirname(__file__)
sys.path.append(os.path.join(dir, '../..'))


import ipxact

xml = open(os.path.join(dir, 'xml/SampleBusDefinitionExtension.xml'), 'r')
busDef = ipxact.CreateFromDocument(xml.read())

assert busDef.vendor == 'accellera.org'
assert busDef.library == 'Sample'
assert busDef.name == 'SampleBusDefinitionExtension'
assert busDef.version == '1.0'
assert busDef.directConnection == True
assert busDef.isAddressable == False

assert busDef.extends.vendor == 'accellera.org'
assert busDef.extends.library == 'Sample'
assert busDef.extends.name == 'SampleBusDefinitionBase'
assert busDef.extends.version == '1.0'

assert busDef.maxMasters.value() == '1'
assert busDef.maxSlaves.value() == '16'

assert busDef.systemGroupNames != None
assert len(busDef.systemGroupNames.systemGroupName) == 1
assert busDef.systemGroupNames.systemGroupName[0].value() == 'SystemSignals'

assert busDef.description == 'Example bus definition used in the IP-XACT standard.'
