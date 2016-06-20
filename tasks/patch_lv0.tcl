#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) RedDot-3ND7355 (For making this task!)
# Copyright (C) B7U3 C50SS (For compiling)
# Copyright (C) ElmerFudd (For the codes [Python])
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Priority: 2
# Description: [4.xx] Patch lv0!


# Option --patch_lv0-my-way: [4.xx] Patch lv0 using habib's patterns! [Deselect if Cobra or Any other = ON!]
# Option --patch-lv0-nodescramble-lv1ldr: [4.xx] Patch to disable lv0 CoreOS ECDSA check & descrambling of LV1LDR!
# Option --patch_lv0-my-way3: [4.4x] Patch lv0 using Rebug/ITA DEX patterns!
# Option --patch_lv0-my-way4: [4.5x] Patch lv0 using Rebug/ITA DEX patterns!
# Option --patch_lv0-my-way5: [4.46&4.53] Patch lv0 for Cobra Featured CFW! [For Cobra 4.46/4.53]
# Option --patch_lv0-my-way6: [4.xx] Patch lv0 for a DB-OFW Build!
# Option --label: [ONLY FOR ADVANCE DEV's] If "Not do lv1-crypt! [for export&import]" is on turn off the import and export!
# Option --no-lv1crypt: [3.xx&4.xx] Not do lv1-crypt! [for export&import]
# Option --no-lv1cryptim: [3.xx&4.xx] Not do lv1-crypt! [for import]
# Option --no-lv1cryptex: [3.xx&4.xx] Not do lv1-crypt! [for export]

# Type --patch_lv0-my-way: boolean
# Type --patch-lv0-nodescramble-lv1ldr: boolean
# Type --patch_lv0-my-way3: boolean
# Type --patch_lv0-my-way4: boolean
# Type --patch_lv0-my-way5: boolean
# Type --patch_lv0-my-way6: boolean
# Type --label: label
# Type --no-lv1crypt: boolean
# Type --no-lv1cryptim: boolean
# type --no-lv1cryptex: boolean


namespace eval ::patch_lv0 {

	global options	
	 # array for saving off SELF-SCE Hdr fields
	 # for "LV0" for use by unself/makeself routines
	array set LV0_SCE_HDRS {
		--KEYREV ""
		--AUTHID ""
		--VENDORID ""
		--SELFTYPE ""
		--APPVERSION ""
		--FWVERSION ""
		--CTRLFLAGS ""
		--CAPABFLAGS ""
		--COMPRESS ""
	}

    array set ::patch_lv0::options {
	    --label ""
		--no-lv1crypt false
		--no-lv1cryptim false
		--no-lv1cryptex true
	    --patch-lv0-nodescramble-lv1ldr false
		--patch_lv0-my-way true
        --patch_lv0-my-way3	false
		--patch_lv0-my-way4 false
		--patch_lv0-my-way5 false
		--patch_lv0-my-way6 false
    }

    proc main { } {
        set self "lv0"
        set ::SELF "lv0"
		::patch_lv0::Patch_Lv0_Bitch $::CUSTOM_COSUNPKG_DIR
    }

	proc Patch_Lv0_Bitch {path} {
		#unpack the CORE_OS, extract lv0 routine and many more!

		if { ${::OLDROUTINE} == "1" } {
		::unpack_coreos_files
        } elseif { ${::OLDROUTINE} == "0" } {
		debug "Skipping unpacking coreos, already done"
		#debug "trying an alternative"
		#::unpack_coreos_files2 ${::CUSTOM_PUP_DIR} LV0_SCE_HDRS
		}
		::patch_lv0::Patch_Lv0_Nigga $path
	}

    proc patch_elf {elf} {               
        catch_die {::patch_elf $elf $::patch_lv0::search $::patch_lv0::offset $::patch_lv0::replace} \
        "Unable to patch self [file tail $elf]"
    }
	
