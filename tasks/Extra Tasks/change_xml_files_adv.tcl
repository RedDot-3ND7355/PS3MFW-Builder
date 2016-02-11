#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Notes: Don't Try To Replace XML Files Unless You Know What You Are Doing..

# Created By RazorX

# Priority: 18
# Description: Replace XML Files (Advanced)


# Option --xml-label::
# Option --category-avc-photo: category_avc_photo.xml
# Option --category-friend: category_friend.xml
# Option --category-friend-shop: category_friend_shop.xml
# Option --category-game: category_game.xml
# Option --category-game-tool2: category_game_tool2.xml
# Option --category-music: category_music.xml
# Option --category-network: category_network.xml
# Option --category-network-shop: category_network_shop.xml
# Option --category-network-tool2: category_network_tool2.xml
# Option --category-photo: category_photo.xml
# Option --category-psn: category_psn.xml
# Option --category-sysconf: category_sysconf.xml
# Option --category-sysconf-shop: category_sysconf_shop.xml
# Option --category-tv: category_tv.xml
# Option --category-user: category_user.xml
# Option --category-user-login: category_user_login.xml
# Option --category-user-shop: category_user_shop.xml
# Option --category-video: category_video.xml
# Option --category-video-bdponly: category_video_bdponly.xml
# Option --category-widget: category_widget.xml
# Option --download-list: download_list.xml
# Option --playlist: playlist.xml
# Option --registory: registory.xml
# Option --savedata-list: savedata_list.xml
# Option --upload-list: upload_list.xml
# Option --videodownloader-list: videodownloader_list.xml
# Option --xml-label1::

# Type --xml-label: label {XML Section}
# Type --category-avc-photo: file open {"xml file" {xml}}
# Type --category-friend: file open {"xml file" {xml}}
# Type --category-friend-shop: file open {"xml file" {xml}}
# Type --category-game: file open {"xml file" {xml}}
# Type --category-game-tool2: file open {"xml file" {xml}}
# Type --category-music: file open {"xml file" {xml}}
# Type --category-network: file open {"xml file" {xml}}
# Type --category-network-shop: file open {"xml file" {xml}}
# Type --category-network-tool2: file open {"xml file" {xml}}
# Type --category-photo: file open {"xml file" {xml}}
# Type --category-psn: file open {"xml file" {xml}}
# Type --category-sysconf: file open {"xml file" {xml}}
# Type --category-sysconf-shop: file open {"xml file" {xml}}
# Type --category-tv: file open {"xml file" {xml}}
# Type --category-user: file open {"xml file" {xml}}
# Type --category-user-login: file open {"xml file" {xml}}
# Type --category-user-shop: file open {"xml file" {xml}}
# Type --category-video: file open {"xml file" {xml}}
# Type --category-video-bdponly: file open {"xml file" {xml}}
# Type --category-widget: file open {"xml file" {xml}}
# Type --download-list: file open {"xml file" {xml}}
# Type --playlist: file open {"xml file" {xml}}
# Type --registory: file open {"xml file" {xml}}
# Type --savedata-list: file open {"xml file" {xml}}
# Type --upload-list: file open {"xml file" {xml}}
# Type --videodownloader-list: file open {"xml file" {xml}}
# Type --xml-label1: label {XML Section}

namespace eval change_xml_files_adv {

    array set ::change_xml_files_adv::options {
	
		--xml-label "---------------------------------- Welcome To The XML Section --------------------------------   : :"
		--category-avc-photo "/path/to/file"
		--category-friend "/path/to/file"
		--category-friend-shop "/path/to/file"
		--category-game "/path/to/file"
		--category-game-tool2 "/path/to/file"
		--category-music "/path/to/file"
		--category-network "/path/to/file"
		--category-network-shop "/path/to/file"
		--category-network-tool2 "/path/to/file"
		--category-photo "/path/to/file"
		--category-psn "/path/to/file"
		--category-sysconf "/path/to/file"
		--category-sysconf-shop "/path/to/file"
		--category-tv "/path/to/file"
		--category-user "/path/to/file"
		--category-user-login "/path/to/file"
		--category-user-shop "/path/to/file"
		--category-video "/path/to/file"
		--category-video-bdponly "/path/to/file"
		--category-widget "/path/to/file"
		--download-list "/path/to/file"
		--playlist "/path/to/file"
		--registory "/path/to/file"
		--savedata-list "/path/to/file"
		--upload-list "/path/to/file"
		--videodownloader-list "/path/to/file"
		--xml-label1 "-------------------------------------------------------------------------------------------------------------   : :"
    }

