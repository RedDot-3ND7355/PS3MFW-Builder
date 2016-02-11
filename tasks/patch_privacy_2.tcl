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

# Priority: 600
# Description: [4.xx] Patch all self/sprx to secure privacy

# Option --patch-playstation-com: Patch communication to playstation.com
# Option --patch-playstation-net: Patch communication to playstation.net
# Option --patch-playstation-org: Patch communication to playstation.org
# Option --patch-sony: Patch communication to sony.[com|co.jp]
# Option --patch-bitwallet: Patch communication to bitwallet.co.jp
# Option --patch-qriocity: Patch communication to qriocity.com
# Option --patch-trendmicro: Patch communication to trendmicro.com
# Option --patch-allmusic: Patch communication to allmusic.com
# Option --patch-intertrust: Patch communication to intertrust.com
# Option --patch-marlin-drm: Patch communication to marlin-drm.com
# Option --patch-marlin-tmo: Patch communication to marlin-tmo.com
# Option --patch-oasis-open: Patch communication to oasis-open.org
# Option --patch-octopus-drm: Patch communication to octopus-drm.com

# Type --patch-playstation-com: boolean
# Type --patch-playstation-net: boolean
# Type --patch-playstation-org: boolean
# Type --patch-sony: boolean
# Type --patch-bitwallet: boolean
# Type --patch-qriocity: boolean
# Type --patch-trendmicro: boolean
# Type --patch-allmusic: boolean
# Type --patch-intertrust: boolean
# Type --patch-marlin-drm: boolean
# Type --patch-marlin-tmo: boolean
# Type --patch-oasis-open: boolean
# Type --patch-octopus-drm: boolean

namespace eval ::patch_privacy_2 {

    array set ::patch_privacy_2::options {
        --patch-allmusic true
        --patch-bitwallet true
        --patch-intertrust true
        --patch-marlin-drm true
        --patch-marlin-tmo true
        --patch-oasis-open true
        --patch-octopus-drm true
        --patch-playstation-net false
        --patch-playstation-com true
        --patch-playstation-org true
        --patch-qriocity true
        --patch-sony true
        --patch-trendmicro true
    }