	proc patch_self { self } {
            ::modify_lv0_file $self patch_lv0::patch_elf
        }
	
	proc Patch_Lv0_Nigga {path} {
	
		if {$::patch_lv0::options(--no-lv1crypt)} {
		set --no-lv1cryptim false
		set --no-lv1cryptex false
		debug "Setting others off"
		}
		
		log "Applying LV0 patches...."
		if {$::patch_lv0::options(--patch-lv0-nodescramble-lv1ldr)} {
		
		log "Applying LV0 ECDSA Disable patch on LV0"
	    log "Patching Lv0 to disable CoreOS ECDSA check -- LV1LDR descramble"
			set self "lv0"
			set file [file join $path $self]
            set ::SELF "lv0"
			set ::patch_lv0::search  "\xE8\x61\x00\x70\x80\x81\x00\x7C\x48\x00\x09\xB1"
            set ::patch_lv0::replace "\xE8\x61\x00\x70\x80\x81\x00\x7C\x60\x00\x00\x00"
            set ::patch_lv0::offset 0
		
		if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
		}
		
		if { ${::OLDROUTINE} == "1" } {
		 if {$::patch_lv0::options(--no-lv1crypt)} {
         set ::FLAG_NO_LV1LDR_CRYPT "NO"
		 log "Turned off lv1-crypt"
		 catch_die {::extract_lv0 $::CUSTOM_COSUNPKG_DIR "lv0"} \
		"ERROR: Could not extract LV0"				
         } elseif {$::patch_lv0::options(--no-lv1cryptex)} {	 
		 set ::FLAG_NO_LV1LDR_CRYPT "NO"
		 log "Turned off lv1-crypt"
         catch_die {::extract_lv0 $::CUSTOM_COSUNPKG_DIR "lv0"} \
		 "ERROR: Could not extract LV0"				
		} else {
		set ::FLAG_NO_LV1LDR_CRYPT "YES"
		catch_die {::extract_lv0 $::CUSTOM_COSUNPKG_DIR "lv0"} \
		"ERROR: Could not extract LV0"
		}
		} elseif { ${::OLDROUTINE} == "0" } {
	    debug "Skipped extracting of lv0 ldr's, allready did"
		}
		
		if {$::patch_lv0::options(--patch_lv0-my-way5)} {
					
			log "Patching LV0 ldrs 4.46 and 4.53 -- Only Compatible for COBRA 7.0 and it's Features!"            
			set self "lv1ldr.self"
			set file [file join $path $self]
			set ::SELF $self	
		
        set ::patch_lv0::search  "\x12\x09\x45\x09\x24\xff\xc0\xd0"
        set ::patch_lv0::replace "\x40\x80\x00\x03\x35\x00\x00\x00"
	    set ::patch_lv0::offset 0

		if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
		
		
		log "Patched lv1ldr"
		    log "Patching 4.46 and 4.53 lv2ldr..."
			set self "lv2ldr.self"
			set file [file join $path $self]
			set ::SELF $self	
         
		debug "Part 1"
        set ::patch_lv0::search  "\x33\x04\x99\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
		set ::patch_lv0::offset 0
		
		if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
		
		debug "Part 2"
		set ::patch_lv0::search  "\x33\x03\x9c\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
		set ::patch_lv0::offset 0

		if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}

		log "Patched lv2ldr"
		    log "Patching 4.46 and 4.53 isoldr for Cobra 7.0"     		
			set self "isoldr.self"
			set file [file join $path $self]
			set ::SELF $self		
            
		debug "Part 1"
        set ::patch_lv0::search  "\x33\x7e\x2e\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
	    set ::patch_lv0::offset 0

		if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			            
		debug "Part 2" 
        set ::patch_lv0::search  "\x33\x7d\x31\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
	    set ::patch_lv0::offset 0
			
        if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
		
		log "Patched isoldr"
			log "Patching 4.46 and 4.53 appldr..."
			set self "appldr.self"
			set file [file join $path $self]
			set ::SELF $self
			
			debug "Part 1"
            set ::patch_lv0::search  "\x04\x00\x2a\x03\x18\x04\x80\x81\x34\xff\xc0\xd0\x34\xff\x80\xd1"
            set ::patch_lv0::replace "\x40\x80\x00\x03\x18\x04\x80\x81\x34\xff\xc0\xd0\x34\xff\x80\xd1"
	        set ::patch_lv0::offset 0

			if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			
			debug "Part 2"
            set ::patch_lv0::search  "\x58\x24\x88\x90"
            set ::patch_lv0::replace "\x40\x80\x00\x10"
	        set ::patch_lv0::offset 0
			
            if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			
			debug "Part 3"
            set ::patch_lv0::search  "\x33\x7c\x54\x80"
            set ::patch_lv0::replace "\x40\x80\x00\x03"
	        set ::patch_lv0::offset 0
			
            if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			
			debug "Part 4"
            set ::patch_lv0::search  "\x12\x11\x62\x09\x24\xff\xc0\xd0"
            set ::patch_lv0::replace "\x48\x20\xc1\x83\x35\x00\x00\x00"
	        set ::patch_lv0::offset 0
			
            if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			
			debug "Part 5"
            set ::patch_lv0::search  "\x33\x7b\xc5\x00"
            set ::patch_lv0::replace "\x40\x80\x00\x03"
	        set ::patch_lv0::offset 0
			
            if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			log "Patched appldr"
			}
			
