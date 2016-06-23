#!/bin/env python

import sys
import os
dir = os.path.dirname(__file__)
sys.path.append(os.path.join(dir, '../..'))


import ipxact

xml = open(os.path.join(dir, 'xml/SampleComponent.xml'), 'r')
component = ipxact.CreateFromDocument(xml.read())

assert component.vendor == 'accellera.org'
assert component.library == 'Sample'
assert component.name == 'SampleComponent'
assert component.version == '1.0'

assert component.busInterfaces != None
assert len(component.busInterfaces.busInterface) == 7

busIntf0 = component.busInterfaces.busInterface[0]
assert busIntf0.name == 'Slave'
assert busIntf0.busType.vendor == 'accellera.org'
assert busIntf0.busType.library == 'Sample'
assert busIntf0.busType.name == 'SampleBusDefinition'
assert busIntf0.busType.version == '1.0'

assert busIntf0.abstractionTypes != None
assert len(busIntf0.abstractionTypes.abstractionType) == 2

abstrType0 = busIntf0.abstractionTypes.abstractionType[0]
assert abstrType0.viewRef[0].value() == 'RTLview'
assert abstrType0.abstractionRef.vendor == 'accellera.org'
assert abstrType0.abstractionRef.library == 'Sample'
assert abstrType0.abstractionRef.name == 'SampleAbstractionDefinition_RTL'
assert abstrType0.abstractionRef.version == '1.0'

assert abstrType0.abstractionRef.configurableElementValues != None
assert len(abstrType0.abstractionRef.configurableElementValues.configurableElementValue) == 1
assert abstrType0.abstractionRef.configurableElementValues.configurableElementValue[0].referenceId == 'UsingParity'
assert abstrType0.abstractionRef.configurableElementValues.configurableElementValue[0].value() == '1'

assert abstrType0.portMaps != None
assert len(abstrType0.portMaps.portMap) == 4

portMap0 = abstrType0.portMaps.portMap[0]
assert portMap0.logicalPort.name == 'Data'
assert portMap0.physicalPort.name == 'slv_data'
assert portMap0.physicalPort.partSelect.range.left.value() == '7'
assert portMap0.physicalPort.partSelect.range.right.value() == '0'

portMap1 = abstrType0.portMaps.portMap[1]
assert portMap1.logicalPort.name == 'Address'
assert portMap1.physicalPort.name == 'slv_addr'

portMap2 = abstrType0.portMaps.portMap[2]
assert portMap2.logicalPort.name == 'Parity'
assert portMap2.physicalPort.name == 'slv_parity'

portMap3 = abstrType0.portMaps.portMap[3]
assert portMap3.logicalPort.name == 'Clk'
assert portMap3.physicalPort.name == 'clk'
assert portMap3.isInformative == True

abstrType1 = busIntf0.abstractionTypes.abstractionType[1]
assert abstrType1.viewRef[0].value() == 'TLMview'
assert abstrType1.abstractionRef.vendor == 'accellera.org'
assert abstrType1.abstractionRef.library == 'Sample'
assert abstrType1.abstractionRef.name == 'SampleAbstractionDefinition_TLM'
assert abstrType1.abstractionRef.version == '1.0'

assert abstrType1.portMaps != None
assert len(abstrType1.portMaps.portMap) == 1

portMap0 = abstrType1.portMaps.portMap[0]
assert portMap0.logicalPort.name == 'Transport'
assert portMap0.physicalPort.name == 'slv_transaction'

assert busIntf0.slave.memoryMapRef.memoryMapRef == 'SimpleMapWithBlock'
assert busIntf0.connectionRequired == True

busIntf = component.busInterfaces.busInterface[1]
assert busIntf.name == 'Master'
assert busIntf.busType.vendor == 'accellera.org'
assert busIntf.busType.library == 'Sample'
assert busIntf.busType.name == 'SampleBusDefinition'
assert busIntf.busType.version == '1.0'

assert busIntf.abstractionTypes != None
assert len(busIntf.abstractionTypes.abstractionType) == 2

abstrType = busIntf.abstractionTypes.abstractionType[0]
assert abstrType.viewRef[0].value() == 'RTLview'
assert abstrType.abstractionRef.vendor == 'accellera.org'
assert abstrType.abstractionRef.library == 'Sample'
assert abstrType.abstractionRef.name == 'SampleAbstractionDefinition_RTL'
assert abstrType.abstractionRef.version == '1.0'

