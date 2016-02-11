#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
# Copyright (C) RedDot-3ND7355 & ElmerFudd & ThoughtMechanic
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#
#

# Keep these allways out!
proc usage {{msg ""}} {
    global options

    ego

    if {$msg != ""} {
        puts $msg
    }
    puts "Usage: ${::argv0} \[options\] <Original> <Modified> \[task\] \[task options\]"
    puts "eg. ${::argv0} PS3UPDAT.PUP PS3UPDAT.MFW.PUP"
    puts ""
    puts "Available options are : "
    foreach option [get_sorted_options [file normalize [info script]] [array names options]] {
        puts "  $option \"$options($option)\"\n    [get_option_description [file normalize [info script]] $option]"
    }
    puts "\nAvailable tasks are : "
    foreach task [get_sorted_task_files] {
        puts "\nTask:\n--[string map {_ -} [file rootname [file tail $task]]] : [string map {\n \n\t\t\t\t} [get_task_description $task]]"
        set taskname [file rootname [file tail $task]]
        if { [llength [array names ::${taskname}::options]] } {
            puts "  Task options:"
            foreach option [get_sorted_options $task [array names ::${taskname}::options]] {
                puts "  $option \"[set ::${taskname}::options($option)]\"\n    [get_option_description $task $option]"
            }
        }
    }
    puts ""
    exit -1
}

proc get_ps3mfw_build {} {
    set dldl [open [file join ${::CUSTOM_BUILDVER_TXT}] r]
    set versionDL [string trim [read $dldl]]
    close $dldl
    return $versionDL
}

proc get_ps3mfw_build_alter {} {
    set dldl2 [open [file join ${::CUSTOM_BUILDVER_TXT}] r]
    set versionDL2 [string trim [read $dldl2]]
    close $dldl2
	set PS3MFW_BUILD $versionDL2
}

proc debug {msg} {
    if {$::options(--debug)} {
        log $msg 1
    }
}
# End of important processes

# PRINT USAGE

#added array
proc extract_lv0 {path file} {   

	log "Extracting LV0 and ldr's..."

	set fullpath [file join $path $file]
	
	
	# decrypt LV0 to "LV0.elf", and
	# delete the original "lv0"
	decrypt_self $fullpath ${fullpath}.elf
	file delete ${fullpath}
	log "Decrypted lv0!"
	# export LV0 contents.....
	append fullpath ".elf"	
	shell ${::LV0TOOL} -option export -filename ${file}.elf -filepath $path	
	log "Extracted loaders!"
}

# new routine for re-packing LV0 for 3.60+ OFW (using lv0tool.exe)
# default:  crypt/decrypt "lv1ldr", unless we are under
# FW version 3.65
proc import_lv0 {path file} {   

	log "Importing loaders into LV0...."
	set ::SELF "lv0"
	set fullpath [file join $path $file]
	
	# if firmware is >= 3.65, LV1LDR is crypted, otherwise it's
	# not crypted.  Also, check if we "override" this setting
	# by the flag in the "patch_coreos" task
	set FWVer [format "%d%d" $::OFW_MAJOR_VER $::OFW_MINOR_VER]	
	if { ${FWVer} >= "365"} {
		set lv1ldr_crypt "yes"
		log "Turned on lv1-crypt"
		if {$::FLAG_NO_LV1LDR_CRYPT == "NO" } {	
			set lv1ldr_crypt "no"
			log "Turned off lv1-crypt"
		}
	}	

	# execute the "lv0tool" to re-import the loaders
	shell ${::LV0TOOL} -option import -lv1crypt $lv1ldr_crypt -cleanup yes -filename ${file}.elf -filepath $path	
	log "Imported Loaders!"
	
	# resign "lv0.elf" "lv0.self"
	sign_elf ${fullpath}.elf ${fullpath}.self
	log "Signed lv0!"
	
	file delete lv0.elf
	file delete ${fullpath}.elf
	file delete appldr.self
	file delete isoldr.self
	file delete lv1ldr.self
	file delete lv2ldr.self
	file rename -force ${fullpath}.self $fullpath		
}

proc get_log_fd {} {
    global log_fd LOG_FILE

    if {![info exists log_fd]} {
        set log_fd [open $LOG_FILE w]
        fconfigure $log_fd -buffering none
    }
    return $log_fd
}

proc log {msg {force 0}} {
    global options

    if {!$options(--silent) || $force} {
        set fd [get_log_fd]
        puts $fd $msg
        if {$force} {
            puts stderr $msg
        } else {
            puts $msg
        }
    }
}

proc debug {msg} {
    if {$::options(--debug)} {
        log $msg 1
    }
}

proc grep {re args} {
    set result [list]
    set files [eval glob -types f $args]
    foreach file $files {
        set fp [open $file]
        set l 0
        while {[gets $fp line] >= 0} {
            if [regexp -- $re $line] {
                lappend result [list $file $line $l]
            }
            incr l
        } 
		close $fp
    }
    set result
}

proc _get_comment_from_file {filename re} {
    set results [grep $re $filename]
    set comment ""
    foreach match $results {
        foreach {file match line} $match break
        append comment "[string trim [regsub $re $match {}]]\n"
    }
    string trim $comment
}

