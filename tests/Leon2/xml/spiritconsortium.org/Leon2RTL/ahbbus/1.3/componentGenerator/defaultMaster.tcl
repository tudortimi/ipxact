#!/bin/sh
# \
exec tclsh "$0" ${1+"$@"}

# Description : defaultMaster.tcl
#               Component generator that sets the default master on the component with a
#               value from a generator parameter
# Author : SPIRIT Schema Working Group 
# Version: 1.0
# 
# Revision:    $Revision: 1506 $
# Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
# 
# Copyright (c) 2008, 2009 The SPIRIT Consortium.
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
# modifications; this notice must be included on any copy.

# 
# Load required packages -- assumes that your TCL environment is
# set up to find them. Typically this means setting the environment
# variable TCLLIBPATH to point to where these packages are installed.
#
package require cmdline
package require SOAP
package require SOAP::WSDL

#
# Process command line
set options [list \
               [list url.arg "" {SOAP service url}] \
               [list defaultMaster.arg "0" {Default master number}] \
              ]
array set arg [cmdline::getoptions argv $options]
if {$arg(url) eq ""} {  error "Must specify -url" }

# Get generator parameters from command line
set url           $arg(url)
set defaultMaster $arg(defaultMaster)

# Locate the TGI.wsdl file
# 1) In same directory as the generator
# 2) Via IPXACT_TGI_WSDL environment variable
# 3) Via the web.
#
set wsdl {}
set scriptDir [string trimright [file dirname [info script]] ./]
set scriptDir [file join [pwd] $scriptDir]
set wsdlFile [file join $scriptDir TGI.wsdl] 
if {![file exists $wsdlFile]} {
  if {[info exists ::env(IPXACT_TGI_WSDL)] &&
      [file exists $::env(IPXACT_TGI_WSDL)]} {
    set wsdlFile $::env(IPXACT_TGI_WSDL)
  } else {
    package require http
    set WSDL_URL "http://www.spiritconsortium.org/XMLSchema/SPIRIT/1.4/TGI/TGI.wsdl"
    if {[catch {set wsdl [http::data [http::geturl $WSDL_URL]]} msg]} {
      error "Could not retreive TGI.wsdl from $WSDL_URL"
    }
  }
}

if {[string equal $wsdl ""] && [file exists $wsdlFile]} {
  set f [open $wsdlFile]
  set wsdl [read $f]
  close $f
}

if {[string equal $wsdl ""]} {
  error "Could not find TGI WSDL definition."
}

#
# Connect to the SOAP TGI
#
set doc  [dom::parse $wsdl]

# Add service section to WSDL
set root [$doc cget -documentElement]
set service [::dom::document createElementNS $root "http://schemas.xmlsoap.org/wsdl/" service]
  ::dom::element setAttribute $service name tgi
set port [::dom::document createElement $service port]
  ::dom::element setAttribute $port name TGI_port
  ::dom::element setAttribute $port binding TGI_binding
set address [::dom::document createElement $port soap:address]
  ::dom::element setAttribute $address location $url

set impl [SOAP::WSDL::parse $doc]
eval [set $impl]

#
# The actual work ...
#
namespace eval tgi {

  proc dump_instance_pin_info { instanceId instname} {
    set portInfo ""
    set name [lindex [getComponentInstanceVLNV $instanceId] 2]
    message info "Processing component $name  instance $instname"

    # Iterate over the pins on the current component
    set componentId [getComponentInstanceComponentID $instanceId]
    set portIDs [getComponentPortIDs $componentId]
    foreach portId $portIDs {
      # Dump information about the current port
      set style [getPortStyle $portId]
      if {$style eq "wire"} {
	set name [getName $portId]
	set dir  [getPortDirection $portId]
	set range [getPortRange $portId]
	lappend portInfo "  $name - $dir - $range"
      }
    }
    message info $portInfo
  }

  proc dump_instance_modelParameter_info { instanceId instname } {
    set modelParameterInfo ""
    set name [lindex [getComponentInstanceVLNV $instanceId] 2]
    message info "modelParameters processing component $name  instance $instname"

    # Iterate over the modelParameters on the current component
    set usageType ""
    set componentId [getComponentInstanceComponentID $instanceId]
    set modelParameterIDs \
      [getComponentModelParameterIDs $componentId $usageType]
    foreach modelParameterId $modelParameterIDs {

      # Dump information about the current components modelParameters
      set name [getName $modelParameterId]
      set value [getValue $modelParameterId]
      lappend modelParameterInfo "  $name - $value"
    }
    message info $modelParameterInfo
  }

  # Initialize
  init 1.4 fail "Client connected"
  message info "Running prototype generator"

  set instanceId [getGeneratorContextComponentInstanceID "defaultMaster component generator"]
  set instname [getComponentInstanceName $instanceId]
  set name [lindex [getComponentInstanceVLNV $instanceId] 2]

  # Dump pin information
  dump_instance_pin_info $instanceId $instname
  # Dump modelParameter information
  dump_instance_modelParameter_info $instanceId $instname

  # Locate parameter to be updated.
  set componentId [getComponentInstanceComponentID $instanceId]
  set defmastID ""
  foreach paramId [getComponentModelParameterIDs $componentId {}] {
    # Find defmast parameter IDs
    if {[getName $paramId] eq "defmast"} {
      set defmastID $paramId  
      break
    }
  }
  
  # Change defmast 
  if {$defmastID ne ""} {
    set defmast [getValue $defmastID]
    setValue $defmastID $defaultMaster
    message info "Changing the default master on component $name, instance $instname, from $defmast to $defaultMaster"

    set defmast [getValue $defmastID]
    if {$defmast != $defaultMaster} {
      message error "Default master not set to $defaultMaster as expected!"
    }
  }

  # Indicate that we are done.
  end 0 "Client done"
}