assert abstrType.abstractionRef.configurableElementValues != None
assert len(abstrType0.abstractionRef.configurableElementValues.configurableElementValue) == 1
assert abstrType.abstractionRef.configurableElementValues.configurableElementValue[0].referenceId == 'UsingParity'
assert abstrType.abstractionRef.configurableElementValues.configurableElementValue[0].value() == '0'

assert abstrType.portMaps != None
assert len(abstrType.portMaps.portMap) == 3

portMap = abstrType.portMaps.portMap[0]
assert portMap.logicalPort.name == 'Data'
assert portMap.physicalPort.name == 'mst_data'

portMap = abstrType.portMaps.portMap[1]
assert portMap.logicalPort.name == 'Address'
assert portMap.physicalPort.name == 'mst_addr'

portMap = abstrType.portMaps.portMap[2]
assert portMap.logicalPort.name == 'Clk'
assert portMap.physicalPort.name == 'clk'
assert portMap.isInformative == True

abstrType = busIntf.abstractionTypes.abstractionType[1]
assert abstrType.viewRef[0].value() == 'TLMview'
assert abstrType.abstractionRef.vendor == 'accellera.org'
assert abstrType.abstractionRef.library == 'Sample'
assert abstrType.abstractionRef.name == 'SampleAbstractionDefinition_TLM'
assert abstrType.abstractionRef.version == '1.0'

for idx, portMap in enumerate(abstrType.portMaps.portMap):
    if idx == 0:
        assert portMap.logicalPort.name == 'Transport'
        assert portMap.physicalPort.name == 'mst_transaction'

    if idx == 1:
        assert False

assert busIntf.master.addressSpaceRef.addressSpaceRef == 'simpleAddressSpace'

busIntf = component.busInterfaces.busInterface[2]
assert busIntf.name == 'MirroredMaster'
assert busIntf.busType.vendor == 'accellera.org'
assert busIntf.busType.library == 'Sample'
assert busIntf.busType.name == 'SampleBusDefinition'
assert busIntf.busType.version == '1.0'
assert busIntf.mirroredMaster != None

busIntf = component.busInterfaces.busInterface[3]
assert busIntf.name == 'MirroredSlave'
assert busIntf.busType.vendor == 'accellera.org'
assert busIntf.busType.library == 'Sample'
assert busIntf.busType.name == 'SampleBusDefinition'
assert busIntf.busType.version == '1.0'
assert busIntf.mirroredSlave.baseAddresses.remapAddress[0].value() == '0x40000000'
assert busIntf.mirroredSlave.baseAddresses.range.value() == '0x1000'

busIntf = component.busInterfaces.busInterface[4]
assert busIntf.name == 'SlaveWithTransparentBridge'
assert busIntf.busType.vendor == 'accellera.org'
assert busIntf.busType.library == 'Sample'
assert busIntf.busType.name == 'SampleBusDefinition'
assert busIntf.busType.version == '1.0'
assert busIntf.slave.transparentBridge[0].masterRef == 'Master'

busIntf = component.busInterfaces.busInterface[5]
assert busIntf.name == 'SlaveForSubspaceMap'
assert busIntf.busType.vendor == 'accellera.org'
assert busIntf.busType.library == 'Sample'
assert busIntf.busType.name == 'SampleBusDefinition'
assert busIntf.busType.version == '1.0'
assert busIntf.slave.memoryMapRef.memoryMapRef == 'SimpleMapWithSubspace'

busIntf = component.busInterfaces.busInterface[6]
assert busIntf.name == 'Monitor'
assert busIntf.busType.vendor == 'accellera.org'
assert busIntf.busType.library == 'Sample'
assert busIntf.busType.name == 'SampleBusDefinition'
assert busIntf.busType.version == '1.0'
assert busIntf.monitor.interfaceMode == 'slave'

for idx, indIntf in enumerate(component.indirectInterfaces.indirectInterface):
    if idx == 0:
        assert indIntf.name == 'IndirectMemoryInterface'
        assert indIntf.indirectAddressRef == 'IAR'
        assert indIntf.indirectDataRef == 'IDR'
        assert indIntf.memoryMapRef == 'MapForMemory'

    if idx == 1:
        assert False

