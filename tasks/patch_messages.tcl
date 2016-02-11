#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Fixed by RedDot-3ND7355 to work on PS3MFW :)

# Priority: 14
# Description: [4.xx] Remove (annoying?) Debug messages (REX/REBUG) 

# Option --remove-gamequit: [4.xx] Delete "Quit Game: No Request Event" message (Info Icon remains!)
# Option --remove-fakesave-dex: [4.xx] Delete "Caution! Fake Save Data Owner: On" (DEX)
# Option --remove-fakesave-rex: [4.xx] Delete "Caution! Fake Save Data Owner: On" (REBUG)

# Type --remove-gamequit: boolean
# Type --remove-fakesave-dex: boolean
# Type --remove-fakesave-rex: boolean


namespace eval ::patch_messages {

    array set ::patch_messages::options {
        --remove-gamequit false
        --remove-fakesave-dex false
        --remove-fakesave-rex false
    }

    proc main {} {
        variable options
			if {$::patch_messages::options(--remove-gamequit)} {
			  set EXT_SPRX [file join dev_flash vsh module game_ext_plugin.sprx]
			  set ::SELF "game_ext_plugin.sprx"
				if { ${::OLDROUTINE} == "1" } {
				::modify_devflash_file ${EXT_SPRX} ::patch_messages::patch_self
			    } elseif { ${::OLDROUTINE} == "0" } {
				::modify_devflash_file2 ${EXT_SPRX} ::patch_messages::patch_self
				}
			}
			if {$::patch_messages::options(--remove-fakesave-dex)} {
			  set VSH_SELF [file join dev_flash vsh module vsh.self]
			  set ::SELF "vsh.self"
				if { ${::OLDROUTINE} == "1" } {
				::modify_devflash_file ${VSH_SELF} ::patch_messages::patch_self
			    } elseif { ${::OLDROUTINE} == "0" } {
				::modify_devflash_file2 ${VSH_SELF} ::patch_messages::patch_self
				}
			}
			if {$::patch_messages::options(--remove-fakesave-rex)} {
			  set VSH_SELF [file join dev_flash vsh module vsh.self]
			  set ::SELF "vsh.self"
				if { ${::OLDROUTINE} == "1" } {
				::modify_devflash_file ${VSH_SELF} ::patch_messages::patch_self
			    } elseif { ${::OLDROUTINE} == "0" } {
				::modify_devflash_file2 ${VSH_SELF} ::patch_messages::patch_self
				}
			  set VSH_SWP [file join dev_flash vsh module vsh.self.swp]
			  set ::SELF "vsh.self.swp"
				if { ${::OLDROUTINE} == "1" } {
				::modify_devflash_file ${VSH_SWP} ::patch_messages::patch_self
				} elseif { ${::OLDROUTINE} == "0" } {
				::modify_devflash_file2 ${VSH_SWP} ::patch_messages::patch_self
				}
			}
	}

    proc patch_self {self} {
        log "Patching [file tail $self]"
        if { ${::OLDROUTINE} == "1" } {
		::modify_self_file $self ::patch_messages::patch_elf
        } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $self ::patch_messages::patch_elf
		}
	}

    proc patch_elf {elf} {
        if {$::patch_messages::options(--remove-gamequit)} {
           log "Patching [file tail $elf] to remove the No Request Event message on DEX or REBUG"
            set search  "\x6D\x73\x67\x5F\x74\x6F\x6F\x6C\x5F\x67\x61\x6D\x65\x5F\x71\x75\x69\x74\x5F\x6E\x6F\x5F\x72\x65\x71\x75\x65\x73\x74\x5F\x65\x76\x65\x6E\x74"
            set replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
            catch_die {::patch_elf $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
		}
        if {$::patch_messages::options(--remove-fakesave-dex)} {
           log "Patching [file tail $elf] to remove the Fake Savedata message on DEX firmware"
            set search  "\x00\x43\x00\x61\x00\x75\x00\x74\x00\x69\x00\x6F\x00\x6E\x00\x21\x00\x0A\x00\x46\x00\x61\x00\x6B\x00\x65\x00\x20\x00\x53\x00\x61\x00\x76\x00\x65\x00\x20\x00\x44\x00\x61\x00\x74\x00\x61\x00\x20\x00\x4F\x00\x77\x00\x6E\x00\x65\x00\x72\x00\x20\x00\x3A\x00\x20\x00\x4F\x00\x6E"
            set replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
            catch_die {::patch_elf $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
		}
        if {$::patch_messages::options(--remove-fakesave-rex)} {
           log "Patching [file tail $elf] to remove the Fake Savedata message on REBUG firmware"
            set search  "\x00\x43\x00\x61\x00\x75\x00\x74\x00\x69\x00\x6F\x00\x6E\x00\x21\x00\x0A\x00\x46\x00\x61\x00\x6B\x00\x65\x00\x20\x00\x53\x00\x61\x00\x76\x00\x65\x00\x20\x00\x44\x00\x61\x00\x74\x00\x61\x00\x20\x00\x4F\x00\x77\x00\x6E\x00\x65\x00\x72\x00\x20\x00\x3A\x00\x20\x00\x4F\x00\x6E"
            set replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
            catch_die {::patch_elf $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
		}
	}
}