#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) RedDot-3ND7355 (For compiling tasks that are working)
# Copyright (C) B7U3 C50SS (For helping RedDot-3ND7355 compiling and to perfect it)
# Copyright (C) Habib (For patterns!)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Modified By RazorX

# Priority: 14
# Description: [4.xx] Patch/Enable in-game screenshot feature!

# Option --screen-label::
# Option --screen-label1::
# Option --screen-label2::
# Option --screen-label3::
# Option --screen-label4::
# Option --patch-ingamescreenshot-features: Patch vsh.self [4.46 & 4.50 & 4.53]
# Option --patch-ingamescreenshot-photo: Patch Photo Category Ingame                (If Selected Dont Enable Permanent)
# Option --patch-ingamescreenshot-photo2: Patch Photo Category Permanent          (If Selected Dont Enable Ingame)
# Option --screen-label6::
# Option --screen-label5::

# Type --screen-label: label {Screenshot Section}
# Type --screen-label1: label {Space}
# Type --screen-label2: label {Info}
# Type --screen-label3: label {Info}
# Type --screen-label4: label {Space}
# Type --patch-ingamescreenshot-features: boolean
# Type --patch-ingamescreenshot-photo: boolean
# Type --patch-ingamescreenshot-photo2: boolean
# Type --screen-label6: label {Space}
# Type --screen-label5: label {Screenshot Section}

namespace eval ::patch_ingamescreenshot {

    array set ::patch_ingamescreenshot::options {
	
		--screen-label "----------------------------- Welcome To The Screenshot Section -----------------------------   : :"
	    --screen-label1 "                                                                                                                                                      : :"
	    --screen-label2 "                    Welcome To The Screenshot Section Here You Can Enable                      : :"
	    --screen-label3 "                                Taking a Screenshot For PS3, PSP & MINIS.                                       : :"
	    --screen-label4 "                                                                                                                                                       : :"
		--patch-ingamescreenshot-features true
		--patch-ingamescreenshot-photo true
		--patch-ingamescreenshot-photo2 false
		--screen-label6 "                                                                                                                                                      : :"
		--screen-label5 "--------------------------------------------------------------------------------------------------------------   : :"
    }

    proc main { } {
	
	if {$::patch_ingamescreenshot::options(--patch-ingamescreenshot-features)} {
            set self [file join dev_flash vsh module vsh.self]
			set file [file join dev_flash vsh module vsh.self]
			set ::SELF "vsh.self"
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $self ::patch_ingamescreenshot::patch_self
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $self ::patch_ingamescreenshot::patch_self
			}
		}
	
	if {$::patch_ingamescreenshot::options(--patch-ingamescreenshot-photo)} {
			set self [file join dev_flash vsh resource explore xmb category_photo.xml]
			if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $self ::patch_ingamescreenshot::callback_patch
		    } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $self ::patch_ingamescreenshot::callback_patch
			}
		}
	
	if {$::patch_ingamescreenshot::options(--patch-ingamescreenshot-photo2)} {
			set self [file join dev_flash vsh resource explore xmb category_photo.xml]
			if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $self ::patch_ingamescreenshot::callback_patch2
			} elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $self ::patch_ingamescreenshot::callback_patch2
			}
		}
	}

    proc patch_self {self} {
            if { ${::OLDROUTINE} == "1" } {
			::modify_self_file $self ::patch_ingamescreenshot::patch_elf
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_self_file2 $self ::patch_ingamescreenshot::patch_elf
			}
		}
    	

	proc patch_elf {elf} {
        if {$::patch_ingamescreenshot::options(--patch-ingamescreenshot-features)} {
			log "Patching Screenshot Option"
            set search "\x29\x00\x04\x7C\x00\x48\x28\x7C\x09\xFE\x70"
            set replace "\x29\x00\x04\x38\x00\x00\x01\x7C\x09\xFE\x70"
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			
            set search "\x29\x00\x04\x7C\x00\x48\x28\x2F\x80\x00\x00\x38\x60"
            set replace "\x29\x00\x04\x38\x00\x00\x01\x2F\x80\x00\x00\x38\x60"
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
        }
    }
	
	proc callback_patch {path args} {		
        log "Patching Photo Category (Ingame)"
		
		if {$::patch_ingamescreenshot::options(--patch-ingamescreenshot-photo)} {
		sed_in_place [file join $path] "sel://localhost/screenshot?category_photo.xml#seg_screenshot" "sel://localhost/ingame?path=category_photo.xml#seg_screenshot"
		}
	}
	
	proc callback_patch2 {path args} {		
        log "Patching Photo Category (Permanent)"
		
		if {$::patch_ingamescreenshot::options(--patch-ingamescreenshot-photo2)} {
		sed_in_place [file join $path] "sel://localhost/screenshot?category_photo.xml#seg_screenshot" "#seg_screenshot"
		}
	}
}