for idx, channel in enumerate(component.channels.channel):
    if idx == 0:
        assert channel.name == 'theChannel'
        assert channel.busInterfaceRef[0].localName == 'MirroredMaster'
        assert channel.busInterfaceRef[1].localName == 'MirroredSlave'

    if idx == 1:
        assert False

for idx, remapState in enumerate(component.remapStates.remapState):
    if idx == 0:
        assert remapState.name == 'Boot'
        assert remapState.description == 'Defines the remap state associated with the component at boot time.'
    
    if idx == 1:
        assert remapState.name == 'Normal'
        assert remapState.description == 'Defines the remap state associated with the component after boot time.'

    if idx == 2:
        assert False

for idx, addrSpace in enumerate(component.addressSpaces.addressSpace):
    if idx == 0:
        assert addrSpace.name == 'simpleAddressSpace'
        assert addrSpace.range.value() == '4*(2**30)'
        assert addrSpace.width.value() == '32'
    
    if idx == 1:
        assert False

assert len(component.memoryMaps.memoryMap) == 4
for memMapIdx, memMap in enumerate(component.memoryMaps.memoryMap):
    if memMapIdx == 0:
        assert memMap.name == 'SimpleMapWithBlock'
        for addrBlockIdx, addrBlock in enumerate(memMap.addressBlock):
            if addrBlockIdx == 0:
                assert addrBlock.name == 'SimpleAddressBlock'
                assert addrBlock.baseAddress.value() == '0x0'
                assert addrBlock.range.value() == '2**10'
                assert addrBlock.width.value() == '32'
                assert addrBlock.usage == 'register'
                assert addrBlock.volatile == False
                assert addrBlock.access == 'read-write'
                for regIdx, reg in enumerate(addrBlock.register):
                    if regIdx == 0:
                        assert reg.name == 'BasicRegister'
                        assert reg.addressOffset.value() == '0x4'
                        assert reg.size.value() == '32'
                        assert reg.volatile == True
                        assert reg.access == 'read-writeOnce'
                        for fieldIdx, field in enumerate(reg.field):
                            if fieldIdx == 0:
                                assert field.name == 'F1'
                                assert field.bitOffset.value() == '0'
                                for rstIdx, rst in enumerate(field.resets.reset_):
                                    if rstIdx == 0:
                                        assert rst.value_.value() == '0x0'
                                    if rstIdx == 1:
                                        assert rst.resetTypeRef == 'SOFT'
                                        assert rst.value_.value() == '0xf'
                                        assert rst.mask.value() == '0xa'
                                    if rstIdx == 2:
                                        assert False
                                assert field.bitWidth.value() == '4'
                                assert field.access == 'writeOnce'
                                for rstIdx, enumVal in enumerate(field.enumeratedValues.enumeratedValue):
                                    if rstIdx == 0:
                                        assert enumVal.name == 'SetPos0'
                                        assert enumVal.value_.value() == '0x1'
                                    if rstIdx == 1:
                                        assert enumVal.name == 'SetPos1'
                                        assert enumVal.value_.value() == '0x2'
                                    if rstIdx == 2:
                                        assert False
                            
                            if fieldIdx == 1:
                                assert field.name == 'F2'
                                assert field.bitOffset.value() == '4'
                                for rstIdx, rst in enumerate(field.resets.reset_):
                                    if rstIdx == 0:
                                        assert rst.value_.value() == '0x0'
                                    if rstIdx == 1:
                                        assert False
                                assert field.bitWidth.value() == '4'
                                assert field.modifiedWriteValue.value() == 'oneToClear'
                                assert field.readAction.value() == 'modify'
                                assert field.testable.testConstraint == 'readOnly'
                                assert field.testable.value() == True
                            
                            if fieldIdx == 2:
                                assert field.name == 'F3'
                                assert field.bitOffset.value() == '8'
                                assert field.bitWidth.value() == '4'
                                assert field.writeValueConstraint.minimum.value() == '0x1'
                                assert field.writeValueConstraint.maximum.value() == '0x2'

                            if fieldIdx == 3:
                                assert field.name == 'F4'
                                assert field.bitOffset.value() == '12'
                                assert field.bitWidth.value() == '20'
                                assert field.reserved.value() == 'true'

                            if fieldIdx == 4:
                                assert False
                                
                    if regIdx == 1:
                        assert reg.name == 'IAR'
                        assert reg.addressOffset.value() == '0x8'
                        assert reg.size.value() == '32'
                        for fieldIdx, field in enumerate(reg.field):
                            if fieldIdx == 0:
                                assert field.fieldID == 'IAR'
                                assert field.name == 'IAR'
                                assert field.bitOffset.value() == '0'
                                assert field.bitWidth.value() == '32'
                            if fieldIdx == 1:
                                assert False

                    if regIdx == 2:
                        assert reg.name == 'IDR'
                        assert reg.addressOffset.value() == '0xc'
                        assert reg.size.value() == '32'
                        for fieldIdx, field in enumerate(reg.field):
                            if fieldIdx == 0:
                                assert field.fieldID == 'IDR'
                                assert field.name == 'IDR'
                                assert field.bitOffset.value() == '0'
                                assert field.bitWidth.value() == '32'
                            if fieldIdx == 1:
                                assert False
                        
                    if regIdx == 3:
                        assert reg.name == 'RegisterWithAlternate'
                        assert reg.addressOffset.value() == '0x10'
                        assert reg.size.value() == '32'
                        assert reg.access == 'write-only'
                        
                        for fieldIdx, field in enumerate(reg.field):
                            if fieldIdx == 0:
                                assert field.name == 'F'
                                assert field.bitOffset.value() == '0'
                                assert field.bitWidth.value() == '32'
                        assert fieldIdx == 0
                        
                        for altRegIdx, altReg in enumerate(reg.alternateRegisters.alternateRegister):
                            if altRegIdx == 0:
                                assert altReg.name == 'Alternate1'
                                
                                for altGroupIdx, altGroup in enumerate(altReg.alternateGroups.alternateGroup):
                                    if altGroupIdx == 0:
                                        assert altGroup.value() == 'AltRegGroup'
                                assert altGroupIdx == 0
                                
                                assert altReg.access == 'read-only'
                                for fieldIdx, field in enumerate(altReg.field):
                                    if fieldIdx == 0:
                                        assert field.name == 'F'
                                        assert field.bitOffset.value() == '0'
                                        assert field.bitWidth.value() == '32'
                                assert fieldIdx == 0                                    
                        assert altRegIdx == 0
                        
                assert regIdx == 3
                
                assert len(addrBlock.registerFile) == 1
                for regFileIdx, regFile in enumerate(addrBlock.registerFile):
                    if regFileIdx == 0:
                        assert regFile.name == 'RegisterArray'

                        assert len(regFile.dim) == 1
                        for dimIdx, dim in enumerate(regFile.dim):
                            if dimIdx == 0:
                                assert dim.value() == '8'
                        
                        assert regFile.addressOffset.value() == '0x200'
                        assert regFile.range.value() == '0x10'
                        
                        assert len(regFile.register) == 1
                        for regIdx, reg in enumerate(regFile.register):
                            if regIdx == 0:
                                assert reg.name == 'RegArrayEntry'
                                assert reg.addressOffset.value() == '0x0'
                                assert reg.size.value() == '32'
                                assert len(reg.field) == 1
                                for fieldIdx, field in enumerate(reg.field):
                                    if fieldIdx == 0:
                                        assert field.name == 'MandatoryField'
                                        assert field.bitOffset.value() == '0'
                                        assert field.bitWidth.value() == '32'
                
        assert memMap.addressUnitBits.value() == '8'
                                
    if memMapIdx == 1:
        assert memMap.name == 'SimpleMapWithBank'
        
        assert len(memMap.bank) == 1
        for bankIdx, bank in enumerate(memMap.bank):
            if bankIdx == 0:
                assert bank.bankAlignment == 'serial'
                assert bank.name == 'SerialBank'
                assert bank.baseAddress.value() == '0x1000'

                assert len(bank.addressBlock) == 2
                for addrBlockIdx, addrBlock in enumerate(bank.addressBlock):
                    if addrBlockIdx == 0:
                        assert addrBlock.name == 'ram0'
                        assert addrBlock.range.value() == '0x1000'
                        assert addrBlock.width.value() == '32'
                    if addrBlockIdx == 1:
                        assert addrBlock.name == 'ram1'
                        assert addrBlock.range.value() == '0x1000'
                        assert addrBlock.width.value() == '32'
                        
    if memMapIdx == 2:
        assert memMap.name == 'SimpleMapWithSubspace'
        
        assert len(memMap.subspaceMap) == 1
        for subMapIdx, subMap in enumerate(memMap.subspaceMap):
            if subMapIdx == 0:
                assert subMap.masterRef == 'Master'
                assert subMap.name == 'SubSpace'
                assert subMap.baseAddress.value() == '0x10000'

    if memMapIdx == 3:
        assert memMap.name == 'MapForMemory'
        
        assert len(memMap.addressBlock) == 1
        for addrBlockIdx, addrBlock in enumerate(memMap.addressBlock):
            if addrBlockIdx == 0:
                assert addrBlock.name == 'MemoryBlock'
                assert addrBlock.baseAddress.value() == '0x0'
                assert addrBlock.range.value() == '2**10';
                assert addrBlock.width.value() == '32'
                assert addrBlock.usage == 'memory'
                assert addrBlock.access == 'read-write'

