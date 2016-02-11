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
    
# Priority: 2600
# Description: Spoof Firmware Version & Build

# Option --spoof-label::
# Option --spoof-label1::
# Option --spoof-label2::
# Option --spoof-label3::
# Option --spoof-label4::
# Option --spoof: Select Spoof Version
# Option --spoof-label5::

# Type --spoof-label: label {Version Spoof Section}
# Type --spoof-label1: label {Space}
# Type --spoof-label2: label {Info}
# Type --spoof-label3: label {Info}
# Type --spoof-label4: label {Space}
# Type --spoof: combobox { {1.02 1788 001:CEX-ww} {1.10 2120 001:CEX-ww} {1.11 2232 001:CEX-ww} {1.30 2400 001:CEX-ww} {1.31 2494 001:CEX-ww} {1.32 2587 001:CEX-ww} {1.50 3014 001:CEX-ww} {1.51 3229 001:CEX-ww} {1.54 3563 001:CEX-ww} {1.60 3940 001:CEX-ww} {1.70 4540 001:CEX-ww} {1.80 5354 001:CEX-ww} {1.81 5746 001:CEX-ww} {1.82 5986 001:CEX-ww} {1.90 6591 001:CEX-ww} {1.92 7272 001:CEX-ww} {1.93 7444 001:CEX-ww} {1.94 7510 001:CEX-ww} {2.00 8237 001:CEX-ww} {2.01 8426 001:CEX-ww} {2.10 9181 001:CEX-ww} {2.16 10444 001:CEX-ww} {2.17 11729 001:CEX-ww} {2.20 12342 001:CEX-ww} {2.30 13778 001:CEX-ww} {2.35 15109 001:CEX-ww} {2.36 16093 001:CEX-ww} {2.40 17023 001:CEX-ww} {2.41 17362 001:CEX-ww} {2.42 18467 001:CEX-ww} {2.43 19024 001:CEX-ww} {2.50 23368 001:CEX-ww} {2.52 24267 001:CEX-ww} {2.53 25075 001:CEX-ww} {2.60 28392 001:CEX-ww} {2.70 30429 001:CEX-ww} {2.76 31347 001:CEX-ww} {2.80 32582 001:CEX-ww} {3.00 34641 001:CEX-ww} {3.01 35108 001:CEX-ww} {3.10 37233 001:CEX-ww} {3.15 38031 001:CEX-ww} {3.20 39999 001:CEX-ww} {3.21 41486 001:CEX-ww} {3.30 42164 001:CEX-ww} {3.40 44261 001:CEX-ww} {3.41 45039 001:CEX-ww} {3.42 45831 001:CEX-ww} {3.50 46135 001:CEX-ww} {3.55 47516 001:CEX-ww} {3.56 48165 001:CEX-ww} {3.56 48246 001:CEX-ww} {3.60 48686 001:CEX-ww} {3.61 49561 001:CEX-ww} {3.65 49764 001:CEX-ww} {3.66 50527 001:CEX-ww} {3.70 51968 001:CEX-ww} {3.72 52565 001:CEX-ww} {3.73 52870 001:CEX-ww} {4.00 53642 001:CEX-ww} {4.10 54953 001:CEX-ww} {4.11 55054 001:CEX-ww} {4.20 57923 001:CEX-ww} {4.21 58071 001:CEX-ww} {4.25 58730 001:CEX-ww} {4.30 59178 001:CEX-ww} {4.31 59249 001:CEX-ww} {4.40 60156 001:CEX-ww} {4.41 60349 001:CEX-ww} {4.45 60695 001:CEX-ww} {4.46 60826 001:CEX-ww} }
# Type --spoof-label5: label {Version Spoof Section}
    
namespace eval ::spoof_version {

    array set ::spoof_version::options {
	  --spoof-label "--------------------------------- Welcome To The Spoof Section -------------------------------   : :"
	  --spoof-label1 "                                                                                                                                                    : :"
	  --spoof-label2 "                 Welcome To The Version Spoof Section Here You Can Change                : :"
	  --spoof-label3 "                                            The Version & Build Of Your CFW.                                          : :"
	  --spoof-label4 "                                                                                                                                                   : :"
      --spoof "4.46 60826 001:CEX-ww"
	  --spoof-label5 "--------------------------------------------------------------------------------------------------------------   : :"
    }

    proc main {} {
      variable options

      set release [lindex $options(--spoof) 0]
      set build [lindex $options(--spoof) 1]
      set target [lindex $options(--spoof) 2]
      set auth [lindex $options(--spoof) 1]

        if {$release != "" || $build != "" || $target != "" || $auth != ""} {
        log "Changing firmware version.txt & index.dat file"
           if { ${::OLDROUTINE} == "1" } {
		   ::modify_devflash_file [file join dev_flash vsh etc version.txt] ::spoof_version::version_txt
           } elseif { ${::OLDROUTINE} == "0" } {
		   ::modify_devflash_file2 [file join dev_flash vsh etc version.txt] ::spoof_version::version_txt
		   }
	    }
        if {$build != "" || $auth != ""} {
        log "Patching vsh.self"
           if { ${::OLDROUTINE} == "1" } {
	       ::modify_devflash_file [file join dev_flash vsh module vsh.self] ::spoof_version::patch_self
           } elseif { ${::OLDROUTINE} == "0" } {
		   ::modify_devflash_file2 [file join dev_flash vsh module vsh.self] ::spoof_version::patch_self
		   }
	    }
    }

