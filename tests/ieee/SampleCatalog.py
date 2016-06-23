#!/bin/env python

import sys
import os
dir = os.path.dirname(__file__)
sys.path.append(os.path.join(dir, '../..'))


import ipxact

xml = open(os.path.join(dir, 'xml/SampleCatalog.xml'), 'r')
catalog = ipxact.CreateFromDocument(xml.read())

assert catalog.vendor == 'accellera.org'
assert catalog.library == 'Sample'
assert catalog.name == 'SampleCatalog'
assert catalog.version == '1.0'
assert catalog.description == 'Example catalog used in the IP-XACT standard.'

assert catalog.busDefinitions != None
assert len(catalog.busDefinitions.ipxactFile) == 2

busDef0 = catalog.busDefinitions.ipxactFile[0]
assert busDef0.vlnv.vendor == 'accellera.org'
assert busDef0.vlnv.library == 'Sample'
assert busDef0.vlnv.name == 'SampleBusDefinitionBase'
assert busDef0.vlnv.version == '1.0'
assert busDef0.name.value() == './SampleBusDefinitionBase.xml'
assert busDef0.description == 'File included for semantic validation only.'

busDef1 = catalog.busDefinitions.ipxactFile[1]
assert busDef1.vlnv.vendor == 'accellera.org'
assert busDef1.vlnv.library == 'Sample'
assert busDef1.vlnv.name == 'SampleBusDefinitionExtension'
assert busDef1.vlnv.version == '1.0'
assert busDef1.name.value() == './SampleBusDefinitionExtension.xml'
assert busDef1.description == 'Sample extended busDefinition'

assert catalog.abstractionDefinitions != None
assert len(catalog.abstractionDefinitions.ipxactFile) == 2

abstrDef0 = catalog.abstractionDefinitions.ipxactFile[0]
assert abstrDef0.vlnv.vendor == 'accellera.org'
assert abstrDef0.vlnv.library == 'Sample'
assert abstrDef0.vlnv.name == 'SampleAbstractionDefinition_RTL'
assert abstrDef0.vlnv.version == '1.0'
assert abstrDef0.name.value() == './SampleAbstractionDefinition_RTL.xml'

abstrDef1 = catalog.abstractionDefinitions.ipxactFile[1]
assert abstrDef1.vlnv.vendor == 'accellera.org'
assert abstrDef1.vlnv.library == 'Sample'
assert abstrDef1.vlnv.name == 'SampleAbstractionDefinition_TLM'
assert abstrDef1.vlnv.version == '1.0'
assert abstrDef1.name.value() == './SampleAbstractionDefinition_TLM.xml'

assert catalog.components != None
assert len(catalog.components.ipxactFile) == 1

component0 = catalog.components.ipxactFile[0]
assert component0.vlnv.vendor == 'accellera.org'
assert component0.vlnv.library == 'Sample'
assert component0.vlnv.name == 'SampleComponent'
assert component0.vlnv.version == '1.0'
assert component0.name.value() == './SampleComponent.xml'

assert catalog.abstractors != None
assert len(catalog.abstractors.ipxactFile) == 1

abstractor0 = catalog.abstractors.ipxactFile[0]
assert abstractor0.vlnv.vendor == 'accellera.org'
assert abstractor0.vlnv.library == 'Sample'
assert abstractor0.vlnv.name == 'SampleAbstractor'
assert abstractor0.vlnv.version == '1.0'
assert abstractor0.name.value() == './SampleAbstractor.xml'

assert catalog.designs != None
assert len(catalog.designs.ipxactFile) == 1

design0 = catalog.designs.ipxactFile[0]
assert design0.vlnv.vendor == 'accellera.org'
assert design0.vlnv.library == 'Sample'
assert design0.vlnv.name == 'SampleDesign'
assert design0.vlnv.version == '1.0'
assert design0.name.value() == './SampleDesign.xml'

assert catalog.designConfigurations != None
assert len(catalog.designConfigurations.ipxactFile) == 1

designCfg0 = catalog.designConfigurations.ipxactFile[0]
assert designCfg0.vlnv.vendor == 'accellera.org'
assert designCfg0.vlnv.library == 'Sample'
assert designCfg0.vlnv.name == 'SampleDesignConfiguration'
assert designCfg0.vlnv.version == '1.0'
assert designCfg0.name.value() == './SampleDesignConfiguration.xml'

assert catalog.generatorChains != None
assert len(catalog.generatorChains.ipxactFile) == 2

genChain0 = catalog.generatorChains.ipxactFile[0]
assert genChain0.vlnv.vendor == 'accellera.org'
assert genChain0.vlnv.library == 'Sample'
assert genChain0.vlnv.name == 'SampleGeneratorChain'
assert genChain0.vlnv.version == '1.0'
assert genChain0.name.value() == './SampleGeneratorChain.xml'

genChain1 = catalog.generatorChains.ipxactFile[1]
assert genChain1.vlnv.vendor == 'accellera.org'
assert genChain1.vlnv.library == 'Sample'
assert genChain1.vlnv.name == 'SampleGeneratorChainForReference'
assert genChain1.vlnv.version == '1.0'
assert genChain1.name.value() == './SampleGeneratorChainForReference.xml'
