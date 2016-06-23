#!/bin/csh -f

# first argument is the language then the library and the rest are the HDL files

echo Compiling $2

if (! -d $2) then
  mkdir $2
endif

grep " $2 " cds.lib >/dev/null
if ($status) then
  echo "DEFINE $2 $2" >> cds.lib
endif

if (! -e hdl.var) then
  touch hdl.var
endif

if ($1 == "vhdl") then
  ncvhdl -v93 -work $argv[2-]
endif

if ($1 == "verilog") then
  if ($2 == "-incdir") then
    ncvlog -WORK -INCDIR $3 $argv[4-]
  else
    ncvlog -WORK $argv[2-]
  endif
endif
