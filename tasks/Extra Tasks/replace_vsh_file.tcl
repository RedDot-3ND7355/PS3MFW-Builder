#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Notes: Don't Try To Replace vsh Files Unless You Know What You Are Doing..

# Created By RazorX

# Priority: 2204
# Description: Replace vsh.self File (Run This Task Seperate, No Other Tasks Enabled)


# Option --vsh-label::
# Option --vsh-label1::
# Option --vsh-replace: Replace vsh.self
# Option --vsh-label2::
# Option --vsh-label3::

# Type --vsh-label: label {VSH Section}
# Type --vsh-label1: label {SPACE}
# Type --vsh-replace: file open {"self file" {self}}
# Type --vsh-label2: label {SPACE}
# Type --vsh-label3: label {VSH Section}

namespace eval replace_vsh_file {

    array set ::replace_vsh_file::options {
	
		--vsh-label "----------------------------------- Welcome To The VSH Section ---------------------------------   : :"
	    --vsh-label1 "                                                                                                                                                      : :"
        --vsh-replace "/path/to/file"
		--vsh-label2 "                                                                                                                                                      : :"
		--vsh-label3 "--------------------------------------------------------------------------------------------------------------   : :"
    }

    proc main {} {
        variable options

        set vsh_replace [file join dev_flash vsh module vsh.self]

        if {[file exists $options(--vsh-replace)] == 0 } {
            log "Skipping Custom vsh.self Does Not Exist"
        } else {
            ::modify_devflash_file ${vsh_replace} ::replace_vsh_file::copy_vsh_file $::replace_vsh_file::options(--vsh-replace)
        }
    }

    proc copy_vsh_file { dst src } {
        if {[file exists $src] == 0} {
            die "$src does not exist"
        } else {
            if {[file exists $dst] == 0} {
                die "$dst does not exist"
            } else {
                log "Replacing Default [file tail $dst] With Custom [file tail $src]"
                copy_file -force $src $dst
            }
        }
    }
}
