#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Created By RazorX

# Priority: 21
# Description: Add Package File(s) To Firmware


# Option --pkg-label::
# Option --pkg-label1::
# Option --pkg-label2::
# Option --pkg-label3::
# Option --pkg-label4::
# Option --pkg-label5::
# Option --pkg-label6::
# Option --pkg-enable: Add Package Files To Dev_Flash
# Option --pkg-enable2: Add "Install Package Files" To Firmware
# Option --pkg-enable1: Add "/app_home" To Firmware
# Option --pkg-enable4: Add Package Files To Dev_Flash (4.xx)
# Option --pkg-enable6: Add Package Files To Dev_Flash (4.50)
# Option --pkg-enable5: Add "Install Package Files" To Firmware (4.xx)
# Option --pkg-enable3: Add "/app_home" To Firmware (4.xx)
# Option --pkg-label7::
# Option --pkg-src: Select Package File
# Option --pkg-src2: Select Package File
# Option --pkg-src3: Select Package File
# Option --pkg-src4: Select Package File
# Option --pkg-src5: Select Package File
# Option --pkg-label9::
# Option --pkg-loc: Custom Path /dev_flash/
# Option --pkg-label10::
# Option --pkg-label8::

# Type --pkg-label: label {PKG Section}
# Type --pkg-label1: label {Space}
# Type --pkg-label2: label {Warning}
# Type --pkg-label3: label {Warning}
# Type --pkg-label4: label {Warning}
# Type --pkg-label5: label {Space}
# Type --pkg-label6: label {Space}
# Type --pkg-enable: boolean
# Type --pkg-enable2: boolean
# Type --pkg-enable1: boolean
# Type --pkg-enable4: boolean
# Type --pkg-enable6: boolean
# Type --pkg-enable5: boolean
# Type --pkg-enable3: boolean
# Type --pkg-label7: label {Space}
# Type --pkg-src: file open {"Package File" {pkg}}
# Type --pkg-src2: file open {"Package File" {pkg}}
# Type --pkg-src3: file open {"Package File" {pkg}}
# Type --pkg-src4: file open {"Package File" {pkg}}
# Type --pkg-src5: file open {"Package File" {pkg}}
# Type --pkg-label9: label {Space}
# Type --pkg-loc: string
# Type --pkg-label10: label {Space}
# Type --pkg-label8: label {PKG Section}

namespace eval add_pkg_file {

    array set ::add_pkg_file::options {
	
		--pkg-label "---------------------------------- Welcome To The PKG Section --------------------------------   : :"
		--pkg-label1 "                                                                                                                                                    : :"
		--pkg-label2 "                                Add Package Files To OFW Using This Patch                                  : :"
		--pkg-label3 "                                    Files Will Be Added To Your /dev_flash/                                        : :"
		--pkg-label4 "   Don't Add Package File(s) To Nand/Nor Unless You Know What Your Doing...     : :"
		--pkg-label5 "                                                                                                                                                    : :"
		--pkg-label6 "                                                                                                                                                    : :"
		--pkg-enable false
		--pkg-enable2 false
		--pkg-enable1 false
		--pkg-enable4 false
		--pkg-enable6 true
		--pkg-enable5 true
		--pkg-enable3 true
		--pkg-label7 "                                                                                                                                                    : :"
		--pkg-src "/path/to/file"
		--pkg-src2 "/path/to/file"
		--pkg-src3 "/path/to/file"
		--pkg-src4 "/path/to/file"
		--pkg-src5 "/path/to/file"
		--pkg-label9 "                                                                                                                                                       : :"
		--pkg-loc "packages"
		--pkg-label10 "                                                                                                                                                      : :"
		--pkg-label8 "--------------------------------------------------------------------------------------------------------------   : :"
    }

