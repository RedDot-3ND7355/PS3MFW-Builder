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

# Priority: 1001
# Description: Replace XMB Wave

# Option --qrc-label::
# Option --qrc-label1::
# Option --customize-firmware-xmb-wave: Replace Default XMB Wave
# Option --qrc-label2::
# Option --qrc-label3::

# Type --qrc-label: label {QRC Section}
# Type --qrc-label1: label {SPACE}
# Type --customize-firmware-xmb-wave: file open {"QRC Resource" {qrc}}
# Type --qrc-label2: label {SPACE}
# Type --qrc-label3: label {QRC Section}

namespace eval customize_wave {

    array set ::customize_wave::options {
	
		--qrc-label "----------------------------------- Welcome To The QRC Section ---------------------------------   : :"
	    --qrc-label1 "                                                                                                                                                       : :"
        --customize-firmware-xmb-wave "/path/to/file"
		--qrc-label2 "                                                                                                                                                      : :"
		--qrc-label3 "---------------------------------------------------------------------------------------------------------------   : :"
    }

    proc main {} {
        variable options

        set xmb_wave [file join dev_flash vsh resource qgl lines.qrc]
        
       	if {[file exists $::customize_wave::options(--customize-firmware-xmb-wave)] == 0 } {
            log "Skipping Custom XMB Wave Does Not Exist"
        } else {
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $xmb_wave ::customize_wave::copy_customized_file $::customize_wave::options(--customize-firmware-xmb-wave)
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $xmb_wave ::customize_wave::copy_customized_file $::customize_wave::options(--customize-firmware-xmb-wave)
			}
		}
	}
    
    proc copy_customized_file { dst src } {
        if {[file exists $src] == 0} {
            die "$src does not exist"
        } else {
            if {[file exists $dst] == 0} {
                die "$dst does not exist"
            } else {
                log "Replacing Default [file tail $dst] With Custom [file tail $src]"
                copy_file -force $src $dst
            }
        }
    }
}