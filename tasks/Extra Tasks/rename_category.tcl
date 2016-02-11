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

# Priority: 203
# Description: Rename XMB Categories

# Option --spoof-label::
# Option --spoof-label1::
# Option --spoof-label2::
# Option --spoof-label3::
# Option --spoof-label4::
# Option --rename-settings: Enter New Settings Name
# Option --rename-photo: Enter New Photo Name
# Option --rename-music: Enter New Music Name
# Option --rename-game: Enter New Game Name
# Option --rename-network: Enter New Network Name
# Option --rename-friends: Enter New Friends Name
# Option --rename-users: Enter New Users Name
# Option --rename-login: Enter New Log In Name
# Option --rename-tv-vid: Enter New TV/Video Services Name (4.xx)
# Option --rename-video: Enter New Video Name
# Option --rename-tv: Enter New TV Name
# Option --rename-psn: Enter New PSN Name (4.50)
# Option --rename-off: Enter New Turn Off System Name
# Option --rename-update: Enter New System Update Name
# Option --rename-app-home: Enter New /app_home/PS3_GAME/ Name
# Option --spoof-label5::

# Type --spoof-label: label {Category Section}
# Type --spoof-label1: label {Space}
# Type --spoof-label2: label {Info}
# Type --spoof-label3: label {Info}
# Type --spoof-label4: label {Space}
# Type --rename-settings: string
# Type --rename-photo: string
# Type --rename-music: string
# Type --rename-game: string
# Type --rename-network: string
# Type --rename-friends: string
# Type --rename-users: string
# Type --rename-login: string
# Type --rename-tv-vid: string
# Type --rename-video: string
# Type --rename-tv: string
# Type --rename-psn: string
# Type --rename-off: string
# Type --rename-update: string
# Type --rename-app-home: string
# Type --spoof-label5: label {Category Section}


namespace eval ::rename_category {

    array set ::rename_category::options {
		--spoof-label "------------------------------- Welcome To The Category Section -----------------------------   : :"
	    --spoof-label1 "                                                                                                                                                    : :"
	    --spoof-label2 "                    Welcome To The Category Section Here You Can Rename                     : :"
	    --spoof-label3 "                                               Various Different Categories.                                                : :"
	    --spoof-label4 "                                                                                                                                                   : :"
		--rename-settings ""
		--rename-photo ""
		--rename-music ""
		--rename-game ""
		--rename-network ""
		--rename-friends ""
		--rename-users ""
		--rename-login ""
		--rename-tv-vid ""
		--rename-video ""
		--rename-tv ""
		--rename-psn ""
		--rename-off ""
		--rename-update ""
		--rename-app-home ""
		--spoof-label5 "--------------------------------------------------------------------------------------------------------------   : :"
    }

