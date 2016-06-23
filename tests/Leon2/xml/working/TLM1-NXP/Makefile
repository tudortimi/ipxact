##############################################################################
#                      SPIRIT 1.4 OSCI-TLM-PV example
#-----------------------------------------------------------------------------
# Makefile
#-----------------------------------------------------------------------------
# Revision: 1.4
# Authors:  Jean-Michel Fernandez
# 
# Revision:    $Revision: 1506 $
# Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
# 
# Copyright (c) 2007, 2008, 2009 The SPIRIT Consortium.
# 
# This work forms part of a deliverable of The SPIRIT Consortium.
# 
# Use of these materials are governed by the legal terms and conditions
# outlined in the disclaimer available from www.spiritconsortium.org.
# 
# This source file is provided on an AS IS basis.  The SPIRIT
# Consortium disclaims any warranty express or implied including
# any warranty of merchantability and fitness for use for a
# particular purpose.
# 
# The user of the source file shall indemnify and hold The SPIRIT
# Consortium and its members harmless from any damages or liability.
# Users are requested to provide feedback to The SPIRIT Consortium
# using either mailto:feedback@lists.spiritconsortium.org or the forms at 
# http://www.spiritconsortium.org/about/contact_us/
# 
# This file may be copied, and distributed, with or without
# modifications; but this notice must be included on any copy.
##############################################################################

#-----------------------------------------------------------------------------
# WARNING: 
#
# Prior to run this example, you must have installed the SystemC 2.1
# and OSCI TLM tarkits,
# and you must set the following environment variables:
#    setenv SYSTEMC_HOME <your_systemC_2.2_install_dir>
#    setenv OSCITLM_HOME <your_OSCI_TLM_install_dir>
#    setenv TAC_HOME     <your_TAC_install_dir>
#    setenv TARGET_ARCH  <your_target_OS>
#                        (e.g. linux or gccsparcOS5)
#    setenv GXX          <path_to_g++>
#
# You can update these variables in file setup.csh and source it before
# running make.
#
#----------------------------------------------------------------------------

TLM = ${OSCITLM_HOME}/tlm
DESIGN_ROOT = ../../spiritconsortium.org/Leon2TLM
PROTOCOL = ${DESIGN_ROOT}/PV

## Include directories
INCDIR = -I$(SYSTEMC_HOME)/include \
	-I$(TLM) \
	-I$(PROTOCOL) \
	-I$(DESIGN_ROOT)/ahbbus/1.4/tlmsrc \
	-I$(DESIGN_ROOT)/ahbram/1.4/tlmsrc \
	-I$(DESIGN_ROOT)/apbmst/1.4/tlmsrc \
	-I$(DESIGN_ROOT)/apbbus/1.4/tlmsrc \
	-I$(DESIGN_ROOT)/cgu/1.4/tlmsrc \
	-I$(DESIGN_ROOT)/rgu/1.4/tlmsrc \
	-I$(DESIGN_ROOT)/dma/1.4/tlmsrc \
	-I$(DESIGN_ROOT)/irqctrl/1.4/tlmsrc \
	-I$(DESIGN_ROOT)/processor/1.4/tlmsrc \
	-I$(DESIGN_ROOT)/timers/1.4/tlmsrc \
	-I.

## Library directories
LIBDIR = -L$(SYSTEMC_HOME)/lib-$(TARGET_ARCH)

## SystemC static library
LIB_SC = -lsystemc
#LIB_SC = -lsystemc_ar 
LIBS = $(LIBDIR) $(LIB_SC)  

## Compil flags
#FLAGS= -g -m32 -O3 -fpermissive -DVERBOSE_GLOBAL -Wno-deprecated -DSC_INCLUDE_DYNAMIC_PROCESSES -DTLM_HOST_ENDIAN=tlm::TLM_LITTLE_ENDIAN
FLAGS= -g -m32 -O3 -fpermissive -DVERBOSE_GLOBAL -Wno-deprecated -DSC_INCLUDE_DYNAMIC_PROCESSES
CFLAGS = $(FLAGS) $(INCDIR) 
VPATH = .
DEPEND = -MM