    proc main {} {
        variable options

        set category_avc_photo [file join dev_flash vsh resource explore xmb category_avc_photo.xml]
        set category_friend [file join dev_flash vsh resource explore xmb category_friend.xml]
        set category_friend_shop [file join dev_flash vsh resource explore xmb category_friend_shop.xml]
        set category_game [file join dev_flash vsh resource explore xmb category_game.xml]
        set category_game_tool2 [file join dev_flash vsh resource explore xmb category_game_tool2.xml]
        set category_music [file join dev_flash vsh resource explore xmb category_music.xml]
        set category_network [file join dev_flash vsh resource explore xmb category_network.xml]
        set category_network_shop [file join dev_flash vsh resource explore xmb category_network_shop.xml]
        set category_network_tool2 [file join dev_flash vsh resource explore xmb category_network_tool2.xml]
        set category_photo [file join dev_flash vsh resource explore xmb category_photo.xml]
        set category_psn [file join dev_flash vsh resource explore xmb category_psn.xml]
        set category_sysconf [file join dev_flash vsh resource explore xmb category_sysconf.xml]
        set category_sysconf_shop [file join dev_flash vsh resource explore xmb category_sysconf_shop.xml]
        set category_tv [file join dev_flash vsh resource explore xmb category_tv.xml]
        set category_user [file join dev_flash vsh resource explore xmb category_user.xml]
        set category_user_login [file join dev_flash vsh resource explore xmb category_user_login.xml]
        set category_user_shop [file join dev_flash vsh resource explore xmb category_user_shop.xml]
        set category_video [file join dev_flash vsh resource explore xmb category_video.xml]
        set category_video_bdponly [file join dev_flash vsh resource explore xmb category_video_bdponly.xml]
        set category_widget [file join dev_flash vsh resource explore xmb category_widget.xml]
        set download_list [file join dev_flash vsh resource explore xmb download_list.xml]
        set playlist [file join dev_flash vsh resource explore xmb playlist.xml]
        set registory [file join dev_flash vsh resource explore xmb registory.xml]
        set savedata_list [file join dev_flash vsh resource explore xmb savedata_list.xml]
        set upload_list [file join dev_flash vsh resource explore xmb upload_list.xml]
        set videodownloader_list [file join dev_flash vsh resource explore xmb videodownloader_list.xml]

        if {[file exists $options(--category-avc-photo)] == 0 } {
            log "Skipping category_avc_photo, $options(--category-avc-photo) does not exist"
        } else {
            ::modify_devflash_file ${category_avc_photo} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-avc-photo)
        }
		