assert len(component.model.views.view) == 2
for viewIdx, view in enumerate(component.model.views.view):
    if viewIdx == 0:
        assert view.name == 'RTLview'
        assert view.displayName == 'RTL View'
        assert view.description == 'Simple RTL view of a component.'
        assert len(view.envIdentifier) == 1
        assert view.envIdentifier[0].value() == ':*Synthesis:'
        assert view.componentInstantiationRef == 'VerilogModel'

    if viewIdx == 1:
        assert view.name == 'TLMview'
        assert view.displayName == 'TLM View'
        assert view.description == 'Simple TLM view of a component.'
        assert len(view.envIdentifier) == 1
        assert view.envIdentifier[0].value() == ':*Simulation:'
        assert view.componentInstantiationRef == 'TLMModel'

assert len(component.model.instantiations.componentInstantiation) == 2
for instIdx, inst in enumerate(component.model.instantiations.componentInstantiation):
    if instIdx == 0:
        assert inst.name == 'VerilogModel'
        assert inst.language.value() == 'verilog'
        assert inst.moduleName == 'sample'
        
        assert len(inst.moduleParameters.moduleParameter) == 1
        for modParamIdx, modParam in enumerate(inst.moduleParameters.moduleParameter):
            if modParamIdx == 0:
                assert modParam.type == 'bit'
                assert modParam.name == 'dual_mode_reg_value'
                
                assert len(modParam.vectors.vector) == 1
                assert modParam.vectors.vector[0].left.value() == '3'
                assert modParam.vectors.vector[0].right.value() == '0'
                
                assert modParam.value_.value() == "comp_dual_mode?4'hf:4'h0"

        assert len(inst.fileSetRef) == 1
        assert inst.fileSetRef[0].localName == 'VerilogFiles'
    
    if instIdx == 1:
        assert inst.name == 'TLMModel'
        assert inst.language.value() == 'SystemC'
        assert inst.moduleName == 'sample'

        assert len(inst.moduleParameters.moduleParameter) == 2
        for modParamIdx, modParam in enumerate(inst.moduleParameters.moduleParameter):
            if modParamIdx == 0:
                assert modParam.type == 'bit'
                assert modParam.name == 'dual_mode'
                assert modParam.value_.value() == 'comp_dual_mode'
            
            if modParamIdx == 1:
                assert modParam.parameterId == 'vdp'
                assert modParam.resolve == 'generated'
                assert modParam.type == 'bit'
                assert modParam.name == 'view_dependent_param'
                assert modParam.value_.value() == '0'

        assert len(inst.fileSetRef) == 1
        assert inst.fileSetRef[0].localName == 'SystemCFiles'

