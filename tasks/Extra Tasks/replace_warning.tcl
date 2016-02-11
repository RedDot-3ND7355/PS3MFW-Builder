#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Created By RazorX

# Priority: 204
# Description: Replace Startup Messages

# Option --spoof-label::
# Option --spoof-label1::
# Option --spoof-label2::
# Option --spoof-label3::
# Option --spoof-label4::
# Option --replace-warning1: Replace Warning Title
# Option --replace-warning2: Replace Warning Text
# Option --replace-warning3: Replace Photosensitive Epilepsy Title
# Option --replace-warning4: Replace Photosensitive Epilepsy Text
# Option --spoof-label6::
# Option --spoof-label5::

# Type --spoof-label: label {Startup Section}
# Type --spoof-label1: label {Space}
# Type --spoof-label2: label {Info}
# Type --spoof-label3: label {Info}
# Type --spoof-label4: label {Space}
# Type --replace-warning1: string
# Type --replace-warning2: string
# Type --replace-warning3: string
# Type --replace-warning4: string
# Type --spoof-label6: label {Space}
# Type --spoof-label5: label {Startup Section}


namespace eval ::replace_warning {

    array set ::replace_warning::options {
		--spoof-label "-------------------------------- Welcome To The Startup Section -----------------------------   : :"
	    --spoof-label1 "                                                                                                                                                  : :"
	    --spoof-label2 "                      Welcome To The Startup Section Here You Can Replace                      : :"
	    --spoof-label3 "                                                  Various Startup Messages.                                               : :"
	    --spoof-label4 "                                                                                                                                                  : :"
		--replace-warning1 "WARNING:"
		--replace-warning2 "BEFORE USING, READ PRODUCT DOCUMENTATION FOR IMPORTANT INFORMATION ABOUT YOUR HEALTH AND SAFETY."
		--replace-warning3 "PHOTOSENSITIVE EPILEPSY"
		--replace-warning4 "IF YOU HAVE A HISTORY OF EPILEPSY OR SEIZURES, CONSULT A DOCTOR BEFORE USE. CERTAIN PATTERNS MAY TRIGGER SEIZURES WITH NO PRIOR HISTORY. BEFORE USING THIS PRODUCT, CAREFULLY READ THE INSTRUCTION MANUAL."
		--spoof-label6 "                                                                                                                                                  : :"
		--spoof-label5 "-----------------------------------------------------------------------------------------------------------   : :"
    }

    proc main {} {
	variable options
	
		set SYSCONF_PLUGIN_RCO [file join dev_flash vsh resource sysconf_plugin.rco]
		
		if {$::replace_warning::options(--replace-warning1) != ""} {
		modify_rco_file $SYSCONF_PLUGIN_RCO ::replace_warning::callback_warning1
		}
		
		if {$::replace_warning::options(--replace-warning2) != ""} {
		modify_rco_file $SYSCONF_PLUGIN_RCO ::replace_warning::callback_warning2
		}
		
		if {$::replace_warning::options(--replace-warning3) != ""} {
		modify_rco_file $SYSCONF_PLUGIN_RCO ::replace_warning::callback_warning3
		}
		
		if {$::replace_warning::options(--replace-warning4) != ""} {
		modify_rco_file $SYSCONF_PLUGIN_RCO ::replace_warning::callback_warning4
		}
	}
	
	proc callback_warning1 {path args} {
			log "Patching English.xml for Warning Title in [file tail $path]"
			sed_in_place [file join $path English.xml] "WARNING:" $::replace_warning::options(--replace-warning1)
			log "Patching unknown0x12.xml for Warning Title in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "WARNING:" $::replace_warning::options(--replace-warning1)
	}
	
	proc callback_warning2 {path args} {
			log "Patching English.xml for WARNING Text in [file tail $path]"
			sed_in_place [file join $path English.xml] "BEFORE USING, READ PRODUCT DOCUMENTATION FOR IMPORTANT INFORMATION ABOUT YOUR HEALTH AND SAFETY." $::replace_warning::options(--replace-warning2)
			log "Patching unknown0x12.xml for WARNING Text in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "BEFORE USING, READ PRODUCT DOCUMENTATION FOR IMPORTANT INFORMATION ABOUT YOUR HEALTH AND SAFETY." $::replace_warning::options(--replace-warning2)
	}
	
	proc callback_warning3 {path args} {
			log "Patching English.xml for Photosensitive Epilepsy Title in [file tail $path]"
			sed_in_place [file join $path English.xml] "PHOTOSENSITIVE EPILEPSY" $::replace_warning::options(--replace-warning3)
			log "Patching unknown0x12.xml for Photosensitive Epilepsy Title in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "PHOTOSENSITIVE EPILEPSY" $::replace_warning::options(--replace-warning3)
	}
	
	proc callback_warning4 {path args} {
			log "Patching English.xml for Photosensitive Epilepsy Text in [file tail $path]"
			sed_in_place [file join $path English.xml] "IF YOU HAVE A HISTORY OF EPILEPSY OR SEIZURES, CONSULT A DOCTOR BEFORE USE. CERTAIN PATTERNS MAY TRIGGER SEIZURES WITH NO PRIOR HISTORY. BEFORE USING THIS PRODUCT, CAREFULLY READ THE INSTRUCTION MANUAL." $::replace_warning::options(--replace-warning4)
			log "Patching unknown0x12.xml for Photosensitive Epilepsy Text in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "IF YOU HAVE A HISTORY OF EPILEPSY OR SEIZURES, CONSULT A DOCTOR BEFORE USE. CERTAIN PATTERNS MAY TRIGGER SEIZURES WITH NO PRIOR HISTORY. BEFORE USING THIS PRODUCT, CAREFULLY READ THE INSTRUCTION MANUAL." $::replace_warning::options(--replace-warning4)
	}
}