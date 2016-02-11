#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
# (C) haxxxen

# Priority: 20
# Description: DEX 3.55 MFW Mod

# Option --allow-offline-activation: Patch selfs to allow Activation of PSN-Content Offline
# Option --patch-pnp: Patch DEX lv1/lv2 for Peek & Poke
# Option --patch-ps2emu: Patch selfs to Enable FSM PS2 Compatibility
# Option --patch-pup-search-in-game-disc: Disable searching for Update Packages in GAME Disc.
# Option --patch-nas-plugin: Patch Package Installer for different types
# Option --allow-unsigned-app: Patch to allow running of unsigned applications
# Option --patch-privacy: Patch DEX selfs to enable Privacy

# Type --allow-offline-activation: combobox {{RETAIL 3.41} {RETAIL 3.55} {REBUG 3.41.3} {REBUG 3.55.2} {DEX 3.55}}
# Type --patch-pnp: boolean
# Type --patch-ps2emu: boolean
# Type --patch-pup-search-in-game-disc: boolean
# Type --patch-nas-plugin: boolean
# Type --allow-unsigned-app: boolean
# Type --patch-privacy: boolean

namespace eval ::dex_mod {

    array set ::dex_mod::options {
        --allow-offline-activation "DEX 3.55"
        --patch-pnp true
        --patch-ps2emu true
        --patch-pup-search-in-game-disc true
        --patch-nas-plugin true
        --allow-unsigned-app true
        --patch-privacy false
    }
    proc main {} {
        variable options
        set self [file join dev_flash vsh module vsh.self]
		if {$::dex_mod::options(--allow-offline-activation) == "DEX 3.55"} {
			log "NOTE: You will need reActPSN_2.0.pkg to activate PSN® Content" 1
            set selfs {vsh.self}
            
			::modify_devflash_files [file join dev_flash vsh module] $selfs ::dex_mod::patch_355debug_self_rbgme
		
		
		
		}
		if {$::dex_mod::options(--allow-offline-activation) == "REBUG 3.55.2"} {
			log "NOTE: You will need reActPSN_2.0.pkg to activate PSN® Content" 1
            set selfs {vsh.self vsh.self.cexsp vsh.self.swp}
        
    		::modify_devflash_files [file join dev_flash vsh module] $selfs ::dex_mod::patch_355debug_self_rbgme
		
		
		
		}
        if {$::dex_mod::options(--patch-pnp)} {
        set lv1 "lv1.self"
        
		::modify_coreos_file $lv1 ::dex_mod::patch_lv1
		
		
		
        set lv2 "lv2_kernel.self"
        
		::modify_coreos_file $lv2 ::dex_mod::patch_lv2
		
		
		
        }
        if {$::dex_mod::options(--patch-ps2emu)} {
        set sprxa [file join dev_flash vsh module game_ext_plugin.sprx]
		  ::modify_devflash_file ${sprxa} ::dex_mod::patch_gamext_self
        set sprxb [file join dev_flash vsh module sysconf_plugin.sprx]
		  ::modify_devflash_file ${sprxb} ::dex_mod::patch_sysconf_self
        }
        if {$::dex_mod::options(--patch-pup-search-in-game-disc)} {
			set selfa "emer_init.self"
			::modify_coreos_file $selfa ::dex_mod::patch_selfa
        }
        if {$::dex_mod::options(--patch-nas-plugin)} {
			set selfb [file join dev_flash vsh module nas_plugin.sprx]
			::modify_devflash_file $selfb ::dex_mod::patch_selfb
        }
        if {$::dex_mod::options(--allow-unsigned-app)} {
			set selfc [file join dev_flash vsh module vsh.self]
			::modify_devflash_file $self ::dex_mod::patch_selfc
        }
        if {$::dex_mod::options(--patch-privacy)} {
#			set selfsn {libad_core.sprx libmedi.sprx libsysutil_np_clans.sprx libsysutil_np_commerce2.sprx libsysutil_np_util.sprx}
#            ::modify_devflash_files [file join dev_flash sys external] $selfs ::dex_mod::patch_playstation_net_self
            set selfsa {x3_amgsdk.sprx}
            ::modify_devflash_files [file join dev_flash vsh module] $selfsa ::dex_mod::patch_allmusic_com_self
            set selfsb {edy_plugin.sprx}
            ::modify_devflash_files [file join dev_flash vsh module] $selfsb ::dex_mod::patch_bitwallet_co_jp_self
            set selfsc {mcore.self msmw2.sprx}
            ::modify_devflash_files [file join dev_flash vsh module] $selfsc ::dex_mod::patch_intertrust_com_self
            set selfsd {mcore.self}
            ::modify_devflash_files [file join dev_flash vsh module] $selfsd ::dex_mod::patch_marlin-drm_com_self
            set selfse {mcore.self msmw2.sprx}
            ::modify_devflash_files [file join dev_flash vsh module] $selfse ::dex_mod::patch_marlin-tmo_com_self
            set selfsf {mcore.self msmw2.sprx}
            ::modify_devflash_files [file join dev_flash vsh module] $selfsf ::dex_mod::patch_oasis-open_org_self
            set selfsg {mcore.self msmw2.sprx}
            ::modify_devflash_files [file join dev_flash vsh module] $selfsg ::dex_mod::patch_octopus-drm_com_self
            set selfsh {netconf_plugin.sprx sysconf_plugin.sprx}
            ::modify_devflash_files [file join dev_flash vsh module] $selfsh ::dex_mod::patch_playstation_com_self
			set selfsi {libad_core.sprx libmedi.sprx libsysutil_np_clans.sprx libsysutil_np_commerce2.sprx libsysutil_np_util.sprx}
            ::modify_devflash_files [file join dev_flash sys external] $selfsi ::dex_mod::patch_playstation_net_self
			set selfsj {autodownload_plugin.sprx download_plugin.sprx esehttp.sprx eula_cddb_plugin.sprx eula_hcopy_plugin.sprx eula_net_plugin.sprx explore_category_friend.sprx explore_category_game.sprx explore_category_music.sprx explore_category_network.sprx explore_category_photo.sprx explore_category_psn.sprx explore_category_sysconf.sprx explore_category_tv.sprx explore_category_user.sprx explore_category_video.sprx explore_plugin.sprx explore_plugin_ft.sprx explore_plugin_np.sprx friendtrophy_plugin.sprx game_ext_plugin.sprx hknw_plugin.sprx nas_plugin.sprx newstore_plugin.sprx np_eula_plugin.sprx np_trophy_plugin.sprx np_trophy_util.sprx photo_network_sharing_plugin.sprx profile_plugin.sprx regcam_plugin.sprx sysconf_plugin.sprx videoeditor_plugin.sprx videoplayer_plugin.sprx videoplayer_util.sprx vsh.self x3_mdimp11.sprx x3_mdimp7.sprx}
            ::modify_devflash_files [file join dev_flash vsh module] $selfsj ::dex_mod::patch_playstation_net_self
            set selfsk {netconf_plugin.sprx sysconf_plugin.sprx}
            ::modify_devflash_files [file join dev_flash vsh module] $selfsk ::dex_mod::patch_playstation_org_self
            set selfsl {regcam_plugin.sprx}
            ::modify_devflash_files [file join dev_flash vsh module] $selfsl ::dex_mod::patch_qriocity_com_self
            set selfsm {eula_net_plugin.sprx mintx_client.sprx}
            ::modify_devflash_files [file join dev_flash vsh module] $selfsm ::dex_mod::patch_sony_com_self
            set selfsn {videodownloader_plugin.sprx}
            ::modify_devflash_files [file join dev_flash vsh module] $selfsn ::dex_mod::patch_sony_co_jp_self
            set selfso {silk.sprx silk_nas.sprx}
            ::modify_devflash_files [file join dev_flash vsh module] $selfso ::dex_mod::patch_trendmicro_com_self
        }
    }
    proc patch_355debug_self_rbgme {self} {
        ::modify_self_file $self ::dex_mod::patch_355debug_elf_rbgme
    }
    proc patch_lv1 {self} {
        ::modify_self_file $self ::dex_mod::patch_lv1_elf
    }
    proc patch_lv2 {self} {
        ::modify_self_file $self ::dex_mod::patch_lv2_elf
    }
    proc patch_gamext_self {self} {
        ::modify_self_file $self ::dex_mod::patch_gamext_elf
    }
    proc patch_sysconf_self {self} {
        ::modify_self_file $self ::dex_mod::patch_sysconf_elf
    }
    proc patch_selfa {self} {
        ::modify_self_file $self ::dex_mod::patch_elfa
    }
    proc patch_selfb {self} {
        ::modify_self_file $self ::dex_mod::patch_elfb
    }
    proc patch_selfc {self} {
        ::modify_self_file $self ::dex_mod::patch_elfc
    }
    proc patch_allmusic_com_self {self} {
        ::modify_self_file $self ::dex_mod::patch_allmusic_com_elf
    }
    proc patch_bitwallet_co_jp_self {self} {
        ::modify_self_file $self ::dex_mod::patch_bitwallet_co_jp_elf
    }
    proc patch_intertrust_com_self {self} {
        ::modify_self_file $self ::dex_mod::patch_intertrust_com_elf
    }
    proc patch_marlin-drm_com_self {self} {
        ::modify_self_file $self ::dex_mod::patch_marlin-drm_com_elf
    }
    proc patch_marlin-tmo_com_self {self} {
        ::modify_self_file $self ::dex_mod::patch_marlin-tmo_com_elf
    }
    proc patch_oasis-open_org_self {self} {
        ::modify_self_file $self ::dex_mod::patch_oasis-open_org_elf
    }
    proc patch_octopus-drm_com_self {self} {
        ::modify_self_file $self ::dex_mod::patch_octopus-drm_com_elf
    }
    proc patch_playstation_com_self {self} {
        ::modify_self_file $self ::dex_mod::patch_playstation_com_elf
    }
    proc patch_playstation_net_self {self} {
#        ::modify_self_file $self ::dex_mod::patch_playstation_net_elf
    }
    proc patch_playstation_org_self {self} {
        ::modify_self_file $self ::dex_mod::patch_playstation_org_elf
    }
    proc patch_qriocity_com_self {self} {
        ::modify_self_file $self ::dex_mod::patch_qriocity_com_elf
    }
    proc patch_sony_com_self {self} {
        ::modify_self_file $self ::dex_mod::patch_sony_com_elf
    }
    proc patch_sony_co_jp_self {self} {
        ::modify_self_file $self ::dex_mod::patch_sony_co_jp_elf
    }
    proc patch_trendmicro_com_self {self} {
        ::modify_self_file $self ::dex_mod::patch_trendmicro_com_elf
    }
    proc patch_355debug_elf_rbgme {elf} {
		if {$::dex_mod::options(--allow-offline-activation) == "DEX 3.55"} {
            log "Patching DEX 3.55 [file tail $elf] to allow Offline PSN-Activation"
#           disable deletion of act.dat
            set search  "\x48\x00\x4E\x65"
            set replace "\x60\x00\x00\x00"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
#           allow unsigned act.dat and rif files
            set search  "\x4B\xCE\xEA\x6D"
            set replace "\x38\x60\x00\x00"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_lv1_elf {elf} {
        if {$::dex_mod::options(--patch-pnp)} {
            log "Patching LV1 hypervisor to allow mapping of any memory area"
            set search  "\x39\x08\x05\x48\x39\x20\x00\x00\x38\x60\x00\x00\x4b\xff\xfc\x45"
            set replace "\x01"
            catch_die {::patch_elf $elf $search 7 $replace} \
                "Unable to patch self [file tail $elf]"
        }
        if {$::dex_mod::options(--patch-pnp)} {
            log "Patching LV1 hypervisor to add peek/poke support"
            set search  "\x38\x00\x00\x00\x64\x00\xff\xff\x60\x00\xff\xec\xf8\x03\x00\xc0"
	    append search "\x4e\x80\x00\x20\x38\x00\x00\x00"
            set replace "\xe8\x83\x00\x18\xe8\x84\x00\x00\xf8\x83\x00\xc8"
            catch_die {::patch_elf $elf $search 4 $replace} \
                "Unable to patch self [file tail $elf]"
            set search  "\x4e\x80\x00\x20\x38\x00\x00\x00\x64\x00\xff\xff\x60\x00\xff\xec"
	    append search "\xf8\x03\x00\xc0\x4e\x80\x00\x20"
            set replace "\xe8\xa3\x00\x20\xe8\x83\x00\x18\xf8\xa4\x00\x00"
            catch_die {::patch_elf $elf $search 8 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_lv2_elf {elf} {
        if {$::dex_mod::options(--patch-pnp)} {
            log "Patching LV2 to allow Peek and Poke support"
            set search    "\xEB\xA1\x00\x88\x38\x60\x00\x00\xEB\xC1\x00\x90\xEB\xE1\x00\x98"
            append search "\x7C\x08\x03\xA6\x7C\x63\x07\xB4\x38\x21\x00\xA0\x4E\x80\x00\x20"
            append search "\x3C\x60\x80\x01\x60\x63\x00\x03\x4E\x80\x00\x20\x3C\x60\x80\x01"
            append search "\x60\x63\x00\x03\x4E\x80\x00\x20"
            set replace   "\xE8\x63\x00\x00\x60\x00\x00\x00\x4E\x80\x00\x20\xF8\x83\x00\x00\x60\x00\x00\x00"
            catch_die {::patch_elf $elf $search 32 $replace} \
                "Unable to patch self [file tail $elf]"
        }
        if {$::dex_mod::options(--patch-pnp)} {
            log "Patching LV2 to allow LV1 Peek and Poke support (3.55)"
            set search     "\x7C\x71\x43\xA6\x7C\x92\x43\xA6\x7C\xB3\x43\xA6\x48"
            set replace    "\x7C\x08\x02\xA6\xF8\x01\x00\x10\x39\x60\x00\xB6\x44\x00\x00\x22"
	    append replace "\x7C\x83\x23\x78\xE8\x01\x00\x10\x7C\x08\x03\xA6\x4E\x80\x00\x20"
	    append replace "\x7C\x08\x02\xA6\xF8\x01\x00\x10\x39\x60\x00\xB7\x44\x00\x00\x22"
	    append replace "\x38\x60\x00\x00\xE8\x01\x00\x10\x7C\x08\x03\xA6\x4E\x80\x00\x20"
            catch_die {::patch_elf $elf $search 5644 $replace} \
                "Unable to patch self [file tail $elf]"
            set search     "\xEB\xA1\x00\x88\x38\x60\x00\x00\xEB\xC1\x00\x90\xEB\xE1\x00\x98"
            append search  "\x7C\x08\x03\xA6\x7C\x63\x07\xB4\x38\x21\x00\xA0\x4E\x80\x00\x20"
            set replace    "\x4B\xFE\x83\xB8\x60\x00\x00\x00\x60\x00\x00\x00\x4B\xFE\x83\xCC"
	    append replace "\x60\x00\x00\x00\x60\x00\x00\x00"
            catch_die {::patch_elf $elf $search 56 $replace} \
                "Unable to patch self [file tail $elf]"
        }
        if {$::dex_mod::options(--patch-pnp)} {
            log "Patching LV2 to allow LV1 Call support (3.55)"
            set search     "\x7C\x71\x43\xA6\x7C\x92\x43\xA6\x7C\xB3\x43\xA6\x48"
            set replace    "\x7C\x08\x02\xA6\xF8\x01\x00\x10\x7D\x4B\x53\x78\x44\x00\x00\x22"
	    append replace "\xE8\x01\x00\x10\x7C\x08\x03\xA6\x4E\x80\x00\x20"
            catch_die {::patch_elf $elf $search 5708 $replace} \
                "Unable to patch self [file tail $elf]"
            set search     "\xEB\xA1\x00\x88\x38\x60\x00\x00\xEB\xC1\x00\x90\xEB\xE1\x00\x98"
            append search  "\x7C\x08\x03\xA6\x7C\x63\x07\xB4\x38\x21\x00\xA0\x4E\x80\x00\x20"
            set replace    "\x4B\xFE\x83\xE0\x60\x00\x00\x00\x60\x00\x00\x00"
            catch_die {::patch_elf $elf $search 80 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_gamext_elf {elf} {
        if {$::dex_mod::options(--patch-ps2emu)} {
            log "Patching game_ext_plugin for FSM PS2 Compatibility"
            set search  "\x88\x1F\x00\x06\x3B\x80"
            set replace "\x38\x00\xFF\xFF\x3B\x80"
            catch_die {::patch_elf $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_sysconf_elf {elf} {
        if {$::dex_mod::options(--patch-ps2emu)} {
            log "Patching sysconf_plugin for FSM PS2 Compatibility"
            set search  "\x04\x48\x88\x1C\x00\x06"
            set replace "\x04\x48\x38\x00\xFF\xFF"
            catch_die {::patch_elf $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_elfa {elf} {
        variable options
        set pup $options(--patch-pup-search-in-game-disc)
        if {$pup} {
            log "Patching [file tail $elf] to disable searching for update packages in GAME disc"
            set search  "\x80\x01\x00\x74\x2f\x80\x00\x00\x40\x9e\x00\x14\x7f\xa3\xeb\x78"
            set replace "\x38\x00\x00\x01"
            catch_die {::patch_elf $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_elfb { elf } {
        if {$::dex_mod::options(--patch-nas-plugin) } {
            log "Patching [file tail $elf] to allow Pseudo-Retail PKG Installs"
            set search "\x7c\x60\x1b\x78\xf8\x1f\x01\x80"
            set replace "\x38\x00\x00\x00"
            catch_die {::patch_elf $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
        if {$::dex_mod::options(--patch-nas-plugin) } {
            log "Patching [file tail $elf] to allow  Retail PKG  Installs"
            set search "\x2f\x80\x00\x00\x41\x9e\x01\xb0\x3b\xa1\x00\x80"
            set replace "\x60\x00\x00\x00"
            catch_die {::patch_elf $elf $search 4 $replace} \
                "Unable to patch self [file tail $elf]"
        }
        if {$::dex_mod::options(--patch-nas-plugin) } {
            log "Patching [file tail $elf] to allow Debug PKG Installs"
            set search "\x2f\x89\x00\x00\x41\x9e\x00\x4c\x38\x00\x00\x00"
            set replace "\x60\x00\x00\x00"
            catch_die {::patch_elf $elf $search 4 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_elfc { elf } {
        if {$::dex_mod::options(--allow-unsigned-app)} {
            log "Patching [file tail $elf] to allow running of unsigned applications"
            set search "\xF8\x21\xFF\x81\x7C\x08\x02\xA6\x38\x61\x00\x70\xF8\x01\x00\x90\x4B\xFF\xFF\xE1\x38\x00\x00\x00"
            set replace "\x38\x60\x00\x01\x4E\x80\x00\x20"
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
            set search "\xA0\x7F\x00\x04\x39\x60\x00\x01\x38\x03\xFF\x7F\x2B\xA0\x00\x01\x40\x9D\x00\x08\x39\x60\x00\x00"
            set replace "\x60\x00\x00\x00"
            catch_die {::patch_elf $elf $search 20 $replace} "Unable to patch self [file tail $elf]"
            log "WARNING: Running unsigned applications will only work if the kernel also supports this option" 1
        }
    }
    proc patch_allmusic_com_elf {elf} {
        if {$::dex_mod::options(--patch-privacy)} {
            log "Patching [file tail $elf] to disable communication with allmusic.com"
#           allmusic.com
            set search  "\x61\x6c\x6c\x6d\x75\x73\x69\x63\x2e\x63\x6f\x6d"
#           aaaaaaaa.com
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x63\x6f\x6d"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_bitwallet_co_jp_elf {elf} {
        if {$::dex_mod::options(--patch-privacy)} {
            log "Patching [file tail $elf] to disable communication with bitwallet.co.jp"
#           bitwallet.co.jp
            set search  "\x62\x69\x74\x77\x61\x6c\x6c\x65\x74\x2e\x63\x6f\x2e\x6a\x70"
#           aaaaaaaaa.co.jp
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x63\x6f\x2e\x6a\x70"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_intertrust_com_elf {elf} {
        if {$::dex_mod::options(--patch-privacy)} {
            log "Patching [file tail $elf] to disable communication with intertrust.com"
#           intertrust.com
            set search  "\x69\x6e\x74\x65\x72\x74\x72\x75\x73\x74\x2e\x63\x6f\x6d"
#           aaaaaaaaaa.com
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x63\x6f\x6d"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_marlin-tmo_com_elf {elf} {
        if {$::dex_mod::options(--patch-privacy)} {
            log "Patching [file tail $elf] to disable communication with marlin-tmo.com"
#           marlin-tmo.com
            set search  "\x6d\x61\x72\x6c\x69\x6e\x2d\x74\x6d\x6f\x2e\x63\x6f\x6d"
#           aaaaaaaaaa.com
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x63\x6f\x6d"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_marlin-drm_com_elf {elf} {
        if {$::dex_mod::options(--patch-privacy)} {
            log "Patching [file tail $elf] to disable communication with marlin-drm.com"
#           marlin-drm.com
            set search  "\x6d\x61\x72\x6c\x69\x6e\x2d\x64\x72\x6d\x2e\x63\x6f\x6d"
#           aaaaaaaaaa.com
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x63\x6f\x6d"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_oasis-open_org_elf {elf} {
        if {$::dex_mod::options(--patch-privacy)} {
            log "Patching [file tail $elf] to disable communication with oasis-open.org"
#           oasis-open.org
            set search  "\x6f\x61\x73\x69\x73\x2d\x6f\x70\x65\x6e\x2e\x6f\x72\x67"
#           aaaaaaaaaa.org
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x6f\x72\x67"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_octopus-drm_com_elf {elf} {
        if {$::dex_mod::options(--patch-privacy)} {
            log "Patching [file tail $elf] to disable communication with octopus-drm.com"
#           octopus-drm.com
            set search  "\x6f\x63\x74\x6f\x70\x75\x73\x2d\x64\x72\x6d\x2e\x63\x6f\x6d"
#           aaaaaaaaaaa.com
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x63\x6f\x6d"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_playstation_com_elf {elf} {
        if {$::dex_mod::options(--patch-privacy)} {
            log "Patching [file tail $elf] to disable communication with playstation.com"
#           playstation.com
            set search  "\x70\x6c\x61\x79\x73\x74\x61\x74\x69\x6f\x6e\x2e\x63\x6f\x6d"
#           aaaaaaaaaaa.com
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x63\x6f\x6d"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_playstation_net_elf {elf} {
        if {$::dex_mod::options(--patch-privacy)} {
            log "Patching [file tail $elf] to disable communication with playstation.net"
#           playstation.net
            set search  "\x70\x6c\x61\x79\x73\x74\x61\x74\x69\x6f\x6e\x2e\x6e\x65\x74"
#           aaaaaaaaaaa.net
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x6e\x65\x74"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
#           playstation.net
            set search  "\x70\x00\x6c\x00\x61\x00\x79\x00\x73\x00\x74\x00\x61\x00\x74\x00\x69\x00\x6f\x00\x6e\x00\x2e\x00\x6e\x00\x65\x00\x74"
#           aaaaaaaaaaa.net
            set replace "\x61\x00\x61\x00\x61\x00\x61\x00\x61\x00\x61\x00\x61\x00\x61\x00\x61\x00\x61\x00\x61\x00\x2e\x00\x6e\x00\x65\x00\x74"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_playstation_org_elf {elf} {
        if {$::dex_mod::options(--patch-privacy)} {
            log "Patching [file tail $elf] to disable communication with playstation.org"
#           playstation.org
            set search  "\x70\x6c\x61\x79\x73\x74\x61\x74\x69\x6f\x6e\x2e\x6f\x72\x67"
#           aaaaaaaaaaa.org
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x6f\x72\x67"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_qriocity_com_elf {elf} {
        if {$::dex_mod::options(--patch-privacy)} {
            log "Patching [file tail $elf] to disable communication with qriocity.com"
#           qriocity.com
            set search  "\x71\x72\x69\x6f\x63\x69\x74\x79\x2e\x63\x6f\x6d"
#           aaaaaaaa.com
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x63\x6f\x6d"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_sony_com_elf {elf} {
        if {$::dex_mod::options(--patch-privacy)} {
            log "Patching [file tail $elf] to disable communication with sony.com"
#           sony.com
            set search  "\x73\x6f\x6e\x79\x2e\x63\x6f\x6d"
#           aaaa.com
            set replace "\x61\x61\x61\x61\x2e\x63\x6f\x6d"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_sony_co_jp_elf {elf} {
        if {$::dex_mod::options(--patch-privacy)} {
            log "Patching [file tail $elf] to disable communication with sony.co.jp"
#           sony.co.jp
            set search  "\x73\x6f\x6e\x79\x2e\x63\x6f\x2e\x6a\x70"
#           aaaa.co.jp
            set replace "\x61\x61\x61\x61\x2e\x63\x6f\x2e\x6a\x70"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
    proc patch_trendmicro_com_elf {elf} {
        if {$::dex_mod::options(--patch-privacy)} {
            log "Patching [file tail $elf] to disable communication with trendmicro.com"
#           trendmicro.com
            set search  "\x74\x72\x65\x6e\x64\x6d\x69\x63\x72\x6f\x2e\x63\x6f\x6d"
#           aaaaaaaaaa.com
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x63\x6f\x6d"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
}

