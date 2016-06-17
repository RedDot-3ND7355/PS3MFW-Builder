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

# Priority: 8
# Description: [4.xx] Patch spu's & spp!

# Option --patch-token-features: [4.xx] Patch spu_token_processor[.self]
# Option --patch-spp-features: [4.xx] Patch spp_verifier[.self]
# Option --patch-spu-features: [4.xx] Patch spu_pkg_rvk_Verifier[.self] ! Select Only this Patch for a DB OFW Build Incl it's LV0 Patch!


# Type --patch-token-features: boolean
# Type --patch-spp-features: boolean
# Type --patch-spu-features: boolean

namespace eval ::patchcombo {

    array set ::patchcombo::options {
		--patch-spp-features false
		--patch-token-features false
		--patch-spu-features true
    }

	proc main { } {
	        if {$::patchcombo::options(--patch-spu-features)} {
            set self "spu_pkg_rvk_verifier.self"
			set ::SELF "spu_pkg_rvk_verifier.self"
            if { ${::OLDROUTINE} == "1" } {
			::modify_coreos_file $self ::patchcombo::patch_self1
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_coreos_file2 $self ::patchcombo::patch_self1
			}
			}
			
            if {$::patchcombo::options(--patch-token-features)} {
            set self "spu_token_processor.self"
			set ::SELF "spu_token_processor.self"
            if { ${::OLDROUTINE} == "1" } {
			::modify_coreos_file $self ::patchcombo::patch_self2
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_coreos_file2 $self ::patchcombo::patch_self2
			}
		    }

            if {$::patchcombo::options(--patch-spp-features)} {
            set self "spp_verifier.self"
			set ::SELF "spp_verifier.self"
            if { ${::OLDROUTINE} == "1" } {
			::modify_coreos_file $self ::patchcombo::patch_self3
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_coreos_file2 $self ::patchcombo::patch_self3
		    }
		    }
	}

	proc patch_self1 {self} {
            if { ${::OLDROUTINE} == "1" } {
			::modify_self_file $self ::patchcombo::patch_elf1
            } elseif { ${::OLDROUTINE} == "0" } {
		    ::modify_self_file2 $self ::patchcombo::patch_elf1
		    }
	}

	proc patch_self2 {self} {
            if { ${::OLDROUTINE} == "1" } {
			::modify_self_file $self ::patchcombo::patch_elf2
            } elseif { ${::OLDROUTINE} == "0" } {
		    ::modify_self_file2 $self ::patchcombo::patch_elf2
		    }
	}

	proc patch_self3 {self} {
            if { ${::OLDROUTINE} == "1" } {
			::modify_self_file $self ::patchcombo::patch_elf3
            } elseif { ${::OLDROUTINE} == "0" } {
		    ::modify_self_file2 $self ::patchcombo::patch_elf3
		    }
	}
	
	proc patch_elf3 {elf} {
        if {$::patchcombo::options(--patch-spp-features)} {
            
			#Patching SPP_Verifier!
			log "Patching SPP verifier!"
            log "Feature Added by RedDot-3ND7355 :)"
			log "Thanks habib for the patterns!"
            set search     "\x33\x07\x95\x00\x4C\xFF\xC1\xBF"
            set replace    "\x40\x80\x00\x03\x4c\xff\xc1\xbf"
            
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
        }
    }
	
	proc patch_elf2 {elf} {
        if {$::patchcombo::options(--patch-token-features)} {
            
			#Patching token_processor!
			log "Patching spu token processor!"
            log "Feature Added by RedDot-3ND7355 ;)"
			log "Thanks habib for the patterns!"
            set search     "\x12\x03\x42\x0B\x24\xFF\xC0\xD0\x04\x00\x01\xD0"
            set replace    "\x40\x80\x00\x03\x35\x00\x00\x00\x04\x00\x01\xD0"
            
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
        }
    }
	
	proc patch_elf1 {elf} {
        if {$::patchcombo::options(--patch-spu-features)} {
            
			#Patching SPKG ECDSA Verifier
			log "Patching SPKG ECDSA verifier to disable ECDSA check"
            log "Feature fixed by RedDot-3ND7355 ;)"
			log "Used for a DB OFW Build, Deselect ALL Other Patches!"
            set search  "\x33\x7F\xD0\x80\x04\x00\x01\x82\x32\x00\x01\x00"
			set replace "\x40\x80\x00\x03\x04\x00\x01\x82\x32\x00\x01\x00"
            
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
        }
    }
}