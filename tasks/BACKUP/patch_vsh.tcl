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
# Description: [4.xx/3.xx] Patch VSH

# Option --allow-pseudoretail-pkg-dex: [3.55] Patch to allow installation of pseudo-retail packages on DEX
# Option --allow-retail-pkg-dex: [3.55] Patch to allow installation of retail packages on DEX
# Option --allow-pseudoretail-pkg: [3.xx&4.xx] Patch to allow installation of pseudo-retail packages
# Option --allow-debug-pkg: [3.xx&4.xx] Patch to allow installation of debug packages
# Option --patch-vsh-react-psn-v2-341-debug: [3.41] Jailbait - Patch to implement ReactPSN v2.0 into VSH DEBUG
# Option --patch-vsh-react-psn-v2-355-debug: [3.55] Jailbait - Patch to implement ReactPSN v2.0 into VSH DEBUG
# Option --patch-vsh-react-psn-v2-341: [3.41] Jailbait - Patch to implement ReactPSN v2.0 into VSH
# Option --patch-vsh-react-psn-v2-355: [3.55] Jailbait - Patch to implement ReactPSN v2.0 into VSH
# Option --patch-vsh-react-psn-v2-4x: [Patterns Not Supported] Jailbait - Patch to implement ReactPSN v2.0 into VSH
# Option --spoof-psn-passphrase: Jailbait - Patch PSN Passphrase (Not needed to time)

# Type --allow-pseudoretail-pkg-dex: boolean
# Type --allow-retail-pkg-dex: boolean
# Type --allow-pseudoretail-pkg: boolean
# Type --allow-debug-pkg: boolean
# Type --patch-vsh-react-psn-v2-341-debug: boolean
# Type --patch-vsh-react-psn-v2-355-debug: boolean
# Type --patch-vsh-react-psn-v2-341: boolean
# Type --patch-vsh-react-psn-v2-355: boolean
# Type --patch-vsh-react-psn-v2-4x: boolean
# Type --spoof-psn-passphrase: boolean

namespace eval ::patch_vsh {

    array set ::patch_vsh::options {
        --allow-pseudoretail-pkg-dex false
        --allow-retail-pkg-dex false
        --allow-pseudoretail-pkg true
        --allow-debug-pkg true
        --patch-vsh-react-psn-v2-341-debug false
        --patch-vsh-react-psn-v2-355-debug false
        --patch-vsh-react-psn-v2-341 false
        --patch-vsh-react-psn-v2-355 false
        --patch-vsh-react-psn-v2-4x false
        --spoof-psn-passphrase false
    }

    proc main { } {
        variable options
        set path [file join dev_flash data cert]
     
        if {$::patch_vsh::options(--allow-pseudoretail-pkg) || $::patch_vsh::options(--allow-debug-pkg) || $::patch_vsh::options(--allow-pseudoretail-pkg-dex) || $::patch_vsh::options(--allow-retail-pkg-dex)} {
            set self [file join dev_flash vsh module nas_plugin.sprx]
			set ::SELF "nas_plugin.sprx"
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $self ::patch_vsh::patch_self
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $self ::patch_vsh::patch_self
			}
		}
        
