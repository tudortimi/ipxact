#!/bin/env python

import sys
import os
dir = os.path.dirname(__file__)
sys.path.append(os.path.join(dir, '../..'))


import ipxact

xml = open(os.path.join(dir, 'xml/SampleDesignConfiguration.xml'), 'r')
config = ipxact.CreateFromDocument(xml.read())

assert config.vendor == 'accellera.org'
assert config.library == 'Sample'
assert config.name == 'SampleDesignConfiguration'
assert config.version == '1.0'

assert len(config.generatorChainConfiguration) == 1
for genChainCfgIdx, genChainCfg in enumerate(config.generatorChainConfiguration):
    if genChainCfgIdx == 0:
        assert genChainCfg.vendor == 'accellera.org'
        assert genChainCfg.library == 'Sample'
        assert genChainCfg.name == 'SampleGeneratorChain'
        assert genChainCfg.version == '1.0'
        assert len(genChainCfg.configurableElementValues.configurableElementValue) == 1
        assert genChainCfg.configurableElementValues.configurableElementValue[0].referenceId == 'genParm1'
        assert genChainCfg.configurableElementValues.configurableElementValue[0].value() == '7'

assert len(config.interconnectionConfiguration) == 1
for connCfgIdx, connCfg in enumerate(config.interconnectionConfiguration):
    if connCfgIdx == 0:
        assert connCfg.interconnectionRef == 'ExportTLM'
        assert len(connCfg.abstractorInstances) == 1
        assert len(connCfg.abstractorInstances[0].abstractorInstance) == 1
        for abstrInstIdx, abstrInst in enumerate(connCfg.abstractorInstances[0].abstractorInstance):
            if abstrInstIdx == 0:
                assert abstrInst.instanceName == 'U_tlm2rtl'
                assert abstrInst.abstractorRef.vendor == 'accellera.org'
                assert abstrInst.abstractorRef.library == 'Sample'
                assert abstrInst.abstractorRef.name == 'SampleAbstractor'
                assert abstrInst.abstractorRef.version == '1.0'
                assert abstrInst.viewName == 'default'

assert len(config.viewConfiguration) == 3
for viewCfgIdx, viewCfg in enumerate(config.viewConfiguration):
    if viewCfgIdx == 0:
        assert viewCfg.instanceName == 'U1'
        assert viewCfg.view.viewRef == 'RTLview'
    if viewCfgIdx == 1:
        assert viewCfg.instanceName == 'U2'
        assert viewCfg.view.viewRef == 'RTLview'
    if viewCfgIdx == 2:
        assert viewCfg.instanceName == 'U3'
        assert viewCfg.view.viewRef == 'TLMview'
        assert len(viewCfg.view.configurableElementValues.configurableElementValue) == 1
        assert viewCfg.view.configurableElementValues.configurableElementValue[0].referenceId == 'vdp'
        assert viewCfg.view.configurableElementValues.configurableElementValue[0].value() == '1'