proc get_task_description {filename} {
    return [_get_comment_from_file $filename {^# Description:}]
}

proc get_option_description {filename option} {
    return [_get_comment_from_file $filename "^# Option ${option}:"]
}

proc get_sorted_options {filename options} {
    return [lsort -command [list sort_options $filename] $options]
}

proc sort_options {file opt1 opt2 } {
    set re1 "^# Option ${opt1}:"
    set re2 "^# Option ${opt2}:"
    set results1 [grep $re1 $file]
    set results2 [grep $re2 $file]

    if {$results1 == {} && $results2 == {}} {
        return [string compare $opt1 $opt2]
    } elseif {$results1 == {}} {
        return 1
    } elseif {$results2 == {}} {
        return -1
    } else {
        foreach {file match line1} [lindex $results1 0] break
        foreach {file match line2} [lindex $results2 0] break
        return [expr {$line1 - $line2}]
    }
}

proc get_option_type {filename option} {
    return [_get_comment_from_file $filename "^# Type ${option}:"]
}

proc task_to_file {task} {
    return [file join ${::TASKS_DIR} ${task}.tcl]
}

proc file_to_task {file} {
    return [file rootname [file tail $file]]
}

proc compare_tasks {task1 task2} {
    return [compare_task_files [task_to_file $task1] [task_to_file $task2]]
}

proc compare_task_files {file1 file2} {
    set prio1 [_get_comment_from_file $file1 {^# Priority:}]
    set prio2 [_get_comment_from_file $file2 {^# Priority:}]

    if {$prio1 == {} && $prio2 == {}} {
        return [string compare $file1 $file2]
    } elseif {$prio1 == {}} {
        return 1
    } elseif {$prio2 == {}} {
        return -1
    } else {
        return [expr {$prio1 - $prio2}]
    }
}

proc sort_tasks {tasks} {
    return [lsort -command compare_tasks $tasks]
}

proc sort_task_files {files} {
    return [lsort -command compare_task_files $files]
}

proc get_sorted_tasks { {tasks {}} } {
    set files [glob -nocomplain [file join ${::TASKS_DIR} *.tcl]]
    set tasks [list]
    foreach file $files {
        lappend tasks [file_to_task $file]
    }
    return [sort_tasks $tasks]
}

proc get_sorted_task_files { } {
    set files [glob -nocomplain [file join ${::TASKS_DIR} *.tcl]]
    return [sort_task_files $files]
}

proc get_selected_tasks { } {
    return ${::selected_tasks}
}

# failure function
proc die {message} {
    global LOG_FILE

    log "FATAL ERROR: $message" 1
    puts stderr "See ${LOG_FILE} for more info"
    puts stderr "Last lines of log : "
    puts stderr "*****************"
    catch {puts stderr "[tail $LOG_FILE]"}
    puts stderr "*****************"
    exit -2
}

proc catch_die {command message} {
    set catch {
        if {[catch {@command@} res] } {
            die "@message@ : $res"
        }
        return $res
    }
    debug "Executing command $command"
    set catch [string map [list "@command@" "$command" "@message@" "$message"] $catch]
    uplevel 1 $catch
}

proc shell {args} {
    set fd [get_log_fd]
    debug "Executing shell $args"
    eval exec $args >&@ $fd
}

proc hexify { str } {
    set out ""
    for {set i 0} { $i < [string length $str] } { incr i} {
        set c [string range $str $i $i]
        binary scan $c H* h
        append out "\[$h\]"
    }
    return $out
}

proc tail {filename {n 10}} {
    set fd [open $filename r]
    set lines [list]
    while {![eof $fd]} {
        lappend lines [gets $fd]
        if {[llength $lines] > $n} {
            set lines [lrange $lines end-$n end]
        }
    }
    close $fd
    return [join $lines "\n"]
}

proc create_mfw_dir {args} {   
    catch_die {file mkdir $args} "Could not create dir $args"
}

proc copy_file {args} {
    catch_die {file copy {*}$args} "Unable to copy $args"
}

proc copy_dir {src dst } {   
	debug "Copying source dir:$src to target directory:$dst"
    copy_file -force $src $dst
}

proc sha1_check {file} {
    shell ${::fciv} -add [file nativename $file] -wp -sha1 -xml db.xml
}

proc sha1_verify {file} {
    shell ${::fciv} [file nativename $file] -v -sha1 -xml db.xml
}

proc delete_file {args} {
    catch_die {file delete {*}$args} "Unable to delete $args"
}

proc rename_file {src dst} {
    catch_die {file rename {*}$src $dst} "Unable to rename and/or move $src $dst"
}

proc delete_promo { } {
    delete_file -force ${::CUSTOM_PROMO_FLAGS_TXT}
}

proc copy_spkg { } {
    debug "searching for spkg"
    set spkg [glob -directory ${::CUSTOM_UPDATE_DIR} *.1]
	debug "spkg found in $spkg"
	debug "copy new spkg into spkg dir"
    copy_file -force $spkg ${::CUSTOM_SPKG_DIR}
	if {[file exists [file join $spkg]]} {
	debug "removing spkg from working dir"
	delete_file -force $spkg
	}
} 

proc shellex {args} {
	set outbuffer ""    
    debug "Executing shellex $args"
    set outbuffer [eval exec $args]	
	return $outbuffer
}

proc copy_mfw_imgs { } {
    create_mfw_dir ${::CUSTOM_MFW_DIR}
    copy_file -force ${::CUSTOM_IMG_DIR} ${::CUSTOM_MFW_DIR}
}

# routine to copy standalone '*Install Package Fiels' app into MFW
proc copy_ps3_game {arg} {
    variable option
    set arg0 $::patch_xmb::options(--add-install-pkg)
    set arg1 $::patch_xmb::options(--add-pkg-mgr)
    set arg2 $::patch_xmb::options(--add-hb-seg)
    set arg3 $::patch_xmb::options(--add-emu-seg)
    set arg4 [file exists $::customize_firmware::options(--customize-embedded-app) == 0]
    
    if { $arg0 || $arg1 || $arg2 || $arg3  && !$arg4 } {
        rename_file -force $arg ${::CUSTOM_EMBEDDED_APP}
    } elseif { $arg0 || $arg1 || $arg2 || $arg3  && $arg4 } {
        copy_file -force $arg ${::CUSTOM_MFW_DIR}
    } elseif { !$arg0 && !$arg1 && !$arg2 && !$arg3 && !$arg4 } {
        create_mfw_dir
        rename_file -force $arg ${::CUSTOM_EMBEDDED_APP}
    } elseif { !$arg0 && !$arg1 && !$arg2 && !$arg3 && $arg4 } {
        create_mfw_dir
        copy_file -force $arg ${::CUSTOM_MFW_DIR}
    }
	unset arg0, arg1, arg2, arg3, arg4
}

proc copy_ps3_game_standart { } {
    set ttf "SCE-PS3-RD-R-LATIN.TTF"
	debug "using font file .ttf as argument to search for"
	debug "cause we need a tar with a bit space in it"
    modify_devflash_file [file join dev_flash data font $ttf] callback_ps3_game_standart
}

proc callback_ps3_game_standart { file } {
    log "Creating custom directory in dev_flash"
	create_mfw_dir ${::CUSTOM_MFW_DIR}
	if {${::CFW} == "AC1D"} {
	    log "Installing standalone 'Custom FirmWare' app"
	    copy_file -force ${::CUSTOM_PS3_GAME2} ${::CUSTOM_MFW_DIR}
		log "Copy custom imgs into dev_flash"
	    copy_file -force ${::CUSTOM_IMG_DIR} ${::CUSTOM_MFW_DIR}
	} else {
	    log "Installing standalone '*Install Package Files' app"
	    copy_file -force ${::CUSTOM_PS3_GAME} ${::CUSTOM_MFW_DIR}
	}
}

proc pup_extract {pup dest} {
	#    shell ${::PUP} x $pup $dest
    shell ${::PUPUNPACK} [file nativename $pup] [file nativename $dest]
		log "Extracted PUP!"
}

proc pup_create {dir pup build} {

#    shell ${::PUP} c $dir $pup $build
    shell ${::PUPPACK} $pup [file nativename $dir] [file nativename $build]
	log "Created PUP!"
    }

proc pup_get_build {pup} {
    set fd [open $pup r]
    fconfigure $fd -translation binary
    seek $fd 16
    set build [read $fd 8]
    close $fd

    if {[binary scan $build W build_ver] != 1} {
        error "Cannot read 64 bit big endian from [hexify $build]"
    }
	
    return $build_ver
}

proc extract_tar {tar dest} {

    file mkdir $dest
    debug "Extracting tar file [file tail $tar] into [file tail $dest]"
    catch_die {::tar::untar $tar -dir $dest} "Could not untar file $tar"
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

proc find_devflash_archive {dir find} {

    foreach file [glob -nocomplain [file join $dir * content]] {
        if {[catch {::tar::stat $file $find}] == 0} {
            return $file
        }
    }
    return ""
}

proc spkg {pkg} {
    shell ${::SPKG} [file nativename $pkg]
}

proc new_pkg {pkg dest} {
    log "Making spkg retail"
    shell ${::NEWPKG} retail [file nativename $pkg] [file nativename $dest]
	log "Builded"
}

proc unpkg {pkg dest} {
 
    shell ${::UNPKG} [file nativename $pkg] [file nativename $dest]
}

proc pkg_spkg_archive {dir pkg} {
    debug "pkg-ing / spkg-ing file [file tail $pkg]"
    catch_die {pkg_spkg $dir $pkg} "Could not pkg / spkg file [file tail $pkg]"
}


proc pkg {pkg dest} {

    shell ${::PKG} retail [file nativename $pkg] [file nativename $dest]
}

proc unpkg_archive {pkg dest} {
    debug "unpkg-ing file [file tail $pkg]"
    catch_die {unpkg $pkg $dest} "Could not unpkg file [file tail $pkg]"
	log "Extracted"
}

proc pkg_archive {dir pkg} {
    debug "pkg-ing file [file tail $pkg]"
    catch_die {pkg $dir $pkg} "Could not pkg file [file tail $pkg]"
	log "Imported"
}

proc new_pkg_archive {dir pkg} {
    debug "pkg-ing / spkg-ing file [file tail $pkg]"
    catch_die {new_pkg $dir $pkg} "Could not pkg / spkg file [file tail $pkg]"
	log "Created"
}

proc spkg_archive {pkg} {
    debug "spkg-ing file [file tail $pkg]"
    catch_die {spkg $dir $pkg} "Could not spkg file [file tail $pkg]"
	log "Imported SPKG"
}

proc unpkg_devflash_all {dir} {
    file mkdir $dir
    foreach file [lsort [glob -nocomplain [file join ${::CUSTOM_UPDATE_DIR} dev_flash_*]]] {
        unpkg_archive $file [file join $dir [file tail $file]]
    }
	log "Unpacked Devflash!"
}

proc cosunpkg { pkg dest } {

    shell ${::COSUNPKG} [file nativename $pkg] [file nativename $dest]
}

proc cospkg { dir pkg } {

    shell ${::COSPKG} [file nativename $pkg] [file nativename $dir]
	}

proc cosunpkg_package { pkg dest } {
    debug "cosunpkg-ing file [file tail $pkg]"
    catch_die { cosunpkg $pkg $dest } "Could not cosunpkg file [file tail $pkg]"
	log "Unpacked"
}

proc cospkg_package { dir pkg } {
    debug "cospkg-ing file [file tail $dir]"
    catch_die { cospkg $dir $pkg } "Could not cospkg file [file tail $pkg]"
	log "Packed"
}

proc modify_coreos_file { file callback args } {
    log "Modifying CORE_OS file [file tail $file]"   
    set pkg [file join ${::CUSTOM_UPDATE_DIR} CORE_OS_PACKAGE.pkg]
    set unpkgdir [file join ${::CUSTOM_UPDATE_DIR} CORE_OS_PACKAGE.unpkg]
    set cosunpkgdir [file join ${::CUSTOM_UPDATE_DIR} CORE_OS_PACKAGE]
    
    ::unpkg_archive $pkg $unpkgdir
    ::cosunpkg_package [file join $unpkgdir content] $cosunpkgdir

    if {[file writable [file join $cosunpkgdir $file]]} {
	    set ::SELF $file
        eval $callback [file join $cosunpkgdir $file] $args
    } elseif { ![file exists [file join $cosunpkgdir $file]] } {
        die "Could not find $file in CORE_OS_PACKAGE"
    } else {
        die "File $file is not writable in CORE_OS_PACKAGE"
    }

    ::cospkg_package $cosunpkgdir [file join $unpkgdir content]
    
    if {[::get_pup_version] >= ${::NEWCFW}} {
       ::new_pkg_archive $unpkgdir $pkg
        ::copy_spkg
    } else {
        ::pkg_archive $unpkgdir $pkg
    }
}

proc modify_coreos_files { files callback args } {
    log "Modifying CORE_OS files [file tail $files]" 
    set pkg [file join ${::CUSTOM_UPDATE_DIR} CORE_OS_PACKAGE.pkg]
    set unpkgdir [file join ${::CUSTOM_UPDATE_DIR} CORE_OS_PACKAGE.unpkg]
    set cosunpkgdir [file join ${::CUSTOM_UPDATE_DIR} CORE_OS_PACKAGE]
    
    ::unpkg_archive $pkg $unpkgdir
    ::cosunpkg_package [file join $unpkgdir content] $cosunpkgdir
    
	foreach file $files {
        if {[file writable [file join $cosunpkgdir $file]]} {
		    log "Using file $file now"
			set ::SELF $file
            eval $callback [file join $cosunpkgdir $file] $args
        } elseif { ![file exists [file join $cosunpkgdir $file]] } {
            die "Could not find $file in CORE_OS_PACKAGE"
        } else {
            die "File $file is not writable in CORE_OS_PACKAGE"
        }
	}

    ::cospkg_package $cosunpkgdir [file join $unpkgdir content]
    
    if {[::get_pup_version] >= ${::NEWCFW}} {
        ::new_pkg_archive $unpkgdir $pkg	
        ::copy_spkg
    } else {
        ::pkg_archive $unpkgdir $pkg
    }
}

# proc for "unpackaging" the "CORE_OS" files
proc unpack_coreos_files { args } {

	#::CUSTOM_PKG_DIR == $pkg
	#::CUSTOM_UNPKG_DIR == $unpkg
	#::CUSTOM_COSUNPKG_DIR == $cosunpkg
    log "Unpacking CORE_OS files..."   
   
    ::unpkg_archive $::CUSTOM_PKG_DIR $::CUSTOM_UNPKG_DIR
    ::cosunpkg_package [file join $::CUSTOM_UNPKG_DIR content] $::CUSTOM_COSUNPKG_DIR	
	

	# set the global flag that "CORE_OS" is unpacked
	set ::FLAG_COREOS_UNPACKED 1
	log "CORE_OS Unpacked!" 	
}

# proc for "packaging" up the "CORE_OS" files
proc repack_coreos_files { args } {

	#::CUSTOM_PKG_DIR == $pkg
	#::CUSTOM_UNPKG_DIR == $unpkg
	#::CUSTOM_COSUNPKG_DIR == $cosunpkg
    log "Repacking CORE_OS files..." 


   
	# re-package up the files
    ::cospkg_package $::CUSTOM_COSUNPKG_DIR [file join $::CUSTOM_UNPKG_DIR content]   
	set pkg $::CUSTOM_PKG_DIR
    set unpkgdir $::CUSTOM_UNPKG_DIR
    if {[::get_pup_version] >= ${::NEWCFW}} {   
		::new_pkg_archive $unpkgdir $pkg
        ::copy_spkg
    } else {
        ::pkg_archive $unpkgdir $pkg
    }

	# set the global flag that "CORE_OS" is packed
	set ::FLAG_COREOS_UNPACKED 0
	log "CORE_OS Repacked!" 	
}

proc get_pup_build {} {
    debug "Getting PUP build from [file tail ${::IN_FILE}]"
    catch_die {pup_get_build ${::IN_FILE}} "Could not get the PUP build information"
    return [pup_get_build ${::IN_FILE}]
	log "PUP Build grabbed!"
}

proc set_pup_build {build} {
    debug "PUP build: $build"
    set ::PUP_BUILD $build
}

proc get_pup_version {} {
    debug "Getting PUP version from [file tail ${::CUSTOM_VERSION_TXT}]"
    set fd [open [file join ${::CUSTOM_VERSION_TXT}] r]
    set version [string trim [read $fd]]
    close $fd
    return $version
	log "PUP Version Grabbed!"
}

proc set_pup_version {version} {
    debug "Setting PUP version in [file tail ${::CUSTOM_VERSION_TXT}]"
    set fd [open [file join ${::CUSTOM_VERSION_TXT}] w]
    puts $fd "${version}"
    close $fd
}

proc modify_pup_version_file {prefix suffix {clear 0}} {
    if {$clear} {
      set version ""
    } else {
      set version [::get_pup_version]
    }
    debug "PUP version: ${prefix}${version}${suffix}"
    set_pup_version "${prefix}${version}${suffix}"
}

proc sed_in_place {file search replace} {
    set fd [open $file r]
    set data [read $fd]
    close $fd

    set data [string map [list $search $replace] $data]

    set fd [open $file w]
    puts -nonewline $fd $data
    close $fd
}

proc unself {in out} {
    set FIN [file nativename $in]
	set FOUT [file nativename $out]

    shell ${::SCETOOL} -d $FIN $FOUT
	log "Decrypted!"
}

proc decrypt_self {in out} {
    debug "Decrypting self file [file tail $in]"
    catch_die {unself $in $out} "Could not decrypt file [file tail $in]"
	log "Self Decrypted!"
}

proc import_self_info {in array} {	
	
	log "Importing self-hdr info from file: [file tail $in]"		
	upvar $array MySelfHdrs
	set MyArraySize 0	
	
	# clear the incoming array
	foreach key [array names MySelfHdrs] {
		set MySelfHdrs($key) ""
	}
	
	# execute the "SCETOOL -w" cmd to dump the needed SCE-HDR info
    catch_die {set buffer [shellex ${::SCETOOL2} -w $in]} "failed to dump SCE header for file: [file tail $in]"		
		
	# parse out the return buffer, and 
	# save off the fields into the global array
	set data [split $buffer "\n"]
	foreach line $data {
		if [regexp -- {(^Key-Revision:)(.*)} $line match] {		
			set MySelfHdrs(--KEYREV) [lindex [split $match ":"] 1]
			incr MyArraySize 1	
		} elseif { [regexp -- {(^Auth-ID:)(.*)} $line match] } {		
			set MySelfHdrs(--AUTHID) [lindex [split $match ":"] 1]
			incr MyArraySize 1
		} elseif { [regexp -- {(^Vendor-ID:)(.*)} $line match] } {		
			set MySelfHdrs(--VENDORID) [lindex [split $match ":"] 1]	
			incr MyArraySize 1
		} elseif { [regexp -- {(^SELF-Type:)(.*)} $line match] } {		
			set MySelfHdrs(--SELFTYPE) [lindex [split $match ":"] 1]
			incr MyArraySize 1
		} elseif { [regexp -- {(^AppVersion:)(.*)} $line match] } {		
			set MySelfHdrs(--APPVERSION) [lindex [split $match ":"] 1]
			incr MyArraySize 1
		} elseif { [regexp -- {(^FWVersion:)(.*)} $line match] } {		
			set MySelfHdrs(--FWVERSION) [lindex [split $match ":"] 1]
			incr MyArraySize 1
		} elseif { [regexp -- {(^CtrlFlags:)(.*)} $line match] } {		
			set MySelfHdrs(--CTRLFLAGS) [lindex [split $match ":"] 1]	
			incr MyArraySize 1
		} elseif { [regexp -- {(^CapabFlags:)(.*)} $line match] } {		
			set MySelfHdrs(--CAPABFLAGS) [lindex [split $match ":"] 1]
			incr MyArraySize 1
		} elseif { [regexp -- {(^Compressed:)(.*)} $line match] } {		
			set MySelfHdrs(--COMPRESS) [lindex [split $match ":"] 1]	
			incr MyArraySize 1
		}
	}
	# if we successfully captured all vars, 
	# and it matches our array size, success
	if { $MyArraySize == [array size MySelfHdrs] } { 
		log "Self-sce hdr imported successfully!"
	} else {
		log "!!ERROR!!:  FAILED TO IMPORT SELF-SCE HEADERS FROM FILE: [file tail $in]"
		die "!!ERROR!!:  FAILED TO IMPORT SELF-SCE HEADERS FROM FILE: [file tail $in]"
	}
	# display the imported headers if VERBOSE enabled
	if { $::options(--task-verbose) } {
		foreach key [lsort [array names MySelfHdrs]] {
			log "-->$key:$MySelfHdrs($key)"
		}	
	}		
}

proc sign_elf {in out} {

	debug "Rebuilding self file [file tail $out]"
    catch_die {makeself $in $out} "Could not rebuild file [file tail $out]"
	log "Self Signed"
}

proc modify_self_file {file callback args} {

    log "Modifying self/sprx file [file tail $file]"
    decrypt_self $file ${file}.elf
    eval $callback ${file}.elf $args
    sign_elf ${file}.elf ${file}.self
	#file copy -force ${file}.self ${::BUILD_DIR}    # used for debugging to copy the patched elf and new re-signed self to MFW build dir without the need to unpup the whole fw or even a single file
    file rename -force ${file}.self $file
	#file copy -force ${file}.elf ${::BUILD_DIR}     # same as above
    file delete ${file}.elf
	log "Self successful rebuilded"
}

proc patch_self {file search replace_offset replace {ignore_bytes {}}} {
    modify_self_file $file patch_elf $search $replace_offset $replace $ignore_bytes
}

proc patch_elf {file search replace_offset replace {ignore_bytes {}}} {
    patch_file $file $search $replace_offset $replace $ignore_bytes
}

proc patch_file {file search replace_offset replace {ignore_bytes {}}} {
    foreach bytes $ignore_bytes {
        if {[llength $bytes] == 1} {
            set search [string replace $search $bytes $bytes "?"]
        } elseif {[llength $bytes] == 2} {
            set idx1 [lindex $bytes 0]
            set idx2 [lindex $bytes 1]
            set len [expr {$idx2 - $idx1 + 1}]
            if {$len < 0} {
                set len 0
            }
            set search [string replace $search $idx1 $idx2 [string repeat "?" $len]]
        }
    }
    set fd [open $file r+]
    fconfigure $fd -translation binary
    set offset -1
    set buffer ""
    while {![eof $fd]} {
        append buffer [read $fd 1]
        if {[string length $buffer] > [string length $search]} {
            set buffer [string range $buffer 1 end]
        }
        set tmp $buffer
        foreach bytes $ignore_bytes {
            if {[llength $bytes] == 1} {
                set tmp [string replace $tmp $bytes $bytes "?"]
            } elseif {[llength $bytes] == 2} {
                set idx1 [lindex $bytes 0]
                set idx2 [lindex $bytes 1]
                set len [expr {$idx2 - $idx1 + 1}]
                if {$len < 0} {
                    set len 0
                }
                set tmp [string replace $tmp $idx1 $idx2 [string repeat "?" $len]]
            }
        }
        if {$tmp == $search} {
            if {$offset != -1} {
                error "Pattern found multiple times"
            }
            set offset [tell $fd]
            incr offset -[string length $search]
            incr offset $replace_offset
        }
    }
    if {$offset == -1} {
        error "Could not find pattern to patch"
    }
    debug "offset: $offset"
    seek $fd $offset
    puts -nonewline $fd $replace
    close $fd
}

proc patch_file_multi {file search replace_offset replace {ignore_bytes {}}} {
    foreach bytes $ignore_bytes {
        if {[llength $bytes] == 0} {
            set search [string replace $search $bytes $bytes "?"]
        } else {
            set search [string replace $search [lindex $bytes 0] [lindex $bytes 1] "?"]
        }
    }
    set fd [open $file r+]
    fconfigure $fd -translation binary
    set offset -1
    set counter 0
    set buffer ""
    while {![eof $fd]} {
        append buffer [read $fd 1]
        if {[string length $buffer] > [string length $search]} {
            set buffer [string range $buffer 1 end]
        }
        set tmp $buffer
        foreach bytes $ignore_bytes {
            if {[llength $bytes] == 0} {
                set tmp [string replace $tmp $bytes $bytes "?"]
            } else {
                set tmp [string replace $tmp [lindex $bytes 0] [lindex $bytes 1] "?"]
            }
        }
        if {$tmp == $search} {
            incr counter 1
            set offset [tell $fd]
            incr offset -[string length $search]
            incr offset $replace_offset
            debug "offset: $offset"
            seek $fd $offset
            puts -nonewline $fd $replace
            seek $fd $offset
            set offset -1
        }
    }
    if {$counter == 0} {
        debug "Could not find pattern to patch"
    } else {
        debug "Replaced $counter occurences of search pattern"
    }
    close $fd
}

proc modify_devflash_file {file callback args} {
    log "Modifying dev_flash file [file tail $file]"
	
    set tar_file [find_devflash_archive ${::CUSTOM_DEVFLASH_DIR} $file]

    if {$tar_file == ""} {
        die "Could not find [file tail $file]"
    }

    set pkg_file [file tail [file dirname $tar_file]]
    debug "Found [file tail $file] in $pkg_file"

    file delete -force [file join ${::CUSTOM_DEVFLASH_DIR} dev_flash]
    extract_tar $tar_file ${::CUSTOM_DEVFLASH_DIR}

    if {[file writable [file join ${::CUSTOM_DEVFLASH_DIR} $file]] } {
        eval $callback [file join ${::CUSTOM_DEVFLASH_DIR} $file] $args
    } elseif { ![file exists [file join ${::CUSTOM_DEVFLASH_DIR} $file]] } {
        die "Could not find $file in ${::CUSTOM_DEVFLASH_DIR}"
    } else {
        die "File $file is not writable in ${::CUSTOM_DEVFLASH_DIR}"
    }

    file delete -force $tar_file

    create_tar $tar_file ${::CUSTOM_DEVFLASH_DIR} dev_flash

    set pkg [file join ${::CUSTOM_UPDATE_DIR} $pkg_file]
    set unpkgdir [file join ${::CUSTOM_DEVFLASH_DIR} $pkg_file]
    if {[::get_pup_version] >= ${::NEWCFW}} {
        ::new_pkg_archive $unpkgdir $pkg
        ::copy_spkg
    } else {
        ::pkg_archive $unpkgdir $pkg
    }
}

proc modify_devflash_files {path files callback args} {

    foreach file $files {
        set file [file join $path $file]
        log "Modifying dev_flash file [file tail $file]"
        
        set tar_file [find_devflash_archive ${::CUSTOM_DEVFLASH_DIR} $file]
        
        if {$tar_file == ""} {
            debug "Skipping [file tail $file] not found"
            continue
        }
        
        set pkg_file [file tail [file dirname $tar_file]]
        debug "Found [file tail $file] in $pkg_file"
       
        file delete -force [file join ${::CUSTOM_DEVFLASH_DIR} dev_flash]
        extract_tar $tar_file ${::CUSTOM_DEVFLASH_DIR}
	 
        if {[file writable [file join ${::CUSTOM_DEVFLASH_DIR} $file]] } {
		    set ::SELF $file
			log "Using file $file now"
            eval $callback [file join ${::CUSTOM_DEVFLASH_DIR} $file] $args
        } elseif { ![file exists [file join ${::CUSTOM_DEVFLASH_DIR} $file]] } {
            debug "Could not find $file in ${::CUSTOM_DEVFLASH_DIR}"
        } else {
            die "File $file is not writable in ${::CUSTOM_DEVFLASH_DIR}"
        }
        
        file delete -force $tar_file
        
        create_tar $tar_file ${::CUSTOM_DEVFLASH_DIR} dev_flash
        
        set pkg [file join ${::CUSTOM_UPDATE_DIR} $pkg_file]
        set unpkgdir [file join ${::CUSTOM_DEVFLASH_DIR} $pkg_file]
        if {[::get_pup_version] >= ${::NEWCFW}} {
            ::new_pkg_archive $unpkgdir $pkg
            ::copy_spkg
        } else {
            ::pkg_archive $unpkgdir $pkg
        }
    }
	
}

proc modify_upl_file {callback args} {
    log "Modifying UPL.xml file"
    set file "content"
    
    set pkg [file join ${::CUSTOM_UPDATE_DIR} UPL.xml.pkg]
    set unpkgdir [file join ${::CUSTOM_UPDATE_DIR} UPL.xml.unpkg]

    ::unpkg_archive $pkg $unpkgdir

    if {[file writable [file join $unpkgdir $file]] } {
        eval $callback [file join $unpkgdir $file] $args
    } elseif { ![file exists [file join $unpkgdir $file]] } {
        die "Could not find $file in $unpkgdir"
    } else {
        die "File $file is not writable in $unpkgdir"
    }

    if {[::get_pup_version] >= ${::NEWCFW}} {
        ::new_pkg_archive $unpkgdir $pkg
        ::copy_spkg
    } else {
        ::pkg_archive $unpkgdir $pkg
    }
}

proc remove_node_from_xmb_xml { xml key message} {
    log "Removing \"$message\" from XML"

    while { [::xml::GetNodeByAttribute $xml "XMBML:View:Attributes:Table" key $key] != "" } {
        set xml [::xml::RemoveNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Attributes:Table" key $key]]
    }
    while { [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key $key] != "" } {
        set xml [::xml::RemoveNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key $key]]
    }

    return $xml
}

proc remove_pkg_from_upl_xml { xml key message } {
    log "Removing \"$message\" package from UPL.xml" 1

    set i 0
    while { 1 } {
        set index [::xml::GetNodeIndices $xml "UpdatePackageList:Package" $i]
        if {$index == "" } break
        set node [::xml::GetNodeByIndex $xml $index]
        set data [::xml::GetData $node "Package:Type"]
        #debug "index: $index :: node: $node :: data: $data"
        if {[string equal $data $key] == 1 } {
            #debug "data: $data :: key: $key"
            set xml [::xml::RemoveNode $xml $index]
            break
        }
        incr i 1
    }
    return $xml
}

proc remove_pkgs_from_upl_xml { xml key message } {
    log "Removing \"$message\" packages from UPL.xml" 1

    set i 0
    while { 1 } {
        set index [::xml::GetNodeIndices $xml "UpdatePackageList:Package" $i]
        if {$index == "" } break
        set node [::xml::GetNodeByIndex $xml $index]
        set data [::xml::GetData $node "Package:Type"]
        #debug "index: $index :: node: $node :: data: $data"
        if {[string equal $data $key] == 1 } {
            #debug "data: $data :: key: $key"
            set xml [::xml::RemoveNode $xml $index]
            incr i -1
        }
        incr i 1
    }
    return $xml
}

# .rco files handling routines
proc rco_dump {rco rco_xml rco_dir} {
    shell ${::RCOMAGE} dump [file nativename $rco] [file nativename $rco_xml] --resdir [file nativename $rco_dir]
}

proc rco_compile {rco_xml rco_new} {
    set RCOMAGE_OPTS "--pack-hdr zlib --zlib-method default --zlib-level 9"
    shell ${::RCOMAGE} compile [file nativename $rco_xml] [file nativename $rco_new] {*}$RCOMAGE_OPTS
}

proc unpack_rco_file {rco rco_xml rco_dir} {
    log "unpacking rco file [file tail $rco]"
    catch_die {rco_dump $rco $rco_xml $rco_dir} "Could not unpack rco file [file tail $rco]"
}

proc pack_rco_file {rco_xml rco_new} {
    log "packing rco file [file tail $rco_new]"
    catch_die {rco_compile $rco_xml $rco_new} "Could not pack rco file [file tail $rco_new]"
}

proc callback_modify_rco {rco_file callback callback_args} {
    set RCO_XML ${rco_file}.xml
    set RCO_DIR ${rco_file}_dir
    set RCO_NEW ${rco_file}.new

    catch_die {file mkdir $RCO_DIR} "Could not create dir $RCO_DIR"
    unpack_rco_file $rco_file $RCO_XML $RCO_DIR

    eval $callback $RCO_DIR $callback_args

    pack_rco_file $RCO_XML $RCO_NEW
    catch_die {
        file rename -force $RCO_NEW $rco_file
        file delete -force $RCO_XML
        file delete -force $RCO_DIR
    } "Could not cleanup files after modifying [file tail $rco_file]"
}

proc modify_rco_file {rco_file callback args} {
    modify_devflash_file $rco_file callback_modify_rco $callback $args
}

# RCO callback for multiple files
proc modify_rco_files {path rco_files callback args} {
    modify_devflash_files $path $rco_files callback_modify_rco $callback $args
}

proc get_header_key_upl_xml { file key message } {
    debug "Getting \"$message\" information from UPL.xml"

    set xml [::xml::LoadFile $file]
    set data [::xml::GetData $xml "UpdatePackageList:Header:$key"]
    if {$data != ""} {
        debug "$key: $data"
        return $data
    }
    return ""
}

proc set_header_key_upl_xml { file key replace message } {
    log "Setting \"$message\" information in UPL.xml" 1

    set xml [::xml::LoadFile $file]

    set search [::xml::GetData $xml "UpdatePackageList:Header:$key"]
    if {$search != "" } {
        debug "$key: $search -> $replace"
        set fd [open $file r]
        set xml [read $fd]
        close $fd
     
        set xml [string map [list $search $replace] $xml]
     
        set fd [open $file w]
        puts -nonewline $fd $xml
        close $fd
        return $search
    }
    return ""
}

proc unspp {in out} {

    shell ${::UNSPP} [file nativename $in] [file nativename $out]

}

proc spp {in out} {

    set FWVer [format "%d%d" $::OFW_MAJOR_VER $::OFW_MINOR_VER]
    shell ${::SPP} $FWVer [file nativename $in] [file nativename $out]

}

proc decrypt_spp {in out} {
    debug "Decrypting spp file [file tail $in]"
    catch_die {unspp $in $out} "Could not decrypt file [file tail $in]"
}

proc patch_pp {file search replace_offset replace {ignore_bytes {}}} {
    patch_file $file $search $replace_offset $replace $ignore_bytes
}

proc sign_pp {in out} {
    debug "Rebuilding spp file [file tail $out]"
    catch_die {spp $in $out} "Could not rebuild file [file tail $out]"
}

proc modify_spp_file {file callback args} {
    log "Modifying spp file [file tail $file]"
    decrypt_spp $file ${file}.pp
    eval $callback ${file}.pp $args
    sign_pp ${file}.pp $file
    file delete ${file}.pp
}
#####################################

#####################################

# new routine for extracting LV0 for 3.60+ OFW (using lv0tool.exe)
# default:  (lv1ldr is NOT crypted at FW below 3.65)
#
# "lv0tool.exe" will automatically decrypt the "lv1ldr"
# if it's crypted in LV0
proc extract_lv02 {path file array} {

	log "Extracting LV0 and ldr's..."
	upvar $array MyLV0Hdrs
	set fullpath [file join $path $file]			
	
	# read in the SELF hdr info for LV0
	import_self_info $fullpath MyLV0Hdrs
	
	# decrypt LV0 to "LV0.elf", and
	# delete the original "lv0"	
	decrypt_self $fullpath ${fullpath}.elf
	#file delete ${fullpath}
	
	# export LV0 contents.....
	append fullpath ".elf"	
	shell ${::LV0TOOL} -option export -filename ${file}.elf -filepath $path	
	log "Extracted loaders!"
}

# new routine for re-packing LV0 for 3.60+ OFW (using lv0tool.exe)
# default:  crypt/decrypt "lv1ldr", unless we are under
# FW version 3.65
proc import_lv02 {path file array} {   

	log "Importing 3.60+ loaders into LV0...."
	upvar $array MySelfHdrs
	set fullpath [file join $path $file]
	set lv1ldr_crypt no
	
	# if firmware is >= 3.65, LV1LDR is crypted, otherwise it's
	# not crypted.  Also, check if we "override" this setting
	# by the flag in the "patch_coreos" task	
	if {${::NEWMFW_VER} >= "3.65"} {
		set lv1ldr_crypt yes
		debug "Turned on the ldr_crypt"
		if {$::FLAG_NO_LV1LDR_CRYPT == "NO"} {	
			set lv1ldr_crypt no
			debug "Turned on the ldr_crypt"
		}
	}	

	# execute the "lv0tool" to re-import the loaders
	shell ${::LV0TOOL} -option import -lv1crypt $lv1ldr_crypt -cleanup yes -filename ${file}.elf -filepath ${path}	
	
	# resign "lv0.elf" "lv0.self"
	import_self_info ${fullpath} MySelfHdrs
	sign_elf2 ${fullpath}.elf ${fullpath}.self MySelfHdrs
	
	file delete lv0.elf
	file delete ${fullpath}.elf
	file delete appldr.self
	file delete isoldr.self
	file delete lv1ldr.self
	file delete lv2ldr.self
	file rename -force ${fullpath}.self $fullpath		
}

proc get_log_fd2 {} {
    global log_fd LOG_FILE

    if {![info exists log_fd]} {
        set log_fd [open $LOG_FILE w]
        fconfigure $log_fd -buffering none
    }
    return $log_fd
}

proc log {msg {force 0}} {
    global options

    if {!$options(--silent) || $force} {
        set fd [get_log_fd2]
        puts $fd $msg
        if {$force} {
            puts stderr $msg
        } else {
            puts $msg
        }
    }
}

proc grep {re args} {
    set result [list]
    set files [eval glob -types f $args]
    foreach file $files {
        set fp [open $file]
        set l 0
        while {[gets $fp line] >= 0} {
            if [regexp -- $re $line] {
                lappend result [list $file $line $l]
            }
            incr l
        } 
		close $fp
    }
    set result
}

proc _get_comment_from_file {filename re} {
    set results [grep $re $filename]
    set comment ""
    foreach match $results {
        foreach {file match line} $match break
        append comment "[string trim [regsub $re $match {}]]\n"
    }
    string trim $comment
}

proc get_task_description {filename} {
    return [_get_comment_from_file $filename {^# Description:}]
}

proc get_option_description {filename option} {
    return [_get_comment_from_file $filename "^# Option ${option}:"]
}

proc get_sorted_options {filename options} {
    return [lsort -command [list sort_options $filename] $options]
}

proc sort_options {file opt1 opt2 } {
    set re1 "^# Option ${opt1}:"
    set re2 "^# Option ${opt2}:"
    set results1 [grep $re1 $file]
    set results2 [grep $re2 $file]

    if {$results1 == {} && $results2 == {}} {
        return [string compare $opt1 $opt2]
    } elseif {$results1 == {}} {
        return 1
    } elseif {$results2 == {}} {
        return -1
    } else {
        foreach {file match line1} [lindex $results1 0] break
        foreach {file match line2} [lindex $results2 0] break
        return [expr {$line1 - $line2}]
    }
}

proc get_option_type {filename option} {
    return [_get_comment_from_file $filename "^# Type ${option}:"]
}

proc task_to_file {task} {
    return [file join ${::TASKS_DIR} ${task}.tcl]
}

proc file_to_task {file} {
    return [file rootname [file tail $file]]
}

proc compare_tasks {task1 task2} {
    return [compare_task_files [task_to_file $task1] [task_to_file $task2]]
}

proc compare_task_files {file1 file2} {
    set prio1 [_get_comment_from_file $file1 {^# Priority:}]
    set prio2 [_get_comment_from_file $file2 {^# Priority:}]

    if {$prio1 == {} && $prio2 == {}} {
        return [string compare $file1 $file2]
    } elseif {$prio1 == {}} {
        return 1
    } elseif {$prio2 == {}} {
        return -1
    } else {
        return [expr {$prio1 - $prio2}]
    }
}

proc sort_tasks {tasks} {
    return [lsort -command compare_tasks $tasks]
}

proc sort_task_files {files} {
    return [lsort -command compare_task_files $files]
}

proc get_sorted_tasks { {tasks {}} } {
    set files [glob -nocomplain [file join ${::TASKS_DIR} *.tcl]]
    set tasks [list]
    foreach file $files {
        lappend tasks [file_to_task $file]
    }
    return [sort_tasks $tasks]
}

proc get_sorted_task_files { } {
    set files [glob -nocomplain [file join ${::TASKS_DIR} *.tcl]]
    return [sort_task_files $files]
}

proc get_selected_tasks { } {
    return ${::selected_tasks}
}

# failure function
proc die {message} {
    global LOG_FILE

    log "FATAL ERROR: $message" 1
    puts stderr "See ${LOG_FILE} for more info"
    puts stderr "Last lines of log : "
    puts stderr "*****************"
    catch {puts stderr "[tail $LOG_FILE]"}
    puts stderr "*****************"
    exit -2
}

proc catch_die {command message} {
    set catch {
        if {[catch {@command@} res] } {
            die "@message@ : $res"
        }
        return $res
    }
    debug "Executing command $command"
    set catch [string map [list "@command@" "$command" "@message@" "$message"] $catch]
    uplevel 1 $catch
}
# enhanced 'shellex' to save output to return var
proc shellex {args} {
	set outbuffer ""    
    debug "Executing shellex $args"
    set outbuffer [eval exec $args]	
	return $outbuffer
}

proc hexify { str } {
    set out ""
    for {set i 0} { $i < [string length $str] } { incr i} {
        set c [string range $str $i $i]
        binary scan $c H* h
        append out "\[$h\]"
    }
    return $out
}

proc tail {filename {n 10}} {
    set fd [open $filename r]
    set lines [list]
    while {![eof $fd]} {
        lappend lines [gets $fd]
        if {[llength $lines] > $n} {
            set lines [lrange $lines end-$n end]
        }
    }
    close $fd
    return [join $lines "\n"]
}
# func to create a 'directory'
proc create_mfw_dir {args} {   
    catch_die {file mkdir $args} "Could not create dir $args"
}
# func. to copy a file
proc copy_file {args} {
    catch_die {file copy {*}$args} "Unable to copy $args"
}
# func. to copy src directory/files to dst
proc copy_dir {src dst } {   

	debug "Copying source dir:$src to target directory:$dst"
    copy_file -force $src $dst
}
# func. to sha1 check a hash
proc sha1_check {file} {
    shell ${::fciv} -add [file nativename $file] -wp -sha1 -xml db.xml
}
# func. to sha1 verify a hash
proc sha1_verify {file} {
    shell ${::fciv} [file nativename $file] -v -sha1 -xml db.xml
}
# func. to delete a file
proc delete_file {args} {
    catch_die {file delete {*}$args} "Unable to delete $args"
}
# func. to rename a file
proc rename_file {src dst} {
    catch_die {file rename {*}$src $dst} "Unable to rename and/or move $src $dst"
}

proc delete_promo { } {
    delete_file -force ${::CUSTOM_PROMO_FLAGS_TXT}
}
# func. to copy over any 'spkg_hdr.1" files
proc copy_spkg { } {
    debug "searching for spkg"
    set spkg [glob -directory ${::CUSTOM_UPDATE_DIR} *.1]
	debug "spkg found in $spkg"
	debug "copy new spkg into spkg dir"
    copy_file -force $spkg ${::CUSTOM_SPKG_DIR}
	if {[file exists [file join $spkg]]} {
	debug "removing spkg from working dir"
	delete_file -force $spkg
	}
} 
# func. to copy the 'MFW_DIR' dirs/files
proc copy_mfw_imgs { } {
    create_mfw_dir ${::CUSTOM_MFW_DIR}
    copy_file -force ${::CUSTOM_IMG_DIR} ${::CUSTOM_MFW_DIR}
}

# routine to copy standalone '*Install Package Files' app into MFW
proc copy_ps3_game {arg} {
    variable option
	set arg0 0
	set arg1 0
	set arg2 0
	set arg3 0
	set arg4 1
	
	if {[info exists ::patch_xmb::options(--add-install-pkg)]} {
		set arg0 $::patch_xmb::options(--add-install-pkg) }
	if {[info exists ::patch_xmb::options(--add-pkg-mgr)]} {
		set arg1 $::patch_xmb::options(--add-pkg-mgr) }
	if {[info exists ::patch_xmb::options(--add-hb-seg)]} {
		set arg2 $::patch_xmb::options(--add-hb-seg) }
	if {[info exists ::patch_xmb::options(--add-emu-seg)]} {
		set arg3 $::patch_xmb::options(--add-emu-seg) }
	if {[info exists ::customize_firmware::options(--customize-embedded-app)]} {
		set arg4 [file exists $::customize_firmware::options(--customize-embedded-app) == 0] }
    
    if { $arg0 || $arg1 || $arg2 || $arg3  && !$arg4 } {
        rename_file -force $arg ${::CUSTOM_EMBEDDED_APP}
    } elseif { $arg0 || $arg1 || $arg2 || $arg3  && $arg4 } {
        copy_file -force $arg ${::CUSTOM_MFW_DIR}
    } elseif { !$arg0 && !$arg1 && !$arg2 && !$arg3 && !$arg4 } {
        create_mfw_dir ${::CUSTOM_MFW_DIR}
        rename_file -force $arg ${::CUSTOM_EMBEDDED_APP}
    } elseif { !$arg0 && !$arg1 && !$arg2 && !$arg3 && $arg4 } {
        create_mfw_dir ${::CUSTOM_MFW_DIR}
        copy_file -force $arg ${::CUSTOM_MFW_DIR}
    }
	unset arg0, arg1, arg2, arg3, arg4
}

proc copy_ps3_game_standart { } {
    set ttf "SCE-PS3-RD-R-LATIN.TTF"
	debug "using font file .ttf as argument to search for"
	debug "cause we need a tar with a bit space in it"
    modify_devflash_file [file join dev_flash data font $ttf] callback_ps3_game_standart
}

proc callback_ps3_game_standart { file } {
    log "Creating custom directory in dev_flash"
	create_mfw_dir ${::CUSTOM_MFW_DIR}
	if {${::CFW} == "AC1D"} {
	    log "Installing standalone 'Custom FirmWare' app"
	    copy_file -force ${::CUSTOM_PS3_GAME2} ${::CUSTOM_MFW_DIR}
		log "Copy custom imgs into dev_flash"
	    copy_file -force ${::CUSTOM_IMG_DIR} ${::CUSTOM_MFW_DIR}
	} else {
	    log "Installing standalone '*Install Package Files' app"
	    copy_file -force ${::CUSTOM_PS3_GAME} ${::CUSTOM_MFW_DIR}
	}
}

# func. for 'extracting' the input PUP file
proc pup_extract2 {pup dest} {
	set debugmode no
	if { $::options(--tool-debug) } {
		set debugmode yes
	}
#   shell ${::PUP} x $pup $dest
	shell ${::PKGTOOL} -debug $debugmode -action unpack -type pup -in [file nativename $pup] -out [file nativename $dest]
}

# func. for 'creating' the final PUP output
proc pup_create2 {dir pup build} {
	set debugmode no
	if { $::options(--tool-debug) } {
		set debugmode yes
	}
#   shell ${::PUP} c $dir $pup $build   
	shell ${::PKGTOOL} -debug $debugmode -action pack -type pup -in [file nativename $dir] -out $pup -buildnum $build
	log "Created PUP!"
}

# proc for extracting pup 'build' info
proc pup_get_build {pup} {
    set fd [open $pup r]
    fconfigure $fd -translation binary
    seek $fd 16
    set build [read $fd 8]
    close $fd

    if {[binary scan $build W build_ver] != 1} {
        error "Cannot read 64 bit big endian from [hexify $build]"
    }
	
    return $build_ver
}

# proc for extracting tar files
proc extract_tar2 {tar dest} {
	debug "Extracting tar file [file tail $tar] into [file tail $dest]"	
	# now go untar the file
    file mkdir $dest    
    catch_die {::tar::untar2 $tar -dir $dest} "Could not untar file $tar"
	debug "Extracted"
}

# create_tar proc, for creating custom tar files
# updated:  to set the tar hdr fields based on original file
proc create_tar2 {tar directory files args} {

	debug "Creating tar file:$tar, from directory:$directory\n"	
	set orgcount 0
	set buildcount 0
	set founddir 0
	set orgtar $tar
	set full_headers_list ""
	set inflags [split $args " "]
	set outflags ""
	set debugmode no	
	
	if { $::options(--tool-debug) } {
		set debugmode yes
	} 		
		
	# setup the rest of the vars
	set debug [file tail $tar]
	set myfile $tar
    if {$debug == "content" } {
        set debug [file tail [file dirname $tar]]
    }		
		
	# -------------------------------- TAR HEADERS IMPORTING ------------------------------ #
	# go read in the full 'tar' headers for the entire file, for 
	# every file in the tar	
	
	# substitute the "PS3MFW-MFW" with the "PS3MFW-OFW" dir, 
	# so we grab headers from the ORIGINAL file
	if { [regsub ($::CUSTOM_PUP_DIR) $orgtar $::ORIGINAL_PUP_DIR orgtar] } {	
		log "Importing TAR headers from file:$orgtar"		
	} else {
		log "ERROR: Failed to setup path for TAR file to import tar headers..."
		die "ERROR: Failed to setup path for TAR file to import tar headers..."
	}
	# import tar headers for all tar files
	set full_headers_list [::tar::contents_ps3mfw $orgtar]				
	set orgcount [llength $full_headers_list]	

	# -----------------------------------------
	# parse the full ORIGINAL TAR 'headers list',
	# and check if we have any DIRECTORY entries.  
	# default setup for this tar creation is to
	# create the tar with "-nodirs" specified....
	#
	# if dirs exist in original tar, then we MUST
	# build the tar the same (otherwise, we don't want
	# the dir entries in there!
	#
	foreach entry $full_headers_list {
		set fields [split $entry "~"]
		lassign $fields name mode uid gid mtime type
		if {$type == 5} {
			set founddir 1
			log "\n!! WARNING !!...there are DIRECTORIES in the tar:[file tail $tar]..."
			log "TAR will be built INCLUDING directory entries...."			
			break
		}
	}
	# ----------------------------------------------- #
	# parse the "inflags(args)", and if we have 
	# 'directories' in our original tar, then we
	# CANNOT specify the "-nodirs" option, or we 
	# will be missing tar contents	
	foreach x $inflags {		
		if {[regexp "(^-nodirs).*" $x]} {
			if {$founddir == 1} { continue }
			append outflags "$x "
		}
	}		
	# -------------------------- DONE TAR HEADERS IMPORTING ----------------------------- #	
	# ----------------------------------------------------------------------------------- #		
	
	
    # now go and create the tar file (tar.tcl procs)
    log "Creating tar file $debug, flags:$outflags"	
	# forcibly delete the current 'tar' file
	file delete -force $tar	
    set pwd [pwd]
    cd $directory
	catch_die {::tar::create_ps3mfw $tar $files $full_headers_list buildcount {*}$outflags} "Could not create tar file $tar"
    cd $pwd
	
	# --- VERIFY TAR FILE BUILD SUCCESSFULLY! --- #
	if {$debugmode == yes} {
		log "Original tar count:$orgcount, Build file count:$buildcount"	
	}	
	if {$orgcount == $buildcount} {
		log "$tar file build SUCCESSFUL!\n"
	} else {
		log "Original tar count:$orgcount, Build file count:$buildcount"	
		die "Error rebuilding $tar file, terminating build"
	}	
	# ------------------------------- END TAR CREATION ---------------------------------------- #
}
# proc for 'unpackaging' dev_flash files
proc unpkg_devflash_all2 {updatedir outdir} {
    file mkdir $outdir
    foreach file [lsort [glob -nocomplain [file join $updatedir dev_flash_*]]] {
        unpkg_archive2 $file [file join $outdir [file tail $file]]
    }
}
# proc for finding the file in devflash tars
proc find_devflash_archive {dir find} {

    foreach file [glob -nocomplain [file join $dir * content]] {
        if {[catch {::tar::stat $file $find}] == 0} {
            return $file
        }
    }
    return ""
}

# ---------------------------------------------------------------------------------------------------------------------- #
# -------------------------------- PKG/SPKG functions (pkg/unpkg/spkg -------------------------------------------------- #
# proc for building the 'spkg' package
# --- no longer supported - SPKG is built as part of the 
# --- "PKG" build process!
proc spkg_archive2 {pkg} {
	die "This function is NO LONGER SUPPORTED!!!"
    debug "spkg-ing file [file tail $pkg]"
    catch_die {spkg2 $pkg} "Could not spkg file [file tail $pkg]"
}
proc spkg2 {pkg} {
	die "This function is NO LONGER SUPPORTED!!!"
    shell ${::SPKG} [file nativename $pkg]
}

# 'wrapper' function for calling "unpkg" function
proc unpkg_archive2 {pkg dest} {
    debug "unpkg-ing file [file tail $pkg]"
    catch_die {unpkg2 $pkg $dest} "Could not unpkg file [file tail $pkg]"
	log "Extracted"
}
# function for 'unpackaging'(decrypt) a PKG file
# (outputs the 'content' file)
proc unpkg2 {pkg dest} {	
	set debugmode no
	if { $::options(--tool-debug) } {
		set debugmode yes
	}    
	shell ${::PKGTOOL} -debug $debugmode -action decrypt -type pkg -in [file nativename $pkg] -out [file nativename $dest]
}

# 'wrapper' function for calling "pkg" 
proc pkg_archive {dir pkg} {
    debug "pkg-ing file [file tail $pkg]"
    catch_die {pkg $dir $pkg} "Could not pkg file [file tail $pkg]"
}
# proc for building the normal 'pkg' (encrypt) package
# (outputs the ".pkg" file
proc pkg {pkg dest} {
	log "Building ORIGINAL PKG retail package"
	set debugmode no
	if { $::options(--tool-debug) } {
		set debugmode yes
	}

	# now go build the pkg/spkg output	
	shell ${::PKGTOOL} -debug $debugmode -action encrypt -type pkg -in [file nativename $pkg] -out [file nativename $dest]	
}

# 'wrapper' function for calling "pkg_spkg"
proc pkg_spkg_archive2 {dir pkg} {
    debug "pkg-ing / spkg-ing file [file tail $pkg]"
    catch_die {pkg_spkg2 $dir $pkg} "Could not pkg / spkg file [file tail $pkg]"
}
# proc for building the "new" pkg with spkg headers
# (encrypt) into the pkg/spkg output files
proc pkg_spkg2 {pkg dest} {
	log "Building new pkg & spkg retail package"	
	set debugmode no
	if { $::options(--tool-debug) } {
		set debugmode yes
	} 

	# now go build the pkg/spkg output	
	shell ${::PKGTOOL} -debug $debugmode -action encrypt -type spkg -in [file nativename $pkg] -out [file nativename $dest]
}

# ---------------------------------------------------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------------------------------------------------- #


# ---------------------------------------------------------------------------------------------------------------------- #
# -------------------------------- CORE_OS functions (cospkg/cosunpkg) ------------------------------------------------- #
# 'wrapper' function for calling "cospkg"
proc cospkg_package2 { dir pkg } {
    debug "cospkg-ing file [file tail $dir]"
    catch_die { cospkg2 $dir $pkg } "Could not cospkg file [file tail $pkg]"
}
# func for "packaging up" COS files
# (creates the 'content' file)
proc cospkg2 { dir pkg } {
	set orgfilepath $pkg
	set orgfilesize ""	
	set debugmode no	
	if { $::options(--tool-debug) } {
		set debugmode yes
	} 	
		
	# now go build the pkg/spkg output	
	shell ${::PKGTOOL} -debug $debugmode -action pack -type cos -in [file nativename $dir] -out [file nativename $pkg]		
}
# 'wrapper' function for calling "cosunpkg"
proc cosunpkg_package2 { pkg dest } {
    debug "cosunpkg-ing file [file tail $pkg]"
    catch_die { cosunpkg2 $pkg $dest } "Could not cosunpkg file [file tail $pkg]"
}
# function for "unpacking" CORE_COS files
# (unpacks the 'content' file
proc cosunpkg2 { pkg dest } {
	set debugmode no
	if { $::options(--tool-debug) } {
		set debugmode yes
	}    
	shell ${::PKGTOOL} -debug $debugmode -action unpack -type cos -in [file nativename $pkg] -out [file nativename $dest]	
}
# -------------------------------------------------------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------------------------------------------------- #

proc modify_coreos_file2 { file callback args } {
	## core os files are now automaticallly unpacked/repacked
	## at the start/end of the MFW build script

	
    log "Modifying CORE_OS file [file tail $file]"  	
    set pkg [file join ${::CUSTOM_UPDATE_DIR} CORE_OS_PACKAGE.pkg]
    set unpkgdir [file join ${::CUSTOM_UPDATE_DIR} CORE_OS_PACKAGE.unpkg]
    set cosunpkgdir [file join ${::CUSTOM_UPDATE_DIR} CORE_OS_PACKAGE]
    
    ::unpkg_archive2 $pkg $unpkgdir
    ::cosunpkg_package [file join $unpkgdir content] $cosunpkgdir

    if {[file writable [file join $cosunpkgdir $file]]} {
	    set ::SELF $file
        eval $callback [file join $cosunpkgdir $file] $args
    } elseif { ![file exists [file join $cosunpkgdir $file]] } {
        die "Could not find $file in CORE_OS_PACKAGE"
    } else {
        die "File $file is not writable in CORE_OS_PACKAGE"
    }
	# rebuild the CORE_OS PKG
    ::cospkg_package2 $cosunpkgdir [file join $unpkgdir content]
    
	# if we are >= 3.56 FW, we need to build the new
	# "spkg" headers, otherwise use normal pkg build
	if {${::NEWMFW_VER} >= ${::OFW_2NDGEN_BASE}} {    
		::pkg_spkg_archive2 $unpkgdir $pkg
        ::copy_spkg
    } else {
        ::pkg_archive $unpkgdir $pkg
    }
}

proc modify_coreos_files2 { files callback args } {
	## core os files are now automaticallly unpacked/repacked
	## at the start/end of the MFW build script

	
    log "Modifying CORE_OS files [file tail $files]" 	
    set pkg [file join ${::CUSTOM_UPDATE_DIR} CORE_OS_PACKAGE.pkg]
    set unpkgdir [file join ${::CUSTOM_UPDATE_DIR} CORE_OS_PACKAGE.unpkg]
    set cosunpkgdir [file join ${::CUSTOM_UPDATE_DIR} CORE_OS_PACKAGE]
    
    ::unpkg_archive $pkg $unpkgdir
    ::cosunpkg_package [file join $unpkgdir content] $cosunpkgdir
    
	foreach file $files {
        if {[file writable [file join $cosunpkgdir $file]]} {
		    log "Using file $file now"
			set ::SELF $file
            eval $callback [file join $cosunpkgdir $file] $args
        } elseif { ![file exists [file join $cosunpkgdir $file]] } {
            die "Could not find $file in CORE_OS_PACKAGE"
        } else {
            die "File $file is not writable in CORE_OS_PACKAGE"
        }
	}
	# rebuild the CORE_OS PKG
    ::cospkg_package2 $cosunpkgdir [file join $unpkgdir content]
    
    # if we are >= 3.56 FW, we need to build the new
	# "spkg" headers, otherwise use normal pkg build
	if {${::NEWMFW_VER} >= ${::OFW_2NDGEN_BASE}} {    
		::pkg_spkg_archive2 $unpkgdir $pkg
        ::copy_spkg
    } else {
        ::pkg_archive $unpkgdir $pkg
    }
}

# proc for "unpackaging" the "CORE_OS" files
# 'pupdir' is directory path of PUPDIR being used
# (ie 'PS3MFW-MFW' or 'PS3MFW-OFW')
proc unpack_coreos_files2 { pupdir array } {
	
    log "Unpacking CORE_OS files..."  	
	upvar $array MyLV0Hdrs
	set updatedir [file join $pupdir update_files]
	set pkgfile [file join $updatedir CORE_OS_PACKAGE.pkg]
	set unpkgdir [file join $updatedir CORE_OS_PACKAGE.unpkg]
	set cosunpkgdir [file join $updatedir CORE_OS_PACKAGE]	
	
	# unpkg and cosunpkg the "COREOS.pkg"
    ::unpkg_archive2 $pkgfile $unpkgdir
    ::cosunpkg_package2 [file join $unpkgdir content] $cosunpkgdir	
	
	# if firmware is >= 3.60, we need to extract LV0 contents	
	if {${::NEWMFW_VER} >= "3.60"} {
		catch_die {extract_lv02 $cosunpkgdir "lv0" MyLV0Hdrs} "ERROR: Could not extract LV0"
	}
	
	# set the global flag that "CORE_OS" is unpacked
	set ::FLAG_COREOS_UNPACKED 1
	log "CORE_OS Unpacked!" 	
}

# -------------------------------------------------------- #
# proc for "packaging" up the "CORE_OS" files
#
# 'ALWAYS' repack/rebuild from the 'PS3MFW-MFW' directory
# (so no need to pass a path, always always use the 
# 'CUSTOM....' paths!!
#

proc repack_coreos_files2 { array } {
	#::CUSTOM_PKG_DIR == $pkg
	#::CUSTOM_UNPKG_DIR == $unpkg
	#::CUSTOM_COSUNPKG_DIR == $cosunpkg
    log "Repacking CORE_OS files..." 
	upvar $array MyLV0Hdrs

	# if firmware is >= 3.60, we need to import LV0 contents	
	if {${::NEWMFW_VER} >= "3.60"} {
		catch_die {import_lv02 $::CUSTOM_COSUNPKG_DIR "lv0" MyLV0Hdrs} "ERROR: Could not import LV0"
	}	
    
	# re-package up the files
    ::cospkg_package2 $::CUSTOM_COSUNPKG_DIR [file join $::CUSTOM_UNPKG_DIR content]      	
		
	# if we are >= 3.56 FW, we need to build the new
	# "spkg" headers, otherwise use normal pkg build	
	set pkg $::CUSTOM_PKG_DIR
    set unpkgdir $::CUSTOM_UNPKG_DIR
	if {${::NEWMFW_VER} >= ${::OFW_2NDGEN_BASE}} {    
		::pkg_spkg_archive2 $unpkgdir $pkg
        ::copy_spkg
    } else {
        ::pkg_archive $unpkgdir $pkg
    }
	# For cleaning the lil mess
	catch_die {file delete -force ${unpkgdir}} "Could not delete directory:$unpkgdir for cleanup"
	# set the global flag that "CORE_OS" is packed
	set ::FLAG_COREOS_UNPACKED 0
	log "CORE_OS Repacked!" 	
}
# -------------------------------------------------------- #

# proc for reading in the pup 'build' number
proc get_pup_build {} {
    debug "Getting PUP build from [file tail ${::IN_FILE}]"
    catch_die {pup_get_build ${::IN_FILE}} "Could not get the PUP build information"
    return [pup_get_build ${::IN_FILE}]
}
# proc for 'setting' the pup 'build' number
proc set_pup_build {build} {
    debug "PUP build: $build"
    set ::PUP_BUILD $build
}
# proc for getting the pup 'version' number
proc get_pup_version2 {dir} {
    debug "Getting PUP version from [file tail $dir]"
    set fd [open [file join $dir] r]
    set version [string trim [read $fd]]
    close $fd
    return $version
}
# proc for setting the pup 'version' number
proc set_pup_version {version} {
    debug "Setting PUP version in [file tail ${::CUSTOM_VERSION_TXT}]"
    set fd [open [file join ${::CUSTOM_VERSION_TXT}] w]
    puts $fd "${version}"
    close $fd
}
# wrapper function for calling 'set_pup_version'
proc modify_pup_version_file2 {prefix suffix {clear 0} dir} {
    if {$clear} {
      set version ""
    } else {
      set version [::get_pup_version $dir]
    }
    debug "PUP version: ${prefix}${version}${suffix}"
    set_pup_version "${prefix}${version}${suffix}"
}

proc sed_in_place {file search replace} {
    set fd [open $file r]
    set data [read $fd]
    close $fd

    set data [string map [list $search $replace] $data]

    set fd [open $file w]
    puts -nonewline $fd $data
    close $fd
}

proc unself {in out} {
    set FIN [file nativename $in]
	set FOUT [file nativename $out]

    shell ${::SCETOOL2} -d $FIN $FOUT
	log "Decrypted"
}

# -------------------------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------- MAKESELF - USING SCETOOL ---------------------------------------------------------------- #
#
proc makeself2 {in out array} {   
   upvar $array MySelfHdrs   
  
   set MyKeyRev ""	
   set MyAuthID ""
   set MyVendorID ""
   set MySelfType ""
   set MyAppVersion ""
   set MyFwVersion ""
   set MyCtrlFlags ""   
   set MyCapabFlags ""
   set MyIndivSeed ""   
   set MyCompressed FALSE
   set skipsection FALSE   
   set ZlibCompressLevel -1
   
	
	# set the local vars for all the SCETOOL fields, from the global vars
	# populated from the "import_sce_info{}" proc
	set MyKeyRev $MySelfHdrs(--KEYREV)
	set MyAuthID $MySelfHdrs(--AUTHID)
	set MyVendorID $MySelfHdrs(--VENDORID)
	set MySelfType $MySelfHdrs(--SELFTYPE)
	set MyFirmVersion $MySelfHdrs(--FWVERSION)
	set MyAppVersion $MySelfHdrs(--APPVERSION)	
	set MyCtrlFlags $MySelfHdrs(--CTRLFLAGS)
	set MyCapabFlags $MySelfHdrs(--CAPABFLAGS)
	set MyIndivSeed $MySelfHdrs(--INDIVSEED)
	set MyCompressed $MySelfHdrs(--COMPRESS)	
	
	
	# Reading the SELF version var, and setup in SCETOOL format
	# example: "0004004100000000"	
	set MyAppVersion [format "000%d00%d00000000" [lindex [split $MyAppVersion "."] 0] [lindex [split $MyAppVersion "."] 1]]	
	set ::SELF [file tail $in]	
	#debug "VERSION: $MyAppVersion"	
	if {$MyIndivSeed eq "NONE"} {
                set MyIndivSeed ""
        } elseif {[string length $MyIndivSeed] != 512} {
                die "Error, INDIVSEED length:[string length $MyIndivSeed] from SCE header is invalid!!, exiting...\n"
        }
	
	# ----- IF FOR SOME STRANGE REASON, WE ENDED UP HERE WITHOUT THE SCE HEADER INFO READ IN,
	#       THEN USE DEFAULT VALUES BELOW
	#
	# Load the pre-defined application var into a loop and compare it against the loaded self,
	# search for the "::SELF" filename within the "patchself" string, as it's a full
	# "dev_flash/xxxx" path
	if { ($MyAuthID eq "") } {
                log "\n !!! WARNING !!!  AuthID was empty, using default SCE HDR Params!  check your setup!\n"                
                set MyAppVersion "0003004100000000"
                set MyCompressed TRUE
                set MyAuthID "1070000040000001"
                set MyVendorID "01000002"                
                set MySelfType "APP"
                set MyKeyRev "1C"
                set MyCtrlFlags     "00000000000000000000000000000000"
                append MyCtrlFlags  "00000000000000000000000000000001"
                set MyCapabFlags    "00000000000000000000000000000000"
                append MyCapabFlags "000000000000007B0000000100000000"                                 
        }
	##### ---------------------------------------------------------- ###
	
	## make sure we have a valid authID, if it's blank, 
	## then we have an unhandled SELF type that needs to be added!!	
	if { $MyAuthID == "" } {
		#### CURRENTLY UNHANDLED TYPE - if dies here, fix the script to add  #####		
		die "Unhandled SELF TYPE:\"${::SELF}\", fix script to support it!"
	}
	# run the scetool to resign the elf file
	if { ${MyIndivSeed} == "NONE" } {
	debug "Removed -a because it dosent need it"
    catch_die {shell ${::SCETOOL2} -0 SELF -1 $MyCompressed -s $skipsection -2 $MyKeyRev -3 $MyAuthID -4 $MyVendorID -5 $MySelfType \
	-A $MyAppVersion -6 $MyFirmVersion -8 $MyCtrlFlags -9 $MyCapabFlags -z $ZlibCompressLevel -e $in $out} "SCETOOL execution failed!"      
    } elseif { ${MyIndivSeed} == "" } {
	debug "Removed -a because it dosent need it"
    catch_die {shell ${::SCETOOL2} -0 SELF -1 $MyCompressed -s $skipsection -2 $MyKeyRev -3 $MyAuthID -4 $MyVendorID -5 $MySelfType \
	-A $MyAppVersion -6 $MyFirmVersion -8 $MyCtrlFlags -9 $MyCapabFlags -z $ZlibCompressLevel -e $in $out} "SCETOOL execution failed!"  
	} else {
	debug "Kept -a because the self/sprx uses it"
    catch_die {shell ${::SCETOOL2} -0 SELF -1 $MyCompressed -s $skipsection -2 $MyKeyRev -3 $MyAuthID -4 $MyVendorID -5 $MySelfType \
	-A $MyAppVersion -6 $MyFirmVersion -8 $MyCtrlFlags -9 $MyCapabFlags -a $MyIndivSeed -z $ZlibCompressLevel -e $in $out} "SCETOOL execution failed!"  
    }	
}
# --------------------------------------------------------------------------------------------------------------------------------------- #

# stub proc for decrypting self file
proc decrypt_self {in out} {
    debug "Decrypting self file [file tail $in]"
    catch_die {unself $in $out} "Could not decrypt file [file tail $in]"
}
# proc to run the scetool to dump the SELF header info
proc import_self_info {in array} {	
	
	log "Importing self-hdr info from file: [file tail $in]"		
	upvar $array MySelfHdrs
	set MyArraySize 0
	
	# clear the incoming array
	foreach key [array names MySelfHdrs] {
		set MySelfHdrs($key) ""
	}
	
	# execute the "SCETOOL -w" cmd to dump the needed SCE-HDR info
    catch_die {set buffer [shellex ${::SCETOOL2} -w $in]} "failed to dump SCE header for file: [file tail ${in}]"		
		
	# parse out the return buffer, and 
	# save off the fields into the global array
	set data [split $buffer "\n"]
	foreach line $data {
		if [regexp -- {(^Key-Revision:)(.*)} $line match] {		
			set MySelfHdrs(--KEYREV) [lindex [split $match ":"] 1]
			incr MyArraySize 1	
		} elseif { [regexp -- {(^Auth-ID:)(.*)} $line match] } {		
			set MySelfHdrs(--AUTHID) [lindex [split $match ":"] 1]
			incr MyArraySize 1
		} elseif { [regexp -- {(^Vendor-ID:)(.*)} $line match] } {		
			set MySelfHdrs(--VENDORID) [lindex [split $match ":"] 1]	
			incr MyArraySize 1
		} elseif { [regexp -- {(^SELF-Type:)(.*)} $line match] } {		
			set MySelfHdrs(--SELFTYPE) [lindex [split $match ":"] 1]
			incr MyArraySize 1
		} elseif { [regexp -- {(^AppVersion:)(.*)} $line match] } {		
			set MySelfHdrs(--APPVERSION) [lindex [split $match ":"] 1]
			incr MyArraySize 1
		} elseif { [regexp -- {(^FWVersion:)(.*)} $line match] } {		
			set MySelfHdrs(--FWVERSION) [lindex [split $match ":"] 1]
			incr MyArraySize 1
		} elseif { [regexp -- {(^CtrlFlags:)(.*)} $line match] } {		
			set MySelfHdrs(--CTRLFLAGS) [lindex [split $match ":"] 1]	
			incr MyArraySize 1
		} elseif { [regexp -- {(^CapabFlags:)(.*)} $line match] } {		
			set MySelfHdrs(--CAPABFLAGS) [lindex [split $match ":"] 1]
			incr MyArraySize 1
		} elseif { [regexp -- {(^IndivSeed:)(.*)} $line match] } {                
            set MySelfHdrs(--INDIVSEED) [lindex [split $match ":"] 1]
            incr MyArraySize 1
        } elseif { [regexp -- {(^Compressed:)(.*)} $line match] } {		
		    set MySelfHdrs(--COMPRESS) [lindex [split $match ":"] 1]	
		    incr MyArraySize 1
		}
	}
	# if we successfully captured all vars, 
	# and it matches our array size, success
	if { $MyArraySize == [array size MySelfHdrs] } { 
		log "Self-sce hdr imported successfully!"
	} else {
		log "!!ERROR!!:  FAILED TO IMPORT SELF-SCE HEADERS FROM FILE: [file tail $in]"
		die "!!ERROR!!:  FAILED TO IMPORT SELF-SCE HEADERS FROM FILE: [file tail $in]"
	}
	# display the imported headers if VERBOSE enabled
	if { $::options(--task-verbose) } {
		foreach key [lsort [array names MySelfHdrs]] {
			log "-->$key:$MySelfHdrs($key)"
		}	
	}		
}
# stub proc for resigning the elf
proc sign_elf2 {in out array} {
	upvar $array MySelfHdrs
	
    debug "Rebuilding self file [file tail $out]"		
	# go dispatch the "makeself" routine
    catch_die {makeself2 $in $out MySelfHdrs} "Could not rebuild file [file tail $out]"
}
# proc for decrypting, modifying, and re-signing a SELF file
proc modify_self_file2 {file callback args} {

    log "Modifying self/sprx file [file tail $file]"
	array set MySelfHdrs {
		--KEYREV ""
		--AUTHID ""
		--VENDORID ""
		--SELFTYPE ""
		--APPVERSION ""
		--FWVERSION ""
		--CTRLFLAGS ""
		--CAPABFLAGS ""
		--INDIVSEED ""
		--COMPRESS ""
	}
	
	# read in the SELF hdr info to save off for re-signing
	import_self_info $file MySelfHdrs	
	# decrypt the self file
    decrypt_self $file ${file}.elf
	
	# call the "callback" function to do patching/etc
    eval $callback ${file}.elf $args
	
	# now re-sign the SELF file for final output
    sign_elf2 ${file}.elf ${file}.self MySelfHdrs	
	#file copy -force ${file}.self ${::BUILD_DIR}    # used for debugging to copy the patched elf and new re-signed self to MFW build dir without the need to unpup the whole fw or even a single file
    file rename -force ${file}.self $file
	#file copy -force ${file}.elf ${::BUILD_DIR}     # same as above
    file delete ${file}.elf
	debug "Self successfully rebuilt"
	log "Self successfully rebuilt"
}

proc patch_self {file search replace_offset replace {ignore_bytes {}}} {
    modify_self_file $file patch_elf $search $replace_offset $replace $ignore_bytes
}
# proc for patching files matching the pattern with replace bytes,
# added the global "flag" check for multi-pattern replace, verus
# usual "single" pattern match
proc patch_elf {file search replace_offset replace {ignore_bytes {}}} {
	if { $::FLAG_PATCH_FILE_MULTI != 0 } {
		patch_file_multi $file $search $replace_offset $replace $ignore_bytes
		set ::FLAG_PATCH_FILE_MULTI 0
	} else {
		patch_file $file $search $replace_offset $replace $ignore_bytes
	}
}

proc patch_file {file search replace_offset replace {ignore_bytes {}}} {
    foreach bytes $ignore_bytes {
        if {[llength $bytes] == 1} {
            set search [string replace $search $bytes $bytes "?"]
        } elseif {[llength $bytes] == 2} {
            set idx1 [lindex $bytes 0]
            set idx2 [lindex $bytes 1]
            set len [expr {$idx2 - $idx1 + 1}]
            if {$len < 0} {
                set len 0
            }
            set search [string replace $search $idx1 $idx2 [string repeat "?" $len]]
        }
    }
    set fd [open $file r+]
    fconfigure $fd -translation binary
    set offset -1
    set buffer ""
    while {![eof $fd]} {
        append buffer [read $fd 1]
        if {[string length $buffer] > [string length $search]} {
            set buffer [string range $buffer 1 end]
        }
        set tmp $buffer
        foreach bytes $ignore_bytes {
            if {[llength $bytes] == 1} {
                set tmp [string replace $tmp $bytes $bytes "?"]
            } elseif {[llength $bytes] == 2} {
                set idx1 [lindex $bytes 0]
                set idx2 [lindex $bytes 1]
                set len [expr {$idx2 - $idx1 + 1}]
                if {$len < 0} {
                    set len 0
                }
                set tmp [string replace $tmp $idx1 $idx2 [string repeat "?" $len]]
            }
        }
        if {$tmp == $search} {
            if {$offset != -1} {
                error "Pattern found multiple times"
            }
            set offset [tell $fd]
            incr offset -[string length $search]
            incr offset $replace_offset
        }
    }
    if {$offset == -1} {
        error "Could not find pattern to patch"
    }
	set offsetInHex [format %x $offset]
    #debug "offset: $offset"
	debug "patched offset: 0x$offsetInHex"	
    seek $fd $offset
    puts -nonewline $fd $replace
    close $fd
}

proc patch_file_multi {file search replace_offset replace {ignore_bytes {}}} {
    foreach bytes $ignore_bytes {
        if {[llength $bytes] == 0} {
            set search [string replace $search $bytes $bytes "?"]
        } else {
            set search [string replace $search [lindex $bytes 0] [lindex $bytes 1] "?"]
        }
    }
    set fd [open $file r+]
    fconfigure $fd -translation binary
    set offset -1
    set counter 0
    set buffer ""
    while {![eof $fd]} {
        append buffer [read $fd 1]
        if {[string length $buffer] > [string length $search]} {
            set buffer [string range $buffer 1 end]
        }
        set tmp $buffer
        foreach bytes $ignore_bytes {
            if {[llength $bytes] == 0} {
                set tmp [string replace $tmp $bytes $bytes "?"]
            } else {
                set tmp [string replace $tmp [lindex $bytes 0] [lindex $bytes 1] "?"]
            }
        }
        if {$tmp == $search} {
            incr counter 1
            set offset [tell $fd]
            incr offset -[string length $search]
            incr offset $replace_offset
			set offsetInHex [format %x $offset]
            #debug "offset: $offset"
			debug "patched offset: 0x$offsetInHex"
            seek $fd $offset
            puts -nonewline $fd $replace
            seek $fd $offset
            set offset -1
        }
    }
    if {$counter == 0} {
        error "Could not find pattern to patch"
    } else {
        debug "Replaced $counter occurences of search pattern"
    }
    close $fd
}

proc modify_devflash_file2 {file callback args} {

    log "Modifying dev_flash file [file tail $file]"		
    set tar_file [find_devflash_archive ${::CUSTOM_DEVFLASH_DIR} $file]
    if {$tar_file == ""} {
        die "Could not find [file tail $file] in devflash file"
    }

    set pkg_file [file tail [file dirname $tar_file]]
    debug "Found [file tail $file] in $pkg_file"

    file delete -force [file join ${::CUSTOM_DEVFLASH_DIR} dev_flash]			
	# extract the original flash file
    extract_tar $tar_file ${::CUSTOM_DEVFLASH_DIR}	

    if {[file writable [file join ${::CUSTOM_DEVFLASH_DIR} $file]] } {		
        eval $callback [file join ${::CUSTOM_DEVFLASH_DIR} $file] $args
    } elseif { ![file exists [file join ${::CUSTOM_DEVFLASH_DIR} $file]] } {
        die "Could not find $file in ${::CUSTOM_DEVFLASH_DIR}"
    } else {
        die "File $file is not writable in ${::CUSTOM_DEVFLASH_DIR}"
    }	
		
	# create the tar file
	# '-nodirs' = do NOT include directories in tar file
	# '-nofinalpad'  === NO ZERO PADDING appended to file at end
    create_tar2 $tar_file ${::CUSTOM_DEVFLASH_DIR} dev_flash -nodirs
			    
    set pkg [file join ${::CUSTOM_UPDATE_DIR} $pkg_file]
    set unpkgdir [file join ${::CUSTOM_DEVFLASH_DIR} $pkg_file]
	
	# if we are >= 3.56 FW, we need to build the new
	# "spkg" headers, otherwise use normal pkg build
	if {${::NEWMFW_VER} >= ${::OFW_2NDGEN_BASE}} {    
		::pkg_spkg_archive2 $unpkgdir $pkg
        ::copy_spkg
    } else {
        ::pkg_archive $unpkgdir $pkg
    }
}

proc modify_devflash_files2 {path files callback args} {	
	
    foreach file $files {
	
        set file [file join $path $file]			
        log "Modifying dev_flash file [file tail $file] in devflash file"
        
        set tar_file [find_devflash_archive ${::CUSTOM_DEVFLASH_DIR} $file]        
        if {$tar_file == ""} {
            debug "Skipping [file tail $file] not found"
            continue
        }
        
        set pkg_file [file tail [file dirname $tar_file]]
        debug "Found [file tail $file] in $pkg_file"
       
        file delete -force [file join ${::CUSTOM_DEVFLASH_DIR} dev_flash]		
        extract_tar2 $tar_file ${::CUSTOM_DEVFLASH_DIR}
	 
        if {[file writable [file join ${::CUSTOM_DEVFLASH_DIR} $file]] } {
		    set ::SELF $file
			log "Using file $file now"
            eval $callback [file join ${::CUSTOM_DEVFLASH_DIR} $file] $args
        } elseif { ![file exists [file join ${::CUSTOM_DEVFLASH_DIR} $file]] } {
            debug "Could not find $file in ${::CUSTOM_DEVFLASH_DIR}"
        } else {
            die "File $file is not writable in ${::CUSTOM_DEVFLASH_DIR}"
        }     
      							
		# create the tar file
		# '-nodirs' = do NOT include directories in tar file
		# '-nofinalpad'  === NO ZERO PADDING appended to file at end				
        create_tar2 $tar_file ${::CUSTOM_DEVFLASH_DIR} dev_flash	-nodirs
		        
        set pkg [file join ${::CUSTOM_UPDATE_DIR} $pkg_file]
        set unpkgdir [file join ${::CUSTOM_DEVFLASH_DIR} $pkg_file]		
		
		# if we are >= 3.56 FW, we need to build the new
		# "spkg" headers, otherwise use normal pkg build
		if {${::NEWMFW_VER} >= ${::OFW_2NDGEN_BASE}} {    
			::pkg_spkg_archive2 $unpkgdir $pkg
			::copy_spkg
		} else {
			::pkg_archive $unpkgdir $pkg
		}
    }	
}

proc modify_upl_file {callback args} {
    log "Modifying UPL.xml file"	
    set file "content"
    
    set pkg [file join ${::CUSTOM_UPDATE_DIR} UPL.xml.pkg]
    set unpkgdir [file join ${::CUSTOM_UPDATE_DIR} UPL.xml.unpkg]
	set orgunpkgdir [file join ${::ORIGINAL_UPDATE_DIR} UPL.xml.unpkg]

	# unpkg the archive in the 'MFW' dir
    ::unpkg_archive2 $pkg $unpkgdir
	# unpkg the archive in the 'OFW' dir (for importing content info)
    ::unpkg_archive2 $pkg $orgunpkgdir	

	# verify 'file' is writable/etc before it's patched
    if {[file writable [file join $unpkgdir $file]] } {
        eval $callback [file join $unpkgdir $file] $args
    } elseif { ![file exists [file join $unpkgdir $file]] } {
        die "Could not find $file in $unpkgdir"
    } else {
        die "File $file is not writable in $unpkgdir"
    }
	
	# if we are >= 3.56 FW, we need to build the new
	# "spkg" headers, otherwise use normal pkg build
	if {${::NEWMFW_VER} >= ${::OFW_2NDGEN_BASE}} {    
		::pkg_spkg_archive2 $unpkgdir $pkg
        ::copy_spkg
    } else {
        ::pkg_archive $unpkgdir $pkg
    }
}

proc remove_node_from_xmb_xml { xml key message} {
    log "Removing \"$message\" from XML"

    while { [::xml::GetNodeByAttribute $xml "XMBML:View:Attributes:Table" key $key] != "" } {
        set xml [::xml::RemoveNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Attributes:Table" key $key]]
    }
    while { [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key $key] != "" } {
        set xml [::xml::RemoveNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key $key]]
    }

    return $xml
}

proc remove_pkg_from_upl_xml { xml key message } {
    log "Removing \"$message\" package from UPL.xml" 1

    set i 0
    while { 1 } {
        set index [::xml::GetNodeIndices $xml "UpdatePackageList:Package" $i]
        if {$index == "" } break
        set node [::xml::GetNodeByIndex $xml $index]
        set data [::xml::GetData $node "Package:Type"]
        #debug "index: $index :: node: $node :: data: $data"
        if {[string equal $data $key] == 1 } {
            #debug "data: $data :: key: $key"
            set xml [::xml::RemoveNode $xml $index]
            break
        }
        incr i 1
    }
    return $xml
}

proc remove_pkgs_from_upl_xml { xml key message } {
    log "Removing \"$message\" packages from UPL.xml" 1

    set i 0
    while { 1 } {
        set index [::xml::GetNodeIndices $xml "UpdatePackageList:Package" $i]
        if {$index == "" } break
        set node [::xml::GetNodeByIndex $xml $index]
        set data [::xml::GetData $node "Package:Type"]
        #debug "index: $index :: node: $node :: data: $data"
        if {[string equal $data $key] == 1 } {
            #debug "data: $data :: key: $key"
            set xml [::xml::RemoveNode $xml $index]
            incr i -1
        }
        incr i 1
    }
    return $xml
}

# .rco files handling routines
proc rco_dump {rco rco_xml rco_dir} {
    shell ${::RCOMAGE} dump [file nativename $rco] [file nativename $rco_xml] --resdir [file nativename $rco_dir]
}

proc rco_compile {rco_xml rco_new} {
    set RCOMAGE_OPTS "--pack-hdr zlib --zlib-method default --zlib-level 9"
    shell ${::RCOMAGE} compile [file nativename $rco_xml] [file nativename $rco_new] {*}$RCOMAGE_OPTS
}

proc unpack_rco_file {rco rco_xml rco_dir} {
    log "unpacking rco file [file tail $rco]"
    catch_die {rco_dump $rco $rco_xml $rco_dir} "Could not unpack rco file [file tail $rco]"
}

proc pack_rco_file {rco_xml rco_new} {
    log "packing rco file [file tail $rco_new]"
    catch_die {rco_compile $rco_xml $rco_new} "Could not pack rco file [file tail $rco_new]"
}

proc callback_modify_rco {rco_file callback callback_args} {
    set RCO_XML ${rco_file}.xml
    set RCO_DIR ${rco_file}_dir
    set RCO_NEW ${rco_file}.new

    catch_die {file mkdir $RCO_DIR} "Could not create dir $RCO_DIR"
    unpack_rco_file $rco_file $RCO_XML $RCO_DIR

    eval $callback $RCO_DIR $callback_args

    pack_rco_file $RCO_XML $RCO_NEW
    catch_die {
        file rename -force $RCO_NEW $rco_file
        file delete -force $RCO_XML
        file delete -force $RCO_DIR
    } "Could not cleanup files after modifying [file tail $rco_file]"
}

proc modify_rco_file2 {rco_file callback args} {
    modify_devflash_file2 $rco_file callback_modify_rco $callback $args
}

# RCO callback for multiple files
proc modify_rco_files2 {path rco_files callback args} {
    modify_devflash_files2 $path $rco_files callback_modify_rco $callback $args
}

proc get_header_key_upl_xml { file key message } {

    debug "Getting \"$message\" information from UPL.xml"	
	set verbosemode no
	# if verbose mode enabled
	if { $::options(--task-verbose) } {
		set verbosemode yes
	}

	# load xml file
    set xml [::xml::LoadFile $file]
    set data [::xml::GetData $xml "UpdatePackageList:Header:$key"]
    if {$data != ""} {
		if {$verbosemode == yes} {
			log "$key:$data"
		}
        return $data
    }
    return ""
}

proc set_header_key_upl_xml { file key replace message } {

    log "Setting \"$message\" information in UPL.xml" 1	
	set finaldata ""
    set xml [::xml::LoadFile $file]

	# search the 'xml' data, and try to find the data
	# based on the 'key'
    set search [::xml::GetData $xml "UpdatePackageList:Header:$key"]
    if {$search != "" } {	
	
        set fd [open $file r]
		fconfigure $fd -translation binary 
        set xml [read $fd]
        close $fd     
		
		# iterate through the 'xml' data, and replace the line
		# with the found data
		set lines [split $xml \x0A]
		foreach line $lines {
			if { [regsub ($search) $line $replace line] } {
				log "replaced: $key: $search -> $replace"						
			}
			append finaldata $line\x0A
		}
        # write out final data
        set fd [open $file w]
		fconfigure $fd -translation binary
        puts -nonewline $fd $finaldata
        close $fd
        return $search
    }
    return ""
}

proc remove_node_from_xmb_xml { xml key message} {
    log "Removing \"$message\" from XML"

    while { [::xml::GetNodeByAttribute $xml "XMBML:View:Attributes:Table" key $key] != "" } {
        set xml [::xml::RemoveNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Attributes:Table" key $key]]
    }
    while { [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key $key] != "" } {
        set xml [::xml::RemoveNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key $key]]
    }

    return $xml
}

proc change_build_upl_xml { filename buildnum } {

    log "Changing Buildnum in UPL.xml...."
	# retrieve the '<BUILD>.....</BUILD>' xml tag
	set data [::get_header_key_upl_xml $filename Build Build]	
	if { [regexp {(^[0-9]{5,5}),.*} $data none orgbuild] == 0} {
		die "Failed to locate build number in UPL file!\n"
	}		
	# make sure the user supplied 'buildnum' is same
	# length as original, or error out		
	if {[string length $buildnum] != [string length $orgbuild]} {
		die "Error: build number:$buildnum is invalid!!\n"
	}		
	# substitute in the new build number
	if {[regsub ($orgbuild) $data $buildnum data] == 0} {
		die "Failed updating build number in UPL file\n"
	}				
	# update the <BUILD>....</BUILD> data
	set xml [::set_header_key_upl_xml $filename Build "${data}" Build]
	if { $xml == "" } {
		die "Updating build number in UPL.xml failed...."
	} 	
	# go set the global '::BUILDNUM'
	::set_pup_build $buildnum
}

proc remove_pkg_from_upl_xml { xml key message } {
    log "Removing \"$message\" package from UPL.xml" 1

    set i 0
    while { 1 } {
        set index [::xml::GetNodeIndices $xml "UpdatePackageList:Package" $i]
        if {$index == "" } break
        set node [::xml::GetNodeByIndex $xml $index]
        set data [::xml::GetData $node "Package:Type"]
        #debug "index: $index :: node: $node :: data: $data"
        if {[string equal $data $key] == 1 } {
            #debug "data: $data :: key: $key"
            set xml [::xml::RemoveNode $xml $index]
            break
        }
        incr i 1
    }
    return $xml
}

proc remove_pkgs_from_upl_xml { xml key message } {
    log "Removing \"$message\" packages from UPL.xml" 1

    set i 0
    while { 1 } {
        set index [::xml::GetNodeIndices $xml "UpdatePackageList:Package" $i]
        if {$index == "" } break
        set node [::xml::GetNodeByIndex $xml $index]
        set data [::xml::GetData $node "Package:Type"]
        #debug "index: $index :: node: $node :: data: $data"
        if {[string equal $data $key] == 1 } {
            #debug "data: $data :: key: $key"
            set xml [::xml::RemoveNode $xml $index]
            incr i -1
        }
        incr i 1
    }
    return $xml
}

# func. for 'decrypting' an SPP file
proc unspp2 {in out} {
	set debugmode no
	if { $::options(--tool-debug) } {
		set debugmode yes
	}	
#   shell ${::UNSPP} [file nativename $in] [file nativename $out]
	shell ${::PKGTOOL} -debug $debugmode -action decrypt -type spp -in [file nativename $in] -out [file nativename $out]
}

# func. for 'encrypting' an SPP file
proc spp2 {in out} {
	set debugmode no
	if { $::options(--tool-debug) } {
		set debugmode yes
	}	
#   shell ${::SPP} 355 [file nativename $in] [file nativename $out]
	shell ${::PKGTOOL} -debug $debugmode -action encrypt -type spp -in [file nativename $in] -out [file nativename $out]   
}

proc decrypt_spp2 {in out} {
    debug "Decrypting spp file [file tail $in]"
    catch_die {unspp2 $in $out} "Could not decrypt file [file tail $in]"
}

proc patch_pp {file search replace_offset replace {ignore_bytes {}}} {
    patch_file $file $search $replace_offset $replace $ignore_bytes
}

proc sign_pp2 {in out} {
    debug "Rebuilding spp file [file tail $out]"
    catch_die {spp2 $in $out} "Could not rebuild file [file tail $out]"
}

# main proc for modifying 'spp' files
proc modify_spp_file2 {file callback args} {

    log "Modifying spp file [file tail $file]"
	
	# decrypt the '.spp' file to a '.spp.pp' file
    decrypt_spp2 $file ${file}.pp
    eval $callback ${file}.pp $args
	# re-encrypt the '.spp.pp' file back to '.spp' file
    sign_pp2 ${file}.pp $file
    file delete ${file}.pp
}
# ------------------------------ END OF THIS SCRIPT --------------------------------------------- ##
# ----------------------------------------------------------------------------------------------- ##

# new makeself routine using scetool
proc makeself {in out} {

   variable options
   set fwversiVar ""
   set versionVar ""
   set keyRev "00"
   set authID ""
   set vendID "ff000000"
   set selfType ""
   set compress ""
   set skipsect "FALSE"
   # Added Caps & seeds option!
   set selfcapFLAGS ""
   set selfctrlFLAGS ""
   set indivSeeds ""
   
	
    # Reading the pup suffix var and set up fw/self version var 	
	# example: "0004004100000000"
	set versionVar [format "000%d00%d00000000" $::OFW_MAJOR_VER $::OFW_MINOR_VER]
	set fwversiVar $versionVar
	#debug "VERSION: $versionVar"	
	
    # Read the loaded self and set authentication/vendor ID, self type and key revision (removed sum useless stuff because was USELESS!)
    if { ${::SELF} == "lv0" } {
		set authID "1ff0000001000001"
		set selfType "LV0"	
		set vendID "FF000000"
        set selfcapFLAGS "0000000000000000000000000000000000000000000000780000000000000000"
        set selfctrlFLAGS "0000000000000000000000000000000000000000000000000000000000000000"
        set compress "FALSE"		
    } elseif { ${::SELF} == "lv1ldr.self" } {
		set authID "1FF0000008000001"
		set selfType "LDR"		
		set vendID "FF000000"
		set selfcapFLAGS "0000000000000000000000000000000000000000000000780000000000000000"
        set selfctrlFLAGS "0000000000000000000000000000000000000000000000000000000000000000"
		set compress "FALSE"
    } elseif { ${::SELF} == "lv2ldr.self" } {
		set authID "1FF0000009000001"
		set selfType "LDR"	
		set vendID "FF000000"
		set selfcapFLAGS "0000000000000000000000000000000000000000000000780000000000000000"
        set selfctrlFLAGS "0000000000000000000000000000000000000000000000000000000000000000"
        set compress "FALSE"		
    } elseif { ${::SELF} == "isoldr.self" } {
	    set authID "1FF000000A000001"
		set selfType "LDR"
		set vendID "FF000000"
		set selfcapFLAGS "0000000000000000000000000000000000000000000000780000000000000000"
        set selfctrlFLAGS "0000000000000000000000000000000000000000000000000000000000000000"
		set compress "FALSE"
	} elseif { ${::SELF} == "appldr.self" } {
	    set authID "1ff000000c000001"
		set selfType "LDR"
		set vendID "FF000000"
		set selfcapFLAGS "0000000000000000000000000000000000000000000000780000000000000000"
        set selfctrlFLAGS "0000000000000000000000000000000000000000000000000000000000000000"
		set compress "FALSE"
	} elseif { ${::SELF} == "emer_init" } {
	    set authID "10700003FC000001"
		set selfType "APP"
		set compress "FALSE"
	#} elseif { ${::SELF} == "default.spp" } {
	#    set authID "1070000021000001"
	#	set selfType "SPP"
	#	set compress "FALSE"
	} elseif { ${::SELF} == "lv1.self" } {
		set authID "1ff0000002000001"
		set selfType "LV1"
		set vendID "FF000000"
		set selfcapFLAGS "00000000000000000000000000000000000000000000007B0000000100000000"
		set selfctrlFLAGS "0000000000000000000000000000000000000000000000000000000000000000"
		set compress "TRUE"
    } elseif { ${::SELF} == "lv2_kernel.self" } {
		set authID "1050000003000001"
		set vendID "05000002"
		set selfType "LV2"
		set selfcapFLAGS "00000000000000000000000000000000000000000000007B0000000100000000"
		set selfctrlFLAGS "0000000000000000000000000000000000000000000000000000000000000000"
		set compress "TRUE"
    } elseif { ${::SELF} == "spu_pkg_rvk_verifier.self" } {
		set authID "1070000022000001"
		set vendID "07000001"
		set selfType "ISO"
		set keyRev "01"
		set selfcapFLAGS "0000000000000000000000000000000000000000000000780000000000000000"
		set selfctrlFLAGS "0000000000000000000000000000000000000000000000000000000000000000"
        set indivSeeds "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
		set compress "FALSE"
	} elseif { ${::SELF} == "vsh.self" || ${::SELF} == "vsh.self.swp" } {
		set authID "10700005FF000001"
		set selfType "APP"
		set keyRev "1C"
		set vendID "01000002"
		set selfcapFLAGS "00000000000000000000000000000000000000000000007B0000000100020000"
		set selfctrlFLAGS "4000000000000000000000000000000000000000000000000000000000000002"
		set compress "TRUE"
	#} elseif { ${::SELF} == "spp_verifier.self" } {
	#   set authID "1070000021000001"
	#	set selfType "ISO"
	#	set keyRev "01"
	#	set vendID "07000001"
	#	set selfcapFLAGS "0000000000000000000000000000000000000000000000780000000000000000"
	#	set selfctrlFLAGS "0000000000000000000000000000000000000000000000000000000000000000"
	#   set indivSeeds "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
	#   set compress "FALSE"
	#} elseif { ${::SELF} == "spu_token_processor.self" } {
	#   set authID "1070000023000001"
	#	set selfType "ISO"
	#	set keyRev "0001"
	#	set vendID "07000001"
	#	set selfcapFLAGS "0000000000000000000000000000000000000000000000780000000000000000"
	#	set selfctrlFLAGS "0000000000000000000000000000000000000000000000000000000000000000"
	#    set indivSeeds "ABCAAD1771EFABFC2B921276FAC2130C37A6BE3FEF82C79F3BA5733FC35A690B08B358F970FA16A3D2FFE2299E841EE4D3DB0E0C9BAEB51BC7DFF10467472F85000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
	#    set compress "FALSE"
	#} elseif { ${::SELF} == "explore_plugin.sprx" || ${::SELF} == "nas_plugin.sprx" || ${::SELF} == "explore_category_game.sprx" } {
	#   set authID "1070000052000001"
	#	set selfType "APP"
	#	set keyRev "1C"
	#	set vendID "01000002"
	#	set seldcapFLAGS "00000000000000000000000000000000000000000000007B0000000100020000"
	#	set selfctrlFLAGS "4000000000000000000000000000000000000000000000000000000000000000"
	#	set compress "TRUE"
	}

	# run the scetool to resign the elf file to self!
	if { ${::SELF} == "lv0" } {
	debug "Putting $::SELF values!"
	shell ${::SCETOOL} -0 SELF -1 FALSE -s $skipsect -2 00 -3 1ff0000001000001 -4 FF000000 -5 LV0 -A $versionVar -6 $fwversiVar -8 0000000000000000000000000000000000000000000000000000000000000000 -9 0000000000000000000000000000000000000000000000780000000000000000 -e ${in} ${out}
	} elseif { ${::SELF} == "default.spp" } {
	debug "Putting $::SELF values!"
	shell ${::SCETOOL} -0 SELF -1 FALSE -s $skipsect -2 01 -3 1070000021000001 -4 07000001 -5 SPP -A $versionVar -6 $fwversiVar -8 0000000000000000000000000000000000000000000000000000000000000000 -9 0000000000000000000000000000000000000000000000780000000000000000 -e ${in} ${out}
	} elseif { ${::SELF} == "spp_verifier.self" } {
	debug "Putting $::SELF values!"
	shell ${::SCETOOL} -0 SELF -1 FALSE -s $skipsect -2 01 -3 1070000021000001 -4 07000001 -5 ISO -A $versionVar -6 $fwversiVar -8 0000000000000000000000000000000000000000000000000000000000000000 -9 0000000000000000000000000000000000000000000000780000000000000000 -a 00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 -e ${in} ${out}
	} elseif { ${::SELF} == "spu_token_processor.self" } {
	debug "Putting $::SELF values!"
	shell ${::SCETOOL} -0 SELF -1 FALSE -s $skipsect -2 0001 -3 1070000023000001 -4 07000001 -5 ISO -A $versionVar -6 $fwversiVar -8 0000000000000000000000000000000000000000000000000000000000000000 -9 0000000000000000000000000000000000000000000000780000000000000000 -a ABCAAD1771EFABFC2B921276FAC2130C37A6BE3FEF82C79F3BA5733FC35A690B08B358F970FA16A3D2FFE2299E841EE4D3DB0E0C9BAEB51BC7DFF10467472F85000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 -e ${in} ${out}
	} elseif { ${::SELF} == "explore_plugin.sprx" || ${::SELF} == "nas_plugin.sprx" || ${::SELF} == "explore_category_game.sprx" || ${::SELF} == "basic_plugins.sprx" || ${::SELF} == "game_ext_plugin.sprx" || ${::SELF} == "bdp_plugin.sprx" } {
	debug "Putting $::SELF values!"
	shell ${::SCETOOL} -0 SELF -1 TRUE -s $skipsect -2 1C -3 1070000052000001 -4 01000002 -5 APP -A $versionVar -6 $fwversiVar -8 4000000000000000000000000000000000000000000000000000000000000000 -9 00000000000000000000000000000000000000000000007B0000000100020000 -e ${in} ${out}
	} elseif { ${::SELF} == "spu_pkg_rvk_verifier.self" } {
	debug "Putting $::SELF values!"
	shell ${::SCETOOL} -0 SELF -1 $compress -s $skipsect -2 $keyRev -3 $authID -4 $vendID -5 $selfType -A $versionVar -6 $fwversiVar -8 $selfctrlFLAGS -9 $selfcapFLAGS -a $indivSeeds -e ${in} ${out}
	} else {
	debug "Using detected values!"
	debug "Applying $::SELF values!"
	shell ${::SCETOOL} -0 SELF -1 $compress -s $skipsect -2 $keyRev -3 $authID -4 $vendID -5 $selfType -A $versionVar -6 $fwversiVar -8 $selfctrlFLAGS -9 $selfcapFLAGS -e ${in} ${out}
	}
log "Signed $::SELF using scetool!"
}