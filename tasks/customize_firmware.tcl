#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
# Copyright (C) RedDot-3ND7355 (Fixed the task!)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Priority: 1000
# Description: Customize MFW (USE WITH CAUTION)

# Option --customize-coldboot-raf: Change default coldboot icon
# Option --customize-coldboot-stereo: Change default coldboot sound
# Option --customize-coldboot-multi: Change default coldboot sound
# Option --customize-coldboot-health-screen: Change default coldboot Healthscreen
# Option --customize-firmware-xmb-wave: Change default XMB wave
# Option --customize-game-boot-rco: Change default gameboot RCO
# Option --customize-system-sound-rco: Change default system sound RCO
# Option --customize-theme-src: Change default "Air Paint" Theme
# Option --customize-embended-app: Change default embended app (* Install Package Files)
# Option --customize-fw-version: Change default fw version in XMB
# Option --language-pack: Change default Language Pack
# Option --language-replace: Language Pack to replace (keep empty for none)
# Option --language-font: Replace fonts

# Type --customize-coldboot-raf: file open {"RAF Video" {raf}}
# Type --customize-coldboot-stereo: file open {"AC3 Audio" {ac3}}
# Type --customize-coldboot-multi: file open {"AC3 Audio" {ac3}}
# Type --customize-cooldboot-health-screen: file open {"" {}}
# Type --customize-firmware-xmb-wave: file open {"QRC Resource" {qrc}}
# Type --customize-game-boot-rco: file open {"RCO Resource" {rco}}
# Type --customize-system-sound-rco: file open {"RCO Resource" {rco}}
# Type --customize-theme-src: file open {"PS3 Theme" {p3t}}
# Type --customize-embended-app: directory "Choose directory of Homebrew application to replace"
# Type --customize-fw-version: string
# Type --language-pack: file open {"Language Pack" {.LP}}
# Type --language-replace: combobox {{} {English} {French} {German} {Italian} {Finnish} {Dutch} {Danish} {Swedish} {Spanish} {Russian} {Portugese} {Norwegian} {Korean} {ChineseTrad} {ChineseSimpl} {Japanese}}
# Type --language-font: boolean

namespace eval customize_firmware {

    array set ::customize_firmware::options {
        --customize-coldboot-raf ".raf"
        --customize-coldboot-stereo ".ac3"
        --customize-coldboot-multi ".ac3"
        --customize-coldboot-health-screen "??"
		--customize-firmware-xmb-wave ".qrc"
        --customize-game-boot-rco ".rco"
        --customize-system-sound-rco ".rco"
        --customize-theme-src ".p3t"
        --customize-embended-app ""
        --customize-fw-version "-PS3MFW"
        --language-pack ".LP"
        --language-replace ""
        --language-font false
    }

    proc main {} {
	    ::customize_firmware::set_var_cf
        
        if {[file exists $::customize_firmware::options(--customize-system-sound-rco)] == 0 } { 
            log "Skipping xmb sounds, $::customize_firmware::options(--customize-system-sound-rco) does not exist"
        } else {
            if { ${::OLDROUTINE} == "1" } {
		    ::modify_devflash_file $xmbSoundRCO ::customize_firmware::copy_customized_file $::customize_firmware::options(--customize-system-sound-rco)
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $xmbSoundRCO ::customize_firmware::copy_customized_file $::customize_firmware::options(--customize-system-sound-rco)
			}
		}

        if {[file exists $::customize_firmware::options(--customize-coldboot-raf)] == 0 } {
            log "Skipping coldboot.raf, $::customize_firmware::options(--customize-coldboot-raf) does not exist"
        } else {
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $coldboot_raf ::customize_firmware::copy_customized_file $::customize_firmware::options(--customize-coldboot-raf)
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $coldboot_raf ::customize_firmware::copy_customized_file $::customize_firmware::options(--customize-coldboot-raf)
			}
		}

