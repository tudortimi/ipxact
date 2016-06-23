#!/bin/env python

import sys
import os
dir = os.path.dirname(__file__)
sys.path.append(os.path.join(dir, '../..'))


import ipxact

xml = open(os.path.join(dir, 'xml/SampleDesign.xml'), 'r')
design = ipxact.CreateFromDocument(xml.read())

assert design.vendor == 'accellera.org'
assert design.library == 'Sample'
assert design.name == 'SampleDesign'
assert design.version == '1.0'

assert len(design.componentInstances.componentInstance) == 3
for instIdx, inst in enumerate(design.componentInstances.componentInstance):
    if instIdx == 0:
        assert inst.instanceName == 'U1'
        assert inst.componentRef.vendor == 'accellera.org'
        assert inst.componentRef.library == 'Sample'
        assert inst.componentRef.name == 'SampleComponent'
        assert inst.componentRef.version == '1.0'
        
        assert len(inst.componentRef.configurableElementValues.configurableElementValue) == 1
        assert inst.componentRef.configurableElementValues.configurableElementValue[0].referenceId == 'comp_dual_mode'
        assert inst.componentRef.configurableElementValues.configurableElementValue[0].value() == '0'

    if instIdx == 1:
        assert inst.instanceName == 'U2'
        assert inst.componentRef.vendor == 'accellera.org'
        assert inst.componentRef.library == 'Sample'
        assert inst.componentRef.name == 'SampleComponent'
        assert inst.componentRef.version == '1.0'

    if instIdx == 2:
        assert inst.instanceName == 'U3'
        assert inst.componentRef.vendor == 'accellera.org'
        assert inst.componentRef.library == 'Sample'
        assert inst.componentRef.name == 'SampleComponent'
        assert inst.componentRef.version == '1.0'

assert len(design.interconnections.interconnection) == 3
for connIdx, conn in enumerate(design.interconnections.interconnection):
    if connIdx == 0:
        assert conn.name == 'TwoIntfs'
        assert len(conn.activeInterface) == 2
        for intfIdx, intf in enumerate(conn.activeInterface):
            if intfIdx == 0:
                assert intf.componentRef == 'U1'
                assert intf.busRef == 'Master'
            if intfIdx == 1:
                assert intf.componentRef == 'U2'
                assert intf.busRef == 'Slave'

    if connIdx == 1:
        assert conn.name == 'BroadcastConnection'
        assert len(conn.activeInterface) == 1
        for intfIdx, intf in enumerate(conn.activeInterface):
            if intfIdx == 0:
                assert intf.componentRef == 'U1'
                assert intf.busRef == 'Slave'
        assert len(conn.hierInterface) == 2
        conn.hierInterface[0].busRef == 'Slave0'
        conn.hierInterface[1].busRef == 'Slave1'

    if connIdx == 2:
        assert conn.name == 'ExportTLM'
        assert len(conn.activeInterface) == 1
        for intfIdx, intf in enumerate(conn.activeInterface):
            if intfIdx == 0:
                assert intf.componentRef == 'U3'
                assert intf.busRef == 'Master'
        assert len(conn.hierInterface) == 1
        conn.hierInterface[0].busRef == 'TLMMaster'

assert len(design.interconnections.monitorInterconnection) == 1
for connIdx, conn in enumerate(design.interconnections.monitorInterconnection):
    if connIdx == 0:
        assert conn.name == 'MonitorConnection'
        assert conn.monitoredActiveInterface.componentRef == 'U2'
        assert conn.monitoredActiveInterface.busRef == 'Slave'
        assert len(conn.monitorInterface) == 1
        for intfIdx, intf in enumerate(conn.monitorInterface):
            if intfIdx == 0:
                assert intf.componentRef == 'U2'
                assert intf.busRef == 'Monitor'

#assert len(design.adHocConnections.adHocConnection) == 1
for connIdx, conn in enumerate(design.adHocConnections.adHocConnection):
    if connIdx == 0:
        assert conn.name == 'SimpleWire'
        assert len(conn.portReferences.internalPortReference) == 2
        for portIdx, port in enumerate(conn.portReferences.internalPortReference):
            if portIdx == 0:
                assert port.componentRef == 'U1'
                assert port.portRef == 'anotherPort'
            if portIdx == 1:
                assert port.componentRef == 'U2'
                assert port.portRef == 'status'
                assert port.partSelect.range.left.value() == '7'
    
    if connIdx == 1:
        assert conn.name == 'TieOff'
        assert conn.tiedValue.value() == "3'h2"
        assert len(conn.portReferences.internalPortReference) == 1
        for portIdx, port in enumerate(conn.portReferences.internalPortReference):
            if portIdx == 0:
                assert port.componentRef == 'U2'
                assert port.portRef == 'anotherPort'
                assert port.partSelect.range.left.value() == '2'
                assert port.partSelect.range.right.value() == '0'

    if connIdx == 2:
        assert conn.name == 'TieOpen'
        assert conn.tiedValue.value() == 'open'
        assert len(conn.portReferences.internalPortReference) == 1
        for portIdx, port in enumerate(conn.portReferences.internalPortReference):
            if portIdx == 0:
                assert port.componentRef == 'U1'
                assert port.portRef == 'status'
