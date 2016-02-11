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

# Priority: 2204
# Description: Patch Registory (Alphabetical Order)


# Option --xml-label::
# Option --xml-label1::
# Option --patch-alpha-xml: Patch Registory (Alphabetical Order)
# Option --xml-label2::
# Option --xml-label3::

# Type --xml-label: label {XML Section}
# Type --xml-label1: label {SPACE}
# Type --patch-alpha-xml: boolean
# Type --xml-label2: label {SPACE}
# Type --xml-label3: label {XML Section}

namespace eval patch_alpha_xml {

    array set ::patch_alpha_xml::options {
	
		--xml-label "------------------------------- Welcome To The Registory Section ------------------------------   : :"
	    --xml-label1 "                                                                                                                                                      : :"
        --patch-alpha-xml true
		--xml-label2 "                                                                                                                                                      : :"
		--xml-label3 "--------------------------------------------------------------------------------------------------------------   : :"
    }

    proc main {} {
        variable options

        set patch_alpha_xml [file join dev_flash vsh resource explore xmb registory.xml]

        if {$::patch_alpha_xml::options(--patch-alpha-xml)} {
        if { ${::OLDROUTINE} == "1" } {
		modify_devflash_file ${patch_alpha_xml} ::patch_alpha_xml::alpha_sort
        } elseif {
		modify_devflash_file2 ${patch_alpha_xml} ::patch_alpha_xml::alpha_sort
		}
		}
    }

    proc alpha_sort {path} {
        log "Patching Alphabetical Sort for Games in file [file tail $path]"
        sed_in_place [file join $path] -Game:Common.stat.rating-Game:Common.timeCreated+Game:Common.titleForSort-Game:Game.category -Game:Common.stat.rating-Game:Common.title+Game:Common.titleForSort-Game:Game.category
        sed_in_place [file join $path] -Game:Common.stat.rating+Game:Common.timeCreated+Game:Common.titleForSort-Game:Game.category -Game:Common.stat.rating+Game:Common.title+Game:Common.titleForSort-Game:Game.category
        sed_in_place [file join $path] -Game:Common.stat.rating-Game:Common.stat.timeLastUsed+Game:Common.titleForSort-Game:Common.timeCreated-Game:Game.category -Game:Common.stat.rating-Game:Common.stat.timeLastUsed+Game:Common.titleForSort-Game:Common.title-Game:Game.category
        sed_in_place [file join $path] -Game:Common.stat.rating+Game:Common.titleForSort-Game:Common.timeCreated-Game:Game.category -Game:Common.stat.rating+Game:Common.titleForSort-Game:Common.title-Game:Game.category
        sed_in_place [file join $path] -Game:Common.stat.rating+Game:Game.gameCategory-Game:Common.timeCreated+Game:Common.titleForSort -Game:Common.stat.rating+Game:Game.gameCategory-Game:Common.title+Game:Common.titleForSort
    }
}
