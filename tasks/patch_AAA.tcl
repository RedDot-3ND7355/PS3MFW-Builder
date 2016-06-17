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
# Description: [4.xx] Patch vsh[.self]

# Option --allow-unsigned-app-4xx: [4.xx] Patch to allow running of unsigned applications!
# Option --reactpsn-online-offline: [4.xx] Patch to add ReactPSN online/offline, From habib!
# Option --label: Extra VSH patches
# Option --xtra1-vsh-habib-446: [4.46|.50|.53] Allow Debug PKG install
# Option --xtra2-vsh-habib: [4.46|.50|.53] Firmware SysValue -- PS2 Related!
# Option --xtra3-vsh-habib: [4.50|.53] Fix act.dat Remove on boot
# Option --label2: InGame Screenshots patches
# Option --patch-ingamescreenshot-features: Patch for Ingame Screenshots [4.46 to 4.7x]
# Option --patch-ingamescreenshot-photo: Patch Photo Category Ingame             (If Selected Dont Enable Permanent)
# Option --patch-ingamescreenshot-photo2: Patch Photo Category Permanent          (If Selected Dont Enable Ingame)
# Option --label4: Cobra Featured MFW Only! [Deselect all other VSH Patches]
# Option --allow-vshcobra:[4.46|.53] **ALLIN1** Patch VSH for Cobra Compatibility! Select Only for COBRA!

# Type --allow-unsigned-app-4xx: boolean
# Type --reactpsn-online-offline: boolean
# Type --label: label
# Type --xtra1-vsh-habib-446: boolean
# Type --xtra2-vsh-habib: boolean
# Type --xtra3-vsh-habib: boolean
# Type --label2: label
# Type --patch-ingamescreenshot-features: boolean
# Type --patch-ingamescreenshot-photo: boolean
# Type --patch-ingamescreenshot-photo2: boolean
# Type --label4: label
# Type --allow-vshcobra: boolean


namespace eval ::patch_AAA {

    array set ::patch_AAA::options {
        --allow-unsigned-app-4xx false
		--reactpsn-online-offline true
		--label ""
		--xtra1-vsh-habib-446 false
		--xtra2-vsh-habib false
		--xtra3-vsh-habib false
		--label2 ""
		--patch-ingamescreenshot-features true
		--patch-ingamescreenshot-photo true
		--patch-ingamescreenshot-photo2 false
		--label4 ""
		--allow-vshcobra false
    }