			if {$::patch_lv0::options(--patch_lv0-my-way6)} {
					
			log "Patching LV0 isoldr Only! for DB-OFW Build!"            
		    log "Patching 4.xx isoldr - HABIB DB-OFW Style MFW!"     		
			set self "isoldr.self"
			set file [file join $path $self]
			set ::SELF $self		
            
		debug "Part 1"
        set ::patch_lv0::search  "\x33\x7e\x2e\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
	    set ::patch_lv0::offset 0

		if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			            
		debug "Part 2" 
        set ::patch_lv0::search  "\x33\x7d\x31\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
	    set ::patch_lv0::offset 0
			
        if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
		
		log "Patched isoldr"
			}
		
		if {$::patch_lv0::options(--patch_lv0-my-way4)} {
					
			log "Patching 4.5x lv1ldr Rebug Style"            
			set self "lv1ldr.self"
			set file [file join $path $self]
			set ::SELF $self	
		
        set ::patch_lv0::search  "\x12\x09\x45\x09\x24\xff\xc0\xd0"
        set ::patch_lv0::replace "\x40\x80\x00\x03\x35\x00\x00\x00"
	    set ::patch_lv0::offset 0

		if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
		
		debug "Patching 4.5x LV1LDR **UPDATED** EID0 c2dex Check!"
			
            set ::patch_lv0::search  "\x3F\x83\x15\x05\x33\x0C\x7C\x80\x20\x00\x04\x83\x34\x00\x2B\xB0"
            set ::patch_lv0::replace "\x3F\x83\x15\x05\x40\x80\x00\x03\x20\x00\x04\x83\x34\x00\x2B\xB0"
	        set ::patch_lv0::offset 0

			if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
		
		log "Patched lv1ldr"
		    log "Patching 4.4x lv2ldr..."
			set self "lv2ldr.self"
			set file [file join $path $self]
			set ::SELF $self	
         
		debug "Part 1"
        set ::patch_lv0::search  "\x33\x04\x99\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
		set ::patch_lv0::offset 0
		
		if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
		
		debug "Part 2"
		set ::patch_lv0::search  "\x33\x03\x9c\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
		set ::patch_lv0::offset 0

		if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}

		log "Patched lv2ldr"
		    log "Patching 4.xx isoldr..."     		
			set self "isoldr.self"
			set file [file join $path $self]
			set ::SELF $self		
            
