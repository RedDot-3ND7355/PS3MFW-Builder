#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#
    
# Priority: 1
# Description: [4.xx] Bypass RSOD screen


# Option --patch-rsod-disable-315: [3.15] Patch out branch to rsod
# Option --patch-rsod-disable-355: [3.55] Patch out branch to rsod
# Option --patch-rsod-disable-4XX: [4.xx] Patch out branch to rsod

# Type --patch-rsod-disable-315: boolean
# Type --patch-rsod-disable-355: boolean
# Type --patch-rsod-disable-4XX: boolean

namespace eval ::patch_rsod {

    array set ::patch_rsod::options {
        --patch-rsod-disable-315 false
        --patch-rsod-disable-355 false
        --patch-rsod-disable-4XX true
    }
    proc main {} {
		if {$::patch_rsod::options(--patch-rsod-disable-315)} {
          set self [file join dev_flash vsh module basic_plugins.sprx]
		  set ::SELF "basic_plugins.sprx"
			if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $self ::patch_rsod::patch_self
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $self ::patch_rsod::patch_self
			}
		}
        if {$::patch_rsod::options(--patch-rsod-disable-355)} {
		  set self [file join dev_flash vsh module basic_plugins.sprx]
		  set ::SELF "basic_plugins.sprx"
			if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $self ::patch_rsod::patch_self
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $self ::patch_rsod::patch_self
			}
		}
		if {$::patch_rsod::options(--patch-rsod-disable-4XX)} {
          set self [file join dev_flash vsh module basic_plugins.sprx]
		  set ::SELF "basic_plugins.sprx"
			if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $self ::patch_rsod::patch_self
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $self ::patch_rsod::patch_self
			}
		}
    }
	
    proc patch_self {self} {
        log "Patching [file tail $self]"
        if { ${::OLDROUTINE} == "1" } {
		::modify_self_file $self ::patch_rsod::patch_elf
		} elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $self ::patch_rsod::patch_elf
		}
    }
	
    proc patch_elf {elf} {
        if {$::patch_rsod::options(--patch-rsod-disable-315)} {
              debug "Patching [file tail $elf] to disable RSOD screen"
              set search  "\x41\x9E\x00\xDC\x4B\xFF\xED\x69\x60\x00\x00\x00\x81\x22\x86\x60"
              set replace "\x60\x00\x00\x00\x4B\xFF\xED\x69\x60\x00\x00\x00\x81\x22\x86\x60"
              catch_die {::patch_elf $elf $search 0 $replace} \
                  "Unable to patch self [file tail $elf]"
        }
        if {$::patch_rsod::options(--patch-rsod-disable-355)} {
            debug "Patching [file tail $elf] to disable RSOD screen"
            set search  "\x41\x9E\x00\xDC\x48\x00\x12\x8D\x60\x00\x00\x00\x81\x22"
            set replace "\x60\x00\x00\x00\x48\x00\x12\x8D\x60\x00\x00\x00\x81\x22"
            catch_die {::patch_elf $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
        if {$::patch_rsod::options(--patch-rsod-disable-4XX)} {
            debug "Patching [file tail $elf] to disable RSOD screen"
            set search  "\x40\x9E\x00\x20\x48\x00\x00\x10"
            set replace "\x48\x00\x00\x20\x48\x00\x00\x10"
            catch_die {::patch_elf $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
}