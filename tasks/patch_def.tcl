#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) RedDot-3ND7355 (For doing the oomplete task)
# Copyright (C) Habib (For the patterns)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Priority: 9
# Description: [4.xx] Patch default.spp!

# Option --patch-spp-features: [4.xx] Patch default[.spp] for otheros!

# Type --patch-spp-features: boolean

namespace eval ::patch_def {

    array set ::patch_def::options {
		    --patch-spp-features true
    }
	
    proc main { } {
            set self "default.spp"
			set file "default.spp"
			set ::SELF "default.spp"
            if { ${::OLDROUTINE} == "1" } {
			::modify_coreos_file $self ::patch_def::patch_self
			} elseif { ${::OLDROUTINE} == "0" } {
			::modify_coreos_file2 $self ::patch_def::patch_self
			}
    }
	
    proc patch_self {self} {
	        if { ${::OLDROUTINE} == "1" } {
            ::modify_spp_file $self ::patch_def::patch_elf
			} elseif { ${::OLDROUTINE} == "0" } {
            ::modify_spp_file2 $self ::patch_def::patch_elf
			}
    }
	
    proc patch_elf {elf} {
	if {$::patch_def::options(--patch-spp-features)} {
	
	#Patch default.spp for otheros!
	log "Patching spp for otheros"
	log "Thx habib for the patterns"
	set search  "\x18"
	set replace "\x1b"
	debug "Patched"
	
	catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
	}
  }
}