		debug "Part 1"
        set ::patch_lv0::search  "\x33\x7e\x2e\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
	    set ::patch_lv0::offset 0

		if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			            
		debug "Part 2" 
        set ::patch_lv0::search  "\x33\x7d\x31\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
	    set ::patch_lv0::offset 0
			
        if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
		
		log "Patched isoldr"
			log "Patching 4.xx appldr..."
			set self "appldr.self"
			set file [file join $path $self]
			set ::SELF $self
			
			debug "Part 1"
            set ::patch_lv0::search  "\x04\x00\x2a\x03\x18\x04\x80\x81\x34\xff\xc0\xd0\x34\xff\x80\xd1"
            set ::patch_lv0::replace "\x40\x80\x00\x03\x18\x04\x80\x81\x34\xff\xc0\xd0\x34\xff\x80\xd1"
	        set ::patch_lv0::offset 0

			if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			
			debug "Part 2"
            set ::patch_lv0::search  "\x58\x24\x88\x90"
            set ::patch_lv0::replace "\x40\x80\x00\x10"
	        set ::patch_lv0::offset 0
			
            if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			
			debug "Part 3"
            set ::patch_lv0::search  "\x33\x7c\x54\x80"
            set ::patch_lv0::replace "\x40\x80\x00\x03"
	        set ::patch_lv0::offset 0
			
            if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			
			debug "Part 4"
            set ::patch_lv0::search  "\x12\x11\x62\x09\x24\xff\xc0\xd0"
            set ::patch_lv0::replace "\x48\x20\xc1\x83\x35\x00\x00\x00"
	        set ::patch_lv0::offset 0
			
            if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			
			debug "Part 5"
            set ::patch_lv0::search  "\x33\x7b\xc5\x00"
            set ::patch_lv0::replace "\x40\x80\x00\x03"
	        set ::patch_lv0::offset 0
			
