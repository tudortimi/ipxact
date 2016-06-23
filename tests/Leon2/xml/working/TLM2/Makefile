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
#    setenv SCML_HOME    <your_SCML_install_dir>
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
SCML = ${SCML_HOME}/include
TAC = ${TAC_HOME}
DESIGN_ROOT = ../../spiritconsortium.org/Leon2TLM
PROTOCOL = ${DESIGN_ROOT}/PV

## Include directories
INCDIR = -I$(SYSTEMC_HOME)/include \
	-I$(TLM) \
	-I$(SCML) \
	-I$(TAC)/devkit/tlm/include \
	-I$(TAC)/devkit/tlm_message/include \
	-I$(TAC)/devkit/tlm_utilities/include \
	-I$(TAC)/protocol/tlm_tac/include \
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
	-I$(DESIGN_ROOT)/scmlAdaptor/1.0/tlmsrc \
	-I$(DESIGN_ROOT)/uart_scml/1.0/tlmsrc/inc \
	-I$(DESIGN_ROOT)/serial_device/1.0/tlmsrc \
	-I$(DESIGN_ROOT)/pv2tac/1.0/tlmsrc \
	-I$(DESIGN_ROOT)/uart_tac/1.0/tlmsrc/include \
	-I$(DESIGN_ROOT)/SystemTLM2/apbSubSystem/tlmsrc \
	-I$(DESIGN_ROOT)/SystemTLM2/Leon2Platform/tlmsrc

## Library directories
LIBDIR = -L$(SYSTEMC_HOME)/lib-$(TARGET_ARCH) -L$(SCML_HOME)/lib-$(TARGET_ARCH)

## SystemC static library
LIB_SC = -lsystemc
LIB_SCML = -lModelingObjects
LIB_TAC = $(TAC_HOME)/tac_metadata.o $(TAC_HOME)/tlm_*.o
#LIB_SC = -lsystemc_ar 
LIBS = $(LIBDIR) $(LIB_SC) $(LIB_SCML) $(LIB_TAC)

## Compil flags
FLAGS= -g -m32 -O3 -fpermissive -DVERBOSE_GLOBAL -Wno-deprecated -DSC_INCLUDE_DYNAMIC_PROCESSES
CFLAGS = $(FLAGS) $(INCDIR) 
VPATH = .
DEPEND = -MM

## Leon2 example .cc files
SRCS = 	SystemTLM2.cc \
	bool2sclv.cc \
	$(DESIGN_ROOT)/processor/1.4/tlmsrc/processor.cc \
	$(DESIGN_ROOT)/ahbram/1.4/tlmsrc/ahbram.cc \
	$(DESIGN_ROOT)/dma/1.4/tlmsrc/dma.cc \
	$(DESIGN_ROOT)/cgu/1.4/tlmsrc/cgu.cc \
	$(DESIGN_ROOT)/rgu/1.4/tlmsrc/rgu.cc \
	$(DESIGN_ROOT)/timers/1.4/tlmsrc/timers.cc \
	$(DESIGN_ROOT)/irqctrl/1.4/tlmsrc/irqctrl.cc \
	$(DESIGN_ROOT)/scmlAdaptor/1.0/tlmsrc/scmladaptor.cc \
	$(DESIGN_ROOT)/uart_scml/1.0/tlmsrc/src/uart.cc \
	$(DESIGN_ROOT)/uart_scml/1.0/tlmsrc/src/uart_interrupt_handler.cc \
	$(DESIGN_ROOT)/uart_scml/1.0/tlmsrc/src/uart_register_bank.cc \
	$(DESIGN_ROOT)/uart_scml/1.0/tlmsrc/src/uart_serial_tx_rx.cc \
	$(DESIGN_ROOT)/pv2tac/1.0/tlmsrc/pv2tac.cc \
	$(DESIGN_ROOT)/uart_tac/1.0/tlmsrc/src/Leon2_uart.cc \
	$(DESIGN_ROOT)/uart_tac/1.0/tlmsrc/src/tlmreg_Leon2_uart.cc \
	$(DESIGN_ROOT)/uart_tac/1.0/tlmsrc/src/user_specific_Leon2_uart.cc

OBJS = $(SRCS:%.cc=%.o)

## Targets
all:    Make.dep SystemTLM2

.c.o:
	${GXX} $(CFLAGS) -c $<
.cc.o:
	${GXX} $(CFLAGS) -c $< -o $@

SystemTLM2: $(OBJS)
	${GXX} -m32 -o SystemTLM2 $(OBJS) $(LIBS)

depend:
	${GXX} $(DEPEND) $(CFLAGS) $(SRCS) > Make.dep	

Make.dep:
	if [ ! -r Make.dep ] ; then ${GXX} $(DEPEND) $(CFLAGS) $(SRCS) > Make.dep; fi;

gold: SystemTLM2
	./SystemTLM2 > output.gold

test: SystemTLM2
	./SystemTLM2 > output.log
	@diff -w output.log output.gold || (echo "ERROR: output differs from golden file" ; exit 1)
	@echo "test passed"

clean:
	\rm -f *.o *.dep SystemTLM2 SystemTLM2.exe *~ output.log \
	$(DESIGN_ROOT)/SystemTLM2/apbSubSystem/tlmsrc/*.o \
	$(DESIGN_ROOT)/SystemTLM2/Leon2Platform/tlmsrc/*.o \
	$(DESIGN_ROOT)/processor/1.4/tlmsrc/processor.o \
	$(DESIGN_ROOT)/ahbram/1.4/tlmsrc/ahbram.o \
	$(DESIGN_ROOT)/dma/1.4/tlmsrc/dma.o \
	$(DESIGN_ROOT)/cgu/1.4/tlmsrc/cgu.o \
	$(DESIGN_ROOT)/rgu/1.4/tlmsrc/rgu.o \
	$(DESIGN_ROOT)/timers/1.4/tlmsrc/timers.o \
	$(DESIGN_ROOT)/irqctrl/1.4/tlmsrc/irqctrl.o \
	$(DESIGN_ROOT)/scmlAdaptor/1.0/tlmsrc/scmladaptor.o \
	$(DESIGN_ROOT)/uart_scml/1.0/tlmsrc/src/uart.o \
	$(DESIGN_ROOT)/uart_scml/1.0/tlmsrc/src/uart_interrupt_handler.o \
	$(DESIGN_ROOT)/uart_scml/1.0/tlmsrc/src/uart_register_bank.o \
	$(DESIGN_ROOT)/uart_scml/1.0/tlmsrc/src/uart_serial_tx_rx.o \
	$(DESIGN_ROOT)/pv2tac/1.0/tlmsrc/pv2tac.o \
	$(DESIGN_ROOT)/uart_tac/1.0/tlmsrc/src/Leon2_uart.o \
	$(DESIGN_ROOT)/uart_tac/1.0/tlmsrc/src/tlmreg_Leon2_uart.o \
	$(DESIGN_ROOT)/uart_tac/1.0/tlmsrc/src/user_specific_Leon2_uart.o

include Make.dep