assert len(component.model.ports.port) == 11
for portIdx, port in enumerate(component.model.ports.port):
    if portIdx == 0:
        assert port.name == 'slv_data'
        assert port.wire.direction == 'in'
        assert len(port.wire.vectors.vector) == 1
        assert port.wire.vectors.vector[0].left.value() == '15'
        assert len(port.wire.wireTypeDefs.wireTypeDef) == 1
        assert port.wire.wireTypeDefs.wireTypeDef[0].typeName.value() == 'logic'
        assert len(port.wire.wireTypeDefs.wireTypeDef[0].viewRef) == 1
        assert port.wire.wireTypeDefs.wireTypeDef[0].viewRef[0].value() == 'RTLview'
        assert len(port.wire.drivers.driver) == 1
        assert port.wire.drivers.driver[0].range.left.value() == '15'
        assert port.wire.drivers.driver[0].defaultValue.value() == "8'h0"

    if portIdx == 1:
        assert port.name == 'mst_data'
        assert port.wire.direction == 'out'
        assert len(port.wire.vectors.vector) == 1
        assert port.wire.vectors.vector[0].left.value() == '7'
        assert len(port.wire.wireTypeDefs.wireTypeDef) == 1
        assert port.wire.wireTypeDefs.wireTypeDef[0].typeName.value() == 'logic'
        assert len(port.wire.wireTypeDefs.wireTypeDef[0].viewRef) == 1
        assert port.wire.wireTypeDefs.wireTypeDef[0].viewRef[0].value() == 'RTLview'
    
    if portIdx == 2:
        assert port.name == 'slv_addr'
        assert port.wire.direction == 'in'
        assert len(port.wire.vectors.vector) == 1
        assert port.wire.vectors.vector[0].left.value() == '7'
        assert len(port.wire.wireTypeDefs.wireTypeDef) == 1
        assert port.wire.wireTypeDefs.wireTypeDef[0].typeName.value() == 'logic'
        assert len(port.wire.wireTypeDefs.wireTypeDef[0].viewRef) == 1
        assert port.wire.wireTypeDefs.wireTypeDef[0].viewRef[0].value() == 'RTLview'
        assert len(port.wire.constraintSets.constraintSet) == 1
        assert port.wire.constraintSets.constraintSet[0].driveConstraint.cellSpecification.cellStrength == 'high'
        assert port.wire.constraintSets.constraintSet[0].driveConstraint.cellSpecification.cellClass == 'sequential'
        assert len(port.wire.constraintSets.constraintSet[0].timingConstraint) == 1
        assert port.wire.constraintSets.constraintSet[0].timingConstraint[0].clockName == 'clk'
        
        # TODO The binding insists on giving me '60.0' as a real number, not a string
        #assert port.wire.constraintSets.constraintSet[0].timingConstraint[0].value() == '60'
        assert port.wire.constraintSets.constraintSet[0].timingConstraint[0].value() == 60

    if portIdx == 3:
        assert port.name == 'mst_addr'
        assert port.wire.direction == 'out'
        assert len(port.wire.vectors.vector) == 1
        assert port.wire.vectors.vector[0].left.value() == '7'
        assert len(port.wire.wireTypeDefs.wireTypeDef) == 1
        assert port.wire.wireTypeDefs.wireTypeDef[0].typeName.value() == 'logic'
        assert len(port.wire.wireTypeDefs.wireTypeDef[0].viewRef) == 1
        assert port.wire.wireTypeDefs.wireTypeDef[0].viewRef[0].value() == 'RTLview'
        assert len(port.wire.constraintSets.constraintSet) == 1
        assert port.wire.constraintSets.constraintSet[0].loadConstraint.cellSpecification.cellStrength == 'high'
        assert port.wire.constraintSets.constraintSet[0].loadConstraint.cellSpecification.cellClass == 'sequential'
        assert port.wire.constraintSets.constraintSet[0].loadConstraint.count.value() == '2'
        assert len(port.wire.constraintSets.constraintSet[0].timingConstraint) == 1
        assert port.wire.constraintSets.constraintSet[0].timingConstraint[0].clockName == 'clk'
        
        # TODO The binding insists on giving me '40.0' as a real number, not a string
        #assert port.wire.constraintSets.constraintSet[0].timingConstraint[0].value() == '40'
        assert port.wire.constraintSets.constraintSet[0].timingConstraint[0].value() == 40

    if portIdx == 4:
        assert port.name == 'slv_parity'
        assert port.wire.direction == 'in'
        assert len(port.wire.wireTypeDefs.wireTypeDef) == 1
        assert len(port.wire.wireTypeDefs.wireTypeDef[0].viewRef) == 1
        assert port.wire.wireTypeDefs.wireTypeDef[0].viewRef[0].value() == 'RTLview'

    if portIdx == 5:
        assert port.name == 'clk'
        assert port.wire.direction == 'in'
        assert len(port.wire.wireTypeDefs.wireTypeDef) == 1
        assert len(port.wire.wireTypeDefs.wireTypeDef[0].viewRef) == 1
        assert port.wire.wireTypeDefs.wireTypeDef[0].viewRef[0].value() == 'RTLview'
        assert len(port.wire.drivers.driver) == 1
        assert port.wire.drivers.driver[0].clockDriver.clockPeriod.value() == '5'
        assert port.wire.drivers.driver[0].clockDriver.clockPulseOffset.value() == '2.5'
        assert port.wire.drivers.driver[0].clockDriver.clockPulseValue.value() == '1'
        assert port.wire.drivers.driver[0].clockDriver.clockPulseDuration.value() == '2.5'

    if portIdx == 6:
        assert port.name == 'reset'
        assert port.wire.direction == 'in'
        assert len(port.wire.wireTypeDefs.wireTypeDef) == 1
        assert len(port.wire.wireTypeDefs.wireTypeDef[0].viewRef) == 1
        assert port.wire.wireTypeDefs.wireTypeDef[0].viewRef[0].value() == 'RTLview'
        assert len(port.wire.drivers.driver) == 1
        assert port.wire.drivers.driver[0].singleShotDriver.singleShotOffset.value() == '2'
        assert port.wire.drivers.driver[0].singleShotDriver.singleShotValue.value() == '1'
        assert port.wire.drivers.driver[0].singleShotDriver.singleShotDuration.value() == '5'

    if portIdx == 7:
        assert port.name == 'status'
        assert port.wire.direction == 'out'
        assert len(port.wire.vectors.vector) == 1
        assert port.wire.vectors.vector[0].left.value() == '7'

    if portIdx == 8:
        assert port.name == 'anotherPort'
        assert port.wire.direction == 'in'
        assert len(port.wire.vectors.vector) == 1
        assert port.wire.vectors.vector[0].left.value() == '3'

    if portIdx == 9:
        assert port.name == 'slv_transaction'
        assert port.transactional.initiative == 'requires'
        assert len(port.transactional.transTypeDefs.transTypeDef) == 1
        assert port.transactional.transTypeDefs.transTypeDef[0].typeName.value() == 'sampleTLMtype'
        assert len(port.transactional.transTypeDefs.transTypeDef[0].viewRef) == 1
        assert port.transactional.transTypeDefs.transTypeDef[0].viewRef[0].value() == 'TLMview'

    if portIdx == 10:
        assert port.name == 'mst_transaction'
        assert port.transactional.initiative == 'provides'
        assert len(port.transactional.transTypeDefs.transTypeDef) == 1
        assert port.transactional.transTypeDefs.transTypeDef[0].typeName.value() == 'sampleTLMtype'
        assert len(port.transactional.transTypeDefs.transTypeDef[0].viewRef) == 1
        assert port.transactional.transTypeDefs.transTypeDef[0].viewRef[0].value() == 'TLMview'

