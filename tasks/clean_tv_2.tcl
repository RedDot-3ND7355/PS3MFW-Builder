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

# Priority: 99
# Category: TV
# Description: Clean unwanted icons from the XMB TV Category [4.xx]

# Option --clean_tv_2_gameexit: Remove "gameexit" from the TV Category
# Option --clean_tv_2_gamedir: Remove "gameDir" from the TV Category (Lovefilm, Netflix & Apps)
# Option --clean_tv_2_welcome: Remove "welcome" from the TV Category (My Channels)

# Type --clean_tv_2_gameexit: boolean
# Type --clean_tv_2_gamedir: boolean
# Type --clean_tv_2_welcome: boolean

namespace eval ::clean_tv_2 {

    array set ::clean_tv_2::options {
        --clean_tv_2_gameexit true
        --clean_tv_2_gamedir false
		--clean_tv_2_welcome true
    }

    proc main {} {
        set CATEGORY_SYSCONF_XML [file join dev_flash vsh resource explore xmb category_tv.xml]
        modify_devflash_file ${CATEGORY_SYSCONF_XML} ::clean_tv_2::callback
    }

    proc callback { file } {
        variable options

        log "Modifying XML file [file tail ${file}]"

        set xml [::xml::LoadFile ${file}]

        if {$options(--clean_tv_2_gameexit)} {
            set xml [remove_node_from_xmb_xml ${xml} "seg_gameexit" "seg_gameexit"]
        }
        if {$options(--clean_tv_2_gamedir)} {
            set xml [remove_node_from_xmb_xml ${xml} "gameDir" "gameDir"]
        }
		if {$options(--clean_tv_2_welcome)} {
            set xml [remove_node_from_xmb_xml ${xml} "seg_welcome" "seg_welcome"]
        }

        ::xml::SaveToFile ${xml} ${file}
    }
}