    proc main {} {
	variable options
	
		set EXPLORE_PLUGIN_FULL_RCO [file join dev_flash vsh resource explore_plugin_full.rco]
		set EXPLORE_CATEGORY_SYSCONF_RCO [file join dev_flash vsh resource explore_category_sysconf.rco]
		set EXPLORE_CATEGORY_GAME_RCO [file join dev_flash vsh resource explore_category_game.rco]
		set CATEGORY_SETTING_PLUGIN_RCO [file join dev_flash vsh resource category_setting_plugin.rco]
		set XMB_INGAME_RCO [file join dev_flash vsh resource xmb_ingame.rco]
		
		if {$::rename_category::options(--rename-settings) != ""} {
		modify_rco_file $EXPLORE_PLUGIN_FULL_RCO ::rename_category::callback_settings
		modify_rco_file $XMB_INGAME_RCO ::rename_category::callback_settings
		modify_rco_file $EXPLORE_CATEGORY_SYSCONF_RCO ::rename_category::callback_settings
		modify_rco_file $CATEGORY_SETTING_PLUGIN_RCO ::rename_category::callback_settings
		}
		
		if {$::rename_category::options(--rename-photo) != ""} {
		modify_rco_file $EXPLORE_PLUGIN_FULL_RCO ::rename_category::callback_photo
		modify_rco_file $XMB_INGAME_RCO ::rename_category::callback_photo
		modify_rco_file $EXPLORE_CATEGORY_SYSCONF_RCO ::rename_category::callback_photo
		}

		if {$::rename_category::options(--rename-music) != ""} {
		modify_rco_file $EXPLORE_PLUGIN_FULL_RCO ::rename_category::callback_music
		modify_rco_file $XMB_INGAME_RCO ::rename_category::callback_music
		modify_rco_file $EXPLORE_CATEGORY_SYSCONF_RCO ::rename_category::callback_music
		}
		
		if {$::rename_category::options(--rename-game) != ""} {
		modify_rco_file $EXPLORE_PLUGIN_FULL_RCO ::rename_category::callback_game
		modify_rco_file $XMB_INGAME_RCO ::rename_category::callback_game
		modify_rco_file $EXPLORE_CATEGORY_SYSCONF_RCO ::rename_category::callback_game
		}
		
		if {$::rename_category::options(--rename-network) != ""} {
		modify_rco_file $EXPLORE_PLUGIN_FULL_RCO ::rename_category::callback_network
		modify_rco_file $XMB_INGAME_RCO ::rename_category::callback_network
		modify_rco_file $EXPLORE_CATEGORY_SYSCONF_RCO ::rename_category::callback_network
		}
		
		if {$::rename_category::options(--rename-friends) != ""} {
		modify_rco_file $EXPLORE_PLUGIN_FULL_RCO ::rename_category::callback_friends
		modify_rco_file $XMB_INGAME_RCO ::rename_category::callback_friends
		modify_rco_file $EXPLORE_CATEGORY_SYSCONF_RCO ::rename_category::callback_friends
		}
		
		if {$::rename_category::options(--rename-users) != ""} {
		modify_rco_file $EXPLORE_PLUGIN_FULL_RCO ::rename_category::callback_users
		modify_rco_file $XMB_INGAME_RCO ::rename_category::callback_users
		modify_rco_file $EXPLORE_CATEGORY_SYSCONF_RCO ::rename_category::callback_users
		}
		
		if {$::rename_category::options(--rename-login) != ""} {
		modify_rco_file $EXPLORE_PLUGIN_FULL_RCO ::rename_category::callback_login
		modify_rco_file $XMB_INGAME_RCO ::rename_category::callback_login
		}
		
		if {$::rename_category::options(--rename-tv-vid) != ""} {
		modify_rco_file $EXPLORE_PLUGIN_FULL_RCO ::rename_category::callback_tv_vid
		modify_rco_file $XMB_INGAME_RCO ::rename_category::callback_tv_vid
		}
		
		if {$::rename_category::options(--rename-video) != ""} {
		modify_rco_file $EXPLORE_PLUGIN_FULL_RCO ::rename_category::callback_video
		modify_rco_file $XMB_INGAME_RCO ::rename_category::callback_video
		modify_rco_file $EXPLORE_CATEGORY_SYSCONF_RCO ::rename_category::callback_video
		}
		
		if {$::rename_category::options(--rename-tv) != ""} {
		modify_rco_file $EXPLORE_PLUGIN_FULL_RCO ::rename_category::callback_tv
		modify_rco_file $XMB_INGAME_RCO ::rename_category::callback_tv
		}
		
		if {$::rename_category::options(--rename-psn) != ""} {
		modify_rco_file $EXPLORE_PLUGIN_FULL_RCO ::rename_category::callback_psn
		modify_rco_file $EXPLORE_CATEGORY_GAME_RCO ::rename_category::callback_psn
		}
		
		if {$::rename_category::options(--rename-off) != ""} {
		modify_rco_file $EXPLORE_PLUGIN_FULL_RCO ::rename_category::callback_off
		modify_rco_file $EXPLORE_CATEGORY_GAME_RCO ::rename_category::callback_off
		}
		
		if {$::rename_category::options(--rename-update) != ""} {
		modify_rco_file $EXPLORE_CATEGORY_SYSCONF_RCO ::rename_category::callback_update
		modify_rco_file $CATEGORY_SETTING_PLUGIN_RCO ::rename_category::callback_update
		}
		
		if {$::rename_category::options(--rename-app-home) != ""} {
		modify_rco_file $EXPLORE_PLUGIN_FULL_RCO ::rename_category::callback_rename
		modify_rco_file $EXPLORE_CATEGORY_GAME_RCO ::rename_category::callback_rename
		}
	}
	