    proc main {} {
        variable options
		
		set self [file join dev_flash vsh resource explore xmb category_game_tool2.xml]
			::modify_devflash_file $self ::add_pkg_file::find_nodes
		set self [file join dev_flash vsh resource explore xmb category_game.xml]
			::modify_devflash_file $self ::add_pkg_file::inject_nodes
		set self [file join dev_flash vsh resource explore xmb category_game_tool2.xml]
			::modify_devflash_file $self ::add_pkg_file::callback_patch
		set self [file join dev_flash vsh resource explore xmb category_game.xml]
			::modify_devflash_file $self ::add_pkg_file::callback_patch2
		
		if {$::add_pkg_file::options(--pkg-enable)} {
			set pkg [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2010_11_27_051337]
			set unpkgdir [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2010_11_27_051337.unpkg]
			::unpkg_archive $pkg $unpkgdir
			set tar [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2010_11_27_051337.unpkg content]
			set unpkgdir2 [file join ${::CUSTOM_PUP_DIR}]
			extract_tar $tar $unpkgdir2
			file mkdir [file join ${::CUSTOM_PUP_DIR} dev_flash $::add_pkg_file::options(--pkg-loc)]
			file delete -force $tar
			create_tar $tar ${::CUSTOM_PUP_DIR} dev_flash
			set pkg2 [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2010_11_27_051337.pkg]
			pkg_archive $unpkgdir $pkg2
			file delete -force $pkg
			file rename -force $pkg2 $pkg
			file delete -force $unpkgdir
			set pkg2 [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2010_11_27_051337]
			set unpkgdir3 [file join ${::CUSTOM_UPDATE_DIR} dev_flash dev_flash_013.tar.aa.2010_11_27_051337]
			::unpkg_archive $pkg $unpkgdir3
			set tar2 [file join ${::CUSTOM_UPDATE_DIR} dev_flash dev_flash_013.tar.aa.2010_11_27_051337 content]
			set unpkgdir4 [file join ${::CUSTOM_UPDATE_DIR} dev_flash dev_flash]
			extract_tar $tar2 $unpkgdir4
			file delete -force [file join ${::CUSTOM_PUP_DIR} dev_flash]
		}
		
		if {$::add_pkg_file::options(--pkg-enable4)} {
			set pkg [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2013_06_20_055817]
			set unpkgdir [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2013_06_20_055817.unpkg]
			::unpkg_archive $pkg $unpkgdir
			set tar [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2013_06_20_055817.unpkg content]
			set unpkgdir2 [file join ${::CUSTOM_PUP_DIR}]
			extract_tar $tar $unpkgdir2
			file mkdir [file join ${::CUSTOM_PUP_DIR} dev_flash $::add_pkg_file::options(--pkg-loc)]
			file delete -force $tar
			create_tar $tar ${::CUSTOM_PUP_DIR} dev_flash
			set pkg2 [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2013_06_20_055817.pkg]
			pkg_archive $unpkgdir $pkg2
			file delete -force $pkg
			file rename -force $pkg2 $pkg
			file delete -force $unpkgdir
			set pkg2 [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2013_06_20_055817]
			set unpkgdir3 [file join ${::CUSTOM_UPDATE_DIR} dev_flash dev_flash_013.tar.aa.2013_06_20_055817]
			::unpkg_archive $pkg $unpkgdir3
			set tar2 [file join ${::CUSTOM_UPDATE_DIR} dev_flash dev_flash_013.tar.aa.2013_06_20_055817 content]
			set unpkgdir4 [file join ${::CUSTOM_UPDATE_DIR} dev_flash dev_flash]
			extract_tar $tar2 $unpkgdir4
			file delete -force [file join ${::CUSTOM_PUP_DIR} dev_flash]
		}
		
		if {$::add_pkg_file::options(--pkg-enable6)} {
			set pkg [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2013_09_14_050612]
			set unpkgdir [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2013_09_14_050612.unpkg]
			::unpkg_archive $pkg $unpkgdir
			set tar [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2013_09_14_050612.unpkg content]
			set unpkgdir2 [file join ${::CUSTOM_PUP_DIR}]
			extract_tar $tar $unpkgdir2
			file mkdir [file join ${::CUSTOM_PUP_DIR} dev_flash $::add_pkg_file::options(--pkg-loc)]
			file delete -force $tar
			create_tar $tar ${::CUSTOM_PUP_DIR} dev_flash
			set pkg2 [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2013_09_14_050612.pkg]
			pkg_archive $unpkgdir $pkg2
			file delete -force $pkg
			file rename -force $pkg2 $pkg
			file delete -force $unpkgdir
			set pkg2 [file join ${::CUSTOM_UPDATE_DIR} dev_flash_013.tar.aa.2013_09_14_050612]
			set unpkgdir3 [file join ${::CUSTOM_UPDATE_DIR} dev_flash dev_flash_013.tar.aa.2013_09_14_050612]
			::unpkg_archive $pkg $unpkgdir3
			set tar2 [file join ${::CUSTOM_UPDATE_DIR} dev_flash dev_flash_013.tar.aa.2013_09_14_050612 content]
			set unpkgdir4 [file join ${::CUSTOM_UPDATE_DIR} dev_flash dev_flash]
			extract_tar $tar2 $unpkgdir4
			file delete -force [file join ${::CUSTOM_PUP_DIR} dev_flash]
		}
		
		set src $options(--pkg-src)
		set src2 $options(--pkg-src2)
		set src3 $options(--pkg-src3)
		set src4 $options(--pkg-src4)
		set src5 $options(--pkg-src5)
		set CUSTOM $::add_pkg_file::options(--pkg-loc)
		set dst [file join dev_flash $::add_pkg_file::options(--pkg-loc)]

		if {[file exists $options(--pkg-src)] == 0} {
            log "Skipping Package 1 does not exist"
        } else {
		        log "Adding $src to /dev_flash/$CUSTOM"
				log "Please Install Through: Install Package Files"
		::modify_devflash_file $dst ::add_pkg_file::copy_devflash_file $src
		}
		
		if {[file exists $options(--pkg-src2)] == 0} {
            log "Skipping Package 2 does not exist"
        } else {
		        log "Adding $src2 to /dev_flash/$CUSTOM"
				log "Please Install Through: Install Package Files"
		::modify_devflash_file $dst ::add_pkg_file::copy_devflash_file $src2
		}
		
		if {[file exists $options(--pkg-src3)] == 0} {
            log "Skipping Package 3 does not exist"
        } else {
		        log "Adding $src3 to /dev_flash/$CUSTOM"
				log "Please Install Through: Install Package Files"
		::modify_devflash_file $dst ::add_pkg_file::copy_devflash_file $src3
		}
		
		if {[file exists $options(--pkg-src4)] == 0} {
            log "Skipping Package 4 does not exist"
        } else {
		        log "Adding $src4 to /dev_flash/$CUSTOM"
				log "Please Install Through: Install Package Files"
		::modify_devflash_file $dst ::add_pkg_file::copy_devflash_file $src4
		}
	
		if {[file exists $options(--pkg-src5)] == 0} {
            log "Skipping Package 5 does not exist"
        } else {
				log "Adding $src5 to /dev_flash/$CUSTOM"
				log "Please Install Through: Install Package Files"
		::modify_devflash_file $dst ::add_pkg_file::copy_devflash_file $src5
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

        if {$::add_pkg_file::options(--pkg-enable2)} {
            set ::query_package_files [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_package_files"]
            set ::view_package_files [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_package_files"]
            set ::view_packages [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_packages"]
    
            if {$::query_package_files == "" || $::view_package_files == "" || $::view_packages == "" } {
                die "Could not parse $file"
            }
        }

        if {$::add_pkg_file::options(--pkg-enable1)} {
            set ::query_gamedebug [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_gamedebug"]
            set ::view_gamedebug [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_gamedebug"]
    
            if {$::query_gamedebug == "" || $::view_gamedebug== "" } {
                die "Could not parse $file"
            }
        }
		
		if {$::add_pkg_file::options(--pkg-enable5)} {
            set ::query_package_files [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_package_files"]
            set ::view_package_files [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_package_files"]
            set ::view_packages [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_packages"]
    
            if {$::query_package_files == "" || $::view_package_files == "" || $::view_packages == "" } {
                die "Could not parse $file"
            }
        }

        if {$::add_pkg_file::options(--pkg-enable3)} {
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

        if {$::add_pkg_file::options(--pkg-enable2)} {
            set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "seg_gameexit"] $::query_package_files]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_package_files]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_packages]
    
            unset ::query_package_files
            unset ::view_package_files
            unset ::view_packages
        }

        if {$::add_pkg_file::options(--pkg-enable1)} {
            set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "seg_gameexit"] $::query_gamedebug]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_gamedebug]

            unset ::query_gamedebug
            unset ::view_gamedebug
        }
		
		if {$::add_pkg_file::options(--pkg-enable5)} {
            set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "seg_gameexit"] $::query_package_files]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_package_files]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_packages]
    
            unset ::query_package_files
            unset ::view_package_files
            unset ::view_packages
        }

