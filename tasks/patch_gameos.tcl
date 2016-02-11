#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Priority: 24
# Description: [4.xx] PATCH: GAMEOS - Disable searching for UPDATE Packages in GAME disc

# Option --patch-disable-pupsearch-in-game-disc: [4.xx]  -->  Disable searching for update packages in GAME disc

# Type --patch-disable-pupsearch-in-game-disc: boolean

namespace eval ::patch_gameos {

array set ::patch_gameos::options {
		--patch-disable-pupsearch-in-game-disc true
		
}

    proc main { } {		
        # do the "emer_init" patches
        set self "emer_init.self"
		set file "emer_init.self"
        set ::SELF "emer_init.self"
        if { ${::OLDROUTINE} == "1" } {
			::modify_coreos_file $self ::patch_gameos::patch_self
			} elseif { ${::OLDROUTINE} == "0" } {
			::modify_coreos_file2 $self ::patch_gameos::patch_self
			}
        }

        proc patch_self {self} {
			if { ${::OLDROUTINE} == "1" } {
			::modify_self_file $self ::patch_gameos::patch_elf
            } elseif { ${::OLDROUTINE} == "0" } {
		    ::modify_self_file2 $self ::patch_gameos::patch_elf
		    }
    }

    proc patch_elf {elf} {
	if {$::patch_gameos::options(--patch-disable-pupsearch-in-game-disc)} {
	        
			#Patch emer_init.self!
			log "Patching emer_init to Disable searching for Game UPDATES!"
			set search  "\x80\x01\x00\x74\x2F\x80\x00\x00\x40\x9E\x00\x14\x7F\xE3\xFB\x78"
			set replace "\x38\x00\x00\x01\x2F\x80\x00\x00\x40\x9E\x00\x14\x7F\xE3\xFB\x78"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			log "Done patching"
	  }
	 }
	}

		