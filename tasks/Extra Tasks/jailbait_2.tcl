#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Modified By RazorX & fixed by RedDot-3ND7355
    
# Priority: 9999
# Description: Spoof Firmware Build & Version for SEN/PSN Access

# Option --spoof-label::
# Option --spoof-label1::
# Option --spoof-label2::
# Option --spoof-label3::
# Option --spoof-label4::
# Option --spoof: Select Firmware Details
# Option --cer: Select New CA24.cer
# Option --cer1: Select New CA27.cer
# Option --suffix: Add Suffix To The Version (Not Required)
# Option --spoof-label5::

# Type --spoof-label: label {Version Spoof Section}
# Type --spoof-label1: label {Info}
# Type --spoof-label2: label {Info}
# Type --spoof-label3: label {Info}
# Type --spoof-label4: label {Space}
# Type --spoof: combobox { { 4.46 60826 20130620 0001:CEX-ww 5084@security/sdk_branches/release_446/trunk 49873@sys/sdk_branches/release_446/trunk 16147@x3/branches/target44x 6224@paf/branches/target44x 92595@vsh/branches/target44x 86@sys_jp/branches/target44x 9306@emu/branches/target101/ps1 9308@emu/branches/target445/ps1_net 9246@emu/branches/target202/ps1_new 9199@emu/branches/target400/ps2 16862@branches/target400/gx 16770@branches/soft190/soft 9277@emu/branches/target445/psp 3941@emerald/target44x 19898@bdp/prof5/branches/target44x } { 4.25 58730 20120907 0001:CEX-ww 4859@security/sdk_branches/release_425/trunk 49405@sys/sdk_branches/release_425/trunk 16046@x3/branches/target42x 6203@paf/branches/target42x 90897@vsh/branches/target42x 81@sys_jp/branches/target42x 8891@emu/branches/target101/ps1 8948@emu/branches/target420/ps1_net 8890@emu/branches/target202/ps1_new 9029@emu/branches/target400/ps2 16578@branches/target400/gx 15529@branches/soft190/soft 9020@emu/branches/target42x/psp 3924@emerald/target42x 19089@bdp/prof5/branches/target42x } { 4.21 58071 20120630 0001:CEX-ww 4824@security/sdk_branches/release_421/trunk 49276@sys/sdk_branches/release_421/trunk 16040@x3/branches/target421 6205@paf/branches/target421 90261@vsh/branches/target421 83@sys_jp/branches/target421 8891@emu/branches/target101/ps1 8948@emu/branches/target420/ps1_net 8890@emu/branches/target202/ps1_new 8960@emu/branches/target400/ps2 16578@branches/target400/gx 15529@branches/soft190/soft 8962@emu/branches/target420/psp 3924@emerald/target42x 19089@bdp/prof5/branches/target42x } { 3.55 47516 20101127 0001:CEX-ww 4072@security/sdk_branches/release_355/trunk 46573@sys/sdk_branches/release_355/trunk 15614@x3/branches/target35x 6107@paf/branches/target35x 83779@vsh/branches/target35x 69@sys_jp/branches/target35x 6555@emu/branches/target101/ps1 6679@emu/branches/target355/ps1_net 6556@emu/branches/target202/ps1_new 6597@emu/branches/target350/ps2 14473@branches/target355/gx 13474@branches/soft190/soft 6646@emu/branches/target355/psp 3781@emerald/target35x 14948@bdp/prof5/branches/target35x } {} }
# Type --cer: file open {"SSL Certificate" {cer}}
# Type --cer1: file open {"SSL Certificate" {cer}}
# Type --suffix: string
# Type --spoof-label5: label {Version Spoof Section}
    
namespace eval ::jailbait_2 {

    array set ::jailbait_2::options {
	  --spoof-label "--------------------------------- Welcome To The Spoof Section -------------------------------   : :"
	  --spoof-label1 "Wrong patterns has been used for the vsh.self, may be updated! For the time being its desactivated!: :"
	  --spoof-label2 "                 Welcome To The Version Spoof Section Here You Can Change                       : :"
	  --spoof-label3 "                        The Build & Version Of Your CFW For SEN/PSN Access.                     : :"
	  --spoof-label4 "                                                                                                : :"
      --spoof ""
	  --cer ""
	  --cer1 ""
	  --suffix "CFW"
	  --spoof-label5 "---------------------------------------------------------------------------------------------   : :"
    }