assert len(component.componentGenerators.componentGenerator) == 1
for compGenIdx, compGen in enumerate(component.componentGenerators.componentGenerator):
    if compGenIdx == 0:
        assert compGen.name == 'SimpleComponentGenerator'
        assert compGen.description == 'Simple TGI based component generator'
        assert compGen.phase.value() == '1'
        
        assert len(compGen.parameters.parameter) == 2
        for paramIdx, param in enumerate(compGen.parameters.parameter):
            if paramIdx == 0:
                assert param.parameterId == 'genParm1'
                assert param.prompt == 'Parm 1'
                assert param.type == 'shortint'
                assert param.resolve == 'user'
                assert param.name == 'genParm1'
                assert param.description == 'First generator parameter.'
                assert param.value_.value() == '1'
            
            if paramIdx == 1:
                assert param.parameterId == 'genParm2'
                assert param.prompt == 'Parm 2'
                assert param.type == 'shortint'
                assert param.resolve == 'user'
                assert param.name == 'genParm2'
                assert param.description == 'Second generator parameter.'
                assert param.value_.value() == '2'
            
        assert compGen.apiType.value() == 'TGI_2014_BASE'
        assert compGen.generatorExe.value() == '../bin/generator.sh'

assert len(component.choices.choice) == 1
for choiceIdx, choice in enumerate(component.choices.choice):
    if choiceIdx == 0:
        assert choice.name == 'bitsize'
        assert len(choice.enumeration) == 2
        assert choice.enumeration[0].text == '32 bits'
        assert choice.enumeration[0].value() == '32'
        assert choice.enumeration[1].text == '64 bits'
        assert choice.enumeration[1].value() == '64'

