export PYTHONPATH='dependencies/pyxb'

dependencies/pyxb/scripts/pyxbgen \
    -u http://accellera.org/images/xmlschema/ipxact/1685-2014/index.xsd \
    --module ipxact \
    --write-for-customization
