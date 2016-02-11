#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#
 
# Priority: 21
# Description: [4.53] -- [STAGE2] Add Cobra stage2.bin!

# Option --label: * LEAVE THE TXTBOX AS IS -- When the POPUP Box show for the SELF [Ignore it btw!]
# Option --label1: * PS3M * [4.53]Browse to the PS3MFW Builder dir and copy/paste the MAIN stage2.bin in the BUILD DIR
# Option --label2: * [4.53] PS3MFW-MFW\update_files\dev_flash\dev_flash\sys\ -- Close the BUILD DIR!! and Hit OK!
# Option --add-cobrabins: * For 4.53 Only the ***4.53 STAGE2.BIN***!! Thus Skip POPUP Box 1!

# Type --label: label
# Type --label1: label
# Type --label2: label
# Type --add-cobrabins: textarea


namespace eval add_453stage2cbr_habib {

    array set ::add_453stage2cbr_habib::options {
	    --label ""
		--label1 ""
		--label2 ""
        --add-cobrabins "dev_flash/sys/internal/sys_init_osd.self"
    }

    proc main {} {
        variable options
        foreach file [split $options(--add-cobrabins) "\n"] {
            if {[string equal -length 14 "dev_flash/path" ${file}] != 1} {
                if {[string equal -length 10 "dev_flash/" ${file}] == 1} {
                    ::modify_devflash_file ${file} ::add_453stage2cbr_habib::change_file
                }
            }
        }
    }

    proc change_file { file } {
        log "The file to change is in ${file}"

        if {[package provide Tk] != "" } {
           tk_messageBox -default ok -message "Ignore! this file: '${file}' , Browse to the PS3MFW builder dir and place the BIN's in it's proper place!
		   close the BUILD DIR!!!...then press ok to continue" -icon warning
        } else {
           puts "Press \[RETURN\] or \[ENTER\] to continue"
           gets stdin
        }
    }
}