	proc callback_settings {path args} {
			log "Patching English.xml for Settings in [file tail $path]"
			sed_in_place [file join $path English.xml] "Settings" $::rename_category::options(--rename-settings)
			
			log "Patching unknown0x12.xml for Settings in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "Settings" $::rename_category::options(--rename-settings)
	}
	
	proc callback_photo {path args} {
			log "Patching English.xml for Photo in [file tail $path]"
			sed_in_place [file join $path English.xml] "Photo" $::rename_category::options(--rename-photo)
			
			log "Patching unknown0x12.xml for Photo in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "Photo" $::rename_category::options(--rename-photo)
	}
	
	proc callback_music {path args} {
			log "Patching English.xml for Photo in [file tail $path]"
			sed_in_place [file join $path English.xml] "Music" $::rename_category::options(--rename-music)
	
			log "Patching unknown0x12.xml for Music in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "Music" $::rename_category::options(--rename-music)
			
	}
	
	proc callback_game {path args} {
			log "Patching English.xml for Game in [file tail $path]"
			sed_in_place [file join $path English.xml] "Game" $::rename_category::options(--rename-game)
			
			log "Patching unknown0x12.xml for Game in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "Game" $::rename_category::options(--rename-game)
	}
	
	proc callback_network {path args} {
			log "Patching English.xml for Network in [file tail $path]"
			sed_in_place [file join $path English.xml] "Network" $::rename_category::options(--rename-network)
			
			log "Patching unknown0x12.xml for Network in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "Network" $::rename_category::options(--rename-network)
	}
	
	proc callback_friends {path args} {
			log "Patching English.xml for Friends in [file tail $path]"
			sed_in_place [file join $path English.xml] "Friends" $::rename_category::options(--rename-friends)
			
			log "Patching unknown0x12.xml for Friends in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "Friends" $::rename_category::options(--rename-friends)
	}
	
	proc callback_users {path args} {
			log "Patching English.xml for Users in [file tail $path]"
			sed_in_place [file join $path English.xml] "Users" $::rename_category::options(--rename-users)
			
			log "Patching unknown0x12.xml for Users in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "Users" $::rename_category::options(--rename-users)
	}
	
	proc callback_login {path args} {
			log "Patching English.xml for Log In in [file tail $path]"
			sed_in_place [file join $path English.xml] "Log In" $::rename_category::options(--rename-login)
			
			log "Patching unknown0x12.xml for Log In in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "Log In" $::rename_category::options(--rename-login)
	}
	
	proc callback_tv_vid {path args} {
			log "Patching English.xml for TV/Video Services in [file tail $path]"
			sed_in_place [file join $path English.xml] "TV/Video Services" $::rename_category::options(--rename-tv-vid)
			
			log "Patching unknown0x12.xml for TV/Video Services in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "TV/Video Services" $::rename_category::options(--rename-tv-vid)
	}
	
	proc callback_video {path args} {
			log "Patching English.xml for Video in [file tail $path]"
			sed_in_place [file join $path English.xml] "Video" $::rename_category::options(--rename-video)
			
			log "Patching unknown0x12.xml for Video in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "Video" $::rename_category::options(--rename-video)
	}
	
	proc callback_tv {path args} {
			log "Patching English.xml for TV in [file tail $path]"
			sed_in_place [file join $path English.xml] "TV" $::rename_category::options(--rename-tv)
			
			log "Patching unknown0x12.xml for TV in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "TV" $::rename_category::options(--rename-tv)
	}
	
	proc callback_psn {path args} {
			log "Patching English.xml for PSN in [file tail $path]"
			sed_in_place [file join $path English.xml] "PSN" $::rename_category::options(--rename-psn)
			
			log "Patching unknown0x12.xml for PSN in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "PSN" $::rename_category::options(--rename-psn)
	}
	
	proc callback_off {path args} {
			log "Patching English.xml for Turn Off System in [file tail $path]"
			sed_in_place [file join $path English.xml] "Turn Off System" $::rename_category::options(--rename-off)
			
			log "Patching unknown0x12.xml for Turn Off System in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "Turn Off System" $::rename_category::options(--rename-off)
	}
	
