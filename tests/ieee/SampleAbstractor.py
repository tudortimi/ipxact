#!/bin/env python

import sys
import os
dir = os.path.dirname(__file__)
sys.path.append(os.path.join(dir, '../..'))


import ipxact

xml = open(os.path.join(dir, 'xml/SampleAbstractor.xml'), 'r')
abstractor = ipxact.CreateFromDocument(xml.read())

assert abstractor.vendor == 'accellera.org'
assert abstractor.library == 'Sample'
assert abstractor.name == 'SampleAbstractor'
assert abstractor.version == '1.0'

assert abstractor.abstractorMode.value() == 'master'
assert abstractor.busType.vendor == 'accellera.org'
assert abstractor.busType.library == 'Sample'
assert abstractor.busType.name == 'SampleBusDefinition'
assert abstractor.busType.version == '1.0'

assert abstractor.abstractorInterfaces != None
assert len(abstractor.abstractorInterfaces.abstractorInterface) == 2

intf0 = abstractor.abstractorInterfaces.abstractorInterface[0]
assert intf0.name == 'Master'
assert intf0.abstractionTypes != None
assert len(intf0.abstractionTypes.abstractionType) == 1
assert intf0.abstractionTypes.abstractionType[0].abstractionRef.vendor == 'accellera.org'
assert intf0.abstractionTypes.abstractionType[0].abstractionRef.library == 'Sample'
assert intf0.abstractionTypes.abstractionType[0].abstractionRef.name == 'SampleAbstractionDefinition_TLM'
assert intf0.abstractionTypes.abstractionType[0].abstractionRef.version == '1.0'

intf1 = abstractor.abstractorInterfaces.abstractorInterface[1]
assert intf1.name == 'MirroredMaster'
assert intf1.abstractionTypes != None
assert len(intf1.abstractionTypes.abstractionType) == 1
assert intf1.abstractionTypes.abstractionType[0].abstractionRef.vendor == 'accellera.org'
assert intf1.abstractionTypes.abstractionType[0].abstractionRef.library == 'Sample'
assert intf1.abstractionTypes.abstractionType[0].abstractionRef.name == 'SampleAbstractionDefinition_RTL'
assert intf1.abstractionTypes.abstractionType[0].abstractionRef.version == '1.0'