assert len(component.fileSets.fileSet) == 2
for fileSetIdx, fileSet in enumerate(component.fileSets.fileSet):
    if fileSetIdx == 0:
        assert fileSet.name == 'VerilogFiles'
        assert len(fileSet.file) == 1
        assert fileSet.file[0].name.value() == '../src/component.v'
        assert len(fileSet.file[0].fileType) == 1
        assert fileSet.file[0].fileType[0].value() == 'verilogSource'

    if fileSetIdx == 1:
        assert fileSet.name == 'SystemCFiles'
        assert len(fileSet.file) == 1
        assert fileSet.file[0].name.value() == '../src/component.C'
        assert len(fileSet.file[0].fileType) == 1
        assert fileSet.file[0].fileType[0].value() == 'systemCSource-2.2'

assert len(component.whiteboxElements.whiteboxElement) == 1
for wboxElemIdx, wboxElem in enumerate(component.whiteboxElements.whiteboxElement):
    if wboxElemIdx == 0:
        assert wboxElem.name == 'ImportantInternalSignal'
        assert wboxElem.description == 'Defines access point for forcing sim values'
        assert wboxElem.whiteboxType == 'signal'
        assert wboxElem.driveable == True

assert len(component.cpus.cpu) == 1
assert component.cpus.cpu[0].name == 'cpuDefn'
assert len(component.cpus.cpu[0].addressSpaceRef) == 1
assert component.cpus.cpu[0].addressSpaceRef[0].addressSpaceRef == 'simpleAddressSpace'