        if {$::patch_vsh::options(--patch-vsh-react-psn-v2-341-debug) || $::patch_vsh::options(--patch-vsh-react-psn-v2-355-debug) || $::patch_vsh::options(--patch-vsh-react-psn-v2-341) || $::patch_vsh::options(--patch-vsh-react-psn-v2-355) || $::patch_vsh::options(--patch-vsh-react-psn-v2-4x) || $::patch_vsh::options(--spoof-psn-passphrase)} {
            set self [file join dev_flash vsh module vsh.self]
			set ::SELF "vsh.self"
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $self ::patch_vsh::patch_self
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $self ::patch_vsh::patch_self
			}
	    }
    }

    proc patch_self {self} {    
        if { ${::OLDROUTINE} == "1" } {
		::modify_self_file $self ::patch_vsh::patch_elf
        } elseif { ${::OLDROUTINE} == "0" } {
		::modify_self_file2 $self ::patch_vsh::patch_elf
		}
	}

    proc patch_elf {elf} {
        if {$::patch_vsh::options(--allow-pseudoretail-pkg-dex) } {
            log "Patching [file tail $elf] to allow pseudo-retail pkg installs on dex"
         
            set search "\x7c\x60\x1b\x78\xf8\x1f\x01\x80"
            set replace "\x38\x00\x00\x00"
         
            catch_die {::patch_elf $elf $search 0 $replace} \
            "Unable to patch self [file tail $elf]"
        }
     
		if {$::patch_vsh::options(--allow-retail-pkg-dex) } {
            log "Patching [file tail $elf] to allow retail pkg installs on dex"
         
            set search "\x2f\x80\x00\x00\x41\x9e\x01\xb0\x3b\xa1\x00\x80"
            set replace "\x60\x00\x00\x00"
         
            catch_die {::patch_elf $elf $search 4 $replace} \
            "Unable to patch self [file tail $elf]"
        }
     
        if {$::patch_vsh::options(--allow-pseudoretail-pkg) } {
            log "Patching [file tail $elf] to allow pseudo-retail pkg installs"
         
            set search "\x7c\x60\x1b\x78\xf8\x1f\x01\x80"
            set replace "\x38\x00\x00\x00"
         
            catch_die {::patch_elf $elf $search 0 $replace} \
            "Unable to patch self [file tail $elf]"
        }
     
        if {$::patch_vsh::options(--allow-debug-pkg) } {
            log "Patching [file tail $elf] to allow debug pkg installs"
         
            set search "\x2f\x89\x00\x00\x41\x9e\x00\x4c\x38\x00\x00\x00"
            set replace "\x60\x00\x00\x00"
         
            catch_die {::patch_elf $elf $search 4 $replace} \
            "Unable to patch self [file tail $elf]"
        }

        if {$::patch_vsh::options(--patch-vsh-react-psn-v2-341-debug)} {
            log "Patching [file tail $elf] to allow unsigned act.dat & .rif files"
         
            set search "\x4B\xCF\x3E\x99"
            set replace "\x38\x60\x00\x00"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
         
            log "Patching [file tail $elf] to disable delating of unsigned act.dat & .rif files"
            set search "\x48\x31\x47\x1D"
            set replace "\x38\x60\x00\x00"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
        }
        
        if {$::patch_vsh::options(--patch-vsh-react-psn-v2-341)} {
            log "Patching [file tail $elf] to allow unsigned act.dat & .rif files"
         
            set search "\x4B\xCF\xAF\xB1"
            set replace "\x38\x60\x00\x00"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
         
            log "Patching [file tail $elf] to disable delating of unsigned act.dat & .rif files"
            set search "\x48\x31\x43\xAD"
            set replace "\x38\x60\x00\x00"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
        }
        
        if {$::patch_vsh::options(--patch-vsh-react-psn-v2-355-debug)} {
            log "Patching [file tail $elf] to allow unsigned act.dat & .rif files"
         
            set search "\x4B\xCE\xEA\x6D"
            set replace "\x38\x60\x00\x00"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
         
            log "Patching [file tail $elf] to disable delating of unsigned act.dat & .rif files"
            set search "\x48\x31\xB7\xD5"
            set replace "\x38\x60\x00\x00"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
        }
        
        if {$::patch_vsh::options(--patch-vsh-react-psn-v2-355)} {
            log "Patching [file tail $elf] to allow unsigned act.dat & .rif files"
         
            set search "\x4B\xCF\x5B\x45"
            set replace "\x38\x60\x00\x00"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
         
            log "Patching [file tail $elf] to disable delating of unsigned act.dat & .rif files"
            set search "\x48\x31\xB4\x65"
            set replace "\x38\x60\x00\x00"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
        }
        
        if {$::patch_vsh::options(--patch-vsh-react-psn-v2-4x)} {
            log "Patching [file tail $elf] to allow unsigned act.dat & .rif files"
          
            set search "\x4B\xDC\x03\xA9"
            set replace "\x38\x60\x00\x00"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
         
            log "Patching [file tail $elf] to disable delating of unsigned act.dat & .rif files"
            set search "\x48\x3D\x55\x6D"
            set replace "\x38\x60\x00\x00"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
            
        }
        
        if {$::patch_vsh::options(--spoof-psn-passphrase)} {
            log "Patching [file tail $elf] new passphrase for PSN access"
            
            set search     "\x"
            append search  "\x"
            append search  "\x"
            set replace    "\x"
            append replace "\x"
            append replace "\x"
            
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
        }
        
        if {$::patch_vsh::options(--spoof-new) != 0} {
            variable options
            set release [lindex $::patch_vsh::options(--spoof) 0]
            set build [lindex $::patch_vsh::options(--spoof) 1]
          
            log "Patching [file tail $elf] with new build/version number for PSN access"
         
            debug "Patching build number"
            set search "[format %0.5d [::get_pup_build]]"
            set replace "[format %0.5d $build]"
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf] with [::hexify $replace]"
            
            debug "Patching version number"
            set search "99.99"
            set major [lindex [split $release "."] 0]
            set minor [lindex [split $release "."] 1]
            set replace "[format %0.2d ${major}].[format %0.2d ${minor}]\x00\x00\0x00\0x00"
            catch_die {::patch_elf $elf $search 8 $replace} "Unable to patch self [file tail $elf]"
        }
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

    proc version_txt {filename} {
        variable options
     
        set release [lindex $::patch_vsh::options(--spoof) 0]
        set build [lindex $::patch_vsh::options(--spoof) 1]
        set bdate [lindex $::patch_vsh::options(--spoof) 2]
        set target [lindex $::patch_vsh::options(--spoof) 3]
        set security [lindex $::patch_vsh::options(--spoof) 4]
        set system [lindex $::patch_vsh::options(--spoof) 5]
        set x3 [lindex $::patch_vsh::options(--spoof) 6]
        set paf [lindex $::patch_vsh::options(--spoof) 7]
        set vsh [lindex $::patch_vsh::options(--spoof) 8]
        set sys_jp [lindex $::patch_vsh::options(--spoof) 9]
        set ps1emu [lindex $::patch_vsh::options(--spoof) 10]
        set ps1netemu [lindex $::patch_vsh::options(--spoof) 11]
        set ps1newemu [lindex $::patch_vsh::options(--spoof) 12]
        set ps2emu [lindex $::patch_vsh::options(--spoof) 13]
        set ps2gxemu [lindex $::patch_vsh::options(--spoof) 14]
        set ps2softemu [lindex $::patch_vsh::options(--spoof) 15]
        set pspemu [lindex $::patch_vsh::options(--spoof) 16]
        set emerald [lindex $::patch_vsh::options(--spoof) 17]
        set bdp [lindex $::patch_vsh::options(--spoof) 18]
        set auth [lindex $::patch_vsh::options(--spoof) 1]
     
        set fd [open $filename r]
        set data [read $fd]
        close $fd
       
        if {$release != [get_fw_release $filename]} {
            set major [lindex [split $release "."] 0]
            set minor [lindex [split $release "."] 1]
            set nano "0"
            debug "Setting release to release:[format %0.2d ${major}].[format %0.2d ${minor}][format %0.2d ${nano}]:"
            set data [regsub {release:[0-9]+\.[0-9]+:} $data "release:[format %0.2d ${major}].[format %0.2d ${minor}][format %0.2d ${nano}]:"]
        }
     
        if {$build != [get_fw_build $filename]} {
            set build_num $build
            set build_date $bdate
            debug "Setting build to build:${build_num},${build_date}:"
           set data [regsub {build:[0-9]+,[0-9]+:} $data "build:${build_num},${build_date}:"]
        }
     
        if {$target != [get_fw_target $filename]} {
            set target_num [lindex [split $target ":"] 0]
            set target_string [lindex [split $target ":"] 1]
            debug "Setting target to target:${target_num}:${target_string}"
            set data [regsub {target:[0-9]+:[A-Z]+-ww} $data "target:${target_num}:${target_string}"]
        }
     
        if {$security != [get_fw_security $filename]} {
            set security_string [lindex [split $security ":"] 0]
            debug "Setting security to security:${security_string}:"
            set data [regsub {security:(.*?):} $data "security:${security_string}:"]
        }
     
        if {$system != [get_fw_system $filename]} {
            set system_string [lindex [split $system ":"] 0]
            debug "Setting system to system:${system_string}:"
            set data [regsub {system:(.*?):} $data "system:${system_string}:"]
        }
     
        if {$x3 != [get_fw_x3 $filename]} {
            set x3_string [lindex [split $x3 ":"] 0]
            debug "Setting x3 to x3:${x3_string}:"
            set data [regsub {x3:(.*?):} $data "x3:${x3_string}:"]
        }
     
        if {$paf != [get_fw_paf $filename]} {
            set paf_string [lindex [split $paf ":"] 0]
            debug "Setting paf to paf:${paf_string}:"
            set data [regsub {paf:(.*?):} $data "paf:${paf_string}:"]
        }
     
        if {$vsh != [get_fw_vsh $filename]} {
            set vsh_string [lindex [split $vsh ":"] 0]
            debug "Setting vsh to vsh:${vsh_string}:"
            set data [regsub {vsh:(.*?):} $data "vsh:${vsh_string}:"]
        }
     
        if {$sys_jp != [get_fw_sys_jp $filename]} {
            set sys_jp_string [lindex [split $sys_jp ":"] 0]
            debug "Setting sys_jp to sys_jp:${sys_jp_string}:"
            set data [regsub {sys_jp:(.*?):} $data "sys_jp:${sys_jp_string}:"]
        }
     
        if {$ps1emu != [get_fw_ps1emu $filename]} {
            set ps1emu_string [lindex [split $ps1emu ":"] 0]
            debug "Setting ps1emu to ps1emu:${ps1emu_string}:"
            set data [regsub {ps1emu:(.*?):} $data "ps1emu:${ps1emu_string}:"]
        }
     
        if {$ps1netemu != [get_fw_ps1netemu $filename]} {
            set ps1netemu_string [lindex [split $ps1netemu ":"] 0]
            debug "Setting ps1netemu to ps1netemu:${ps1netemu_string}:"
            set data [regsub {ps1netemu:(.*?):} $data "ps1netemu:${ps1netemu_string}:"]
        }
     
        if {$ps1newemu != [get_fw_ps1newemu $filename]} {
            set ps1newemu_string [lindex [split $ps1newemu ":"] 0]
            debug "Setting ps1newemu to ps1newemu:${ps1newemu_string}:"
            set data [regsub {ps1newemu:(.*?):} $data "ps1newemu:${ps1newemu_string}:"]
        }
     
        if {$ps2emu != [get_fw_ps2emu $filename]} {
            set ps2emu_string [lindex [split $ps2emu ":"] 0]
            debug "Setting ps2emu to ps2emu:${ps2emu_string}:"
            set data [regsub {ps2emu:(.*?):} $data "ps2emu:${ps2emu_string}:"]
        }
     
        if {$ps2gxemu != [get_fw_ps2gxemu $filename]} {
            set ps2gxemu_string [lindex [split $ps2gxemu ":"] 0]
            debug "Setting ps2gxemu to ps2gxemu:${ps2gxemu_string}:"
            set data [regsub {ps2gxemu:(.*?):} $data "ps2gxemu:${ps2gxemu_string}:"]
        }
     
        if {$ps2softemu != [get_fw_ps2softemu $filename]} {
            set ps2softemu_string [lindex [split $ps2softemu ":"] 0]
            debug "Setting ps2softemu to ps2softemu:${ps2softemu_string}:"
            set data [regsub {ps2softemu:(.*?):} $data "ps2softemu:${ps2softemu_string}:"]
        }
     
        if {$pspemu != [get_fw_pspemu $filename]} {
            set pspemu_string [lindex [split $pspemu ":"] 0]
            debug "Setting pspemu to pspemu:${pspemu_string}:"
            set data [regsub {pspemu:(.*?):} $data "pspemu:${pspemu_string}:"]
        }
     
        if {$emerald != [get_fw_emerald $filename]} {
            set emerald_string [lindex [split $emerald ":"] 0]
            debug "Setting emeral to emerald:${emerald_string}:"
            set data [regsub {emerald:(.*?):} $data "emerald:${emerald_string}:"]
        }
     
        if {$bdp != [get_fw_bdp $filename]} {
            set bdp_string [lindex [split $bdp ":"] 0]
            debug "Setting bdp to bdp:${bdp_string}:"
            set data [regsub {bdp:(.*?):} $data "bdp:${bdp_string}:"]
        }
     
        if {$auth != [get_fw_auth $filename]} {
            debug "Setting auth to auth:$auth:"
            set data [regsub {auth:[0-9]+:} $data "auth:$auth:"]
        }
     
        set fd [open $filename w]
        puts -nonewline $fd $data
        close $fd
     
        set index_dat [file join [file dirname $filename] index.dat]
        shell "dat" [file nativename $filename] [file nativename $index_dat]
    }

    proc upl_xml {filename} {
        variable options
     
        set release [lindex $::patch_vsh::options(--spoof) 0]
        set build [lindex $::patch_vsh::options(--spoof) 1]
        set bdate [lindex $::patch_vsh::options(--spoof) 2]
        set major [lindex [split $release "."] 0]
        set minor [lindex [split $release "."] 1]
        set nano "0"
     
        debug "Setting UPL.xml.pkg :: release to ${release} :: build to ${build},${bdate}"
     
        set search [::get_header_key_upl_xml $filename Version Version]
        set replace "[format %0.2d ${major}].[format %0.2d ${minor}][format %0.2d ${nano}]:"
        if { $search != "" && $search != $replace } {
            set xml [::set_header_key_upl_xml $filename Version "${replace}" Version]
            if { $xml == "" } {
                die "spoof failed:: search: $search :: replace: $replace"
            }
        }
     
        set search [::get_header_key_upl_xml $filename Build Build]
        set replace "${build},${bdate}"
        if { $search != "" && $search != $replace } {
            set xml [::set_header_key_upl_xml $filename Build "${replace}" Build]
            if { $xml == "" } {
                die "spoof failed:: search: $search :: replace: $replace"
            }
        }
     
        if {$::change_version::options(--pup-build) == ""} {
            ::set_pup_build [incr build]
        }
    }
   
   proc copy_customized_file { dst src } {
        if {[file exists $src] == 0} {
            die "$src does not exist"
        } else {
            if {[file exists $dst] == 0} {
                die "$dst does not exist"
            } else {
                log "Replacing default firmware file [file tail $dst] with [file tail $src]"
                copy_file -force $src $dst
            }
        }
    }
}