	proc callback_update {path args} {
			log "Patching English.xml for System Update in [file tail $path]"
			sed_in_place [file join $path English.xml] "System Update" $::rename_category::options(--rename-update)
			
			log "Patching unknown0x12.xml for System Update in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "System Update" $::rename_category::options(--rename-update)
	}
	
	proc callback_rename {path args} {
			log "Patching English.xml for /app_home/PS3_GAME/ in [file tail $path]"
			sed_in_place [file join $path English.xml] "/app_home/PS3_GAME/" $::rename_category::options(--rename-app-home)
        
			log "Patching German.xml for /app_home/PS3_GAME/ in [file tail $path]"
			sed_in_place [file join $path German.xml] "/app_home/PS3_GAME/" $::rename_category::options(--rename-app-home)
        
			log "Patching Korean.xml for /app_home/PS3_GAME/ in [file tail $path]"
			sed_in_place [file join $path Korean.xml] "/app_home/PS3_GAME/" $::rename_category::options(--rename-app-home)
        
			log "Patching Russian.xml for /app_home/PS3_GAME/ in [file tail $path]"
			sed_in_place [file join $path Russian.xml] "/app_home/PS3_GAME/" $::rename_category::options(--rename-app-home)
        
			log "Patching Swedish.xml for /app_home/PS3_GAME/ in [file tail $path]"
			sed_in_place [file join $path Swedish.xml] "/app_home/PS3_GAME/" $::rename_category::options(--rename-app-home)
        
			log "Patching Spanish.xml for /app_home/PS3_GAME/ in [file tail $path]"
			sed_in_place [file join $path Spanish.xml] "/app_home/PS3_GAME/" $::rename_category::options(--rename-app-home)
        
			log "Patching Portugese.xml for /app_home/PS3_GAME/ in [file tail $path]"
			sed_in_place [file join $path Portugese.xml] "/app_home/PS3_GAME/" $::rename_category::options(--rename-app-home)
        
			log "Patching Norwegian.xml for /app_home/PS3_GAME/ in [file tail $path]"
			sed_in_place [file join $path Norwegian.xml] "/app_home/PS3_GAME/" $::rename_category::options(--rename-app-home)
        
			log "Patching Japanese.xml for /app_home/PS3_GAME/ in [file tail $path]"
			sed_in_place [file join $path Japanese.xml] "/app_home/PS3_GAME/" $::rename_category::options(--rename-app-home)
        
			log "Patching Italian.xml for /app_home/PS3_GAME/ in [file tail $path]"
			sed_in_place [file join $path Italian.xml] "/app_home/PS3_GAME/" $::rename_category::options(--rename-app-home)
        
			log "Patching French.xml for /app_home/PS3_GAME/ in [file tail $path]"
			sed_in_place [file join $path French.xml] "/app_home/PS3_GAME/" $::rename_category::options(--rename-app-home)
        
			log "Patching Finnish.xml for /app_home/PS3_GAME/ in [file tail $path]"
			sed_in_place [file join $path Finnish.xml] "/app_home/PS3_GAME/" $::rename_category::options(--rename-app-home)
        
			log "Patching Dutch.xml for /app_home/PS3_GAME/ in [file tail $path]"
			sed_in_place [file join $path Dutch.xml] "/app_home/PS3_GAME/" $::rename_category::options(--rename-app-home)
        
			log "Patching Danish.xml for /app_home/PS3_GAME/ in [file tail $path]"
			sed_in_place [file join $path Danish.xml] "/app_home/PS3_GAME/" $::rename_category::options(--rename-app-home)
        
			log "Patching ChineseTrad.xml for /app_home/PS3_GAME/ in [file tail $path]"
			sed_in_place [file join $path ChineseTrad.xml] "/app_home/PS3_GAME/" $::rename_category::options(--rename-app-home)
        
			log "Patching ChineseSimpl.xml for /app_home/PS3_GAME/ in [file tail $path]"
			sed_in_place [file join $path ChineseSimpl.xml] "/app_home/PS3_GAME/" $::rename_category::options(--rename-app-home)
			
			log "Patching unknown0x12.xml for /app_home/PS3_GAME/ in [file tail $path]"
			sed_in_place [file join $path unknown0x12.xml] "/app_home/PS3_GAME/" $::rename_category::options(--rename-app-home)
	}
}