#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
# Copyright (C) RedDot-3ND7355 (For adding "All" and Habib patterns!)
# Copyright (C) Habib (For patterns!)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Priority: 5
# Description: [4.xx] Patch nas_plugin[.sprx]!

# Option --allow-pseudoretail-pkg: [4.xx] Patch to allow installation of pseudo-retail packages
# Option --allow-all-pkg: [4.31-] Patch to allow installation of all packages
# Option --habibs-patching: [4.xx] Patch using Habib's patterns! [includes debug pkg]

# Type --allow-pseudoretail-pkg: boolean
# Type --allow-all-pkg: boolean
# Type --habibs-patching: boolean

namespace eval ::patch_nas_plugin {

    array set ::patch_nas_plugin::options {
        --allow-pseudoretail-pkg true
		--allow-all-pkg false
		--habibs-patching true
    }

    proc main {} {
		    set self [file join dev_flash vsh module nas_plugin.sprx]
			set file [file join dev_flash vsh module nas_plugin.sprx]
			set ::SELF "nas_plugin.sprx"
        if { ${::OLDROUTINE} == "1" } {
		::modify_devflash_file $self ::patch_nas_plugin::patch_self
		} elseif { ${::OLDROUTINE} == "0" } {
		::modify_devflash_file2 $self ::patch_nas_plugin::patch_self
		}
	}

    proc patch_self { self } {
            if { ${::OLDROUTINE} == "1" } {
			::modify_self_file $self ::patch_nas_plugin::patch_elf
			} elseif { ${::OLDROUTINE} == "0" } {
			::modify_self_file2 $self ::patch_nas_plugin::patch_elf
			}
    }

    proc patch_elf { elf } {
        if {$::patch_nas_plugin::options(--allow-pseudoretail-pkg) } {
            log "Patching [file tail $elf] to allow pseudo-retail pkg installs"
			log "Proved Legit by RedDot-3ND7355"
			
            set search  "\x7c\x60\x1b\x78\xf8\x1f\x01\x80"
            set replace "\x38\x00\x00\x00\xf8\x1f\x01\x80"

            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
        }

		if {$::patch_nas_plugin::options(--allow-all-pkg) } {
		    log "Patching [file tail $elf] to allow ALL pkg type to install"
			log "Special feature added by RedDot-3ND7355 for 4.31-"

			set search  "\xFB\xA1\x03\xD8\xFB\xC1\x03\xE0\xFB\xE1\x03\xE8\x40\x9E\x00\x3C"
			set replace "\xFB\xA1\x03\xD8\xFB\xC1\x03\xE0\xFB\xE1\x03\xE8\x48\x00\x00\x3C"
			
			catch_die {::patch_elf $elf $search 2 $replace} "Unable to patch self [file tail $elf]"
		}

		if {$::patch_nas_plugin::options(--habibs-patching) } {
		    log "Habib's patterns!"
			log "Added by RedDot-3ND7355!"
			log "Part 1"
			
			set search  "\x6f\xa0\x7f\xfd\x2f\x80\xae\x12\x40\x9e\x00\x3c\x3d\x20\x00\x06"
			set replace "\x6f\xa0\x7f\xfd\x2f\x80\xae\x12\x48\x00\x00\x3c\x3d\x20\x00\x06"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 2"
            
            set search  "\x2f\x89\x00\x00\x41\x9e\x00\x4c\x38\x00\x00\x00\x81\x22\x80\x44"
            set replace "\x2f\x89\x00\x00\x40\x9e\x00\x4c\x38\x00\x00\x00\x81\x22\x80\x44"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
		}
    }
}