            if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			
			log "Patched appldr"
			}
		
		if {$::patch_lv0::options(--patch_lv0-my-way3)} {
			log "lv1ldr-eid0 check-brickfix LV2DKernel not incl!"
			log "Patching 4.4x lv1ldr Rebug Style...."            
			set self "lv1ldr.self"
			set file [file join $path $self]
			set ::SELF $self	
		
        debug "This part is allready patched!"
		
		debug "Patching 4.4x lv1ldr eid0 c2dex check!"
			
            set ::patch_lv0::search  "\x3F\x83\x15\x05\x33\x0C\x6A\x80\x20\x00\x04\x83\x34\x00\x2B\xB0"
            set ::patch_lv0::replace "\x3F\x83\x15\x05\x40\x80\x00\x03\x20\x00\x04\x83\x34\x00\x2B\xB0"
	        set ::patch_lv0::offset 0

			if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
		
		log "Patched lv1ldr"
		    log "Patching 4.xx lv2ldr..."
			set self "lv2ldr.self"
			set file [file join $path $self]
			set ::SELF $self	
         
		debug "Part 1"
        set ::patch_lv0::search  "\x33\x04\x99\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
		set ::patch_lv0::offset 0
		
		if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
		
		debug "Part 2"
		set ::patch_lv0::search  "\x33\x03\x9c\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
		set ::patch_lv0::offset 0

		if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}

		log "Patched lv2ldr"
		    log "Patching 4.xx isoldr..."     		
			set self "isoldr.self"
			set file [file join $path $self]
			set ::SELF $self		
            
		debug "Part 1"
        set ::patch_lv0::search  "\x33\x7e\x2e\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
	    set ::patch_lv0::offset 0

		if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			            
		debug "Part 2" 
        set ::patch_lv0::search  "\x33\x7d\x31\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
	    set ::patch_lv0::offset 0
			
        if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
		
		log "Patched isoldr"
			log "Patching 4.xx appldr..."
			set self "appldr.self"
			set file [file join $path $self]
			set ::SELF $self
			
			
			debug "Part 1"
            set ::patch_lv0::search  "\x58\x24\x88\x90"
            set ::patch_lv0::replace "\x40\x80\x00\x10"
	        set ::patch_lv0::offset 0
			
            if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			
			debug "Part 2"
            set ::patch_lv0::search  "\x33\x7c\x54\x80"
            set ::patch_lv0::replace "\x40\x80\x00\x03"
	        set ::patch_lv0::offset 0
			
            if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			
			debug "Part 3"
            set ::patch_lv0::search  "\x12\x11\x62\x09\x24\xff\xc0\xd0"
            set ::patch_lv0::replace "\x48\x20\xc1\x83\x35\x00\x00\x00"
	        set ::patch_lv0::offset 0
			
            if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			
			debug "Part 4"
            set ::patch_lv0::search  "\x33\x7b\xc5\x00"
            set ::patch_lv0::replace "\x40\x80\x00\x03"
	        set ::patch_lv0::offset 0
			
            if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			
			log "Patched appldr"
	    }
		
		if {$::patch_lv0::options(--patch_lv0-my-way)} {
			log "Patching 4.xx lv1ldr..."            
			set self "lv1ldr.self"
			set file [file join $path $self]
			set ::SELF $self	
		
        set ::patch_lv0::search  "\x12\x09\x45\x09\x24\xff\xc0\xd0"
        set ::patch_lv0::replace "\x40\x80\x00\x03\x35\x00\x00\x00"
	    set ::patch_lv0::offset 0

		if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
		
		debug "Patching 4.xx LV1LDR ECDSA CHECKS......"
			
            set ::patch_lv0::search  "\x0C\x00\x01\x85\x34\x01\x40\x80\x1C\x10\x00\x81\x3F\xE0\x02\x83"
            set ::patch_lv0::replace "\x0C\x00\x01\x85\x34\x01\x40\x80\x1C\x10\x00\x81\x40\x80\x00\x03"
	        set ::patch_lv0::offset 0

			if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			

		
		log "Patched lv1ldr"
		    log "Patching 4.xx lv2ldr..."
			set self "lv2ldr.self"
			set file [file join $path $self]
			set ::SELF $self	
         
		debug "Part 1"
        set ::patch_lv0::search  "\x33\x04\x99\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
		set ::patch_lv0::offset 0
		
		if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
		
		debug "Part 2"
		set ::patch_lv0::search  "\x33\x03\x9c\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
		set ::patch_lv0::offset 0

		if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
		
		debug "Patching 4.xx LV2LDR ECDSA CHECKS....."	
            
            set ::patch_lv0::search  "\x0C\x00\x01\x85\x34\x01\x40\x80\x1C\x10\x00\x81\x3F\xE0\x02\x83"
            set ::patch_lv0::replace "\x0C\x00\x01\x85\x34\x01\x40\x80\x1C\x10\x00\x81\x40\x80\x00\x03"
		    set ::patch_lv0::offset 0

			if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
             
			
		log "Patched lv2ldr"
		    log "Patching 4.xx isoldr..."     		
			set self "isoldr.self"
			set file [file join $path $self]
			set ::SELF $self		
            
		debug "Part 1"
        set ::patch_lv0::search  "\x33\x7e\x2e\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
	    set ::patch_lv0::offset 0

		if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			            
		debug "Part 2" 
        set ::patch_lv0::search  "\x33\x7d\x31\x00"
        set ::patch_lv0::replace "\x40\x80\x00\x03"
	    set ::patch_lv0::offset 0
			
        if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
		
		debug "Patching 4.xx ISOLDR ECDSA CHECKS......"		
            
        set ::patch_lv0::search  "\x0C\x00\x01\x85\x34\x01\x40\x80\x1C\x10\x00\x81\x3F\xE0\x02\x83"
        set ::patch_lv0::replace "\x0C\x00\x01\x85\x34\x01\x40\x80\x1C\x10\x00\x81\x40\x80\x00\x03"
	    set ::patch_lv0::offset 0

	    if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
		
		    log "Patched isoldr"
			log "Patching 4.xx appldr..."
			set self "appldr.self"
			set file [file join $path $self]
			set ::SELF $self
			
			debug "Part 1"
            set ::patch_lv0::search  "\x04\x00\x2a\x03\x18\x04\x80\x81\x34\xff\xc0\xd0\x34\xff\x80\xd1"
            set ::patch_lv0::replace "\x40\x80\x00\x03\x18\x04\x80\x81\x34\xff\xc0\xd0\x34\xff\x80\xd1"
	        set ::patch_lv0::offset 0

			if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		} 
			
			debug "Part 2"
            set ::patch_lv0::search  "\x58\x24\x88\x90"
            set ::patch_lv0::replace "\x40\x80\x00\x10"
	        set ::patch_lv0::offset 0
			
            if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			
			debug "Part 3"
            set ::patch_lv0::search  "\x33\x7c\x54\x80"
            set ::patch_lv0::replace "\x40\x80\x00\x03"
	        set ::patch_lv0::offset 0
			
            if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			
			debug "Part 4"
            set ::patch_lv0::search  "\x12\x11\x62\x09\x24\xff\xc0\xd0"
            set ::patch_lv0::replace "\x48\x20\xc1\x83\x35\x00\x00\x00"
	        set ::patch_lv0::offset 0
			
            if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			
			debug "Part 5"
            set ::patch_lv0::search  "\x33\x7b\xc5\x00"
            set ::patch_lv0::replace "\x40\x80\x00\x03"
	        set ::patch_lv0::offset 0
			
            if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
			
			debug "Patching LV0 4.xx ldrs ECDSA CHECKS !"
			set ::patch_lv0::search  "\x0C\x00\x01\x85\x34\x01\x40\x80\x1C\x10\x00\x81\x3F\xE0\x02\x83"
            set ::patch_lv0::replace "\x0C\x00\x01\x85\x34\x01\x40\x80\x1C\x10\x00\x81\x40\x80\x00\x03"
	        set ::patch_lv0::offset 0

			if { ${::OLDROUTINE} == "1" } {
        ::modify_self_file $file ::patch_lv0::patch_elf
	    } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $file ::patch_lv0::patch_elf
		}
	        log "Patched appldr"
		
		
		}
		log "Done LV0 patches...."
		#Import lv0 routine and repack coreOS!
		}
		if { ${::OLDROUTINE} == "1" } {
		if {$::patch_lv0::options(--no-lv1crypt)} {
        set ::FLAG_NO_LV1LDR_CRYPT "NO"
		catch_die {::import_lv0 $::CUSTOM_COSUNPKG_DIR "lv0"} "ERROR: Could not import LV0"
		} elseif {$::patch_lv0::options(--no-lv1cryptim)} {
		set ::FLAG_NO_LV1LDR_CRYPT "NO"
		catch_die {::import_lv0 $::CUSTOM_COSUNPKG_DIR "lv0"} "ERROR: Could not import LV0"
		} else {
		set ::FLAG_NO_LV1LDR_CRYPT "YES"
		catch_die {::import_lv0 $::CUSTOM_COSUNPKG_DIR "lv0"} "ERROR: Could not import LV0"
	    ::repack_coreos_files
		#set ::DID_PATCHING_WITH_UNPACKING_WITHIN_TASK "0"
		}
		} elseif { ${::OLDROUTINE} == "0" } {
		if {$::patch_lv0::options(--no-lv1crypt)} {
        set ::FLAG_NO_LV1LDR_CRYPT "NO"
		} elseif {$::patch_lv0::options(--no-lv1cryptim)} {
		set ::FLAG_NO_LV1LDR_CRYPT "NO"
		} else {
		set ::FLAG_NO_LV1LDR_CRYPT "YES"
	    }
	}
}