        if {$::add_pkg_file::options(--pkg-enable3)} {
            set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "seg_gameexit"] $::query_gamedebug]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_gamedebug]

            unset ::query_gamedebug
            unset ::view_gamedebug
        }
        ::xml::SaveToFile $xml $file
	}
	
	proc callback_patch {path args} {	
		set CATEGORY_GAME_TOOL2_XML [file join dev_flash vsh resource explore xmb category_game_tool2.xml]
		
        log "Patching Install Package Files Location"
		set REPLACE1 "host_provider_ms"
		set REPLACE2 "host_provider_flash"
		set REPLACE3 "/dev_ms"
		set REPLACE4 "/dev_flash/"
		set CUSTOM $::add_pkg_file::options(--pkg-loc)
		
		sed_in_place [file join $path] $REPLACE1 $REPLACE2
		sed_in_place [file join $path] $REPLACE3 $REPLACE4$CUSTOM
	}
	
	proc callback_patch2 {path args} {	
		set CATEGORY_GAME_XML [file join dev_flash vsh resource explore xmb category_game.xml]
        
		log "Patching Install Package Files Location"
		set REPLACE1 "host_provider_ms"
		set REPLACE2 "host_provider_flash"
		set REPLACE3 "/dev_ms"
		set REPLACE4 "/dev_flash/"
		set CUSTOM $::add_pkg_file::options(--pkg-loc)
		
		sed_in_place [file join $path] $REPLACE1 $REPLACE2
		sed_in_place [file join $path] $REPLACE3 $REPLACE4$CUSTOM
	}
}