## Leon2 example .cc files
SRCS = 	SystemTLM1.cc \
	$(DESIGN_ROOT)/processor/1.4/tlmsrc/processor.cc \
	$(DESIGN_ROOT)/ahbram/1.4/tlmsrc/ahbram.cc \
	$(DESIGN_ROOT)/dma/1.4/tlmsrc/dma.cc \
	$(DESIGN_ROOT)/cgu/1.4/tlmsrc/cgu.cc \
	$(DESIGN_ROOT)/rgu/1.4/tlmsrc/rgu.cc \
	$(DESIGN_ROOT)/timers/1.4/tlmsrc/timers.cc \
	$(DESIGN_ROOT)/irqctrl/1.4/tlmsrc/irqctrl.cc \
	./apbSubSystem.cc \
	./Leon2Platform.cc \
  ./bool2sclv.cc

## Leon2 example .h files
HDRS = 	$(DESIGN_ROOT)/processor/1.4/tlmsrc/processor.h \
	$(DESIGN_ROOT)/ahbram/1.4/tlmsrc/ahbram.h \
	$(DESIGN_ROOT)/dma/1.4/tlmsrc/dma.h \
	$(DESIGN_ROOT)/cgu/1.4/tlmsrc/cgu.h \
	$(DESIGN_ROOT)/rgu/1.4/tlmsrc/rgu.h \
	$(DESIGN_ROOT)/timers/1.4/tlmsrc/timers.h \
	$(DESIGN_ROOT)/irqctrl/1.4/tlmsrc/irqctrl.h \
	./apbSubSystem.h \
	./Leon2Platform.h \
  ./bool2sclv.h

OBJS = $(SRCS:%.cc=%.o)

## Targets
all:    Make.dep SystemTLM1

.c.o:
	${GXX} $(CFLAGS) -c $<
.cc.o:
	${GXX} $(CFLAGS) -c $< -o $@

SystemTLM1: $(OBJS)
	${GXX} -m32 -o SystemTLM1 $(OBJS) $(LIBS)

depend:
	${GXX} $(DEPEND) $(CFLAGS) $(SRCS) $(HDRS) > Make.dep	

Make.dep:
	if [ ! -r Make.dep ] ; then ${GXX} $(DEPEND) $(CFLAGS) $(SRCS) > Make.dep; fi;

gold: SystemTLM1
	./SystemTLM1 > output.gold

test: SystemTLM1
	./SystemTLM1 > output.log
	@diff -w output.log output.gold || (echo "ERROR: output differs from golden file" ; exit 1)
	@echo "test passed"

clean:
	\rm -f *.o *.dep SystemTLM1 SystemTLM1.exe *~ output.log \
	$(DESIGN_ROOT)/SystemTLM1/apbSubSystem/tlmsrc/*.o \
	$(DESIGN_ROOT)/SystemTLM1/Leon2Platform/tlmsrc/*.o \
	$(DESIGN_ROOT)/processor/1.4/tlmsrc/processor.o \
	$(DESIGN_ROOT)/ahbram/1.4/tlmsrc/ahbram.o \
	$(DESIGN_ROOT)/dma/1.4/tlmsrc/dma.o \
	$(DESIGN_ROOT)/cgu/1.4/tlmsrc/cgu.o \
	$(DESIGN_ROOT)/rgu/1.4/tlmsrc/rgu.o \
	$(DESIGN_ROOT)/timers/1.4/tlmsrc/timers.o \
	$(DESIGN_ROOT)/irqctrl/1.4/tlmsrc/irqctrl.o \
	./apbSubSystem.o \
	./Leon2Platform.o \
  ./bool2sclv.o

include Make.dep


