#!/bin/env python

import sys
sys.path.append('../..')


import ipxact

file_path = 'xml/spiritconsortium.org/Leon2RTL/creg/1.0/creg.xml'
xml = open(file_path, 'r')

component = ipxact.CreateFromDocument(xml.read())

assert component.vendor == 'spiritconsortium.org'
assert component.library == 'Leon2RTL'
assert component.name == 'creg'
assert component.version == '1.2'

# TODO Test bus interface stuff

assert component.memoryMaps != None

memoryMap0 = component.memoryMaps.memoryMap[0]
assert memoryMap0.name == "ambaAPB"
assert len(memoryMap0.addressBlock) == 1

addressBlock = memoryMap0.addressBlock[0]
assert addressBlock.name == "block"
assert addressBlock.baseAddress.value() == "0"

# TODO What's supposed to happen with expressions that are meant to be computed
# When and how should they be evaluated?
#assert addressBlock.range.value() == "1"

reg0 = addressBlock.register[0]
assert reg0.name == "Reg1"
assert reg0.addressOffset.value() == "'h0"
assert reg0.size.value() == '32'

assert reg0.field[0].name == 'field'
assert reg0.field[0].bitOffset.value() == '0'

# TODO 'reset' and 'value' are keywords in Python, so PyXB doesn't generate classes
# under these (exact) names
#assert reg0.field[0].resets.reset_[0].value_.value_() == ''

assert reg0.field[0].bitWidth.value() == '32'
assert reg0.field[0].volatile == False
assert reg0.field[0].access == ipxact.accessType.read_write

# TODO add checks for other registers