        if {[file exists $::customize_firmware::options(--customize-coldboot-stereo)] == 0 } {
            log "Skipping coldboot_stereo, $::customize_firmware::options(--customize-coldboot-stereo) does not exist"
        } else {
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $coldboot_stereo ::customize_firmware::copy_customized_file $::customize_firmware::options(--customize-coldboot-stereo)
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $coldboot_stereo ::customize_firmware::copy_customized_file $::customize_firmware::options(--customize-coldboot-stereo)
			}
		}

        if {[file exists $::customize_firmware::options(--customize-coldboot-multi)] == 0 } {
            log "Skipping coldboot_multi, $::customize_firmware::options(--customize-coldboot-multi) does not exist"
        } else {
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $coldboot_multi ::customize_firmware::copy_customized_file $::customize_firmware::options(--customize-coldboot-multi)
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $coldboot_multi ::customize_firmware::copy_customized_file $::customize_firmware::options(--customize-coldboot-multi)
			}
		}
        
        if {[file exists $::customize_firmware::options(--customize-coldboot-health-screen)] == 0 } {
            log "Skipping health_screen, $::customize_firmware::options(--customize-coldboot-health-screen) does not exist"
        } else {
            ::modify_rco_file $health_screen ::customize_firmware::copy_customized_file $::customize_firmware::options(--customize-coldboot-health-screen)
        }
		
		if {[file exists $::customize_firmware::options(--customize-firmware-xmb-wave)] == 0 } {
            log "Skipping xmb_wave, $::customize_firmware::options(--customize-firmware-xmb-wave) does not exist"
        } else {
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $xmb_wave ::customize_firmware::copy_customized_file $::customize_firmware::options(--customize-firmware-xmb-wave)
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $xmb_wave ::customize_firmware::copy_customized_file $::customize_firmware::options(--customize-firmware-xmb-wave)
			}
		}
        
        if {[file exists $::customize_firmware::options(--customize-game-boot-rco)] == 0 } {
            log "Skipping Game Boot logos, $::customize_firmware::options(--customize-game-boot-rco) does not exist"
        } else {
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $gameBootRCO ::customize_firmware::copy_customized_file $::customize_firmware::options(--customize-game-boot-rco)
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $gameBootRCO ::customize_firmware::copy_customized_file $::customize_firmware::options(--customize-game-boot-rco)
			}
		}
        
        if {[file exists $::customize_firmware::options(--customize-theme-src)] == 0} {
            log "Skipping theme, $::customize_firmware::options(--customize-theme-src) does not exist"
        } else {
            if { ${::OLDROUTINE} == "1" } {
			::modify_devflash_file $theme ::customize_firmware::copy_customized_file $::customize_firmware::options(--customize-theme-src)
            } elseif { ${::OLDROUTINE} == "0" } {
			::modify_devflash_file2 $theme ::customize_firmware::copy_customized_file $::customize_firmware::options(--customize-theme-src)
			}
		}
        
        if {$::customize_firmware::options(--customize-fw-version) != ""} {
            log "Patching fw version in XMB settings"
            ::modify_rco_file $fw_version ::customize_firmware::callback_fwversion
        }
        set arg $::customize_firmware::options(--customize-embended-app)
        if {[file exists $arg] != 0} {
            if {!$::patch_cos::options(--patch-lv2-payload-hermes-4x)} {
                log "WARNING! You want to change the embended App but you forgot to set the patch for lv2 payload hermes 4.xx"
                log "WARNING! Without this patch the App can not be mounted"
                log "Skipping customization of the embended App"
            } elseif {$::patch_xmb::options(--add-install-pkg) || $::patch_xmb::options(--add-pkg-mgr) || $::patch_xmb::options(--add-hb-seg) || $::patch_xmb::options(--add-emu-seg) || $::patch_xmb::options(--patch-package-files) || $::patch_xmb::options(--patch-app-home)} {
                log "Drop"
            } else {
				log "Copy custom embended app into dev_flash"
                ::modify_devflash_file $embd ::copy_ps3_game $arg
            }
        }
        set lp $::customize_firmware::options(--language-pack)
        if {[file exists $lp] != 0} {
		        set langpackDir [file join ${::BUILD_DIR} langpack]
            delete_file $langpackDir
            extract_tar $::customize_firmware::options(--language-pack) $langpackDir
            
            if {$::language_pack::options(--language-font)} {
                foreach fontFiles $fontFiles {
                    if {[file exists $langpackFontFile]} {
                        ::modify_devflash_file $devflashFontFile ::language_pack::callback_font $langpackFontFile
                    }
                }
		    }
		           set langpackDir [file join ${::BUILD_DIR} langpack]
		    foreach rcoFile $rcoFiles {
			    if {[file isdirectory [file join $langpackDir replace]]} {
			    	if {[file exists $replacelangpackRcoFile]} {
					    set mode "0"
                 	    ::modify_rco_file $devflashRcoFile ::language_pack::callback_rco $replacelangpackRcoFile $mode $empty
				 	}
			    }
			         set langpackDir [file join ${::BUILD_DIR} langpack]
				if {[file isdirectory [file join $langpackDir edit]]} {
					foreach langs $langs {
					    if {[file exists $editlangpackRcoFile]} {
					        set mode "1"
                            ::modify_rco_file $devflashRcoFile ::language_pack::callback_rco $editlangpackRcoFile $mode $langs
			    	    }
                    }
                }
                     set langpackDir [file join ${::BUILD_DIR} langpack]
                if {[file exists [file join $langpackDir format.txt]]} {
                    if {[file exists $formatlangpackRcoFile]} {
			            set mode "2"
                        ::modify_rco_file $devflashRcoFile ::language_pack::callback_rco $formatlangpackRcoFile $mode $rcoFile
			        }
                }  
		    }
        }
        
    }
	
	proc set_var_cf { } {
	    variable options
        set arg $::customize_firmware::options(--customize-embended-app)
        set lp $::customize_firmware::options(--language-pack)
        set fontPrefix "SCE-PS3-"
		set langpackDir [file join ${::BUILD_DIR} langpack]
        set fontFiles {{CP-R-KANA} {DH-R-CGB} {MT-BI-LATIN} {MT-B-LATIN} {MT-I-LATIN} {MT-R-LATIN} {NR-B-JPN} {NR-L-JPN} {NR-R-EXT} {NR-R-JPN} {RD-BI-LATIN} {RD-B-LATIN} {RD-B-LATIN2} {RD-I-LATIN} {RD-LI-LATIN} {RD-L-LATIN} {RD-L-LATIN2} {RD-R-LATIN} {RD-R-LATIN2} {SR-R-EXT} {SR-R-JPN} {SR-R-LATIN} {SR-R-LATIN2} {VR-R-LATIN} {VR-R-LATIN2} {YG-B-KOR} {YG-L-KOR} {YG-R-KOR}}
        set devflashFontFile [file join dev_flash data font $fontPrefix$fontFiles.TTF]
        set langpackFontFile [file join $langpackDir font $fontPrefix$fontFiles.TTF]
        set rcoFile {{ap_plugin} {audioplayer_plugin} {audioplayer_plugin_dummy} {audioplayer_plugin_mini} {audioplayer_plugin_util} {auth_plugin} {autodownload_plugin} {avc_game_plugin} {avc_plugin} {avc2_game_plugin} {avc2_game_video_plugin} {avc2_text_plugin} {bdp_disccheck_plugin} {bdp_plugin} {bdp_storage_plugin} {category_setting_plugin} {checker_plugin} {custom_render_plugin} {data_copy_plugin} {deviceconf_plugin} {dlna_plugin} {download_plugin} {edy_plugin} {eula_cddb_plugin} {eula_hcopy_plugin} {eula_net_plugin} {explore_category_friend} {explore_category_game} {explore_category_music} {explore_category_network} {explore_category_photo} {explore_category_psn} {explore_category_sysconf} {explore_category_tv} {explore_category_user} {explore_category_video} {explore_plugin_ft} {explore_plugin_full} {explore_plugin_game} {explore_plugin_np} {filecopy_plugin} {friendim_plugin} {friendim_plugin_game} {friendml_plugin} {friendml_plugin_game} {friendtrophy_plugin} {friendtrophy_plugin_game} {game_ext_plugin} {game_indicator_plugin} {game_plugin} {gamedata_plugin} {gamelib_plugin} {gameupdate_plugin} {hknw_plugin} {idle_plugin} {impose_plugin} {kensaku_plugin} {msgdialog_plugin} {musicbrowser_plugin} {nas_plugin} {netconf_plugin} {newstore_effect} {newstore_plugin} {np_eula_plugin} {np_matching_plugin} {np_multisignin_plugin} {np_trophy_ingame} {np_trophy_plugin} {npsignin_plugin} {osk_plugin} {oskfullkeypanel_plugin} {oskpanel_plugin} {pesm_plugin} {photo_network_sharing_plugin} {photolist_plugin} {photoupload_plugin} {photoviewer_plugin} {playlist_plugin} {poweroff_plugin} {premo_plugin} {print_plugin} {profile_plugin} {profile_plugin_mini} {ps3_savedata_plugin} {rec_plugin} {regcam_plugin} {sacd_plugin} {scenefolder_plugin} {screenshot_plugin} {search_service} {software_update_plugin} {soundvisualizer_plugin} {strviewer_plugin} {subdisplay_plugin} {sv_pseudoaudioplayer_plugin} {sysconf_plugin} {system_plugin} {thumthum_plugin} {upload_util} {user_info_plugin} {user_plugin} {videodownloader_plugin} {videoeditor_plugin} {videoplayer_plugin} {videoplayer_util} {vmc_savedata_plugin} {wboard_plugin} {webbrowser_plugin} {webrender_plugin} {xmb_ingame} {xmb_plugin_normal} {ycon_manual_plugin}}
        set devflashRcoFile [file join dev_flash vsh resource $rcoFile.rco]
        set replacelangpackRcoFile [file join $langpackDir replace $rcoFile.xml]
        set langs {{English} {French} {German} {Italian} {Finnish} {Dutch} {Danish} {Swedish} {Spanish} {Russian} {Portugese} {Norwegian} {Korean} {ChineseTrad} {ChineseSimpl} {Japanese}}
        set editlangpackRcoFile [file join $langpackDir edit $rcoFile $langs.xml]
        set formatlangpackRcoFile [file join $langpackDir format.txt]
        set embd [file join dev_flash vsh etc layout_factor_table_272.txt]
        set coldboot_raf [file join dev_flash vsh resource coldboot.raf]
        set coldboot_stereo [file join dev_flash vsh resource coldboot_stereo.ac3]
        set coldboot_multi [file join dev_flash vsh resource coldboot_multi.ac3]
        set xmb_wave [file join dev_flash vsh resource qgl lines.qrc]
        set health [file join dev_flash vsh resource .rco]
        set gameBootRCO [file join dev_flash vsh resource custom_render_plugin.rco]
        set xmbSoundRCO [file join dev_flash vsh resource system_plugin.rco]
        set theme [file join dev_flash vsh resource theme 01.p3t]
        set fw_version [file join dev_flash resource sysconf_plugin.rco]
	}
    
    proc callback_fwversion { path args } {
        log "Patching English.xml into [file tail $path]"
        sed_in_place [file join $path English.xml] %1.1 %1.1$::customize_firmware::options(--customize-fw-version)
        
        log "Patching German.xml into [file tail $path]"
        sed_in_place [file join $path German.xml] %1.1 %1.1$::customize_firmware::options(--customize-fw-version)
        
        log "Patching Korean.xml into [file tail $path]"
        sed_in_place [file join $path Korean.xml] %1.1 %1.1$::customize_firmware::options(--customize-fw-version)
        
        log "Patching Russian.xml into [file tail $path]"
        sed_in_place [file join $path Russian.xml] %1.1 %1.1$::customize_firmware::options(--customize-fw-version)
        
        log "Patching Swedish.xml into [file tail $path]"
        sed_in_place [file join $path Swedish.xml] %1.1 %1.1$::customize_firmware::options(--customize-fw-version)
        
        log "Patching Spanish.xml into [file tail $path]"
        sed_in_place [file join $path Spanish.xml] %1.1 %1.1$::customize_firmware::options(--customize-fw-version)
        
        log "Patching Portugese.xml into [file tail $path]"
        sed_in_place [file join $path Portugese.xml] %1.1 %1.1$::customize_firmware::options(--customize-fw-version)
        
        log "Patching Norwegian.xml into [file tail $path]"
        sed_in_place [file join $path Norwegian.xml] %1.1 %1.1$::customize_firmware::options(--customize-fw-version)
        
        log "Patching Japanese.xml into [file tail $path]"
        sed_in_place [file join $path Japanese.xml] %1.1 %1.1$::customize_firmware::options(--customize-fw-version)
        
        log "Patching Italian.xml into [file tail $path]"
        sed_in_place [file join $path Italian.xml] %1.1 %1.1$::customize_firmware::options(--customize-fw-version)
        
        log "Patching French.xml into [file tail $path]"
        sed_in_place [file join $path French.xml] %1.1 %1.1$::customize_firmware::options(--customize-fw-version)
        
        log "Patching Finnish.xml into [file tail $path]"
        sed_in_place [file join $path Finnish.xml] %1.1 %1.1$::customize_firmware::options(--customize-fw-version)
        
        log "Patching Dutch.xml into [file tail $path]"
        sed_in_place [file join $path Dutch.xml] %1.1 %1.1$::customize_firmware::options(--customize-fw-version)
        
        log "Patching Danish.xml into [file tail $path]"
        sed_in_place [file join $path Danish.xml] %1.1 %1.1$::customize_firmware::options(--customize-fw-version)
        
        log "Patching ChineseTrad.xml into [file tail $path]"
        sed_in_place [file join $path ChineseTrad.xml] %1.1 %1.1$::customize_firmware::options(--customize-fw-version)
        
        log "Patching ChineseSimpl.xml into [file tail $path]"
        sed_in_place [file join $path ChineseSimpl.xml] %1.1 %1.1$::customize_firmware::options(--customize-fw-version)
        
        if {$::patch_xmb::options(--fix-typo-sysconf-Italian)} {
            ::patch_xmb::callback_fix_typo_sysconf_Italian
        }
    }
    
    proc callback_font { dst src } {
        if {[file exists $src]} {
            if {[file exists $dst]} {
                log "Replacing font file [file tail $dst] with [file tail $src]"
                copy_file -force $src $dst
            } else {
                die "Font file $dst does not exist"
            }
        } else {
            die "Font file $src does not exist"
        }
    }

    proc callback_rco {path src mode name} {
        variable options
        if {$mode == "0" } {
            set dst [file join $path $::customize_firmware::options(--language-replace).xml]
		}
		
		if {$mode == "1" } {
		    set dst [file join $path $name.xml]
	    }
	 
		if {$mode == "2" } {
		    set dst [file join ${::CUSTOM_PUP_DIR} "update_files" "dev_flash" "dev_flash" "vsh" "resource" $name.rco.xml]
		}
		
        if {[file exists $src]} {	
            if {[file exists $dst]} {			
			    if {$mode != "2" } {			
                    log "Replacing $dst"
                    copy_file -force $src $dst
				} else {				                  		
				    log "Patching format"
				    set re [open $src r]
                    set format [read $re]
				    set read [read [open $dst r]]
                    sed_in_place $read utf16 $format
				    close $re	
				}
            } else {
                die "$dst does not exist"
            }						
        } else {
            die "$src does not exist"
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