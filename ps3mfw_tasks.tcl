#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
# Copyright (C) RedDot-3ND7355 (Monkey Eater XD)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

#Import things here for moving operations!

    set ::OLDROUTINE "0"
	if {$::options(--new-routine)} {
    set ::OLDROUTINE "1"
    }

proc ego {} {
    set dldl2 [open [file join ${::CUSTOM_BUILDVER_TXT}] r]
    set versionDL2 [string trim [read $dldl2]]
    close $dldl2
	set PS3MFW_BUILD $versionDL2
    puts "PS3MFW Creator v${::PS3MFW_VERSION}"
	puts "Private Build $PS3MFW_BUILD"
	puts "Patch on-the-go Edition!"
	puts ""
    puts "    Copyright (C) 2013 Project PS3MFW"
    puts "    This program comes with ABSOLUTELY NO WARRANTY;"
    puts "    This is free software, and you are welcome to redistribute it"
    puts "    under certain conditions; see COPYING for details."
    puts ""
	puts "    Original Dev's :"
	puts "    KaKaRoTo"
	puts "    CodeMonkeys"
	puts ""
    puts "    Developed By :"
    puts "    Anonymous Developers"
	puts "    RedDot-3ND7355"
	puts "    B7U3 C50SS"
	puts ""
	puts "    Contributors :"
	puts "    RazorX"
	puts "    haz367"
	puts "    Habib"
	puts "    haxxxen"
	puts "    Naewhert"
	puts "    toolboy2012"
	puts "    Arachetous"
	puts "    PS3HAX Network members"
    puts ""
}

proc ego_gui {} {
    set dldl2 [open [file join ${::CUSTOM_BUILDVER_TXT}] r]
    set versionDL2 [string trim [read $dldl2]]
    close $dldl2
	set PS3MFW_BUILD $versionDL2
    log "PS3MFW Creator v${::PS3MFW_VERSION}"
	log "Private Build $PS3MFW_BUILD"
	log "Patch on-the-go Edition!"
	log ""
    log "    Copyright (C) 2013 Project PS3MFW"
    log "    This program comes with ABSOLUTELY NO WARRANTY;"
    log "    This is free software, and you are welcome to redistribute it"
    log "    under certain conditions; see COPYING for details."
    log ""
	log "    Original Dev's :"
	log "    KaKaRoTo"
	log "    CodeMonkeys"
	log ""
    log "    Developed By :"
    log "    Anonymous Developers"
	log "    RedDot-3ND7355"
	log "    B7U3 C50SS"
	log ""
	log "    Contributors :"
	log "    RazorX"
	log "    haz367"
	log "    Habib"
	log "    haxxxen"
	log "    Naewhert"
	log "    toolboy2012"
	log "    Arachetous"
	log "    PS3HAX Network members"
    log ""
}

proc clean_up {} {
    log "Cleaning up"
    catch_die {file delete -force -- ${::CUSTOM_PUP_DIR} ${::ORIGINAL_PUP_DIR} ${::OUT_FILE}} \
        "Could not cleanup output files"
}

proc unpack_source_pup {pup dest} {
    log "Unpacking source PUP [file tail ${pup}]"
    catch_die {pup_extract ${pup} ${dest}} "Error extracting PUP file [file tail ${pup}]"

    # Check for license.txt for people using older version of ps3tools
    set license_txt [file join ${::CUSTOM_UPDATE_DIR} license.txt]
    if {![file exists ${::CUSTOM_LICENSE_XML}] && [file exists ${license_txt}]} {
        set ::CUSTOM_LICENSE_XML ${license_txt}
    }
}

proc unpack_source_pup2 {pup dest} {
    log "Unpacking source PUP [file tail ${pup}]"
    catch_die {pup_extract2 ${pup} ${dest}} "Error extracting PUP file [file tail ${pup}]"

    # Check for license.txt for people using older version of ps3tools
    set license_txt [file join ${::CUSTOM_UPDATE_DIR} license.txt]
    if {![file exists ${::CUSTOM_LICENSE_XML}] && [file exists ${license_txt}]} {
        set ::CUSTOM_LICENSE_XML ${license_txt}
    }
}