    proc main {} {
      variable options

      set release [lindex $options(--spoof) 0]
      set build [lindex $options(--spoof) 1]
      set bdate [lindex $options(--spoof) 2]
      set target [lindex $options(--spoof) 3]
      set security [lindex $options(--spoof) 4]
      set system [lindex $options(--spoof) 5]
      set x3 [lindex $options(--spoof) 6]
      set paf [lindex $options(--spoof) 7]
      set vsh [lindex $options(--spoof) 8]
      set sys_jp [lindex $options(--spoof) 9]
      set ps1emu [lindex $options(--spoof) 10]
      set ps1netemu [lindex $options(--spoof) 11]
      set ps1newemu [lindex $options(--spoof) 12]
      set ps2emu [lindex $options(--spoof) 13]
      set ps2gxemu [lindex $options(--spoof) 14]
      set ps2softemu [lindex $options(--spoof) 15]
      set pspemu [lindex $options(--spoof) 16]
      set emerald [lindex $options(--spoof) 17]
      set bdp [lindex $options(--spoof) 18]
      set auth [lindex $options(--spoof) 1]
	  set cerfile [file join dev_flash data cert CA24.cer]
	  set cerfile1 [file join dev_flash data cert CA27.cer]
	  set prefix ""
	  set space " "
	  set suffix [lindex $options(--suffix)]
	  
	  set fd [open [file join ${::CUSTOM_VERSION_TXT}] r]
      set data [read $fd]
      close $fd

      if {$release != "" || $build != "" || $bdate != "" || $target != "" || $security != "" || $system != "" || $x3 != "" || $paf != "" || $vsh != "" || $sys_jp != "" || $ps1emu != "" || $ps1netemu != "" || $ps1newemu != "" || $ps2emu != "" || $ps2gxemu != "" || $ps2softemu != "" || $pspemu != "" || $emerald != "" || $bdp != "" || $auth != ""} {
        log "Changing Firmware version.txt & index.dat File"
		set self [file join dev_flash vsh etc version.txt]
		if { ${::OLDROUTINE} == "1" } {
		::modify_devflash_file $self ::jailbait_2::version_txt
        } elseif { ${::OLDROUTINE} == "0" } {
	    ::modify_devflash_file2 $self ::jailbait_2::version_txt
	    }
	  }
	  if {$suffix != ""} {
	  set_pup_version "${prefix}${release}${space}${suffix}"
	  set self [file join dev_flash vsh etc version.txt]
        if { ${::OLDROUTINE} == "1" } {
		::modify_devflash_file $self ::jailbait_2::version_txt
		} elseif { ${::OLDROUTINE} == "0" } {
	    ::modify_devflash_file2 $self ::jailbait_2::version_txt
	    }
	  } else {
		set_pup_version "${prefix}${release}${prefix}"
	  }
      if {$build != "" || $auth != ""} {
        log "Patching vsh.self"
		set self [file join dev_flash vsh module vsh.self]
		set file [file join dev_flash vsh module vsh.self]
		set ::SELF "vsh.self"
        if { ${::OLDROUTINE} == "1" } {
		::modify_devflash_file $self ::jailbait_2::patch_self
        } elseif { ${::OLDROUTINE} == "0" } {
	    ::modify_devflash_file2 $self ::jailbait_2::patch_self
	    }
	  }
      if {$build != "" && $bdate != ""} {
        log "Patching UPL.xml"
        ::modify_upl_file ::jailbait_2::upl_xml
      }
	  
	  if {[file exists $options(--cer)] == 0 } {
            log "Skipped Replacing CA24.cer, $options(--cer) File Not Selected"
        } else {
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file ${cerfile} ::jailbait_2::copy_cer_file $::jailbait_2::options(--cer)
            } elseif { ${::OLDROUTINE} == "0" } {
	        ::modify_devflash_file2 ${cerfile} ::jailbait_2::copy_cer_file $::jailbait_2::options(--cer)
	        }
	  }
	  
