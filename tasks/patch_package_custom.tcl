#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Created By RazorX and modified by RedDot-3ND7355
    
# Priority: 201
# Description: Patch "Install Package Files" With A Custom Directory

# Option --pkg-label::
# Option --pkg-label1::
# Option --pkg-label2::
# Option --pkg-label3::
# Option --pkg-label4::
# Option --REPLACE1: Replace
# Option --REPLACE2: Custom Name
# Option --REPLACE3: Custom Path
# Option --pkg-label5::

# Type --pkg-label: label {PKG Section}
# Type --pkg-label1: label {Space}
# Type --pkg-label2: label {Warning}
# Type --pkg-label3: label {Warning}
# Type --pkg-label4: label {Space}
# Type --REPLACE1: combobox {{host_provider_host} {host_provider_bdvd} {host_provider_ms} {host_provider_usb0} {host_provider_usb1} {host_provider_usb2} {host_provider_usb3} {host_provider_usb4} {host_provider_usb5} {host_provider_usb6} {host_provider_usb7} {}}
# Type --REPLACE2: string
# Type --REPLACE3: string
# Type --pkg-label5: label {PKG Section}

namespace eval ::patch_package_custom {
    
    array set ::patch_package_custom::options {
		--pkg-label "---------------------------------- Welcome To The PKG Section --------------------------------   : :"
		--pkg-label1 "                                                                                                                                                    : :"
		--pkg-label2 "                Here You Can Add A Custom Location To Install Package Files                  : :"
		--pkg-label3 "                             By Replacing An Existing Location On Your CFW.                               : :"
		--pkg-label4 "                                                                                                                                                    : :"
		--REPLACE1 "host_provider_ms"
		--REPLACE2 "host_provider_custom"
		--REPLACE3 "/dev_flash/"
		--pkg-label5 "--------------------------------------------------------------------------------------------------------------   : :"
    }
    
    proc main {} {
	    if { ${::OLDROUTINE} == "1" } {
		set self [file join dev_flash vsh resource explore xmb category_game_tool2.xml]
		::modify_devflash_file $self ::patch_package_custom::callback_patch
		set self [file join dev_flash vsh resource explore xmb category_game.xml]
		::modify_devflash_file $self ::patch_package_custom::callback_patch
		} elseif { ${::OLDROUTINE} == "0" } {
		set self [file join dev_flash vsh resource explore xmb category_game_tool2.xml]
		::modify_devflash_file2 $self ::patch_package_custom::callback_patch
		set self [file join dev_flash vsh resource explore xmb category_game.xml]
		::modify_devflash_file2 $self ::patch_package_custom::callback_patch
		}
	}
	
	proc callback_patch {path args} {		
        log "Patching Install Package Files With A Custom Directory"
		
		if {$::patch_package_custom::options(--REPLACE1) == "host_provider_host"} {
		sed_in_place [file join $path] $::patch_package_custom::options(--REPLACE1) $::patch_package_custom::options(--REPLACE2)
		sed_in_place [file join $path] "/app_home/" $::patch_package_custom::options(--REPLACE3)
		}
		
		if {$::patch_package_custom::options(--REPLACE1) == "host_provider_bdvd"} {
		sed_in_place [file join $path] $::patch_package_custom::options(--REPLACE1) $::patch_package_custom::options(--REPLACE2)
		sed_in_place [file join $path] "/dev_bdvd" $::patch_package_custom::options(--REPLACE3)
		}
		
		if {$::patch_package_custom::options(--REPLACE1) == "host_provider_ms"} {
		sed_in_place [file join $path] $::patch_package_custom::options(--REPLACE1) $::patch_package_custom::options(--REPLACE2)
		sed_in_place [file join $path] "/dev_ms" $::patch_package_custom::options(--REPLACE3)
		}
		
		if {$::patch_package_custom::options(--REPLACE1) == "host_provider_usb0"} {
		sed_in_place [file join $path] $::patch_package_custom::options(--REPLACE1) $::patch_package_custom::options(--REPLACE2)
		sed_in_place [file join $path] "/dev_usb000" $::patch_package_custom::options(--REPLACE3)
		}
		
		if {$::patch_package_custom::options(--REPLACE1) == "host_provider_usb1"} {
		sed_in_place [file join $path] $::patch_package_custom::options(--REPLACE1) $::patch_package_custom::options(--REPLACE2)
		sed_in_place [file join $path] "/dev_usb001" $::patch_package_custom::options(--REPLACE3)
		}
		
		if {$::patch_package_custom::options(--REPLACE1) == "host_provider_usb2"} {
		sed_in_place [file join $path] $::patch_package_custom::options(--REPLACE1) $::patch_package_custom::options(--REPLACE2)
		sed_in_place [file join $path] "/dev_usb002" $::patch_package_custom::options(--REPLACE3)
		}
		
		if {$::patch_package_custom::options(--REPLACE1) == "host_provider_usb3"} {
		sed_in_place [file join $path] $::patch_package_custom::options(--REPLACE1) $::patch_package_custom::options(--REPLACE2)
		sed_in_place [file join $path] "/dev_usb003" $::patch_package_custom::options(--REPLACE3)
		}
		
		if {$::patch_package_custom::options(--REPLACE1) == "host_provider_usb4"} {
		sed_in_place [file join $path] $::patch_package_custom::options(--REPLACE1) $::patch_package_custom::options(--REPLACE2)
		sed_in_place [file join $path] "/dev_usb004" $::patch_package_custom::options(--REPLACE3)
		}
		
		if {$::patch_package_custom::options(--REPLACE1) == "host_provider_usb5"} {
		sed_in_place [file join $path] $::patch_package_custom::options(--REPLACE1) $::patch_package_custom::options(--REPLACE2)
		sed_in_place [file join $path] "/dev_usb005" $::patch_package_custom::options(--REPLACE3)
		}
		
		if {$::patch_package_custom::options(--REPLACE1) == "host_provider_usb6"} {
		sed_in_place [file join $path] $::patch_package_custom::options(--REPLACE1) $::patch_package_custom::options(--REPLACE2)
		sed_in_place [file join $path] "/dev_usb006" $::patch_package_custom::options(--REPLACE3)
		}
		
		if {$::patch_package_custom::options(--REPLACE1) == "host_provider_usb7"} {
		sed_in_place [file join $path] $::patch_package_custom::options(--REPLACE1) $::patch_package_custom::options(--REPLACE2)
		sed_in_place [file join $path] "/dev_usb007" $::patch_package_custom::options(--REPLACE3)
		}
	}
}
