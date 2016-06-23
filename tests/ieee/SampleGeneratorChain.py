#!/bin/env python

import sys
import os
dir = os.path.dirname(__file__)
sys.path.append(os.path.join(dir, '../..'))


import ipxact

xml = open(os.path.join(dir, 'xml/SampleGeneratorChain.xml'), 'r')
genChain = ipxact.CreateFromDocument(xml.read())

assert genChain.vendor == 'accellera.org'
assert genChain.library == 'Sample'
assert genChain.name == 'SampleGeneratorChain'
assert genChain.version == '1.0'

assert len(genChain.generatorChainSelector) == 2
for selIdx, sel in enumerate(genChain.generatorChainSelector):
    if selIdx == 0:
        assert sel.groupSelector.multipleGroupSelectionOperator == 'and'
        assert len(sel.groupSelector.name) == 2
        assert sel.groupSelector.name[0].value() == 'HDLAnalysis'
        assert sel.groupSelector.name[1].value() == 'HDLElaboration'
    if selIdx == 1:
        assert sel.generatorChainRef.vendor == 'accellera.org'
        assert sel.generatorChainRef.library == 'Sample'
        assert sel.generatorChainRef.name == 'SampleGeneratorChainForReference'
        assert sel.generatorChainRef.version == '1.0'
        

assert len(genChain.componentGeneratorSelector) == 1
assert len(genChain.componentGeneratorSelector[0].groupSelector.name) == 1
assert genChain.componentGeneratorSelector[0].groupSelector.name[0].value() == 'DocGeneration'

assert len(genChain.generator) == 1
for genIdx, gen in enumerate(genChain.generator):
    if genIdx == 0:
        assert gen.name == 'myGenerator'
        assert gen.displayName == 'My Generator'
        assert gen.description == 'This is my generator'
        assert gen.phase.value() == '100.0'
        assert len(gen.parameters.parameter) == 1
        for paramIdx, param in enumerate(gen.parameters.parameter):
            if paramIdx == 0:
                assert param.parameterId == 'genParm1'
                assert param.prompt == 'Parm 1'
                assert param.type == 'shortint'
                assert param.resolve == 'user'
                assert param.name == 'genParm1'
                assert param.description == 'First generator parameter.'
                assert param.value_.value() == '1'
        assert gen.apiType.value() == 'TGI_2014_BASE'
        assert gen.transportMethods.transportMethod.value() == 'file'
        assert gen.generatorExe.value() == '../bin/run.sh'

assert len(genChain.chainGroup) == 1
assert genChain.chainGroup[0].value() == 'implementation'
assert genChain.displayName == 'Sample Generator Chain'
assert genChain.description == 'Example generator chain used in the IP-XACT standard.'