    proc patch_self {self} {
        if { ${::OLDROUTINE} == "1" } {
	    ::modify_self_file $self ::spoof_version::patch_elf
        } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $self ::spoof_version::patch_elf
		}
	}

    proc patch_elf {elf} {
      variable options

      set release [lindex $options(--spoof) 0]
      set build [lindex $options(--spoof) 1]

      log "Patching [file tail $elf] to spoof version and build"

      debug "Patching version number"
      set search "99.99"
      debug "search: $search"
      set major [lindex [split $release "."] 0]
      set minor [lindex [split $release "."] 1]
      set replace "[format %0.2d ${major}].[format %0.2d ${minor}]"
      debug "replace: $replace"
      catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"

      debug "Patching build number"
      set search "[format %0.5d [::get_pup_build]]"
      debug "search: $search"
      set replace "[format %0.5d $build]"
      debug "replace: $replace"
      catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf] with [::hexify $replace]"

#      debug "Patching 0x31a7c0" 
#      set search "\x48\x00\x00\x38\xa0\x7f\x00\x04\x39\x60\x00\x01"
#      set replace "\x38\x60\x00\x82"
#      catch_die {::patch_elf $elf $search 4 $replace} "Unable to patch self [file tail $elf]"

#      debug "Patching ..."
#      set search "\x4b\xff\xfe\x80\xf8\x21\xff\x81\x7c\x08\x02\xa6\x38\x61\x00\x70"
#      set replace "\x38\x60\x00\x01\x4e\x80\x00\x20"
#      catch_die {::patch_elf $elf $search 4 $replace} "Unable to patch self [file tail $elf]"

      debug "Patching 0x48d030"
      set search    "\xeb\xe1\x00\x80\x38\x21\x00\x90\x7c\x08\x03\xa6\x4e\x80\x00\x20"
      append search "\xf8\x21\xff\x61\x7c\x08\x02\xa6\xfb\xe1\x00\x98\xf8\x01\x00\xb0"
      append search "\x7c\x7f\x1b\x78\x38\x00\x00\x00\x38\x61\x00\x74\xfb\x81\x00\x80"
      set replace "\x38\x60\x00\x00\x4e\x80\x00\x20"
      catch_die {::patch_elf $elf $search 16 $replace} "Unable to patch self [file tail $elf]"
    }

    proc get_fw_release {filename} {
      debug "Getting firmware release from [file tail $filename]"
      set results [grep "^release:" $filename]
      set release [string trim [regsub "^release:" $results {}] ":"]
      return [string trim $release]
    }

    proc get_fw_build {filename} {
      debug "Getting firmware build from [file tail $filename]"
      set results [grep "^build:" $filename]
      set build [string trim [regsub "^build:" $results {}] ":"]
      return [string trim $build]
    }

    proc get_fw_target {filename} {
      debug "Getting firmware target from [file tail $filename]"
      set results [grep "^target:" $filename]
      set target [regsub "^target:" $results {}]
      return [string trim $target]
    }

    proc get_fw_auth {filename} {
      debug "Getting firmware auth from [file tail $filename]"
      set results [grep "^auth:" $filename]
      set auth [string trim [regsub "^auth:" $results {}] ":"]
      return [string trim $auth]
    }

    proc version_txt {filename} {
      variable options

      set release [lindex $options(--spoof) 0]
      set build [lindex $options(--spoof) 1]
      set target [lindex $options(--spoof) 2]
      set auth [lindex $options(--spoof) 1]

      set fd [open $filename r]
      set data [read $fd]
      close $fd

      if {$release != [get_fw_release $filename]} {
        debug "Setting firmware release to $release"
        set major [lindex [split $release "."] 0]
        set minor [lindex [split $release "."] 1]
        set nano "0"
        set data [regsub {release:[0-9]+\.[0-9]+:} $data "release:[format %0.2d ${major}].[format %0.2d ${minor}][format %0.2d ${nano}]:"]
      }

      if {$build != [get_fw_build $filename]} {
        debug "Setting firmware build in to $build"
        set build_num $build
        set build_date [lindex [split [lindex [split [::spoof_version::get_fw_build $filename] ":"] 1] ","] 1]
        set data [regsub {build:[0-9]+,[0-9]+:} $data "build:${build_num},${build_date}:"]
      }

      if {$target != [get_fw_target $filename]} {
        debug "Setting firmware target to $target"
        set target_num [lindex [split $target ":"] 0]
        set target_string [lindex [split $target ":"] 1]
        set data [regsub {target:[0-9]+:[A-Z]+-ww} $data "target:${target_num}:${target_string}"]
      }

      if {$auth != [get_fw_auth $filename]} {
        debug "Setting firmware auth to $auth"
        set data [regsub {auth:[0-9]+:} $data "auth:$auth:"]
      }

      set fd [open $filename w]
      puts -nonewline $fd $data
      close $fd

      set index_dat [file join [file dirname $filename] index.dat]
      shell "dat" [file nativename $filename] [file nativename $index_dat]
    }
}