	  if {[file exists $options(--cer1)] == 0 } {
            log "Skipped Replacing CA27.cer, $options(--cer1) File Not Selected"
        } else {
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file ${cerfile1} ::jailbait_2::copy_cer_file $::jailbait_2::options(--cer1)
            } elseif { ${::OLDROUTINE} == "0" } {
	        ::modify_devflash_file2 ${cerfile1} ::jailbait_2::copy_cer_file $::jailbait_2::options(--cer1)
	        }
	  }
	}
	  
	proc copy_cer_file { dst src } {
                log "Replacing Certificate File [file tail $dst] With [file tail $src]"
                copy_file -force $src $dst
    }

    proc patch_self {self} {
      if { ${::OLDROUTINE} == "1" } {
	  ::modify_self_file $self ::jailbait_2::patch_elf
      } elseif { ${::OLDROUTINE} == "0" } {
	  ::modify_self_file2 $self ::jailbait_2::patch_elf
	  }
	}

    proc patch_elf {elf} {
      variable options

      set release [lindex $options(--spoof) 0]
      set build [lindex $options(--spoof) 1]

      #log "Patching [file tail $elf]"

      #debug "Patching 0x315f50 unlinking of file"
      #set search     "\x38\x61\x02\x90\x48\x00\x4d\x35\x60\x00\x00\x00"
      #set replace    "\x60\x00\x00\x00"
      #catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"

      #debug "Patching 0x31a7c0 debug 0x82 spoof"
      #set search     "\x48\x00\x00\x38\xa0\x7f\x00\x04\x39\x60\x00\x01"
      #set replace    "\x38\x60\x00\x82"
      #catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"

      #debug "Patching 0x31ac90 unlinking of files"
      #set search     "\xf8\x01\x00\x80\x48\x31\xb4\x65\x60\x00\x00\x00"
      #set replace    "\x38\x60\x00\x00"
      #catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"

      #debug "Patching 0x31b230 allow unsigned act.dat & *.rif"
      #set search     "\xf8\x01\x00\x80\x4b\xcf\x5b\x45\x60\x00\x00\x00"
      #set replace    "\x38\x60\x00\x00"
      #catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"

      #debug "Patching 0x48d030 spoofing"
      #set search     "\xeb\xe1\x00\x80\x38\x21\x00\x90\x7c\x08\x03\xa6\x4e\x80\x00\x20"
      #append search  "\xf8\x21\xff\x61\x7c\x08\x02\xa6\xfb\xe1\x00\x98\xf8\x01\x00\xb0"
      #append search  "\x7c\x7f\x1b\x78\x38\x00\x00\x00\x38\x61\x00\x74\xfb\x81\x00\x80"
      #set replace    "\x38\x60\x00\x00\x4e\x80\x00\x20"
      #catch_die {::patch_elf $elf $search 16 $replace} "Unable to patch self [file tail $elf]"

      #debug "Patching 0x60fee8 fself flag"
      #set search     "\x4b\xff\xfe\x80\xf8\x21\xff\x81\x7c\x08\x02\xa6\x38\x61\x00\x70"
      #set replace    "\x38\x60\x00\x01\x4e\x80\x00\x20"
      #catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"

      #debug "Patching 0x6768b0 build number"
      #set search "[format %0.5d [::get_pup_build]]"
      #set replace "[format %0.5d $build]"
      #catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf] with [::hexify $replace]"

      #debug "Patching 0x689e38 version number"
      #set search "99.99"
      #set major [lindex [split $release "."] 0]
      #set minor [lindex [split $release "."] 1]
      #set replace "[format %0.2d ${major}].[format %0.2d ${minor}]\x00\x00\0x00\0x00"
      #catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"

      #debug "Patching 0x708404 passphrase"
      #set search     "\x09\x13\x8F\x12\x48\x4E\xA4\xF0\xD0\x4C\xED\xF4\xB8\x22\x80\xE4"
      #append search  "\x3C\xB5\x88\x76\x75\x03\xD5\xEF\xB1\x70\xAA\x19\x4D\x42\x7D\x4F"
      #append search  "\xCA\xD8\x6C\x5A\x2B\xE0\xC3\x80\x74\x22\x86\x75\x10\x5D\x40\x99"
      #append search  "\x63\x01\x38\x06\x79\x59\xB9\x62\x96\x53\xDD\x67\x7D\x24\x4F\xA3"
      #set replace    "\x49\xE4\xB5\x6D\x14\xFE\x48\xB9\xD1\x87\x7F\xDF\x1C\xE0\xC6\x21"
      #append replace "\xA3\x74\x2C\x45\x67\x8B\x69\x4D\x32\xC0\xDC\xD9\x40\x4F\xB8\xF6"
      #append replace "\x12\xE0\x60\x3C\x37\x20\x9D\x8B\x93\x71\x6C\xD7\x09\xC8\x20\x21"
      #append replace "\xD7\xE5\x24\x6A\x36\xBE\xE0\x99\xA1\x0E\x8F\x40\x0D\x8E\x0D\x95"
      #catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"

      #log "WARNING: Using The SEN/PSN With This Patch May Violate Laws In Your Country!"
    }

    proc get_fw_release {filename} {
      set results [grep "^release:" $filename]
      set release [string trim [regsub "^release:" $results {}] ":"]
      return [string trim $release]
    }

    proc get_fw_build {filename} {
      set results [grep "^build:" $filename]
      set build [string trim [regsub "^build:" $results {}] ":"]
      return [string trim $build]
    }

    proc get_fw_target {filename} {
      set results [grep "^target:" $filename]
      set target [regsub "^target:" $results {}]
      return [string trim $target]
    }

    proc get_fw_security {filename} {
      set results [grep "^security:" $filename]
      set security [string trim [regsub "^security:" $results {}] ":"]
      return [string trim $security]
    }

    proc get_fw_system {filename} {
      set results [grep "^system:" $filename]
      set system [string trim [regsub "^system:" $results {}] ":"]
      return [string trim $system]
    }

    proc get_fw_x3 {filename} {
      set results [grep "^x3:" $filename]
      set x3 [string trim [regsub "^x3:" $results {}] ":"]
      return [string trim $x3]
    }

    proc get_fw_paf {filename} {
      set results [grep "^paf:" $filename]
      set paf [string trim [regsub "^paf:" $results {}] ":"]
      return [string trim $paf]
    }

    proc get_fw_vsh {filename} {
      set results [grep "^vsh:" $filename]
      set vsh [string trim [regsub "^vsh:" $results {}] ":"]
      return [string trim $vsh]
    }

    proc get_fw_sys_jp {filename} {
      set results [grep "^sys_jp:" $filename]
      set sys_jp [string trim [regsub "^sys_jp:" $results {}] ":"]
      return [string trim $sys_jp]
    }

    proc get_fw_ps1emu {filename} {
      set results [grep "^ps1emu:" $filename]
      set ps1emu [string trim [regsub "^ps1emu:" $results {}] ":"]
      return [string trim $ps1emu]
    }

    proc get_fw_ps1netemu {filename} {
      set results [grep "^ps1netemu:" $filename]
      set ps1netemu [string trim [regsub "^ps1netemu:" $results {}] ":"]
      return [string trim $ps1netemu]
    }

    proc get_fw_ps1newemu {filename} {
      set results [grep "^ps1newemu:" $filename]
      set ps1newemu [string trim [regsub "^ps1newemu:" $results {}] ":"]
      return [string trim $ps1newemu]
    }

    proc get_fw_ps2emu {filename} {
      set results [grep "^ps2emu:" $filename]
      set ps2emu [string trim [regsub "^ps2emu:" $results {}] ":"]
      return [string trim $ps2emu]
    }

    proc get_fw_ps2gxemu {filename} {
      set results [grep "^ps2gxemu:" $filename]
      set ps2gxemu [string trim [regsub "^ps2gxemu:" $results {}] ":"]
      return [string trim $ps2gxemu]
    }

    proc get_fw_ps2softemu {filename} {
      set results [grep "^ps2softemu:" $filename]
      set ps2softemu [string trim [regsub "^ps2softemu:" $results {}] ":"]
      return [string trim $ps2softemu]
    }

    proc get_fw_pspemu {filename} {
      set results [grep "^pspemu:" $filename]
      set pspemu [string trim [regsub "^pspemu:" $results {}] ":"]
      return [string trim $pspemu]
    }

    proc get_fw_emerald {filename} {
      set results [grep "^emerald:" $filename]
      set emerald [string trim [regsub "^emerald:" $results {}] ":"]
      return [string trim $emerald]
    }

    proc get_fw_bdp {filename} {
      set results [grep "^bdp:" $filename]
      set bdp [string trim [regsub "^bdp:" $results {}] ":"]
      return [string trim $bdp]
    }

    proc get_fw_auth {filename} {
      set results [grep "^auth:" $filename]
      set auth [string trim [regsub "^auth:" $results {}] ":"]
      return [string trim $auth]
    }

    proc version_txt {self} {
      variable options

      set release [lindex $options(--spoof) 0]
      set build [lindex $options(--spoof) 1]
      set bdate [lindex $options(--spoof) 2]
      set target [lindex $options(--spoof) 3]
      set security [lindex $options(--spoof) 4]
      set system [lindex $options(--spoof) 5]
      set x3 [lindex $options(--spoof) 6]
      set paf [lindex $options(--spoof) 7]
      set vsh [lindex $options(--spoof) 8]
      set sys_jp [lindex $options(--spoof) 9]
      set ps1emu [lindex $options(--spoof) 10]
      set ps1netemu [lindex $options(--spoof) 11]
      set ps1newemu [lindex $options(--spoof) 12]
      set ps2emu [lindex $options(--spoof) 13]
      set ps2gxemu [lindex $options(--spoof) 14]
      set ps2softemu [lindex $options(--spoof) 15]
      set pspemu [lindex $options(--spoof) 16]
      set emerald [lindex $options(--spoof) 17]
      set bdp [lindex $options(--spoof) 18]
      set auth [lindex $options(--spoof) 1]

      set fd [open $self r]
      set data [read $fd]
      close $fd

      if {$release != [get_fw_release $self]} {
        set major [lindex [split $release "."] 0]
        set minor [lindex [split $release "."] 1]
        set nano "0"
        debug "Setting release to release:[format %0.2d ${major}].[format %0.2d ${minor}][format %0.2d ${nano}]:"
        set data [regsub {release:[0-9]+\.[0-9]+:} $data "release:[format %0.2d ${major}].[format %0.2d ${minor}][format %0.2d ${nano}]:"]
      }

      if {$build != [get_fw_build $self]} {
        set build_num $build
        set build_date $bdate
        debug "Setting build to build:${build_num},${build_date}:"
        set data [regsub {build:[0-9]+,[0-9]+:} $data "build:${build_num},${build_date}:"]
      }

      if {$target != [get_fw_target $self]} {
        set target_num [lindex [split $target ":"] 0]
        set target_string [lindex [split $target ":"] 1]
        debug "Setting target to target:${target_num}:${target_string}"
        set data [regsub {target:[0-9]+:[A-Z]+-ww} $data "target:${target_num}:${target_string}"]
      }

      if {$security != [get_fw_security $self]} {
        set security_string [lindex [split $security ":"] 0]
        debug "Setting security to security:${security_string}:"
        set data [regsub {security:(.*?):} $data "security:${security_string}:"]
      }

      if {$system != [get_fw_system $self]} {
        set system_string [lindex [split $system ":"] 0]
        debug "Setting system to system:${system_string}:"
        set data [regsub {system:(.*?):} $data "system:${system_string}:"]
      }

      if {$x3 != [get_fw_x3 $self]} {
        set x3_string [lindex [split $x3 ":"] 0]
        debug "Setting x3 to x3:${x3_string}:"
        set data [regsub {x3:(.*?):} $data "x3:${x3_string}:"]
      }

      if {$paf != [get_fw_paf $self]} {
        set paf_string [lindex [split $paf ":"] 0]
        debug "Setting paf to paf:${paf_string}:"
        set data [regsub {paf:(.*?):} $data "paf:${paf_string}:"]
      }

      if {$vsh != [get_fw_vsh $self]} {
        set vsh_string [lindex [split $vsh ":"] 0]
        debug "Setting vsh to vsh:${vsh_string}:"
        set data [regsub {vsh:(.*?):} $data "vsh:${vsh_string}:"]
      }

      if {$sys_jp != [get_fw_sys_jp $self]} {
        set sys_jp_string [lindex [split $sys_jp ":"] 0]
        debug "Setting sys_jp to sys_jp:${sys_jp_string}:"
        set data [regsub {sys_jp:(.*?):} $data "sys_jp:${sys_jp_string}:"]
      }

      if {$ps1emu != [get_fw_ps1emu $self]} {
        set ps1emu_string [lindex [split $ps1emu ":"] 0]
        debug "Setting ps1emu to ps1emu:${ps1emu_string}:"
        set data [regsub {ps1emu:(.*?):} $data "ps1emu:${ps1emu_string}:"]
      }

      if {$ps1netemu != [get_fw_ps1netemu $self]} {
        set ps1netemu_string [lindex [split $ps1netemu ":"] 0]
        debug "Setting ps1netemu to ps1netemu:${ps1netemu_string}:"
        set data [regsub {ps1netemu:(.*?):} $data "ps1netemu:${ps1netemu_string}:"]
      }

      if {$ps1newemu != [get_fw_ps1newemu $self]} {
        set ps1newemu_string [lindex [split $ps1newemu ":"] 0]
        debug "Setting ps1newemu to ps1newemu:${ps1newemu_string}:"
        set data [regsub {ps1newemu:(.*?):} $data "ps1newemu:${ps1newemu_string}:"]
      }

      if {$ps2emu != [get_fw_ps2emu $self]} {
        set ps2emu_string [lindex [split $ps2emu ":"] 0]
        debug "Setting ps2emu to ps2emu:${ps2emu_string}:"
        set data [regsub {ps2emu:(.*?):} $data "ps2emu:${ps2emu_string}:"]
      }

      if {$ps2gxemu != [get_fw_ps2gxemu $self]} {
        set ps2gxemu_string [lindex [split $ps2gxemu ":"] 0]
        debug "Setting ps2gxemu to ps2gxemu:${ps2gxemu_string}:"
        set data [regsub {ps2gxemu:(.*?):} $data "ps2gxemu:${ps2gxemu_string}:"]
      }

      if {$ps2softemu != [get_fw_ps2softemu $self]} {
        set ps2softemu_string [lindex [split $ps2softemu ":"] 0]
        debug "Setting ps2softemu to ps2softemu:${ps2softemu_string}:"
        set data [regsub {ps2softemu:(.*?):} $data "ps2softemu:${ps2softemu_string}:"]
      }

      if {$pspemu != [get_fw_pspemu $self]} {
        set pspemu_string [lindex [split $pspemu ":"] 0]
        debug "Setting pspemu to pspemu:${pspemu_string}:"
        set data [regsub {pspemu:(.*?):} $data "pspemu:${pspemu_string}:"]
      }

      if {$emerald != [get_fw_emerald $self]} {
        set emerald_string [lindex [split $emerald ":"] 0]
        debug "Setting emerald to emerald:${emerald_string}:"
        set data [regsub {emerald:(.*?):} $data "emerald:${emerald_string}:"]
      }

      if {$bdp != [get_fw_bdp $self]} {
        set bdp_string [lindex [split $bdp ":"] 0]
        debug "Setting bdp to bdp:${bdp_string}:"
        set data [regsub {bdp:(.*?):} $data "bdp:${bdp_string}:"]
      }

      if {$auth != [get_fw_auth $self]} {
        debug "Setting auth to auth:$auth:"
        set data [regsub {auth:[0-9]+:} $data "auth:$auth:"]
      }

      set fd [open $self w]
      puts -nonewline $fd $data
      close $fd

      set index_dat [file join [file dirname $self] index.dat]
      shell "dat" [file nativename $self] [file nativename $index_dat]
    }

	proc upl_xml {filename} {
      variable options

      set release [lindex $options(--spoof) 0]
      set build [lindex $options(--spoof) 1]
      set bdate [lindex $options(--spoof) 2]
      set major [lindex [split $release "."] 0]
      set minor [lindex [split $release "."] 1]
      set nano "0"

      debug "Setting UPL.xml.pkg :: release to ${release} :: build to ${build},${bdate}"

      set search [::get_header_key_upl_xml $filename Version Version]
      set replace "[format %0.2d ${major}].[format %0.2d ${minor}][format %0.2d ${nano}]:"
      if { $search != "" && $search != $replace } {
        set xml [::set_header_key_upl_xml $filename Version "${replace}" Version]
        if { $xml == "" } {
          die "jailbait failed:: search: $search :: replace: $replace"
        }
      }

      set search [::get_header_key_upl_xml $filename Build Build]
      set replace "${build},${bdate}"
      if { $search != "" && $search != $replace } {
        set xml [::set_header_key_upl_xml $filename Build "${replace}" Build]
        if { $xml == "" } {
          die "jailbait failed:: search: $search :: replace: $replace"
        }
      }
    }
}