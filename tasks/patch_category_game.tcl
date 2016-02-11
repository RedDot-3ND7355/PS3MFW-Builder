#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#
    
# Priority: 12
# Description: [4.xx] Patch XMB -- add app_home and install packages
    
# Option --patch-package-files: [3.xx&4.xx] Add "Install Package Files" icon to the XMB Game Category
# Option --patch-app-home: [3.xx&4.xx] Add "/app_home" icon to the XMB Game Category
    
# Type --patch-package-files: boolean
# Type --patch-app-home: boolean

namespace eval ::patch_category_game {

array set ::patch_category_game::options {
        --patch-package-files true
        --patch-app-home true
    }

    proc main {} {
	    if {$::patch_category_game::options(--patch-package-files) || $::patch_category_game::options(--patch-app-home)} {
	        set self [file join dev_flash vsh module explore_category_game.sprx]
	        set ::SELF "explore_category_game.sprx"
	        if { ${::OLDROUTINE} == "1" } {
		    ::modify_devflash_file $self ::patch_category_game::patch_self
		    } elseif { ${::OLDROUTINE} == "0" } {
		    ::modify_devflash_file2 $self ::patch_category_game::patch_self
		    }
			
		    set self [file join dev_flash vsh module explore_plugin.sprx]
		    set ::SELF "explore_plugin.sprx"
            if { ${::OLDROUTINE} == "1" } {
		    ::modify_devflash_file $self ::patch_category_game::patch_self2
	        } elseif { ${::OLDROUTINE} == "0" } {
		    ::modify_devflash_file2 $self ::patch_category_game::patch_self2
		    }
		}
    set CATEGORY_GAME_TOOL2_XML [file join dev_flash vsh resource explore xmb category_game_tool2.xml]
    set CATEGORY_GAME_XML [file join dev_flash vsh resource explore xmb category_game.xml]
    if {$::patch_category_game::options(--patch-package-files) || $::patch_category_game::options(--patch-app-home)} {
    if { ${::OLDROUTINE} == "1" } {
	::modify_devflash_file $CATEGORY_GAME_TOOL2_XML ::patch_category_game::find_nodes
    ::modify_devflash_file $CATEGORY_GAME_XML ::patch_category_game::inject_nodes
	} elseif { ${::OLDROUTINE} == "0" } {
	::modify_devflash_file2 $CATEGORY_GAME_TOOL2_XML ::patch_category_game::find_nodes
    ::modify_devflash_file2 $CATEGORY_GAME_XML ::patch_category_game::inject_nodes
		}
    }
	}

    proc find_nodes { file } {
        log "Parsing XML: [file tail $file]"
        set xml [::xml::LoadFile $file]

        if {$::patch_category_game::options(--patch-package-files)} {
            set ::query_package_files [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_package_files"]
            set ::view_package_files [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_package_files"]
            set ::view_packages [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_packages"]
    
            if {$::query_package_files == "" || $::view_package_files == "" || $::view_packages == "" } {
                die "Could not parse $file"
            }
        }

        if {$::patch_category_game::options(--patch-app-home)} {
            set ::query_gamedebug [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_gamedebug"]
            set ::view_gamedebug [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_gamedebug"]
    
            if {$::query_gamedebug == "" || $::view_gamedebug== "" } {
                die "Could not parse $file"
            }
        }
    }
    
    proc inject_nodes { file } {
        log "Modifying XML: [file tail $file]"
        set xml [::xml::LoadFile $file]

        if {$::patch_category_game::options(--patch-package-files)} {
            set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "seg_gameexit"] $::query_package_files]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_package_files]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_packages]
    
            unset ::query_package_files
            unset ::view_package_files
            unset ::view_packages
        }

        if {$::patch_category_game::options(--patch-app-home)} {
            set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "seg_gameexit"] $::query_gamedebug]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_gamedebug]

            unset ::query_gamedebug
            unset ::view_gamedebug
        }
        ::xml::SaveToFile $xml $file
		log "Modded XML: [file tail $file]"
    }
	
	proc patch_self2 { self } {
		    if { ${::OLDROUTINE} == "1" } {
			::modify_self_file $self ::patch_category_game::patch_elf2
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_self_file2 $self ::patch_category_game::patch_elf2
			}
			}
			
	proc patch_elf { elf } {
		    log "Patching [file tail $elf] to allow install pkg"
			log "Special feature added by RedDot-3ND7355"
			log "4.xx Patch to allow installation of packages! (part 1)"
			log "explore_category_game.sprx"
			set search  "\xF8\x21\xFE\xD1\x7C\x08\x02\xA6\xFB\x81\x01\x10\x3B\x81\x00\x70"
			set replace "\x38\x60\x00\x01\x4E\x80\x00\x20\xFB\x81\x01\x10\x3B\x81\x00\x70"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			  }
			  
    proc patch_self { self } {
		    if { ${::OLDROUTINE} == "1" } {
			::modify_self_file $self ::patch_category_game::patch_elf
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_self_file2 $self ::patch_category_game::patch_elf
			}
              }
			  
	proc patch_elf2 { elf } { 
			  log "Patched explore_category_game.sprx"
			log "Patching [file tail $elf] to allow install pkg"
			log "Special feature added by RedDot-3ND7355"
			log "4.xx Patch to allow installation of packages! (part 2)"
			log "explore_plugin.sprx"
			set search  "\xF8\x21\xFE\xD1\x7C\x08\x02\xA6\xFB\x81\x01\x10\x3B\x81\x00\x70"
			set replace "\x38\x60\x00\x01\x4E\x80\x00\x20\xFB\x81\x01\x10\x3B\x81\x00\x70"
			
			catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			log "Patched explore_plugin.sprx"
			  }
}
