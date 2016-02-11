#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Notes: Don't Try To Replace RCO Files Unless You Know What You Are Doing..

# Created By RazorX

# Priority: 18
# Description: Replace RCO Files (Normal)


# Option --rco-label::
# Option --rco-game: explore_category_game.rco
# Option --rco-friend: friendtrophy_plugin.rco
# Option --rco-friend2: friendtrophy_plugin_game.rco
# Option --rco-music: explore_category_music.rco
# Option --rco-photo: explore_category_photo.rco
# Option --rco-video: explore_category_video.rco
# Option --rco-full: explore_plugin_full.rco
# Option --rco-plugin-normal: xmb_plugin_normal.rco
# Option --rco-ingame: xmb_ingame.rco
# Option --rco-sysconf: explore_category_sysconf.rco
# Option --rco-label2::

# Type --rco-label: label {RCO Section}
# Type --rco-game: file open {"rco file" {rco}}
# Type --rco-friend: file open {"rco file" {rco}}
# Type --rco-friend2: file open {"rco file" {rco}}
# Type --rco-music: file open {"rco file" {rco}}
# Type --rco-photo: file open {"rco file" {rco}}
# Type --rco-video: file open {"rco file" {rco}}
# Type --rco-full: file open {"rco file" {rco}}
# Type --rco-plugin-normal: file open {"rco file" {rco}}
# Type --rco-ingame: file open {"rco file" {rco}}
# Type --rco-sysconf: file open {"rco file" {rco}}
# Type --rco-label2: label {RCO Section}

namespace eval change_rco_files {

    array set ::change_rco_files::options {
	
		--rco-label "---------------------------------- Welcome To The RCO Section --------------------------------   : :"
        --rco-game "/path/to/file"
		--rco-friend "/path/to/file"
		--rco-friend2 "/path/to/file"
		--rco-music "/path/to/file"
		--rco-photo "/path/to/file"
		--rco-video "/path/to/file"
        --rco-full "/path/to/file"
        --rco-plugin-normal "/path/to/file"
        --rco-ingame "/path/to/file"
        --rco-sysconf "/path/to/file"
		--rco-label2 "--------------------------------------------------------------------------------------------------------------   : :"
    }

    proc main {} {
        variable options

        set rco_game [file join dev_flash vsh resource explore_category_game.rco]
		set rco_friend [file join dev_flash vsh resource friendtrophy_plugin.rco]
		set rco_friend2 [file join dev_flash vsh resource friendtrophy_plugin_game.rco]
		set rco_music [file join dev_flash vsh resource explore_category_music.rco]
		set rco_photo [file join dev_flash vsh resource explore_category_photo.rco]
		set rco_video [file join dev_flash vsh resource explore_category_video.rco]
        set rco_full [file join dev_flash vsh resource explore_plugin_full.rco]
		set rco_plugin_normal [file join dev_flash vsh resource xmb_plugin_normal.rco]
		set rco_ingame [file join dev_flash vsh resource xmb_ingame.rco]
		set rco_sysconf [file join dev_flash vsh resource explore_category_sysconf.rco]

        if {[file exists $options(--rco-game)] == 0 } {
            log "Skipping rco_game, $options(--rco-game) does not exist"
        } else {
            ::modify_devflash_file ${rco_game} ::change_rco_files::copy_rco_file $::change_rco_files::options(--rco-game)
        }
		
		if {[file exists $options(--rco-friend)] == 0 } {
            log "Skipping rco_friend, $options(--rco-friend) does not exist"
        } else {
            ::modify_devflash_file ${rco_friend} ::change_rco_files::copy_rco_file $::change_rco_files::options(--rco-friend)
        }
		
		if {[file exists $options(--rco-friend2)] == 0 } {
            log "Skipping rco_friend2, $options(--rco-friend2) does not exist"
        } else {
            ::modify_devflash_file ${rco_friend2} ::change_rco_files::copy_rco_file $::change_rco_files::options(--rco-friend2)
        }
		
		if {[file exists $options(--rco-music)] == 0 } {
            log "Skipping rco_music, $options(--rco-music) does not exist"
        } else {
            ::modify_devflash_file ${rco_music} ::change_rco_files::copy_rco_file $::change_rco_files::options(--rco-music)
        }
		
		if {[file exists $options(--rco-photo)] == 0 } {
            log "Skipping rco_photo, $options(--rco-photo) does not exist"
        } else {
            ::modify_devflash_file ${rco_photo} ::change_rco_files::copy_rco_file $::change_rco_files::options(--rco-photo)
        }
		
		if {[file exists $options(--rco-video)] == 0 } {
            log "Skipping rco_video, $options(--rco-video) does not exist"
        } else {
            ::modify_devflash_file ${rco_video} ::change_rco_files::copy_rco_file $::change_rco_files::options(--rco-video)
        }

        if {[file exists $options(--rco-full)] == 0 } {
            log "Skipping rco_full, $options(--rco-full) does not exist"
        } else {
            ::modify_devflash_file ${rco_full} ::change_rco_files::copy_rco_file $::change_rco_files::options(--rco-full)
        }
		
		if {[file exists $options(--rco-plugin-normal)] == 0 } {
            log "Skipping rco_plugin_normal, $options(--rco-plugin-normal) does not exist"
        } else {
            ::modify_devflash_file ${rco_plugin_normal} ::change_rco_files::copy_rco_file $::change_rco_files::options(--rco-plugin-normal)
        }
		
		if {[file exists $options(--rco-ingame)] == 0 } {
            log "Skipping rco_ingame, $options(--rco-ingame) does not exist"
        } else {
            ::modify_devflash_file ${rco_ingame} ::change_rco_files::copy_rco_file $::change_rco_files::options(--rco-ingame)
        }
		
		if {[file exists $options(--rco-sysconf)] == 0 } {
            log "Skipping rco_sysconf, $options(--rco-sysconf) does not exist"
        } else {
            ::modify_devflash_file ${rco_sysconf} ::change_rco_files::copy_rco_file $::change_rco_files::options(--rco-sysconf)
        }
    }

    proc copy_rco_file { dst src } {
        if {[file exists $src] == 0} {
            die "$src does not exist"
        } else {
            if {[file exists $dst] == 0} {
                die "$dst does not exist"
            } else {
                log "Replacing default rco file [file tail $dst] with [file tail $src]"
                copy_file -force $src $dst
            }
        }
    }
}
