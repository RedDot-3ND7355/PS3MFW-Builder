#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Created By a monkey

# Priority: 14
# Description: [4.53] Add Rogero's IPF Stealth MM Toolbox instead of [DEFAULT-IPF]!


# Option --pkg-label::
# Option --pkg-label1::
# Option --pkg-label2::
# Option --pkg-label3::
# Option --pkg-label4::
# Option --pkg-label5::
# Option --pkg-label6::
# Option --pkg-enable4: Add The IPF Toolbox PS3_GAME folder To Dev_Flash\pkg (4.53)
# Option --pkg-enable5: Add "Install Package Files" To Firmware (4.XX)
# Option --pkg-enable3: Add "/app_home" To Firmware (4.XX)
# Option --pkg-label7::
# Option --pkg-src::
# Option --pkg-label8::

# Type --pkg-label: label {PKG Section}
# Type --pkg-label1: label {Space}
# Type --pkg-label2: label {Warning}
# Type --pkg-label3: label {Warning}
# Type --pkg-label4: label {Warning}
# Type --pkg-label5: label {Space}
# Type --pkg-label6: label {Space}
# Type --pkg-enable4: boolean
# Type --pkg-enable5: boolean
# Type --pkg-enable3: boolean
# Type --pkg-label7: label {Space}
# Type --pkg-src: label
# Type --pkg-label8: label {PKG Section}

namespace eval ipf_toolbox_pkg_453 {

    array set ::ipf_toolbox_pkg_453::options {
	
		--pkg-label "---------------------------------- Welcome To The IPF Toolbox/PKG Section --------------------------------   : :"
		--pkg-label1 "                                                                                                            : :"
		--pkg-label2 "                             Add IPF Stealth Toolbox Package Files To CFW Using This Patch                  : :"
		--pkg-label3 "                                        Files Will Be Added To /dev_flash/pkg                               : :"
		--pkg-label4 "                              Don't Add Package File(s) To Nand/Nor Unless You Know What Your Doing...      : :"
		--pkg-label5 "                                                                                                            : :"
		--pkg-label6 "                         This task requires the updated LV2 IPF Toolbox-pkg [4.53] patch by Rogero !!		  : :"
		--pkg-enable4 false
		--pkg-enable5 false
		--pkg-enable3 false
		--pkg-label7 "                                                                                                             : :"
		--pkg-src "Your package file will be added automatically!"
		--pkg-label8 "----------------------------------------------------------------------------------------------------------  : :"
    }

    proc main {} {
        variable options
		
		set CATEGORY_GAME_TOOL2_XML [file join dev_flash vsh resource explore xmb category_game_tool2.xml]
		set CATEGORY_GAME_XML [file join dev_flash vsh resource explore xmb category_game.xml]

        ::modify_devflash_file $CATEGORY_GAME_TOOL2_XML ::ipf_toolbox_pkg_453::find_nodes
		::modify_devflash_file $CATEGORY_GAME_XML ::ipf_toolbox_pkg_453::inject_nodes
		
		if {$::ipf_toolbox_pkg_453::options(--pkg-enable4)} {
			set pkg [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2013_11_26_064913]
			set unpkgdir [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2013_11_26_064913.unpkg]
			::unpkg_archive $pkg $unpkgdir
			set tar [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2013_11_26_064913.unpkg content]
			set unpkgdir2 [file join ${::CUSTOM_PUP_DIR}]
			extract_tar $tar $unpkgdir2
			file mkdir [file join ${::CUSTOM_PUP_DIR} dev_flash pkg]
			file delete -force $tar
			create_tar $tar ${::CUSTOM_PUP_DIR} dev_flash
			set pkg2 [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2013_11_26_064913.pkg]
			pkg_archive $unpkgdir $pkg2
			file delete -force $pkg
			file rename -force $pkg2 $pkg
			file delete -force $unpkgdir
			set pkg2 [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2013_11_26_064913]
			set unpkgdir3 [file join ${::CUSTOM_UPDATE_DIR} dev_flash dev_flash_013.tar.aa.2013_11_26_064913]
			::unpkg_archive $pkg $unpkgdir3
			set tar2 [file join ${::CUSTOM_UPDATE_DIR} dev_flash dev_flash_013.tar.aa.2013_11_26_064913 content]
			set unpkgdir4 [file join ${::CUSTOM_UPDATE_DIR} dev_flash dev_flash]
			extract_tar $tar2 $unpkgdir4
			file delete -force [file join ${::CUSTOM_PUP_DIR} dev_flash]
		}
		
		set pkg-src "${::ToolBoxIPF_DIR}"
		set src ${pkg-src}
		set dst [file join dev_flash pkg]

		if {[file exists ${pkg-src}] == 0} {
            log "Skipping Package 1 does not exist"
        } else {
		        log "Adding $src to /dev_flash/pkg"
				log "Please Install Through Install Package Files"
		::modify_devflash_file $dst ::ipf_toolbox_pkg_453::copy_devflash_file $src
		}
    }
	
	proc create_tar {tar directory files} {
		set debug [file tail $tar]
		if {$debug == "content" } {
			set debug [file tail [file dirname $tar]]
		}
		debug "Creating tar file $debug"
		set pwd [pwd]
		cd $directory
		catch_die {::tar::create $tar $files} "Could not create tar file $tar"
		cd $pwd
	}

    proc copy_devflash_file { dst src } {
        if {[file exists $src] == 0} {
            die "$src does not exist"
        } else {
            if {[file exists $dst] == 0} {
                die "$dst does not exist"
            } else {
                copy_file -force $src $dst
            }
        }

    }
	
	proc find_nodes { file } {
        log "Parsing XML: [file tail $file]"
        set xml [::xml::LoadFile $file]
		
		if {$::ipf_toolbox_pkg_453::options(--pkg-enable5)} {
            set ::query_package_files [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_package_files"]
            set ::view_package_files [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_package_files"]
            set ::view_packages [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_packages"]
    
            if {$::query_package_files == "" || $::view_package_files == "" || $::view_packages == "" } {
                die "Could not parse $file"
            }
        }

        if {$::ipf_toolbox_pkg_453::options(--pkg-enable3)} {
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
		
		if {$::ipf_toolbox_pkg_453::options(--pkg-enable5)} {
            set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "seg_gameexit"] $::query_package_files]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_package_files]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_packages]
    
            unset ::query_package_files
            unset ::view_package_files
            unset ::view_packages
        }

        if {$::ipf_toolbox_pkg_453::options(--pkg-enable3)} {
            set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "seg_gameexit"] $::query_gamedebug]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_gamedebug]

            unset ::query_gamedebug
            unset ::view_gamedebug
        }
        ::xml::SaveToFile $xml $file
}

}