proc pack_custom_pup {dir pup} {
    set build ${::PUP_BUILD}
    set obuild [get_pup_build]
	log "PUP original build:$obuild"
    if {${build} == "" || ![string is integer ${build}] || ${build} == ${obuild}} {
        set build ${obuild}        
    }
    # create pup
    log "Packing Modified PUP [file tail ${pup}]"
    catch_die {pup_create2 ${dir} ${pup} $build} "Error packing PUP file [file tail ${pup}]"
}

proc build_mfw {input output tasks} {
    set ::OLDROUTINE "0"
	
	if {$::options(--new-routine)} {
    set ::OLDROUTINE "1"
    }
	
	#set ::BUILD_DIR [::ttk::entry $settings.temp.2 -textvariable ::temp_dir]
	
	#if {${::OLDROUTINE} == "0" } {
	#debug "Using new Routines"
	#} elseif {${::OLDROUTINE} == "1" } {
	#debug "Using old Routines"
	#}
	
	if {${::OLDROUTINE} == "1" } {
	global options
	set ::selected_tasks [sort_tasks ${tasks}]
    # print out ego info
    ego_gui
	
	debug "Using old/outdated Routines & tools"
    if {${input} == "" || ${output} == ""} {
        die "Must specify an input and output file"
    }
    if {![file exists ${input}]} {
        die "Input file does not exist"
    }

    log "Selected tasks : ${::selected_tasks}"

    if {[info exists ::env(HOME)]} {
        debug "HOME=$::env(HOME)"
    }
    if {[info exists ::env(USERPROFILE)]} {
        debug "USERPROFILE=$::env(USERPROFILE)"
    }
    if {[info exists ::env(PATH)]} {
        debug "PATH=$::env(PATH)"
    }

    clean_up
	
	# Add the input OFW SHA1 to the DB
	if {${::SHADD} == "true"} {
	    debug "Adding the SHA1 of the Input PUP to the DB"
		sha1_check ${input}
	}

    # Check input OFW PUP SHA1
	if {${::SHCHK} == "true"} {
	    set catch [catch [sha1_verify ${input}]]
	    if {$catch == 1} {
		    log "Error!!"
			log "SHA1 of input PUP does not match any known SHA1"
			after 20000
			exit 0
		} elseif {$catch == 0} {
		    log "PUP SHA1 of input OFW matches known SHA1!"
		}
		unset catch
	}

	
    unpack_source_pup ${input} ${::CUSTOM_PUP_DIR}
    

    extract_tar ${::CUSTOM_UPDATE_TAR} ${::CUSTOM_UPDATE_DIR}

	if {[::get_pup_version] >= ${::NEWCFW}} {
		extract_tar ${::CUSTOM_SPKG_TAR} ${::CUSTOM_SPKG_DIR}
		debug "Extracted spkg_tar"
	}

	copy_file ${::CUSTOM_PUP_DIR} ${::ORIGINAL_PUP_DIR}
	
	
    # copy original PUP to working dir
    #copy_file ${::CUSTOM_PUP_DIR} ${::ORIGINAL_PUP_DIR}

    # set the pup version into a variable so commands later can check it and do fw specific thingy's
	debug "checking pup version"
    set ::SUF [::get_pup_version]
	set ::OFW_MAJOR_VER [lindex [split $::SUF "."] 0]
    set ::OFW_MINOR_VER [lindex [split $::SUF "."] 1]	
	debug "Getting pup version OK! var = ${::SUF}"


    log "Unpacking all dev_flash files (SLOW)"
    unpkg_devflash_all ${::CUSTOM_DEVFLASH_DIR}
	
	
    # set X.XX pup image to original due to stupideness of mfw builder!
	if { ${::SUF} == "4.50" } {
	debug "Fixing build number!"
	log "Fixing build number for 4.50!"
	set build "61890"
	log "Pup build set to $build"
	} elseif { ${::SUF} == "$::SUF" } {
	debug "Fixing build number for $::SUF"
	set build ""
	log "Fixed..."
	}

	
    # Execute tasks
    foreach task ${::selected_tasks} {
        log "******** Running task $task **********"
        eval [string map {- _} ${task}::main]
    }
    log "******** Completed tasks **********"
	

    # RECREATE PS3UPDAT.PUP
    file delete -force ${::CUSTOM_DEVFLASH_DIR}
	debug "custom dev_flash deleted"
	if {[::get_pup_version] >= ${::NEWCFW}} {		
		set filesSPKG [lsort [glob -nocomplain -tails -directory ${::CUSTOM_SPKG_DIR} *.1]]
		debug "spkg's added to list"
	}
    set files [lsort [glob -nocomplain -tails -directory ${::CUSTOM_UPDATE_DIR} *.pkg]]
	debug "pkg's added to list"
    eval lappend files [lsort [glob -nocomplain -tails -directory ${::CUSTOM_UPDATE_DIR} *.img]]
	debug "img's added to list"
    eval lappend files [lsort [glob -nocomplain -tails -directory ${::CUSTOM_UPDATE_DIR} dev_flash3_*]]
	debug "dev_flash3 added to list"
    eval lappend files [lsort [glob -nocomplain -tails -directory ${::CUSTOM_UPDATE_DIR} dev_flash_*]]
	debug "dev_flash added to list"
    #if {[::get_pup_version] >= ${::NEWCFW}} {
	#log "Detected that the FW is over or equal to ${::NEWCFW}, now will be using 4.xx spkg hdr!"
    #create_tar ${::CUSTOM_UPDATE_TAR}  ${::CUSTOM_UPDATE_DIR} ${files}
	#debug "SPKG TAR created"
    #} else {
	if {[::get_pup_version] >= ${::NEWCFW}} {
		create_tar ${::CUSTOM_SPKG_TAR} ${::CUSTOM_SPKG_DIR} ${filesSPKG}
		debug "SPKG TAR created (spkg_tar)"
	}
	create_tar ${::CUSTOM_UPDATE_TAR} ${::CUSTOM_UPDATE_DIR} ${files}
	debug "SPKG TAR created (update_files)"
	#}
	
	# PACKING ROUTINE
	if { ${build} == "61890" } {
	set pup $::OUT_FILE
	set dir $::CUSTOM_PUP_DIR
	debug "Alternate routine!"
	log "Packing Modified PUP [file tail ${pup}]"
    catch_die {pup_create ${dir} ${pup} $build} "Error packing PUP file [file tail ${pup}]"
	} else {
	set build ${::PUP_BUILD}
    set obuild [get_pup_build]
    if {${build} == "" || ![string is integer ${build}] || ${build} == ${obuild}} {
        set build ${obuild}
        incr build
    }
	# create pup
	debug "Original routine!"
	set pup $::OUT_FILE
	set dir $::CUSTOM_PUP_DIR
    log "Packing Modified PUP [file tail ${pup}]"
    catch_die {pup_create ${::CUSTOM_PUP_DIR} ${::OUT_FILE} $build} \
	"Error packing PUP file [file tail ${pup}]"
    }
#####################################
} elseif { ${::OLDROUTINE} == "0" } {
#####################################
    global options	
	 # array for saving off SELF-SCE Hdr fields
	 # for "LV0" for use by unself/makeself routines
	array set LV0_SCE_HDRS {
		--KEYREV ""
		--AUTHID ""
		--VENDORID ""
		--SELFTYPE ""
		--APPVERSION ""
		--FWVERSION ""
		--CTRLFLAGS ""
		--CAPABFLAGS ""
		--COMPRESS ""
	}
	
	
	set ::DID_PATCHING_WITH_UNPACKING_WITHIN_TASK "0"
	
	set ::selected_tasks [sort_tasks ${tasks}]
	
    # print out ego info
    ego_gui
	debug "Using new Routines & tools"
    
	if {${input} == "" || ${output} == ""} {
        die "Must specify an input and output file"
    }
    if {![file exists ${input}]} {
        die "Input file does not exist"
    }

    log "Selected tasks : ${::selected_tasks}"

    if {[info exists ::env(HOME)]} {
        debug "HOME=$::env(HOME)"
    }
    if {[info exists ::env(USERPROFILE)]} {
        debug "USERPROFILE=$::env(USERPROFILE)"
    }
    if {[info exists ::env(PATH)]} {
        debug "PATH=$::env(PATH)"
    }
	# remove all previous files, etc
	set ::OUT_FILE [file join ${::OUT_DIR} ${::OUT_FILE}]	
    clean_up
	
	# Add the input OFW SHA1 to the DB
	if {${::SHADD} == "true"} {
	    debug "Adding the SHA1 of the Input PUP to the DB"
		sha1_check ${input}
	}

    # Check input OFW PUP SHA1
	if {${::SHCHK} == "true"} {
	    set catch [catch [sha1_verify ${input}]]
	    if {$catch == 1} {
		    log "Error!!"
			log "SHA1 of input PUP does not match any known SHA1"
			after 20000
			exit 0
		} elseif {$catch == 0} {
		    log "PUP SHA1 of input OFW matches known SHA1!"
		}
		unset catch
	}

	## ----------------------------------------------------------------------------------------- ##
	## --------------- UNPACK ALL FILES 'FIRST' IN THE 'ORIGINAL_PUP' DIR ---------------------- ##
	##
	#
    # PREPARE PS3UPDAT.PUP for modification
	# -- create the 'BUILD-DIR' path first, then
	# -- create the 'PS3MFW-OFW' dir
	log "Creating initial build directories..."	
	create_mfw_dir ${::BUILD_DIR}	
	create_mfw_dir ${::ORIGINAL_PUP_DIR}		
	
	## -- unpack the OFW PUP file.....
	log "Directorys creation completed!"	
    unpack_source_pup2 ${input} ${::ORIGINAL_PUP_DIR}	
	log "PUP Unpacked"
	# set the pup version into a variable so commands later can check it and do fw specific thingy's
	# save off the "OFW MAJOR.MINOR" into a global for usage throughout
	debug "Checking PUP Version"
    set ::SUF [::get_pup_version2 ${::ORIGINAL_VERSION_TXT}]	
	if { [regexp "(^\[0-9]{1,2})\.(\[0-9]{1,2})(.*)" $::SUF all ::OFW_MAJOR_VER ::OFW_MINOR_VER SubVerInfo] } {		
		set ::NEWMFW_VER [format "%.1d.%.2d" $::OFW_MAJOR_VER $::OFW_MINOR_VER]	
		if { $SubVerInfo != "" } {
			log "Getting pup version OK! var = ${::NEWMFW_VER} (subversion:$SubVerInfo)"
		} else { 
			log "Getting pup version OK! var = ${::NEWMFW_VER}"
		}		
	} else {
		die "Getting pup version FAILED! Exiting!"
	}
	
	# extract "custom_update.tar
    extract_tar2 ${::ORIGINAL_UPDATE_TAR} ${::ORIGINAL_UPDATE_DIR}
	
	# if firmware is >= 3.56 we need to extract
	# spkg_hdr.tar	
	if { ${::NEWMFW_VER} >= ${::OFW_2NDGEN_BASE} } {
		extract_tar2 ${::ORIGINAL_SPKG_TAR} ${::ORIGINAL_SPKG_DIR}
	}	
	# unpack devflash files	
	# (do this before the copy, so we have the unpacked
	#  flash files in the PS3OFW directory)
    log "Unpacking all dev_flash files (FAST)"
    unpkg_devflash_all2 ${::ORIGINAL_UPDATE_DIR} ${::ORIGINAL_DEVFLASH_DIR}	

	# unpack the CORE_OS files here, pass the 
	# SELF-SCE Headers array
	

	if {[string match "*patch_lv0*" ${::selected_tasks}]} {
		set ::DID_PATCHING_WITH_UNPACKING_WITHIN_TASK "1"
		debug "Preparing unpacking of lv0 loaders!"
		::unpack_coreos_files2 ${::ORIGINAL_PUP_DIR} LV0_SCE_HDRS
	}
	if {${::DID_PATCHING_WITH_UNPACKING_WITHIN_TASK} == "0"} {
		debug "Skipped some useless task..."
	}
	
	
	#::unpack_coreos_files2 ${::ORIGINAL_PUP_DIR} LV0_SCE_HDRS
	# Remove the # to the ::unpack_ ... to re-enable pre-unpack of core os and lv0 ldr's!
	#debug "Skipped some useless task..."
	
	### DO THE COPY HERE, SO WE HAVE A MIRROR OF ALL REQ'D
	### files in the 'PS3MFW-OFW' directory.
	# copy original UNPACKED PUP/assoc. files to working dir
	log "Copying unpacked OFW to MFW dirs..."	
    copy_dir ${::ORIGINAL_PUP_DIR} ${::CUSTOM_PUP_DIR}
	log "Copied"
	#
	### --------------------- END OF PRE-EXECUTION PREP-WORK ------------------- ###
	
	

	### ----------  !!! BEGIN EXECUTION OF MAIN TASKS !!!! --------------------- ###
	
    # Execute tasks
    foreach task ${::selected_tasks} {
        log "******** Running task: \"$task.tcl\" **********"
        eval [string map {- _} ${task}::main]
    }
    log "******** Completed tasks **********"
	
	### ----------  !!!! DONE EXEUCTION OF TASKS !!! --------------------------- ###
	
	#repack the CORE_OS files here, pass the 
	# SELF-SCE Headers array
	
	# Remove the # to the ::repack_coreos_... to re-enable the bs useless task whatever... do what you want ffs.
	
	if {[string match "*patch_lv0*" ${::selected_tasks}]} {
		set ::DID_PATCHING_WITH_UNPACKING_WITHIN_TASK "1"
		debug "Preparing repacking of lv0 loaders!"
		::repack_coreos_files2 LV0_SCE_HDRS
	}
	if {${::DID_PATCHING_WITH_UNPACKING_WITHIN_TASK} == "0"} {
		debug "Skipped the packing of core os and so on... (already packed)"
	}
	
	
    # RECREATE PS3UPDAT.PUP
    file delete -force ${::CUSTOM_DEVFLASH_DIR}
	debug "Custom dev_flash deleted"
	
	# if firmware is >= 3.56, we need to repack spkg files	
	if { ${::SUF} >= ${::OFW_2NDGEN_BASE} } {		
		set filesSPKG [lsort [glob -nocomplain -tails -directory ${::CUSTOM_SPKG_DIR} *.1]]
		debug "spkg's added to list"
	}
    set files [lsort [glob -nocomplain -tails -directory ${::CUSTOM_UPDATE_DIR} *.pkg]]
	debug "pkg's added to list"
    eval lappend files [lsort [glob -nocomplain -tails -directory ${::CUSTOM_UPDATE_DIR} *.img]]
	debug "img's added to list"
    eval lappend files [lsort [glob -nocomplain -tails -directory ${::CUSTOM_UPDATE_DIR} dev_flash3_*]]
	debug "dev_flash 3 added to list"
    eval lappend files [lsort [glob -nocomplain -tails -directory ${::CUSTOM_UPDATE_DIR} dev_flash_*]]
	debug "dev_flash added to list"
		
	
	# create the tar with the 'nodirs' flag, to assure 'directories' are NOT
	# included in the tar
	# '-nodirs' = do NOT include directories in tar file
	# do NOT specify 'nofinalpad', as we want the final .tar padded!
    create_tar2 ${::CUSTOM_UPDATE_TAR} ${::CUSTOM_UPDATE_DIR} ${files} -nodirs
	debug "PKG TAR created"	
	
	# if firmware is >= 3.56, we need to repack spkg files	
	# do NOT specify 'nofinalpad', as we want the final .tar padded!
	if { ${::NEWMFW_VER} >= ${::OFW_2NDGEN_BASE} } {				
		# create the SPKG tar
		# '-nodirs' = do NOT include directories in tar file
		create_tar2 ${::CUSTOM_SPKG_TAR} ${::CUSTOM_SPKG_DIR} ${filesSPKG} -nodirs
		debug "SPKG TAR created"
	}
	# cleanup any previous output builds
	set final_output "${::OUT_FILE}_$::OFW_MAJOR_VER.$::OFW_MINOR_VER.pup"
	catch_die {file delete -force -- ${::OUT_FILE}} "Could not cleanup output files"
	
	
	# finalize the completed PUP
    pack_custom_pup ${::CUSTOM_PUP_DIR} ${final_output}
}
}