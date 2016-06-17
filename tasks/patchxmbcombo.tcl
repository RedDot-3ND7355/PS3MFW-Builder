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

# Priority: 11
# Description: [4.xx] Patch XMB SPRX's Only!

# Option --label: Use this Task in combination with XML replace e.g WebMAN added, and deselect [DEFAULT_IPF] Task!
# Option --allow-install-pkg: [4.xx] Patch to allow installation of packages! (part 1)
# Option --allow-install-pkg2: [4.xx] Patch to allow installation of packages! (part 2)

# Type --label: label
# Type --allow-install-pkg: boolean
# Type --allow-install-pkg2: boolean

namespace eval ::patchxmbcombo {

    array set ::patchxmbcombo::options {
	    --label ""
		--allow-install-pkg true
        --allow-install-pkg2 true
    }

	proc main { } {
	        if {$::patchxmbcombo::options(--allow-install-pkg) || $::patchxmbcombo::options(--allow-install-pkg2)} {
	        set self [file join dev_flash vsh module explore_category_game.sprx]
	        set ::SELF "explore_category_game.sprx"
	        if { ${::OLDROUTINE} == "1" } {
		    ::modify_devflash_file $self ::patchxmbcombo::patch_self1
		    } elseif { ${::OLDROUTINE} == "0" } {
		    ::modify_devflash_file2 $self ::patchxmbcombo::patch_self1
		    }
			
		    set self [file join dev_flash vsh module explore_plugin.sprx]
		    set ::SELF "explore_plugin.sprx"
            if { ${::OLDROUTINE} == "1" } {
		    ::modify_devflash_file $self ::patchxmbcombo::patch_self2
	        } elseif { ${::OLDROUTINE} == "0" } {
		    ::modify_devflash_file2 $self ::patchxmbcombo::patch_self2
		    }
		    }
	}

	proc patch_self1 {self} {
            if { ${::OLDROUTINE} == "1" } {
			::modify_self_file $self ::patchxmbcombo::patch_elf1
            } elseif { ${::OLDROUTINE} == "0" } {
		    ::modify_self_file2 $self ::patchxmbcombo::patch_elf1
		    }
	}

	proc patch_self2 {self} {
            if { ${::OLDROUTINE} == "1" } {
			::modify_self_file $self ::patchxmbcombo::patch_elf2
            } elseif { ${::OLDROUTINE} == "0" } {
		    ::modify_self_file2 $self ::patchxmbcombo::patch_elf2
		    }
	}
	
	proc patch_elf2 {elf} {
        if {$::patchxmbcombo::options(--allow-install-pkg)} {
            
			log "Patching [file tail $elf] to allow install pkg"
			log "Special feature added by RedDot-3ND7355"
			log "4.xx Patch to allow installation of packages! (part 1)"
			log "explore_plugin.sprx"
			set search  "\xF8\x21\xFE\xD1\x7C\x08\x02\xA6\xFB\x81\x01\x10\x3B\x81\x00\x70"
			set replace "\x38\x60\x00\x01\x4E\x80\x00\x20\xFB\x81\x01\x10\x3B\x81\x00\x70"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			log "Patched explore_plugin.sprx"
			  }
    }
	
	proc patch_elf1 {elf} {
        if {$::patchxmbcombo::options(--allow-install-pkg2)} {
            
			log "Patching [file tail $elf] to allow install pkg"
			log "Special feature added by RedDot-3ND7355"
			log "4.xx Patch to allow installation of packages! (part 2)"
			log "explore_category_game.sprx"
			set search  "\xF8\x21\xFE\xD1\x7C\x08\x02\xA6\xFB\x81\x01\x10\x3B\x81\x00\x70"
			set replace "\x38\x60\x00\x01\x4E\x80\x00\x20\xFB\x81\x01\x10\x3B\x81\x00\x70"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			log "Patched explore_category_game.sprx"
			  }
    }
}