    proc main { } {
	
	if {$::patch_AAA::options(--patch-ingamescreenshot-photo)} {
			set self [file join dev_flash vsh resource explore xmb category_photo.xml]
			if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $self ::patch_AAA::callback_patch
		    } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $self ::patch_AAA::callback_patch
			}
		}
	
	if {$::patch_AAA::options(--patch-ingamescreenshot-photo2)} {
			set self [file join dev_flash vsh resource explore xmb category_photo.xml]
			if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $self ::patch_AAA::callback_patch2
			} elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $self ::patch_AAA::callback_patch2
			}
		}
	
            set self [file join dev_flash vsh module vsh.self]
			set file [file join dev_flash vsh module vsh.self]
			set ::SELF "vsh.self"
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $self ::patch_AAA::patch_self
			} elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $self ::patch_AAA::patch_self
			}
    }

    proc patch_self {self} {    
        if { ${::OLDROUTINE} == "1" } {
		::modify_self_file $self ::patch_AAA::patch_elf
		} elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $self ::patch_AAA::patch_elf
		}
    }

    proc patch_elf {elf} {
	
	
	set ::SUF [::get_pup_version2 ${::ORIGINAL_VERSION_TXT}]	
	if { [regexp "(^\[0-9]{1,2})\.(\[0-9]{1,2})(.*)" $::SUF all ::OFW_MAJOR_VER ::OFW_MINOR_VER SubVerInfo] } {		
		set ::NEWMFW_VER [format "%.1d.%.2d" $::OFW_MAJOR_VER $::OFW_MINOR_VER]	
		if { $SubVerInfo != "" } {
			log "Getting pup version OK! var = ${::NEWMFW_VER} (subversion:$SubVerInfo)"
		} else { 
			log "Getting pup version OK! var = ${::NEWMFW_VER}"
		}		
	} else {
		die "Getting pup version FAILED! Exiting!"
	}
		if {$::NEWMFW_VER != "4.80"} {
	    if {$::patch_AAA::options(--patch-ingamescreenshot-features)} {
			log "Patching Screenshot Option"
			log "Part 1"
            set search "\x29\x00\x04\x7C\x00\x48\x28\x7C\x09\xFE\x70"
            set replace "\x29\x00\x04\x38\x00\x00\x01\x7C\x09\xFE\x70"
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			log "Part 2"
            set search "\x29\x00\x04\x7C\x00\x48\x28\x2F\x80\x00\x00\x38\x60"
            set replace "\x29\x00\x04\x38\x00\x00\x01\x2F\x80\x00\x00\x38\x60"
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
        log "Done vsh.self patches for screenshots"
		}
		} else { 
		log "Doing Patches for screenshots"
		log "Error, scanning if offsets are patched..."
		log "..."
		log "Already patched"
		}
        if {$::patch_AAA::options(--allow-unsigned-app-4xx) } {
		if {$::NEWMFW_VER == "4.40" || $::NEWMFW_VER == "4.41" || $::NEWMFW_VER == "4.42" || $::NEWMFW_VER == "4.43" || $::NEWMFW_VER == "4.44" || $::NEWMFW_VER == "4.45" || $::NEWMFW_VER == "4.46"} {

            log "Patching [file tail $elf] to allow running of unsigned applications"
			log "Proved Legit by RedDot-3ND7355"
			log "Part 1"
         
            set search  "\xF8\x21\xFF\x81\x7C\x08\x02\xA6\x38\x61\x00\x70\xF8\x01\x00\x90\x4B\xFF\xFF\xE1\x38\x00\x00\x00"
            set replace "\x38\x60\x00\x01\x4E\x80\x00\x20\x38\x61\x00\x70\xF8\x01\x00\x90\x4B\xFF\xFF\xE1\x38\x00\x00\x00"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
         
			log "Proved Legit by RedDot-3ND7355"
			log "Part 2"

            set search  "\xA0\x7F\x00\x04\x39\x60\x00\x01\x38\x03\xFF\x7F\x2B\xA0\x00\x01\x40\x9D\x00\x08\x39\x60\x00\x00"
            set replace "\x60\x00\x00\x00\x39\x60\x00\x01\x38\x03\xFF\x7F\x2B\xA0\x00\x01\x40\x9D\x00\x08\x39\x60\x00\x00"
         
            catch_die {::patch_elf $elf $search 20 $replace} "Unable to patch self [file tail $elf]"
        }
		
			if {$::NEWMFW_VER == "4.50" || $::NEWMFW_VER == "4.51" || $::NEWMFW_VER == "4.52" || $::NEWMFW_VER == "4.53" || $::NEWMFW_VER == "4.54" || $::NEWMFW_VER == "4.55" || $::NEWMFW_VER == "4.56" || $::NEWMFW_VER == "4.57" || $::NEWMFW_VER == "4.58" || $::NEWMFW_VER == "4.59"} {
            log "Patching [file tail $elf] to allow running of unsigned applications!"
			log "Part 1 --  4.50"
			
			set search "\xF8\x21\xFF\x81\x7C\x08\x02\xA6\x38\x61\x00\x70\xF8\x01\x00\x90"
			append search "\x4B\xFF\xFF\xE1\x38\x00\x00\x00\x2F\x83\x00\x00\x40\x9E\x00\x10"
			append search "\x88\x01\x00\x70\x68\x00\x00\x01\x54\x00\x07\xFE\x7C\x03\x07\xB4"
			append search "\xE8\x01\x00\x90\x38\x21\x00\x80\x7C\x08\x03\xA6\x4E\x80\x00\x20"
			append search "\x7C\x64\x1B\x78\x3C\x60\x00\x04\x60\x63\x8C\x07\x4B\xFF\xFF\x58"
			
			set replace "\x38\x60\x00\x01\x4E\x80\x00\x20\x38\x61\x00\x70\xF8\x01\x00\x90"
			append replace "\x4B\xFF\xFF\xE1\x38\x00\x00\x00\x2F\x83\x00\x00\x40\x9E\x00\x10"
			append replace "\x88\x01\x00\x70\x68\x00\x00\x01\x54\x00\x07\xFE\x7C\x03\x07\xB4"
			append replace "\xE8\x01\x00\x90\x38\x21\x00\x80\x7C\x08\x03\xA6\x4E\x80\x00\x20"
			append replace "\x7C\x64\x1B\x78\x3C\x60\x00\x04\x60\x63\x8C\x07\x4B\xFF\xFF\x58"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			log "Patching [file tail $elf] to allow running of unsigned applications!"
			log "Part 2"

			set search  "\x39\x60\x00\x00\x3D\x20\x00\x72\x99\x69\x71"
            set replace "\x60\x00\x00\x00\x3D\x20\x00\x72\x99\x69\x71"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			}
		
		if {$::NEWMFW_VER == "4.60" || $::NEWMFW_VER == "4.65"} {
            log "Patching [file tail $elf] to allow running of unsigned applications!"
			log "Part 1 --  4.6x"
			
			set search "\xF8\x21\xFF\x81\x7C\x08\x02\xA6\x38\x61\x00\x70\xF8\x01\x00\x90"
			append search "\x4B\xFF\xFF\xE1\x38\x00\x00\x00\x2F\x83\x00\x00\x40\x9E\x00\x10"
			append search "\x88\x01\x00\x70\x68\x00\x00\x01\x54\x00\x07\xFE\x7C\x03\x07\xB4"
			append search "\xE8\x01\x00\x90\x38\x21\x00\x80\x7C\x08\x03\xA6\x4E\x80\x00\x20"
			append search "\x7C\x64\x1B\x78\x3C\x60\x00\x04\x60\x63\x8C\x07\x4B\xFF\xFF\x58"
			
			set replace "\x38\x60\x00\x01\x4E\x80\x00\x20\x38\x61\x00\x70\xF8\x01\x00\x90"
			append replace "\x4B\xFF\xFF\xE1\x38\x00\x00\x00\x2F\x83\x00\x00\x40\x9E\x00\x10"
			append replace "\x88\x01\x00\x70\x68\x00\x00\x01\x54\x00\x07\xFE\x7C\x03\x07\xB4"
			append replace "\xE8\x01\x00\x90\x38\x21\x00\x80\x7C\x08\x03\xA6\x4E\x80\x00\x20"
			append replace "\x7C\x64\x1B\x78\x3C\x60\x00\x04\x60\x63\x8C\x07\x4B\xFF\xFF\x58"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Patching [file tail $elf] to allow running of unsigned applications!"
			log "Part 2"

			set search  "\x39\x60\x00\x00\x3D\x20\x00\x72\x99\x69\x5B"
            set replace "\x60\x00\x00\x00\x3D\x20\x00\x72\x99\x69\x5B"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Patching [file tail $elf] 4.60 to allow debug pkg installs"
			
			set search  "\x48\x00\x02\xB8\x38\x61\x02\x90\x48\x00\x50\xD5\x6F\xA0\x80\x01"
			set replace "\x48\x00\x02\xB8\x38\x61\x02\x90\x60\x00\x00\x00\x6F\xA0\x80\x01"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			}
			
		}
		
		
		if {$::patch_AAA::options(--reactpsn-online-offline) } {
		if  {$::NEWMFW_VER == "4.80" || $::NEWMFW_VER == "4.78"} {
			log "Patching [file tail $elf] for ReactPSN ONLINE/OFFLINE, run apps unsigned & more!"
			log "Updated patterns for 4.80"
			log "Part 1"
		
			set search "\x39\x29\x00\x04\x7C\x00\x48\x28\x7C\x09\xFE\x70\x7D\x23\x02\x78"
			set replace "\x39\x29\x00\x04\x38\x00\x00\x01\x7C\x09\xFE\x70\x7D\x23\x02\x78"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 2"
			
			set search "\x7C\x00\x48\x28\x2F\x80\x00\x00\x38\x60\xD8\xF3\x41\x9E\x06\xF0"
			set replace "\x38\x00\x00\x01\x2F\x80\x00\x00\x38\x60\xD8\xF3\x41\x9E\x06\xF0"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 3"
			
			set search "\x48\x00\x53\x31\x6F\xA0\x80\x01\x2F\x80\x05\x14\x41\x9E\x03\x54"
			set replace "\x60\x00\x00\x00\x6F\xA0\x80\x01\x2F\x80\x05\x14\x41\x9E\x03\x54"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 4"
			
			set search "\x7C\x7F\x1B\x78\x41\x9E\xFF\x10\xE8\x01\x02\x10\x7F\xE3\x07\xB4"
			set replace "\x7C\x7F\x1B\x78\x41\x9E\xFF\x10\xE8\x01\x02\x10\x38\x60\x00\x00"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 5"
			
			set search "\x40\x9D\x00\x08\x39\x60\x00\x00\x3D\x20\x00\x72\x99\x69\x55\xD0"
			set replace "\x40\x9D\x00\x08\x60\x00\x00\x00\x3D\x20\x00\x72\x99\x69\x55\xD0"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 6"
			
			set search "\xF8\x21\xFF\x91\x7C\x08\x02\xA6\xF8\x01\x00\x80\x4B\xDB\xA4\x09"
			set replace "\xF8\x21\xFF\x91\x7C\x08\x02\xA6\xF8\x01\x00\x80\x38\x60\x00\x00"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 7"
			
			set search "\x60\x63\x8C\x06\x4B\xFF\xFF\xA8\xF8\x21\xFF\x81\x7C\x08\x02\xA6"
			set replace "\x60\x63\x8C\x06\x4B\xFF\xFF\xA8\x38\x60\x00\x01\x4E\x80\x00\x20"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 8"
			
			set search     "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
			append search  "\x00\x00\x00\x24\x13\xBC\xC5\xF6\x00\x33\x00\x00\x00\x48\x00\x00"
			append search  "\x00\x00\x03\x84\x00\x00\x90\x00\x00\x01\x00\x00\x00\x00\x00\x00"
			set replace    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
			append replace "\x00\x00\x00\x24\x13\xBC\xC5\xF6\x00\x33\x00\x00\x00\x34\x00\x00"
			append repalce "\x00\x00\x03\x84\x00\x00\x90\x00\x00\x01\x00\x00\x00\x00\x00\x00"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 9"
			
			set search "\x00\x6C\x02\xBC\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00"
			append search "\x00\x00\x00\x02\x00\x00\x00\x01\x02\x01\x01\x01\xFF\xFF\xFF\xFF"
			set replace "\x00\x6C\x02\xBC\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00"
			append replace "\x00\x00\x00\x02\x00\x00\x00\x01\x02\x00\x01\x01\xFF\xFF\xFF\xFF"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			}
		
		if {$::NEWMFW_VER == "4.65"} {
            log "Patching [file tail $elf] for ReactPSN ONLINE/OFFLINE"
			log "Updated pattern for 4.65"
			log "Part 1"
			
			set search  "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x48\x39\xc4\xf9\x60\x00\x00\x00"
            set replace "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x48\x39\xc4\xf9\x38\x60\x00\x00"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 2"
			
			set search  "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x48\x3D\x7b\x41\x38\x03\xFF\xFF"
			set replace "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x38\x60\x00\x00\x38\x03\xFF\xFF"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
		}
		
		if {$::NEWMFW_VER == "4.60"} {
            log "Patching [file tail $elf] for ReactPSN ONLINE/OFFLINE"
			log "Updated pattern for 4.60"
			log "Part 1"
			
			set search  "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x4B\xDB\xB7\xFD\x60\x00\x00\x00"
            set replace "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x38\x60\x00\x00\x60\x00\x00\x00"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 2"
			
			set search  "\x00\x00\x00\x24\x13\xBC\xC5\xF6\x00\x33\x00\x00\x00\x46\x00\x00"
			set replace "\x00\x00\x00\x24\x13\xBC\xC5\xF6\x00\x33\x00\x00\x00\x34\x00\x00"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
		}
		
		if {$::NEWMFW_VER == "4.55"} {
            log "Patching [file tail $elf] for ReactPSN ONLINE/OFFLINE"
			log "Updated pattern for 4.55"
			log "Part 1"
			
			set search  "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x48\x39\xA0\xC1\x60\x00\x00\x00"
            set replace "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x48\x39\xA0\xC1\x38\x60\x00\x00"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 2"
			
			set search  "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x48\x3D\x57\x09\x38\x03\xFF\xFF"
			set replace "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x38\x60\x00\x00\x38\x03\xFF\xFF"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
		}
		
		if {$::NEWMFW_VER == "4.53"} {
            log "Patching [file tail $elf] for ReactPSN ONLINE/OFFLINE"
			log "Updated pattern for 4.53...."
			log "Part 1"
			
			set search  "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x48\x39\x92\xD5\x60\x00\x00\x00"
            set replace "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x48\x39\x92\xD5\x38\x60\x00\x00"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 2"
			
			set search  "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x48\x3D\x49\x1D\x38\x03\xFF\xFF"
			set replace "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x38\x60\x00\x00\x38\x03\xFF\xFF"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
		}
		
		if {$::NEWMFW_VER == "4.50" || $::NEWMFW_VER == "4.51" || $::NEWMFW_VER == "4.52"} {
            log "Patching [file tail $elf] for ReactPSN ONLINE/OFFLINE"
			log "Updated pattern for 4.5x...."
			log "Part 1"
			
			set search  "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x48\x39\x8F\xB9\x60\x00\x00\x00"
            set replace "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x48\x39\x8F\xB9\x38\x60\x00\x00"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 2"
			
			set search  "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x48\x3D\x45\xFD\x38\x03\xFF\xFF"
			set replace "\x7C\x08\x02\xA6\xF8\x01\x00\x80\x38\x60\x00\x00\x38\x03\xFF\xFF"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
		}
		
		if {$::NEWMFW_VER == "4.40" || $::NEWMFW_VER == "4.41" || $::NEWMFW_VER == "4.42" || $::NEWMFW_VER == "4.43" || $::NEWMFW_VER == "4.44" || $::NEWMFW_VER == "4.45" || $::NEWMFW_VER == "4.46"} {
            log "Patching [file tail $elf] for ReactPSN ONLINE/OFFLINE"
			log "Added by RedDot-3ND7355"
			log "Patterns by Habib!"
			log "Part 1"
			
			set search  "\x7c\x08\x02\xa6\xf8\x01\x00\x80\x4b\xdb\xe7\x2d\x60\x00\x00\x00"
            set replace "\x7c\x08\x02\xa6\xf8\x01\x00\x80\x4b\xdb\xe7\x2d\x38\x60\x00\x00"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 2"
			
			set search  "\x7c\x08\x02\xa6\xf8\x01\x00\x80\x48\x3d\x68\xd9\x38\x03\xff\xff"
			set replace "\x7c\x08\x02\xa6\xf8\x01\x00\x80\x38\x60\x00\x00\x38\x03\xff\xff"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
		}
		}
		
		
		if {$::patch_AAA::options(--xtra1-vsh-habib-446) } {
		if {$::NEWMFW_VER == "4.50"} {
            log "Patching [file tail $elf] xtra1 Patch1  - Allow debug pkg install!"
			log "Patching [file tail $elf] 4.50 to allow debug pkg installs"
			
			set search  "\x40\x9E\x02\xD0\x48\x00\x02\xB8\x38\x61\x02\x90\x48\x00\x50\xCD"
            set replace "\x40\x9E\x02\xD0\x48\x00\x02\xB8\x38\x61\x02\x90\x60\x00\x00\x00"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			}
			
			if {$::NEWMFW_VER == "4.53"} {
            log "Patching [file tail $elf] xtra1 Patch1!"
			log "Patching [file tail $elf] 4.53 to allow debug pkg installs"
			
			set search  "\x40\x9E\x02\xD0\x48\x00\x02\xB8\x38\x61\x02\x90\x48\x00\x50\xC9"
            set replace "\x40\x9E\x02\xD0\x48\x00\x02\xB8\x38\x61\x02\x90\x60\x00\x00\x00"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			}
			}
			
			
			if {$::patch_AAA::options(--xtra2-vsh-habib) } {
			if {$::NEWMFW_VER == "4.46"} {
            log "Patching [file tail $elf] xtra2 Patch2 patterns by habib!"
			log "vsh - 4460 vs 3400 -- PS2 Related! The Screenshot task Incl this task....all screenshot functions for PS1,PS2,PSP working e.g COBRA-ROG446!"
			
			set search  "\x00\x00\x00\x24\x13\xBC\xC5\xF6\x00\x33\x00\x00\x00\x44\x60\x00"
            set replace "\x00\x00\x00\x24\x13\xBC\xC5\xF6\x00\x33\x00\x00\x00\x34\x00\x00"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
		    }
			
			if {$::NEWMFW_VER == "4.50"} {
            log "Patching [file tail $elf] xtra2 Patch2 patterns by habib!"
			log "vsh - 4500 vs 3400 -- PS2 Related! The Screenshot task Incl this task....all screenshot functions for PS1,PS2,PSP working!"
			
			set search  "\x00\x00\x00\x24\x13\xBC\xC5\xF6\x00\x33\x00\x00\x00\x45\x00\x00"
            set replace "\x00\x00\x00\x24\x13\xBC\xC5\xF6\x00\x33\x00\x00\x00\x34\x00\x00"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			}
			
			if {$::NEWMFW_VER == "4.53"} {
            log "Patching [file tail $elf] xtra2 Patch2 patterns by habib!"
			log "vsh - 4530 vs 3400 -- PS2 Related! The Screenshot task Incl this task....all screenshot functions for PS1,PS2,PSP working!"
			
			set search  "\x00\x00\x00\x24\x13\xBC\xC5\xF6\x00\x33\x00\x00\x00\x45\x30\x00"
            set replace "\x00\x00\x00\x24\x13\xBC\xC5\xF6\x00\x33\x00\x00\x00\x34\x00\x00"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			}
			}
			
			if {$::patch_AAA::options(--xtra3-vsh-habib) } {
			if {$::NEWMFW_VER == "4.50"} {
            log "Patching [file tail $elf] xtra3 Patch3 patterns by habib!"
			log "vsh - assumed DISABLE fix removing act-dat after each reboot!"
			
			set search  "\x4B\xDB\xCF\xD1\x60\x00\x00\x00\xE8\x01\x00\x80"
            set replace "\x38\x60\x00\x00\x60\x00\x00\x00\xE8\x01\x00\x80"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			}
			
			if {$::NEWMFW_VER == "4.53"} {
            log "Patching [file tail $elf] xtra3 Patch3 patterns by habib!"
			log "vsh - assumed DISABLE fix removing act-dat after each reboot!"
			
			set search  "\x4B\xDB\xCF\x09\x60\x00\x00\x00\xE8\x01\x00\x80"
            set replace "\x38\x60\x00\x00\x60\x00\x00\x00\xE8\x01\x00\x80"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			}
		}
		
		if {$::patch_AAA::options(--allow-vshcobra) } {
		if {$::NEWMFW_VER == "4.46"} {
            log "Patching [file tail $elf] to allow running of unsigned applications"
			log "Proved Legit by RedDot-3ND7355"
			log "Part 1"
         
            set search  "\xF8\x21\xFF\x81\x7C\x08\x02\xA6\x38\x61\x00\x70\xF8\x01\x00\x90\x4B\xFF\xFF\xE1\x38\x00\x00\x00"
            set replace "\x38\x60\x00\x01\x4E\x80\x00\x20\x38\x61\x00\x70\xF8\x01\x00\x90\x4B\xFF\xFF\xE1\x38\x00\x00\x00"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
         
			log "Part 2"

            set search  "\x39\x60\x00\x00\x3D\x20\x00\x72\x99\x69\x65\x60\x88\x09\x65\x60"
            set replace "\x60\x00\x00\x00\x3D\x20\x00\x72\x99\x69\x65\x60\x88\x09\x65\x60"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 3"

            set search  "\x4B\xDB\xE7\x2D\x60\x00\x00\x00\xE8\x01\x00\x80\x7C\x63\x07\xB4"
            set replace "\x38\x60\x00\x00\x60\x00\x00\x00\xE8\x01\x00\x80\x7C\x63\x07\xB4"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 4"

            set search  "\x38\x61\x02\x90\x48\x00\x50\xC9\x6F\xA0\x80\x01\x2F\x80\x05\x14"
            set replace "\x38\x61\x02\x90\x60\x00\x00\x00\x6F\xA0\x80\x01\x2F\x80\x05\x14"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Part 5"
			
			set search  "\x00\x00\x00\x24\x13\xBC\xC5\xF6\x00\x33\x00\x00\x00\x44\x60\x00"
            set replace "\x00\x00\x00\x24\x13\xBC\xC5\xF6\x00\x33\x00\x00\x00\x34\x00\x00"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Patching InGame Screenshot Feature!"
			log "Thanks to mysis patterns, Part 1 -- 4.21,4.46 and 4.5x+"
			
            set search "\x29\x00\x04\x7C\x00\x48\x28\x7C\x09\xFE\x70"
            set replace "\x29\x00\x04\x38\x00\x00\x01\x7C\x09\xFE\x70"
            
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Patching InGame Screenshot Feature!"
            log "Part 2"
			log "All credits to Mysis/Wiki for the patterns!"
			
            set search "\x29\x00\x04\x7C\x00\x48\x28\x2F\x80\x00\x00"
            set replace "\x29\x00\x04\x38\x00\x00\x01\x2F\x80\x00\x00"
            
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
        }
		
		if {$::NEWMFW_VER == "4.53"} {
            log "Patching [file tail $elf] to allow running of unsigned applications!"
			log "Part 1 --  4.5x"
			
			set search "\xF8\x21\xFF\x81\x7C\x08\x02\xA6\x38\x61\x00\x70\xF8\x01\x00\x90"
			append search "\x4B\xFF\xFF\xE1\x38\x00\x00\x00\x2F\x83\x00\x00\x40\x9E\x00\x10"
			append search "\x88\x01\x00\x70\x68\x00\x00\x01\x54\x00\x07\xFE\x7C\x03\x07\xB4"
			append search "\xE8\x01\x00\x90\x38\x21\x00\x80\x7C\x08\x03\xA6\x4E\x80\x00\x20"
			append search "\x7C\x64\x1B\x78\x3C\x60\x00\x04\x60\x63\x8C\x07\x4B\xFF\xFF\x58"
			
			set replace "\x38\x60\x00\x01\x4E\x80\x00\x20\x38\x61\x00\x70\xF8\x01\x00\x90"
			append replace "\x4B\xFF\xFF\xE1\x38\x00\x00\x00\x2F\x83\x00\x00\x40\x9E\x00\x10"
			append replace "\x88\x01\x00\x70\x68\x00\x00\x01\x54\x00\x07\xFE\x7C\x03\x07\xB4"
			append replace "\xE8\x01\x00\x90\x38\x21\x00\x80\x7C\x08\x03\xA6\x4E\x80\x00\x20"
			append replace "\x7C\x64\x1B\x78\x3C\x60\x00\x04\x60\x63\x8C\x07\x4B\xFF\xFF\x58"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			log "Patching [file tail $elf] to allow running of unsigned applications!"
			log "Part 2"

			set search  "\x39\x60\x00\x00\x3D\x20\x00\x72\x99\x69\x71"
            set replace "\x60\x00\x00\x00\x3D\x20\x00\x72\x99\x69\x71"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Patching [file tail $elf] patterns by habib!"
			log "vsh - DISABLE fix removing act-dat after each reboot!"
			
			set search  "\x4B\xDB\xCF\x09\x60\x00\x00\x00\xE8\x01\x00\x80"
            set replace "\x38\x60\x00\x00\x60\x00\x00\x00\xE8\x01\x00\x80"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Patching [file tail $elf] 4.53 to allow debug pkg installs"
			
			set search  "\x40\x9E\x02\xD0\x48\x00\x02\xB8\x38\x61\x02\x90\x48\x00\x50\xC9"
            set replace "\x40\x9E\x02\xD0\x48\x00\x02\xB8\x38\x61\x02\x90\x60\x00\x00\x00"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Patching InGame Screenshot Feature!"
			log "Thanks to mysis patterns, Part 1 -- 4.21,4.46 and 4.5x+"
			
            set search "\x29\x00\x04\x7C\x00\x48\x28\x7C\x09\xFE\x70"
            set replace "\x29\x00\x04\x38\x00\x00\x01\x7C\x09\xFE\x70"
            
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
			log "Patching InGame Screenshot Feature!"
            log "Part 2"
			log "All credits to Mysis/Wiki for the patterns!"
			
            set search "\x29\x00\x04\x7C\x00\x48\x28\x2F\x80\x00\x00"
            set replace "\x29\x00\x04\x38\x00\x00\x01\x2F\x80\x00\x00"
            
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
        }
	}
}
  proc callback_patch {path args} {		
        log "Patching Photo Category (Ingame)"
		
		if {$::patch_AAA::options(--patch-ingamescreenshot-photo)} {
		sed_in_place [file join $path] "sel://localhost/screenshot?category_photo.xml#seg_screenshot" "sel://localhost/ingame?path=category_photo.xml#seg_screenshot"
		}
	log "Done category_photo patches for screenshots"
	}
	
  proc callback_patch2 {path args} {		
        log "Patching Photo Category (Permanent)"
		
		if {$::patch_AAA::options(--patch-ingamescreenshot-photo2)} {
		sed_in_place [file join $path] "sel://localhost/screenshot?category_photo.xml#seg_screenshot" "#seg_screenshot"
		}
	log "Done vsh.self patches for screenshots"
	}
}