    proc main { } {
		variable options

        if {$::patch_privacy_2::options(--patch-allmusic)} {
            set selfs {x3_amgsdk.sprx}
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_files [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_allmusic_com_elf
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_files2 [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_allmusic_com_elf
			}
		}
        if {$::patch_privacy_2::options(--patch-bitwallet)} {
            set selfs {edy_plugin.sprx}
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_files [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_bitwallet_co_jp_elf
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_files2 [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_bitwallet_co_jp_elf
			}
		}
        if {$::patch_privacy_2::options(--patch-intertrust)} {
            set selfs {mcore.self msmw2.sprx}
            if { ${::OLDROUTINE} == "1" } {
		    ::modify_devflash_files [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_intertrust_com_elf
            } elseif { ${::OLDROUTINE} == "0" } {
	        ::modify_devflash_files2 [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_intertrust_com_elf
			}
		}
        if {$::patch_privacy_2::options(--patch-marlin-drm)} {
            set selfs {mcore.self}
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_files [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_marlin_drm_com_elf
            } elseif { ${::OLDROUTINE} == "0" } {
		    ::modify_devflash_files2 [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_marlin_drm_com_elf
			}
		}
        if {$::patch_privacy_2::options(--patch-marlin-tmo)} {
            set selfs {mcore.self msmw2.sprx}
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_files [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_marlin_tmo_com_elf
            } elseif { ${::OLDROUTINE} == "0" } {
		    ::modify_devflash_files2 [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_marlin_tmo_com_elf
			}
		}
        if {$::patch_privacy_2::options(--patch-oasis-open)} {
            set selfs {mcore.self msmw2.sprx}
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_files [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_oasis_open_org_elf
            } elseif { ${::OLDROUTINE} == "0" } {
		    ::modify_devflash_files2 [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_oasis_open_org_elf
			}
		}
        if {$::patch_privacy_2::options(--patch-octopus-drm)} {
            set selfs {mcore.self msmw2.sprx}
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_files [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_octopus_drm_com_elf
            } elseif { ${::OLDROUTINE} == "0" } {
		    ::modify_devflash_files2 [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_octopus_drm_com_elf
			}
		}
        if {$::patch_privacy_2::options(--patch-playstation-com)} {
            set selfs {netconf_plugin.sprx sysconf_plugin.sprx}
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_files [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_playstation_com_elf
            } elseif { ${::OLDROUTINE} == "0" } {
		    ::modify_devflash_files2 [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_playstation_com_elf
			}
		}
        if {$::patch_privacy_2::options(--patch-playstation-net)} {
        set selfs1 {libad_core.sprx libmedi.sprx libsysutil_np_clans.sprx libsysutil_np_commerce2.sprx libsysutil_np_util.sprx}
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_files [file join dev_flash sys external] $selfs1 ::patch_privacy_2::patch_playstation_net_elf
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_files2 [file join dev_flash sys external] $selfs1 ::patch_privacy_2::patch_playstation_net_elf
			}
        set selfs2 {autodownload_plugin.sprx download_plugin.sprx esehttp.sprx eula_cddb_plugin.sprx eula_hcopy_plugin.sprx eula_net_plugin.sprx explore_category_friend.sprx explore_category_game.sprx explore_category_music.sprx explore_category_network.sprx explore_category_photo.sprx explore_category_psn.sprx explore_category_sysconf.sprx explore_category_tv.sprx explore_category_user.sprx explore_category_video.sprx explore_plugin.sprx explore_plugin_ft.sprx explore_plugin_np.sprx friendtrophy_plugin.sprx game_ext_plugin.sprx hknw_plugin.sprx nas_plugin.sprx newstore_plugin.sprx np_eula_plugin.sprx np_trophy_plugin.sprx np_trophy_util.sprx photo_network_sharing_plugin.sprx profile_plugin.sprx regcam_plugin.sprx sysconf_plugin.sprx videoeditor_plugin.sprx videoplayer_plugin.sprx videoplayer_util.sprx vsh.self x3_mdimp11.sprx x3_mdimp7.sprx}
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_files [file join dev_flash vsh module] $selfs2 ::patch_privacy_2::patch_playstation_net_elf
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_files2 [file join dev_flash vsh module] $selfs2 ::patch_privacy_2::patch_playstation_net_elf
			}
		}
        if {$::patch_privacy_2::options(--patch-playstation-org)} {
            set selfs {netconf_plugin.sprx sysconf_plugin.sprx}
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_files [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_playstation_org_elf
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_files2 [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_playstation_org_elf
			}
		}
        if {$::patch_privacy_2::options(--patch-qriocity)} {
            set selfs {regcam_plugin.sprx}
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_files [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_qriocity_com_elf
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_files2 [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_qriocity_com_elf
			}
		}
        if {$::patch_privacy_2::options(--patch-sony)} {
            set selfs {eula_net_plugin.sprx mintx_client.sprx}
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_files [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_sony_com_elf
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_files2 [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_sony_com_elf
			}
		}
        if {$::patch_privacy_2::options(--patch-sony)} {
            set selfs {videodownloader_plugin.sprx}
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_files [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_sony_co_jp_elf
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_files2 [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_sony_co_jp_elf
			}
		}
        if {$::patch_privacy_2::options(--patch-trendmicro)} {
            set selfs {silk.sprx silk_nas.sprx}
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_files [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_trendmicro_com_elf
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_files2 [file join dev_flash vsh module] $selfs ::patch_privacy_2::patch_trendmicro_com_elf
			}
		}
    }

    proc patch_playstation_com_elf {elf} {
        if {$::patch_privacy_2::options(--patch-playstation-com)} {
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
        if {$::patch_privacy_2::options(--patch-playstation-net)} {
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
        if {$::patch_privacy_2::options(--patch-playstation-org)} {
            log "Patching [file tail $elf] to disable communication with playstation.org"
#           playstation.org
            set search  "\x70\x6c\x61\x79\x73\x74\x61\x74\x69\x6f\x6e\x2e\x6f\x72\x67"
#           aaaaaaaaaaa.org
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x6f\x72\x67"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }

    proc patch_sony_com_elf {elf} {
        if {$::patch_privacy_2::options(--patch-sony)} {
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
        if {$::patch_privacy_2::options(--patch-sony)} {
            log "Patching [file tail $elf] to disable communication with sony.co.jp"
#           sony.co.jp
            set search  "\x73\x6f\x6e\x79\x2e\x63\x6f\x2e\x6a\x70"
#           aaaa.co.jp
            set replace "\x61\x61\x61\x61\x2e\x63\x6f\x2e\x6a\x70"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }

    proc patch_bitwallet_co_jp_elf {elf} {
        if {$::patch_privacy_2::options(--patch-bitwallet)} {
            log "Patching [file tail $elf] to disable communication with bitwallet.co.jp"
#           bitwallet.co.jp
            set search  "\x62\x69\x74\x77\x61\x6c\x6c\x65\x74\x2e\x63\x6f\x2e\x6a\x70"
#           aaaaaaaaa.co.jp
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x63\x6f\x2e\x6a\x70"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }

    proc patch_qriocity_com_elf {elf} {
        if {$::patch_privacy_2::options(--patch-qriocity)} {
            log "Patching [file tail $elf] to disable communication with qriocity.com"
#           qriocity.com
            set search  "\x71\x72\x69\x6f\x63\x69\x74\x79\x2e\x63\x6f\x6d"
#           aaaaaaaa.com
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x63\x6f\x6d"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }

    proc patch_trendmicro_com_elf {elf} {
        if {$::patch_privacy_2::options(--patch-trendmicro)} {
            log "Patching [file tail $elf] to disable communication with trendmicro.com"
#           trendmicro.com
            set search  "\x74\x72\x65\x6e\x64\x6d\x69\x63\x72\x6f\x2e\x63\x6f\x6d"
#           aaaaaaaaaa.com
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x63\x6f\x6d"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }

    proc patch_allmusic_com_elf {elf} {
        if {$::patch_privacy_2::options(--patch-allmusic)} {
            log "Patching [file tail $elf] to disable communication with allmusic.com"
#           allmusic.com
            set search  "\x61\x6c\x6c\x6d\x75\x73\x69\x63\x2e\x63\x6f\x6d"
#           aaaaaaaa.com
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x63\x6f\x6d"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }

    proc patch_intertrust_com_elf {elf} {
        if {$::patch_privacy_2::options(--patch-intertrust)} {
            log "Patching [file tail $elf] to disable communication with intertrust.com"
#           intertrust.com
            set search  "\x69\x6e\x74\x65\x72\x74\x72\x75\x73\x74\x2e\x63\x6f\x6d"
#           aaaaaaaaaa.com
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x63\x6f\x6d"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }

    proc patch_marlin_tmo_com_elf {elf} {
        if {$::patch_privacy_2::options(--patch-marlin-tmo)} {
            log "Patching [file tail $elf] to disable communication with marlin-tmo.com"
#           marlin-tmo.com
            set search  "\x6d\x61\x72\x6c\x69\x6e\x2d\x74\x6d\x6f\x2e\x63\x6f\x6d"
#           aaaaaaaaaa.com
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x63\x6f\x6d"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }

    proc patch_marlin_drm_com_elf {elf} {
        if {$::patch_privacy_2::options(--patch-marlin-drm)} {
            log "Patching [file tail $elf] to disable communication with marlin-drm.com"
#           marlin-drm.com
            set search  "\x6d\x61\x72\x6c\x69\x6e\x2d\x64\x72\x6d\x2e\x63\x6f\x6d"
#           aaaaaaaaaa.com
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x63\x6f\x6d"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }

    proc patch_oasis_open_org_elf {elf} {
        if {$::patch_privacy_2::options(--patch-oasis-open)} {
            log "Patching [file tail $elf] to disable communication with oasis-open.org"
#           oasis-open.org
            set search  "\x6f\x61\x73\x69\x73\x2d\x6f\x70\x65\x6e\x2e\x6f\x72\x67"
#           aaaaaaaaaa.org
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x6f\x72\x67"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }

    proc patch_octopus_drm_com_elf {elf} {
        if {$::patch_privacy_2::options(--patch-octopus-drm)} {
            log "Patching [file tail $elf] to disable communication with octopus-drm.com"
#           octopus-drm.com
            set search  "\x6f\x63\x74\x6f\x70\x75\x73\x2d\x64\x72\x6d\x2e\x63\x6f\x6d"
#           aaaaaaaaaaa.com
            set replace "\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x61\x2e\x63\x6f\x6d"
            catch_die {::patch_file_multi $elf $search 0 $replace} \
                "Unable to patch self [file tail $elf]"
        }
    }
}