assert len(component.otherClockDrivers.otherClockDriver) == 1
for clockDrvIdx, clockDrv in enumerate(component.otherClockDrivers.otherClockDriver):
    if clockDrvIdx == 0:
        assert clockDrv.clockName == 'virtualClock1'
        assert clockDrv.clockPeriod.value() == '10'
        assert clockDrv.clockPulseOffset.value() == '5'
        assert clockDrv.clockPulseValue.value() == '1'
        assert clockDrv.clockPulseDuration.value() == '5'

assert len(component.resetTypes.resetType) == 1
assert component.resetTypes.resetType[0].name == 'SOFT'
assert component.resetTypes.resetType[0].displayName == 'Soft Reset'

assert component.description == 'Example component used in the IP-XACT standard.'

assert len(component.parameters.parameter) == 3
for paramIdx, param in enumerate(component.parameters.parameter):
    if paramIdx == 0:
        assert param.parameterId == 'TLMModelsAvailable'
        assert param.prompt == 'TLM Models Available'
        assert param.type == 'bit'
        assert param.resolve == 'user'
        assert param.name == 'TLMModelsAvailable'
        assert param.displayName == 'TLM Models Available'
        assert param.description == 'Set to true if TLM simulation models are available.'
        assert param.value_.value() == '0'

    if paramIdx == 1:
        assert param.parameterId == 'comp_dual_mode'
        assert param.prompt == 'Dual Mode Supported'
        assert param.type == 'bit'
        assert param.resolve == 'user'
        assert param.name == 'comp_dual_mode'
        assert param.description == 'Indicates dual mode support is desired.'
        assert param.value_.value() == '1'

    if paramIdx == 2:
        assert param.parameterId == 'addrBits'
        assert param.choiceRef == 'bitsize'
        assert param.prompt == 'Address Bits'
        assert param.type == 'shortint'
        assert param.resolve == 'user'
        assert param.name == 'addrBits'
        assert param.value_.value() == '32'

assert len(component.assertions.assertion) == 1
for assrtIdx, assrt in enumerate(component.assertions.assertion):
    if assrtIdx == 0:
        assert assrt.name == 'ArbitraryAssertion1'
        assert assrt.description == 'Arbitrary assertion to show syntax. Must evaluate to true.'
        assert assrt.assert_.value() == 'TLMModelsAvailable || !comp_dual_mode'

# TODO Figure out how to handle vendorExtensions
