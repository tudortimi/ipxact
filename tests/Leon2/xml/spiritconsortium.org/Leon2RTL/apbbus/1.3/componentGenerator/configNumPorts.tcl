#!/bin/sh
# \
exec wish "$0" ${1+"$@"}

# Description : configNumPorts.tcl
#               Component generator that replaces the current component with a new version with a
#               different number of slave ports.
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
               [list url.arg "" {SOAP service url}] 
              ]
array set arg [cmdline::getoptions argv $options]
if {$arg(url) eq ""} {  error "Must specify -url" }

# Get generator parameters from command line
set url           $arg(url)

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


#This function will be executed when the replace button is pushed
proc replace_button {} {
        set lst_id [.lst curselection] ;#Get the number in the list
        set lst_name [.lst get $lst_id] ;#Get the name of the item

        set returnstat "false"
	set returnstat [replaceComponentInstance $::tgi::designId $::tgi::instanceId [list $::tgi::vendor $::tgi::library $lst_name $::tgi::version]]

        #GEE not sure on the return type?
	if {$returnstat eq "true"} {
	  message info "Component replaced!"
	  puts stdout "Component replaced with $lst_name!"
	}
	if {$returnstat eq "false"} {
	  message error "Component NOT replaced!"
	  puts stdout "Component NOT replaced with $lst_name!"
	}

        end 0 "Client done"
	exit
}

#This function will be executed when the cancel button is pushed
proc cancel_button {} {
        end 0 "Client done"
	exit
}

#Global Variables
# list of components in this family
set nameList { apbbus1  apbbus2  apbbus4  apbbus6  apbbus8  apbbus9  apbbus16 }

  # Initialize TGI
  init 1.4 fail "Client connected"
  message info "Running prototype generator to replace component."

  set designId [getDesignID false]
  set instanceId [getGeneratorContextComponentInstanceID "configNumPorts component generator"]
  set instname [getComponentInstanceName $instanceId]
  set vendor  [lindex [getComponentInstanceVLNV $instanceId] 0]
  set library [lindex [getComponentInstanceVLNV $instanceId] 1]
  set name    [lindex [getComponentInstanceVLNV $instanceId] 2]
  set version [lindex [getComponentInstanceVLNV $instanceId] 3]

# set name "apbbus4"


#GUI building
frame .frm_lst
label .lab -text "Switch to APB channel component:"

#Adding ports
listbox .lst -selectmode single

# add each component to the list
foreach nameL $nameList {
  .lst insert end $nameL
}
.lst selection set [lsearch $nameList $name]
.lst configure -state normal

button .replace -text "Replace Component" -command "tgi::replace_button"
button .cancel -text "Cancel" -command "tgi::cancel_button"

#Geometry Management
grid .frm_lst -in . -row 1 -column 1 -columnspan 2
grid .lab -in .frm_lst -row 1 -column 1
grid .lst -in .frm_lst -row 1 -column 2
grid .replace -in . -row 2 -column 1 
grid .cancel -in . -row 2 -column 2


}