		if {[file exists $options(--category-friend)] == 0 } {
            log "Skipping category_friend, $options(--category-friend) does not exist"
        } else {
            ::modify_devflash_file ${category_friend} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-friend)
        }
		
		if {[file exists $options(--category-friend-shop)] == 0 } {
            log "Skipping category_friend_shop, $options(--category-friend-shop) does not exist"
        } else {
            ::modify_devflash_file ${category_friend_shop} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-friend-shop)
        }
		
		if {[file exists $options(--category-game)] == 0 } {
            log "Skipping category_game, $options(--category-game) does not exist"
        } else {
            ::modify_devflash_file ${category_game} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-game)
        }
		
		if {[file exists $options(--category-game-tool2)] == 0 } {
            log "Skipping category_game_tool2, $options(--category-game-tool2) does not exist"
        } else {
            ::modify_devflash_file ${category_game_tool2} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-game-tool2)
        }
		
		if {[file exists $options(--category-music)] == 0 } {
            log "Skipping category_music, $options(--category-music) does not exist"
        } else {
            ::modify_devflash_file ${category_music} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-music)
        }

        if {[file exists $options(--category-network)] == 0 } {
            log "Skipping category_network, $options(--category-network) does not exist"
        } else {
            ::modify_devflash_file ${category_network} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-network)
        }
		
		if {[file exists $options(--category-network-shop)] == 0 } {
            log "Skipping category_network_shop, $options(--category-network-shop) does not exist"
        } else {
            ::modify_devflash_file ${category_network_shop} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-network-shop)
        }
		
		if {[file exists $options(--category-network-tool2)] == 0 } {
            log "Skipping category_network_tool2, $options(--category-network-tool2) does not exist"
        } else {
            ::modify_devflash_file ${category_network_tool2} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-network-tool2)
        }
		
		if {[file exists $options(--category-photo)] == 0 } {
            log "Skipping category_photo, $options(--category-photo) does not exist"
        } else {
            ::modify_devflash_file ${category_photo} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-photo)
        }
		
		if {[file exists $options(--category-psn)] == 0 } {
            log "Skipping category_psn, $options(--category-psn) does not exist"
        } else {
            ::modify_devflash_file ${category_psn} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-psn)
        }
		
		if {[file exists $options(--category-sysconf)] == 0 } {
            log "Skipping category_sysconf, $options(--category-sysconf) does not exist"
        } else {
            ::modify_devflash_file ${category_sysconf} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-sysconf)
        }
		
		if {[file exists $options(--category-sysconf-shop)] == 0 } {
            log "Skipping category_sysconf_shop, $options(--category-sysconf-shop) does not exist"
        } else {
            ::modify_devflash_file ${category_sysconf_shop} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-sysconf-shop)
        }
		
		if {[file exists $options(--category-tv)] == 0 } {
            log "Skipping category_tv, $options(--category-tv) does not exist"
        } else {
            ::modify_devflash_file ${category_tv} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-tv)
        }
		
		if {[file exists $options(--category-user)] == 0 } {
            log "Skipping category_user, $options(--category-user) does not exist"
        } else {
            ::modify_devflash_file ${category_user} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-user)
        }
		
		if {[file exists $options(--category-user-login)] == 0 } {
            log "Skipping category_user_login, $options(--category-user-login) does not exist"
        } else {
            ::modify_devflash_file ${category_user_login} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-user-login)
        }
		
		if {[file exists $options(--category-user-shop)] == 0 } {
            log "Skipping category_user_shop, $options(--category-user-shop) does not exist"
        } else {
            ::modify_devflash_file ${category_user_shop} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-user-shop)
        }

        if {[file exists $options(--category-video)] == 0 } {
            log "Skipping category_video, $options(--category-video) does not exist"
        } else {
            ::modify_devflash_file ${category_video} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-video)
        }
		
		if {[file exists $options(--category-video-bdponly)] == 0 } {
            log "Skipping category_video_bdponly, $options(--category-video-bdponly) does not exist"
        } else {
            ::modify_devflash_file ${category_video_bdponly} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-video-bdponly)
        }
		
		if {[file exists $options(--category-widget)] == 0 } {
            log "Skipping category_widget, $options(--category-widget) does not exist"
        } else {
            ::modify_devflash_file ${category_widget} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--category-widget)
        }
		
		if {[file exists $options(--download-list)] == 0 } {
            log "Skipping download_list, $options(--download-list) does not exist"
        } else {
            ::modify_devflash_file ${download_list} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--download-list)
        }
		
		if {[file exists $options(--playlist)] == 0 } {
            log "Skipping playlist, $options(--playlist) does not exist"
        } else {
            ::modify_devflash_file ${playlist} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--playlist)
        }
		
		if {[file exists $options(--registory)] == 0 } {
            log "Skipping registory, $options(--registory) does not exist"
        } else {
            ::modify_devflash_file ${registory} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--registory)
        }
		
		if {[file exists $options(--savedata-list)] == 0 } {
            log "Skipping savedata_list, $options(--savedata-list) does not exist"
        } else {
            ::modify_devflash_file ${savedata_list} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--savedata-list)
        }
		
		if {[file exists $options(--upload-list)] == 0 } {
            log "Skipping upload_list, $options(--upload-list) does not exist"
        } else {
            ::modify_devflash_file ${upload_list} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--upload-list)
        }
		
		if {[file exists $options(--videodownloader-list)] == 0 } {
            log "Skipping videodownloader_list, $options(--videodownloader-list) does not exist"
        } else {
            ::modify_devflash_file ${videodownloader_list} ::change_xml_files_adv::copy_xml_file_adv $::change_xml_files_adv::options(--videodownloader-list)
        }
    }

    proc copy_xml_file_adv { dst src } {
        if {[file exists $src] == 0} {
            die "$src does not exist"
        } else {
            if {[file exists $dst] == 0} {
                die "$dst does not exist"
            } else {
                log "Replacing default xml file [file tail $dst] with [file tail $src]"
                copy_file -force $src $dst
            }
        }
    }
}
