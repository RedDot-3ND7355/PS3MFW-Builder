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
# Description: Replace RCO Files (Advanced)


# Option --rco-label::
# Option --ap-plugin: ap-plugin.rco
# Option --audioplayer-plugin: audioplayer-plugin.rco
# Option --audioplayer-plugin-dummy: audioplayer-plugin-dummy.rco
# Option --audioplayer-plugin-mini: audioplayer-plugin-mini.rco
# Option --audioplayer-plugin-util: audioplayer-plugin-util.rco
# Option --auth-plugin: auth-plugin.rco
# Option --autodownload-plugin: autodownload-plugin.rco
# Option --avc-game-plugin: avc-game-plugin.rco
# Option --avc-plugin: avc-plugin.rco
# Option --avc2-game-plugin: avc2-game-plugin.rco
# Option --avc2-game-video-plugin: avc2-game-video-plugin.rco
# Option --avc2-text-plugin: avc2-text-plugin.rco
# Option --bdp-disccheck-plugin: bdp-disccheck-plugin.rco
# Option --bdp-plugin: bdp-plugin.rco
# Option --bdp-storage-plugin: bdp-storage-plugin.rco
# Option --category-setting-plugin: category-setting-plugin.rco
# Option --checker-plugin: checker-plugin.rco
# Option --custom-render-plugin: custom-render-plugin.rco
# Option --data-copy-plugin: data-copy-plugin.rco
# Option --deviceconf-plugin: deviceconf-plugin.rco
# Option --dlna-plugin: dlna-plugin.rco
# Option --download-plugin: download-plugin.rco
# Option --dtcpip-util: dtcpip-util.rco
# Option --edy-plugin: edy-plugin.rco
# Option --eula-cddb-plugin: eula-cddb-plugin.rco
# Option --eula-hcopy-plugin: eula-hcopy-plugin.rco
# Option --eula-net-plugin: eula-net-plugin.rco
# Option --explore-category-friend: explore-category-friend.rco
# Option --explore-category-game: explore-category-game.rco
# Option --explore-category-music: explore-category-music.rco
# Option --explore-category-network: explore-category-network.rco
# Option --explore-category-photo: explore-category-photo.rco
# Option --explore-category-psn: explore-category-psn.rco
# Option --explore-category-sysconf: explore-category-sysconf.rco
# Option --explore-category-tv: explore-category-tv.rco
# Option --explore-category-user: explore-category-user.rco
# Option --explore-category-video: explore-category-video.rco
# Option --explore-plugin-ft: explore-plugin-ft.rco
# Option --explore-plugin-full: explore-plugin-full.rco
# Option --explore-plugin-game: explore-plugin-game.rco
# Option --explore-plugin-np: explore-plugin-np.rco
# Option --filecopy-plugin: filecopy-plugin.rco
# Option --friendim-plugin: friendim-plugin.rco
# Option --friendim-plugin-game: friendim-plugin-game.rco
# Option --friendml-plugin: friendml-plugin.rco
# Option --friendml-plugin-game: friendml-plugin-game.rco
# Option --friendtrophy-plugin: friendtrophy-plugin.rco
# Option --friendtrophy-plugin-game: friendtrophy-plugin-game.rco
# Option --game-ext-plugin: game-ext-plugin.rco
# Option --game-indicator-plugin: game-indicator-plugin.rco
# Option --game-plugin: game-plugin.rco
# Option --gamedata-plugin: gamedata-plugin.rco
# Option --gamelib-plugin: gamelib-plugin.rco
# Option --gameupdate-plugin: gameupdate-plugin.rco
# Option --hknw-plugin: hknw-plugin.rco
# Option --idle-plugin: idle-plugin.rco
# Option --impose-plugin: impose-plugin.rco
# Option --kensaku-plugin: kensaku-plugin.rco
# Option --msgdialog-plugin: msgdialog-plugin.rco
# Option --musicbrowser-plugin: musicbrowser-plugin.rco
# Option --nas-plugin: nas-plugin.rco
# Option --netconf-plugin: netconf-plugin.rco
# Option --newstore-effect: newstore-effect.rco
# Option --newstore-plugin: newstore-plugin.rco
# Option --np-eula-plugin: np-eula-plugin.rco
# Option --np-matching-plugin: np-matching-plugin.rco
# Option --np-multisignin-plugin: np-multisignin-plugin.rco
# Option --np-sns-plugin: np-sns-plugin.rco
# Option --np-trophy-ingame: np-trophy-ingame.rco
# Option --np-trophy-plugin: np-trophy-plugin.rco
# Option --npsignin-plugin: npsignin-plugin.rco
# Option --osk-plugin: osk-plugin.rco
# Option --oskfullkeypanel-plugin: oskfullkeypanel-plugin.rco
# Option --oskpanel-plugin: oskpanel-plugin.rco
# Option --pesm-plugin: pesm-plugin.rco
# Option --photo-network-sharing-plugin: photo-network-sharing-plugin.rco
# Option --photolist-plugin: photolist-plugin.rco
# Option --photoupload-plugin: photoupload-plugin.rco
# Option --photoviewer-plugin: photoviewer-plugin.rco
# Option --playlist-plugin: playlist-plugin.rco
# Option --poweroff-plugin: poweroff-plugin.rco
# Option --premo-plugin: premo-plugin.rco
# Option --print-plugin: print-plugin.rco
# Option --profile-plugin: profile-plugin.rco
# Option --profile-plugin-mini: profile-plugin-mini.rco
# Option --ps3-savedata-plugin: ps3-savedata-plugin.rco
# Option --rec-plugin: rec-plugin.rco
# Option --regcam-plugin: regcam-plugin.rco
# Option --sacd-plugin: sacd-plugin.rco
# Option --scenefolder-plugin: scenefolder-plugin.rco
# Option --screenshot-plugin: screenshot-plugin.rco
# Option --search-service: search-service.rco
# Option --software-update-plugin: software-update-plugin.rco
# Option --soundvisualizer-plugin: soundvisualizer-plugin.rco
# Option --strviewer-plugin: strviewer-plugin.rco
# Option --subdisplay-plugin: subdisplay-plugin.rco
# Option --sv-pseudoaudioplayer-plugin: sv-pseudoaudioplayer-plugin.rco
# Option --sysconf-plugin: sysconf-plugin.rco
# Option --system-plugin: system-plugin.rco
# Option --thumthum-plugin: thumthum-plugin.rco
# Option --upload-util: upload-util.rco
# Option --user-info-plugin: user-info-plugin.rco
# Option --user-plugin: user-plugin.rco
# Option --videodownloader-plugin: videodownloader-plugin.rco
# Option --videoeditor-plugin: videoeditor-plugin.rco
# Option --videoplayer-plugin: videoplayer-plugin.rco
# Option --videoplayer-util: videoplayer-util.rco
# Option --vmc-savedata-plugin: vmc-savedata-plugin.rco
# Option --wboard-plugin: wboard-plugin.rco
# Option --webbrowser-plugin: webbrowser-plugin.rco
# Option --webrender-plugin: webrender-plugin.rco
# Option --xmb-ingame: xmb-ingame.rco
# Option --xmb-plugin-normal: xmb-plugin-normal.rco
# Option --rco-label1::

# Type --rco-label: label {RCO Section}
# Type --ap-plugin: file open {"rco file" {rco}}
# Type --audioplayer-plugin: file open {"rco file" {rco}}
# Type --audioplayer-plugin-dummy: file open {"rco file" {rco}}
# Type --audioplayer-plugin-mini: file open {"rco file" {rco}}
# Type --audioplayer-plugin-util: file open {"rco file" {rco}}
# Type --auth-plugin: file open {"rco file" {rco}}
# Type --autodownload-plugin: file open {"rco file" {rco}}
# Type --avc-game-plugin: file open {"rco file" {rco}}
# Type --avc-plugin: file open {"rco file" {rco}}
# Type --avc2-game-plugin: file open {"rco file" {rco}}
# Type --avc2-game-video-plugin: file open {"rco file" {rco}}
# Type --avc2-text-plugin: file open {"rco file" {rco}}
# Type --bdp-disccheck-plugin: file open {"rco file" {rco}}
# Type --bdp-plugin: file open {"rco file" {rco}}
# Type --bdp-storage-plugin: file open {"rco file" {rco}}
# Type --category-setting-plugin: file open {"rco file" {rco}}
# Type --checker-plugin: file open {"rco file" {rco}}
# Type --custom-render-plugin: file open {"rco file" {rco}}
# Type --data-copy-plugin: file open {"rco file" {rco}}
# Type --deviceconf-plugin: file open {"rco file" {rco}}
# Type --dlna-plugin: file open {"rco file" {rco}}
# Type --download-plugin: file open {"rco file" {rco}}
# Type --dtcpip-util: file open {"rco file" {rco}}
# Type --edy-plugin: file open {"rco file" {rco}}
# Type --eula-cddb-plugin: file open {"rco file" {rco}}
# Type --eula-hcopy-plugin: file open {"rco file" {rco}}
# Type --eula-net-plugin: file open {"rco file" {rco}}
# Type --explore-category-friend: file open {"rco file" {rco}}
# Type --explore-category-game: file open {"rco file" {rco}}
# Type --explore-category-music: file open {"rco file" {rco}}
# Type --explore-category-network: file open {"rco file" {rco}}
# Type --explore-category-photo: file open {"rco file" {rco}}
# Type --explore-category-psn: file open {"rco file" {rco}}
# Type --explore-category-sysconf: file open {"rco file" {rco}}
# Type --explore-category-tv: file open {"rco file" {rco}}
# Type --explore-category-user: file open {"rco file" {rco}}
# Type --explore-category-video: file open {"rco file" {rco}}
# Type --explore-plugin-ft: file open {"rco file" {rco}}
# Type --explore-plugin-full: file open {"rco file" {rco}}
# Type --explore-plugin-game: file open {"rco file" {rco}}
# Type --explore-plugin-np: file open {"rco file" {rco}}
# Type --filecopy-plugin: file open {"rco file" {rco}}
# Type --friendim-plugin: file open {"rco file" {rco}}
# Type --friendim-plugin-game: file open {"rco file" {rco}}
# Type --friendml-plugin: file open {"rco file" {rco}}
# Type --friendml-plugin-game: file open {"rco file" {rco}}
# Type --friendtrophy-plugin: file open {"rco file" {rco}}
# Type --friendtrophy-plugin-game: file open {"rco file" {rco}}
# Type --game-ext-plugin: file open {"rco file" {rco}}
# Type --game-indicator-plugin: file open {"rco file" {rco}}
# Type --game-plugin: file open {"rco file" {rco}}
# Type --gamedata-plugin: file open {"rco file" {rco}}
# Type --gamelib-plugin: file open {"rco file" {rco}}
# Type --gameupdate-plugin: file open {"rco file" {rco}}
# Type --hknw-plugin: file open {"rco file" {rco}}
# Type --idle-plugin: file open {"rco file" {rco}}
# Type --impose-plugin: file open {"rco file" {rco}}
# Type --kensaku-plugin: file open {"rco file" {rco}}
# Type --msgdialog-plugin: file open {"rco file" {rco}}
# Type --musicbrowser-plugin: file open {"rco file" {rco}}
# Type --nas-plugin: file open {"rco file" {rco}}
# Type --netconf-plugin: file open {"rco file" {rco}}
# Type --newstore-effect: file open {"rco file" {rco}}
# Type --newstore-plugin: file open {"rco file" {rco}}
# Type --np-eula-plugin: file open {"rco file" {rco}}
# Type --np-matching-plugin: file open {"rco file" {rco}}
# Type --np-multisignin-plugin: file open {"rco file" {rco}}
# Type --np-sns-plugin: file open {"rco file" {rco}}
# Type --np-trophy-ingame: file open {"rco file" {rco}}
# Type --np-trophy-plugin: file open {"rco file" {rco}}
# Type --npsignin-plugin: file open {"rco file" {rco}}
# Type --osk-plugin: file open {"rco file" {rco}}
# Type --oskfullkeypanel-plugin: file open {"rco file" {rco}}
# Type --oskpanel-plugin: file open {"rco file" {rco}}
# Type --pesm-plugin: file open {"rco file" {rco}}
# Type --photo-network-sharing-plugin: file open {"rco file" {rco}}
# Type --photolist-plugin: file open {"rco file" {rco}}
# Type --photoupload-plugin: file open {"rco file" {rco}}
# Type --photoviewer-plugin: file open {"rco file" {rco}}
# Type --playlist-plugin: file open {"rco file" {rco}}
# Type --poweroff-plugin: file open {"rco file" {rco}}
# Type --premo-plugin: file open {"rco file" {rco}}
# Type --print-plugin: file open {"rco file" {rco}}
# Type --profile-plugin: file open {"rco file" {rco}}
# Type --profile-plugin-mini: file open {"rco file" {rco}}
# Type --ps3-savedata-plugin: file open {"rco file" {rco}}
# Type --rec-plugin: file open {"rco file" {rco}}
# Type --regcam-plugin: file open {"rco file" {rco}}
# Type --sacd-plugin: file open {"rco file" {rco}}
# Type --scenefolder-plugin: file open {"rco file" {rco}}
# Type --screenshot-plugin: file open {"rco file" {rco}}
# Type --search-service: file open {"rco file" {rco}}
# Type --software-update-plugin: file open {"rco file" {rco}}
# Type --soundvisualizer-plugin: file open {"rco file" {rco}}
# Type --strviewer-plugin: file open {"rco file" {rco}}
# Type --subdisplay-plugin: file open {"rco file" {rco}}
# Type --sv-pseudoaudioplayer-plugin: file open {"rco file" {rco}}
# Type --sysconf-plugin: file open {"rco file" {rco}}
# Type --system-plugin: file open {"rco file" {rco}}
# Type --thumthum-plugin: file open {"rco file" {rco}}
# Type --upload-util: file open {"rco file" {rco}}
# Type --user-info-plugin: file open {"rco file" {rco}}
# Type --user-plugin: file open {"rco file" {rco}}
# Type --videodownloader-plugin: file open {"rco file" {rco}}
# Type --videoeditor-plugin: file open {"rco file" {rco}}
# Type --videoplayer-plugin: file open {"rco file" {rco}}
# Type --videoplayer-util: file open {"rco file" {rco}}
# Type --vmc-savedata-plugin: file open {"rco file" {rco}}
# Type --wboard-plugin: file open {"rco file" {rco}}
# Type --webbrowser-plugin: file open {"rco file" {rco}}
# Type --webrender-plugin: file open {"rco file" {rco}}
# Type --xmb-ingame: file open {"rco file" {rco}}
# Type --xmb-plugin-normal: file open {"rco file" {rco}}
# Type --rco-label1: label {RCO Section}

namespace eval change_rco_files_adv {

    array set ::change_rco_files_adv::options {
	
		--rco-label "---------------------------------- Welcome To The RCO Section --------------------------------   : :"
        --ap-plugin "/path/to/file"
        --audioplayer-plugin "/path/to/file"
        --audioplayer-plugin-dummy "/path/to/file"
        --audioplayer-plugin-mini "/path/to/file"
        --audioplayer-plugin-util "/path/to/file"
        --auth-plugin "/path/to/file"
        --autodownload-plugin "/path/to/file"
        --avc-game-plugin "/path/to/file"
        --avc-plugin "/path/to/file"
        --avc2-game-plugin "/path/to/file"
        --avc2-game-video-plugin "/path/to/file"
        --avc2-text-plugin "/path/to/file"
        --bdp-disccheck-plugin "/path/to/file"
        --bdp-plugin "/path/to/file"
        --bdp-storage-plugin "/path/to/file"
        --category-setting-plugin "/path/to/file"
        --checker-plugin "/path/to/file"
        --custom-render-plugin "/path/to/file"
        --data-copy-plugin "/path/to/file"
        --deviceconf-plugin "/path/to/file"
        --dlna-plugin "/path/to/file"
        --download-plugin "/path/to/file"
        --dtcpip-util "/path/to/file"
        --edy-plugin "/path/to/file"
        --eula-cddb-plugin "/path/to/file"
        --eula-hcopy-plugin "/path/to/file"
        --eula-net-plugin "/path/to/file"
        --explore-category-friend "/path/to/file"
        --explore-category-game "/path/to/file"
        --explore-category-music "/path/to/file"
        --explore-category-network "/path/to/file"
        --explore-category-photo "/path/to/file"
        --explore-category-psn "/path/to/file"
        --explore-category-sysconf "/path/to/file"
        --explore-category-tv "/path/to/file"
        --explore-category-user "/path/to/file"
        --explore-category-video "/path/to/file"
        --explore-plugin-ft "/path/to/file"
        --explore-plugin-full "/path/to/file"
        --explore-plugin-game "/path/to/file"
        --explore-plugin-np "/path/to/file"
        --filecopy-plugin "/path/to/file"
        --friendim-plugin "/path/to/file"
        --friendim-plugin-game "/path/to/file"
        --friendml-plugin "/path/to/file"
        --friendml-plugin-game "/path/to/file"
        --friendtrophy-plugin "/path/to/file"
        --friendtrophy-plugin-game "/path/to/file"
        --game-ext-plugin "/path/to/file"
        --game-indicator-plugin "/path/to/file"
        --game-plugin "/path/to/file"
        --gamedata-plugin "/path/to/file"
        --gamelib-plugin "/path/to/file"
        --gameupdate-plugin "/path/to/file"
        --hknw-plugin "/path/to/file"
        --idle-plugin "/path/to/file"
        --impose-plugin "/path/to/file"
        --kensaku-plugin "/path/to/file"
        --msgdialog-plugin "/path/to/file"
        --musicbrowser-plugin "/path/to/file"
        --nas-plugin "/path/to/file"
        --netconf-plugin "/path/to/file"
        --newstore-effect "/path/to/file"
        --newstore-plugin "/path/to/file"
        --np-eula-plugin "/path/to/file"
        --np-matching-plugin "/path/to/file"
        --np-multisignin-plugin "/path/to/file"
        --np-sns-plugin "/path/to/file"
        --np-trophy-ingame "/path/to/file"
        --np-trophy-plugin "/path/to/file"
        --npsignin-plugin "/path/to/file"
        --osk-plugin "/path/to/file"
        --oskfullkeypanel-plugin "/path/to/file"
        --oskpanel-plugin "/path/to/file"
        --pesm-plugin "/path/to/file"
        --photo-network-sharing-plugin "/path/to/file"
        --photolist-plugin "/path/to/file"
        --photoupload-plugin "/path/to/file"
        --photoviewer-plugin "/path/to/file"
        --playlist-plugin "/path/to/file"
        --poweroff-plugin "/path/to/file"
        --premo-plugin "/path/to/file"
        --print-plugin "/path/to/file"
        --profile-plugin "/path/to/file"
        --profile-plugin-mini "/path/to/file"
        --ps3-savedata-plugin "/path/to/file"
        --rec-plugin "/path/to/file"
        --regcam-plugin "/path/to/file"
        --sacd-plugin "/path/to/file"
        --scenefolder-plugin "/path/to/file"
        --screenshot-plugin "/path/to/file"
        --search-service "/path/to/file"
        --software-update-plugin "/path/to/file"
        --soundvisualizer-plugin "/path/to/file"
        --strviewer-plugin "/path/to/file"
        --subdisplay-plugin "/path/to/file"
        --sv-pseudoaudioplayer-plugin "/path/to/file"
        --sysconf-plugin "/path/to/file"
        --system-plugin "/path/to/file"
        --thumthum-plugin "/path/to/file"
        --upload-util "/path/to/file"
        --user-info-plugin "/path/to/file"
        --user-plugin "/path/to/file"
        --videodownloader-plugin "/path/to/file"
        --videoeditor-plugin "/path/to/file"
        --videoplayer-plugin "/path/to/file"
        --videoplayer-util "/path/to/file"
        --vmc-savedata-plugin "/path/to/file"
        --wboard-plugin "/path/to/file"
        --webbrowser-plugin "/path/to/file"
        --webrender-plugin "/path/to/file"
        --xmb-ingame "/path/to/file"
        --xmb-plugin-normal "/path/to/file"
		--rco-label1 "-------------------------------------------------------------------------------------------------------------   : :"
    }

    proc main {} {
        variable options

		set ap_plugin [file join dev_flash vsh resource ap_plugin.rco]
		set audioplayer_plugin [file join dev_flash vsh resource audioplayer_plugin.rco]
		set audioplayer_plugin_dummy [file join dev_flash vsh resource audioplayer_plugin_dummy.rco]
		set audioplayer_plugin_mini [file join dev_flash vsh resource audioplayer_plugin_mini.rco]
		set audioplayer_plugin_util [file join dev_flash vsh resource audioplayer_plugin_util.rco]
		set auth_plugin [file join dev_flash vsh resource auth_plugin.rco]
		set autodownload_plugin [file join dev_flash vsh resource autodownload_plugin.rco]
		set avc_game_plugin [file join dev_flash vsh resource avc_game_plugin.rco]
		set avc_plugin [file join dev_flash vsh resource avc_plugin.rco]
		set avc2_game_plugin [file join dev_flash vsh resource avc2_game_plugin.rco]
		set avc2_game_video_plugin [file join dev_flash vsh resource avc2_game_video_plugin.rco]
		set avc2_text_plugin [file join dev_flash vsh resource avc2_text_plugin.rco]
		set bdp_disccheck_plugin [file join dev_flash vsh resource bdp_disccheck_plugin.rco]
		set bdp_plugin [file join dev_flash vsh resource bdp_plugin.rco]
		set bdp_storage_plugin [file join dev_flash vsh resource bdp_storage_plugin.rco]
		set category_setting_plugin [file join dev_flash vsh resource category_setting_plugin.rco]
		set checker_plugin [file join dev_flash vsh resource checker_plugin.rco]
		set custom_render_plugin [file join dev_flash vsh resource custom_render_plugin.rco]
		set data_copy_plugin [file join dev_flash vsh resource data_copy_plugin.rco]
		set deviceconf_plugin [file join dev_flash vsh resource deviceconf_plugin.rco]
		set dlna_plugin [file join dev_flash vsh resource dlna_plugin.rco]
		set download_plugin [file join dev_flash vsh resource download_plugin.rco]
		set dtcpip_util [file join dev_flash vsh resource dtcpip_util.rco]
		set edy_plugin [file join dev_flash vsh resource edy_plugin.rco]
		set eula_cddb_plugin [file join dev_flash vsh resource eula_cddb_plugin.rco]
		set eula_hcopy_plugin [file join dev_flash vsh resource eula_hcopy_plugin.rco]
		set eula_net_plugin [file join dev_flash vsh resource eula_net_plugin.rco]
		set explore_category_friend [file join dev_flash vsh resource explore_category_friend.rco]
		set explore_category_game [file join dev_flash vsh resource explore_category_game.rco]
		set explore_category_music [file join dev_flash vsh resource explore_category_music.rco]
		set explore_category_network [file join dev_flash vsh resource explore_category_network.rco]
		set explore_category_photo [file join dev_flash vsh resource explore_category_photo.rco]
		set explore_category_psn [file join dev_flash vsh resource explore_category_psn.rco]
		set explore_category_sysconf [file join dev_flash vsh resource explore_category_sysconf.rco]
		set explore_category_tv [file join dev_flash vsh resource explore_category_tv.rco]
		set explore_category_user [file join dev_flash vsh resource explore_category_user.rco]
		set explore_category_video [file join dev_flash vsh resource explore_category_video.rco]
		set explore_plugin_ft [file join dev_flash vsh resource explore_plugin_ft.rco]
		set explore_plugin_full [file join dev_flash vsh resource explore_plugin_full.rco]
		set explore_plugin_game [file join dev_flash vsh resource explore_plugin_game.rco]
		set explore_plugin_np [file join dev_flash vsh resource explore_plugin_np.rco]
		set filecopy_plugin [file join dev_flash vsh resource filecopy_plugin.rco]
		set friendim_plugin [file join dev_flash vsh resource friendim_plugin.rco]
		set friendim_plugin_game [file join dev_flash vsh resource friendim_plugin_game.rco]
		set friendml_plugin [file join dev_flash vsh resource friendml_plugin.rco]
		set friendml_plugin_game [file join dev_flash vsh resource friendml_plugin_game.rco]
		set friendtrophy_plugin [file join dev_flash vsh resource friendtrophy_plugin.rco]
		set friendtrophy_plugin_game [file join dev_flash vsh resource friendtrophy_plugin_game.rco]
		set game_ext_plugin [file join dev_flash vsh resource game_ext_plugin.rco]
		set game_indicator_plugin [file join dev_flash vsh resource game_indicator_plugin.rco]
		set game_plugin [file join dev_flash vsh resource game_plugin.rco]
		set gamedata_plugin [file join dev_flash vsh resource gamedata_plugin.rco]
		set gamelib_plugin [file join dev_flash vsh resource gamelib_plugin.rco]
		set gameupdate_plugin [file join dev_flash vsh resource gameupdate_plugin.rco]
		set hknw_plugin [file join dev_flash vsh resource hknw_plugin.rco]
		set idle_plugin [file join dev_flash vsh resource idle_plugin.rco]
		set impose_plugin [file join dev_flash vsh resource impose_plugin.rco]
		set kensaku_plugin [file join dev_flash vsh resource kensaku_plugin.rco]
		set msgdialog_plugin [file join dev_flash vsh resource msgdialog_plugin.rco]
		set musicbrowser_plugin [file join dev_flash vsh resource musicbrowser_plugin.rco]
		set nas_plugin [file join dev_flash vsh resource nas_plugin.rco]
		set netconf_plugin [file join dev_flash vsh resource netconf_plugin.rco]
		set newstore_effect [file join dev_flash vsh resource newstore_effect.rco]
		set newstore_plugin [file join dev_flash vsh resource newstore_plugin.rco]
		set np_eula_plugin [file join dev_flash vsh resource np_eula_plugin.rco]
		set np_matching_plugin [file join dev_flash vsh resource np_matching_plugin.rco]
		set np_multisignin_plugin [file join dev_flash vsh resource np_multisignin_plugin.rco]
		set np_sns_plugin [file join dev_flash vsh resource np_sns_plugin.rco]
		set np_trophy_ingame [file join dev_flash vsh resource np_trophy_ingame.rco]
		set np_trophy_plugin [file join dev_flash vsh resource np_trophy_plugin.rco]
		set npsignin_plugin [file join dev_flash vsh resource npsignin_plugin.rco]
		set osk_plugin [file join dev_flash vsh resource osk_plugin.rco]
		set oskfullkeypanel_plugin [file join dev_flash vsh resource oskfullkeypanel_plugin.rco]
		set oskpanel_plugin [file join dev_flash vsh resource oskpanel_plugin.rco]
		set pesm_plugin [file join dev_flash vsh resource pesm_plugin.rco]
		set photo_network_sharing_plugin [file join dev_flash vsh resource photo_network_sharing_plugin.rco]
		set photolist_plugin [file join dev_flash vsh resource photolist_plugin.rco]
		set photoupload_plugin [file join dev_flash vsh resource photoupload_plugin.rco]
		set photoviewer_plugin [file join dev_flash vsh resource photoviewer_plugin.rco]
		set playlist_plugin [file join dev_flash vsh resource playlist_plugin.rco]
		set poweroff_plugin [file join dev_flash vsh resource poweroff_plugin.rco]
		set premo_plugin [file join dev_flash vsh resource premo_plugin.rco]
		set print_plugin [file join dev_flash vsh resource print_plugin.rco]
		set profile_plugin [file join dev_flash vsh resource profile_plugin.rco]
		set profile_plugin_mini [file join dev_flash vsh resource profile_plugin_mini.rco]
		set ps3_savedata_plugin [file join dev_flash vsh resource ps3_savedata_plugin.rco]
		set rec_plugin [file join dev_flash vsh resource rec_plugin.rco]
		set regcam_plugin [file join dev_flash vsh resource regcam_plugin.rco]
		set sacd_plugin [file join dev_flash vsh resource sacd_plugin.rco]
		set scenefolder_plugin [file join dev_flash vsh resource scenefolder_plugin.rco]
		set screenshot_plugin [file join dev_flash vsh resource screenshot_plugin.rco]
		set search_service [file join dev_flash vsh resource search_service.rco]
		set software_update_plugin [file join dev_flash vsh resource software_update_plugin.rco]
		set soundvisualizer_plugin [file join dev_flash vsh resource soundvisualizer_plugin.rco]
		set strviewer_plugin [file join dev_flash vsh resource strviewer_plugin.rco]
		set subdisplay_plugin [file join dev_flash vsh resource subdisplay_plugin.rco]
		set sv_pseudoaudioplayer_plugin [file join dev_flash vsh resource sv_pseudoaudioplayer_plugin.rco]
		set sysconf_plugin [file join dev_flash vsh resource sysconf_plugin.rco]
		set system_plugin [file join dev_flash vsh resource system_plugin.rco]
		set thumthum_plugin [file join dev_flash vsh resource thumthum_plugin.rco]
		set upload_util [file join dev_flash vsh resource upload_util.rco]
		set user_info_plugin [file join dev_flash vsh resource user_info_plugin.rco]
		set user_plugin [file join dev_flash vsh resource user_plugin.rco]
		set videodownloader_plugin [file join dev_flash vsh resource videodownloader_plugin.rco]
		set videoeditor_plugin [file join dev_flash vsh resource videoeditor_plugin.rco]
		set videoplayer_plugin [file join dev_flash vsh resource videoplayer_plugin.rco]
		set videoplayer_util [file join dev_flash vsh resource videoplayer_util.rco]
		set vmc_savedata_plugin [file join dev_flash vsh resource vmc_savedata_plugin.rco]
		set wboard_plugin [file join dev_flash vsh resource wboard_plugin.rco]
		set webbrowser_plugin [file join dev_flash vsh resource webbrowser_plugin.rco]
		set webrender_plugin [file join dev_flash vsh resource webrender_plugin.rco]
		set xmb_ingame [file join dev_flash vsh resource xmb_ingame.rco]
		set xmb_plugin_normal [file join dev_flash vsh resource xmb_plugin_normal.rco]

		if {[file exists $options(--ap-plugin)] == 0 } {
            log "Skipping ap_plugin, $options(--ap-plugin) does not exist"
        } else {
            ::modify_devflash_file ${ap_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--ap-plugin)
        }
		
		if {[file exists $options(--audioplayer-plugin)] == 0 } {
            log "Skipping audioplayer_plugin, $options(--audioplayer-plugin) does not exist"
        } else {
            ::modify_devflash_file ${audioplayer_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--audioplayer-plugin)
        }
		
		if {[file exists $options(--audioplayer-plugin-dummy)] == 0 } {
            log "Skipping audioplayer-plugin-dummy, $options(--audioplayer-plugin-dummy) does not exist"
        } else {
            ::modify_devflash_file ${audioplayer_plugin_dummy} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--audioplayer-plugin-dummy)
        }
		
		if {[file exists $options(--audioplayer-plugin-mini)] == 0 } {
            log "Skipping audioplayer_plugin_mini, $options(--audioplayer-plugin-mini) does not exist"
        } else {
            ::modify_devflash_file ${audioplayer_plugin_mini} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--audioplayer-plugin-mini)
        }
		
		if {[file exists $options(--audioplayer-plugin-util)] == 0 } {
            log "Skipping audioplayer_plugin_util, $options(--audioplayer-plugin-util) does not exist"
        } else {
            ::modify_devflash_file ${audioplayer_plugin_util} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--audioplayer-plugin-util)
        }
		
		if {[file exists $options(--auth-plugin)] == 0 } {
            log "Skipping auth_plugin, $options(--auth-plugin) does not exist"
        } else {
            ::modify_devflash_file ${auth_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--auth-plugin)
        }
		
		if {[file exists $options(--autodownload-plugin)] == 0 } {
            log "Skipping autodownload_plugin, $options(--autodownload-plugin) does not exist"
        } else {
            ::modify_devflash_file ${autodownload_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--autodownload-plugin)
        }
		
		if {[file exists $options(--avc-game-plugin)] == 0 } {
            log "Skipping avc_game_plugin, $options(--avc-game-plugin) does not exist"
        } else {
            ::modify_devflash_file ${avc_game_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--avc-game-plugin)
        }
		
		if {[file exists $options(--avc-plugin)] == 0 } {
            log "Skipping avc_plugin, $options(--avc-plugin) does not exist"
        } else {
            ::modify_devflash_file ${avc_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--avc-plugin)
        }
		
		if {[file exists $options(--avc2-game-plugin)] == 0 } {
            log "Skipping avc2_game_plugin, $options(--avc2-game-plugin) does not exist"
        } else {
            ::modify_devflash_file ${avc2_game_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--avc2-game-plugin)
        }
		
		if {[file exists $options(--avc2-game-video-plugin)] == 0 } {
            log "Skipping avc2_game_video_plugin, $options(--avc2-game-video-plugin) does not exist"
        } else {
            ::modify_devflash_file ${avc2_game_video_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--avc2-game-video-plugin)
        }
		
		if {[file exists $options(--avc2-text-plugin)] == 0 } {
            log "Skipping avc2_text_plugin, $options(--avc2-text-plugin) does not exist"
        } else {
            ::modify_devflash_file ${avc2_text_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--avc2-text-plugin)
        }
		
		if {[file exists $options(--bdp-disccheck-plugin)] == 0 } {
            log "Skipping bdp_disccheck_plugin, $options(--bdp-disccheck-plugin) does not exist"
        } else {
            ::modify_devflash_file ${bdp_disccheck_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--bdp-disccheck-plugin)
        }
		
		if {[file exists $options(--bdp-plugin)] == 0 } {
            log "Skipping bdp_plugin, $options(--bdp-plugin) does not exist"
        } else {
            ::modify_devflash_file ${bdp_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--bdp-plugin)
        }
		
		if {[file exists $options(--bdp-storage-plugin)] == 0 } {
            log "Skipping bdp_storage_plugin, $options(--bdp-storage-plugin) does not exist"
        } else {
            ::modify_devflash_file ${bdp_storage_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--bdp-storage-plugin)
        }
		
		if {[file exists $options(--category-setting-plugin)] == 0 } {
            log "Skipping category_setting_plugin, $options(--category-setting-plugin) does not exist"
        } else {
            ::modify_devflash_file ${category_setting_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--category-setting-plugin)
        }
		
		if {[file exists $options(--checker-plugin)] == 0 } {
            log "Skipping checker_plugin, $options(--checker-plugin) does not exist"
        } else {
            ::modify_devflash_file ${checker_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--checker-plugin)
        }
		
		if {[file exists $options(--custom-render-plugin)] == 0 } {
            log "Skipping custom_render_plugin, $options(--custom-render-plugin) does not exist"
        } else {
            ::modify_devflash_file ${custom_render_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--custom-render-plugin)
        }
		
		if {[file exists $options(--data-copy-plugin)] == 0 } {
            log "Skipping data_copy_plugin, $options(--data-copy-plugin) does not exist"
        } else {
            ::modify_devflash_file ${data_copy_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--data-copy-plugin)
        }
		
		if {[file exists $options(--deviceconf-plugin)] == 0 } {
            log "Skipping deviceconf_plugin, $options(--deviceconf-plugin) does not exist"
        } else {
            ::modify_devflash_file ${deviceconf_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--deviceconf-plugin)
        }
		
		if {[file exists $options(--dlna-plugin)] == 0 } {
            log "Skipping dlna_plugin, $options(--dlna-plugin) does not exist"
        } else {
            ::modify_devflash_file ${dlna_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--dlna-plugin)
        }
		
		if {[file exists $options(--download-plugin)] == 0 } {
            log "Skipping download_plugin, $options(--download-plugin) does not exist"
        } else {
            ::modify_devflash_file ${download_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--download-plugin)
        }
		
		if {[file exists $options(--dtcpip-util)] == 0 } {
            log "Skipping dtcpip_util, $options(--dtcpip-util) does not exist"
        } else {
            ::modify_devflash_file ${dtcpip_util} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--dtcpip-util)
        }
		
		if {[file exists $options(--edy-plugin)] == 0 } {
            log "Skipping edy_plugin, $options(--edy-plugin) does not exist"
        } else {
            ::modify_devflash_file ${edy_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--edy-plugin)
        }
		
		if {[file exists $options(--eula-cddb-plugin)] == 0 } {
            log "Skipping eula_cddb_plugin, $options(--eula-cddb-plugin) does not exist"
        } else {
            ::modify_devflash_file ${eula_cddb_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--eula-cddb-plugin)
        }
		
		if {[file exists $options(--eula-hcopy-plugin)] == 0 } {
            log "Skipping eula_hcopy_plugin, $options(--eula-hcopy-plugin) does not exist"
        } else {
            ::modify_devflash_file ${eula_hcopy_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--eula-hcopy-plugin)
        }
		
		if {[file exists $options(--eula-net-plugin)] == 0 } {
            log "Skipping eula_net_plugin, $options(--eula-net-plugin) does not exist"
        } else {
            ::modify_devflash_file ${eula_net_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--eula-net-plugin)
        }
		
		if {[file exists $options(--explore-category-friend)] == 0 } {
            log "Skipping explore_category_friend, $options(--explore-category-friend) does not exist"
        } else {
            ::modify_devflash_file ${explore_category_friend} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--explore-category-friend)
        }
		
		if {[file exists $options(--explore-category-game)] == 0 } {
            log "Skipping explore_category_game, $options(--explore-category-game) does not exist"
        } else {
            ::modify_devflash_file ${explore_category_game} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--explore-category-game)
        }
		
		if {[file exists $options(--explore-category-music)] == 0 } {
            log "Skipping explore_category_music, $options(--explore-category-music) does not exist"
        } else {
            ::modify_devflash_file ${explore_category_music} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--explore-category-music)
        }
		
		if {[file exists $options(--explore-category-network)] == 0 } {
            log "Skipping explore_category_network, $options(--explore-category-network) does not exist"
        } else {
            ::modify_devflash_file ${explore_category_network} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--explore-category-network)
        }
		
		if {[file exists $options(--explore-category-photo)] == 0 } {
            log "Skipping explore_category_photo, $options(--explore-category-photo) does not exist"
        } else {
            ::modify_devflash_file ${explore_category_photo} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--explore-category-photo)
        }
		
		if {[file exists $options(--explore-category-psn)] == 0 } {
            log "Skipping explore_category_psn, $options(--explore-category-psn) does not exist"
        } else {
            ::modify_devflash_file ${explore_category_psn} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--explore-category-psn)
        }
		
		if {[file exists $options(--explore-category-sysconf)] == 0 } {
            log "Skipping explore_category_sysconf, $options(--explore-category-sysconf) does not exist"
        } else {
            ::modify_devflash_file ${explore_category_sysconf} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--explore-category-sysconf)
        }
		
		if {[file exists $options(--explore-category-tv)] == 0 } {
            log "Skipping explore_category_tv, $options(--explore-category-tv) does not exist"
        } else {
            ::modify_devflash_file ${explore_category_tv} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--explore-category-tv)
        }
		
		if {[file exists $options(--explore-category-user)] == 0 } {
            log "Skipping explore_category_user, $options(--explore-category-user) does not exist"
        } else {
            ::modify_devflash_file ${explore_category_user} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--explore-category-user)
        }
		
		if {[file exists $options(--explore-category-video)] == 0 } {
            log "Skipping explore_category_video, $options(--explore-category-video) does not exist"
        } else {
            ::modify_devflash_file ${explore_category_video} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--explore-category-video)
        }
		
		if {[file exists $options(--explore-plugin-ft)] == 0 } {
            log "Skipping explore_plugin_ft, $options(--explore-plugin-ft) does not exist"
        } else {
            ::modify_devflash_file ${explore_plugin_ft} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--explore-plugin-ft)
        }
		
		if {[file exists $options(--explore-plugin-full)] == 0 } {
            log "Skipping explore_plugin_full, $options(--explore-plugin-full) does not exist"
        } else {
            ::modify_devflash_file ${explore_plugin_full} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--explore-plugin-full)
        }
		
		if {[file exists $options(--explore-plugin-game)] == 0 } {
            log "Skipping explore_plugin_game, $options(--explore-plugin-game) does not exist"
        } else {
            ::modify_devflash_file ${explore_plugin_game} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--explore-plugin-game)
        }
		
		if {[file exists $options(--explore-plugin-np)] == 0 } {
            log "Skipping explore_plugin_np, $options(--explore-plugin-np) does not exist"
        } else {
            ::modify_devflash_file ${explore_plugin_np} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--explore-plugin-np)
        }
		
		if {[file exists $options(--filecopy-plugin)] == 0 } {
            log "Skipping filecopy_plugin, $options(--filecopy-plugin) does not exist"
        } else {
            ::modify_devflash_file ${filecopy_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--filecopy-plugin)
        }
		
		if {[file exists $options(--friendim-plugin)] == 0 } {
            log "Skipping friendim_plugin, $options(--friendim-plugin) does not exist"
        } else {
            ::modify_devflash_file ${friendim_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--friendim-plugin)
        }
		
		if {[file exists $options(--friendim-plugin-game)] == 0 } {
            log "Skipping friendim_plugin_game, $options(--friendim-plugin-game) does not exist"
        } else {
            ::modify_devflash_file ${friendim_plugin_game} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--friendim-plugin-game)
        }
		
		if {[file exists $options(--friendml-plugin)] == 0 } {
            log "Skipping friendml_plugin, $options(--friendml-plugin) does not exist"
        } else {
            ::modify_devflash_file ${friendml_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--friendml-plugin)
        }
		
		if {[file exists $options(--friendml-plugin-game)] == 0 } {
            log "Skipping friendml_plugin_game, $options(--friendml-plugin-game) does not exist"
        } else {
            ::modify_devflash_file ${friendml_plugin_game} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--friendml-plugin-game)
        }
		
		if {[file exists $options(--friendtrophy-plugin)] == 0 } {
            log "Skipping friendtrophy_plugin, $options(--friendtrophy-plugin) does not exist"
        } else {
            ::modify_devflash_file ${friendtrophy_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--friendtrophy-plugin)
        }
		
		if {[file exists $options(--friendtrophy-plugin-game)] == 0 } {
            log "Skipping friendtrophy_plugin_game, $options(--friendtrophy-plugin-game) does not exist"
        } else {
            ::modify_devflash_file ${friendtrophy_plugin_game} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--friendtrophy-plugin-game)
        }
		
		if {[file exists $options(--game-ext-plugin)] == 0 } {
            log "Skipping game_ext_plugin, $options(--game-ext-plugin) does not exist"
        } else {
            ::modify_devflash_file ${game_ext_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--game-ext-plugin)
        }
		
		if {[file exists $options(--game-indicator-plugin)] == 0 } {
            log "Skipping game_indicator_plugin, $options(--game-indicator-plugin) does not exist"
        } else {
            ::modify_devflash_file ${game_indicator_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--game-indicator-plugin)
        }
		
		if {[file exists $options(--game-plugin)] == 0 } {
            log "Skipping game_plugin, $options(--game-plugin) does not exist"
        } else {
            ::modify_devflash_file ${game_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--game-plugin)
        }
		
		if {[file exists $options(--gamedata-plugin)] == 0 } {
            log "Skipping gamedata_plugin, $options(--gamedata-plugin) does not exist"
        } else {
            ::modify_devflash_file ${gamedata_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--gamedata-plugin)
        }
		
		if {[file exists $options(--gamelib-plugin)] == 0 } {
            log "Skipping gamelib_plugin, $options(--gamelib-plugin) does not exist"
        } else {
            ::modify_devflash_file ${gamelib_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--gamelib-plugin)
        }

		if {[file exists $options(--gameupdate-plugin)] == 0 } {
            log "Skipping gameupdate_plugin, $options(--gameupdate-plugin) does not exist"
        } else {
            ::modify_devflash_file ${gameupdate_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--gameupdate-plugin)
        }
		
		if {[file exists $options(--hknw-plugin)] == 0 } {
            log "Skipping hknw_plugin, $options(--hknw-plugin) does not exist"
        } else {
            ::modify_devflash_file ${hknw_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--hknw-plugin)
        }
		
		if {[file exists $options(--idle-plugin)] == 0 } {
            log "Skipping idle_plugin, $options(--idle-plugin) does not exist"
        } else {
            ::modify_devflash_file ${idle_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--idle-plugin)
        }
		
		if {[file exists $options(--impose-plugin)] == 0 } {
            log "Skipping impose_plugin, $options(--impose-plugin) does not exist"
        } else {
            ::modify_devflash_file ${impose_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--impose-plugin)
        }
		
		if {[file exists $options(--kensaku-plugin)] == 0 } {
            log "Skipping kensaku_plugin, $options(--kensaku-plugin) does not exist"
        } else {
            ::modify_devflash_file ${kensaku_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--kensaku-plugin)
        }
		
		if {[file exists $options(--msgdialog-plugin)] == 0 } {
            log "Skipping msgdialog_plugin, $options(--msgdialog-plugin) does not exist"
        } else {
            ::modify_devflash_file ${msgdialog_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--msgdialog-plugin)
        }
		
		if {[file exists $options(--musicbrowser-plugin)] == 0 } {
            log "Skipping musicbrowser_plugin, $options(--musicbrowser-plugin) does not exist"
        } else {
            ::modify_devflash_file ${musicbrowser_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--musicbrowser-plugin)
        }
		
		if {[file exists $options(--nas-plugin)] == 0 } {
            log "Skipping nas_plugin, $options(--nas-plugin) does not exist"
        } else {
            ::modify_devflash_file ${nas_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--nas-plugin)
        }
		
		if {[file exists $options(--netconf-plugin)] == 0 } {
            log "Skipping netconf_plugin, $options(--netconf-plugin) does not exist"
        } else {
            ::modify_devflash_file ${netconf_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--netconf-plugin)
        }
		
		if {[file exists $options(--newstore-effect)] == 0 } {
            log "Skipping newstore_effect, $options(--newstore-effect) does not exist"
        } else {
            ::modify_devflash_file ${newstore_effect} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--newstore-effect)
        }
		
		if {[file exists $options(--newstore-plugin)] == 0 } {
            log "Skipping newstore_plugin, $options(--newstore-plugin) does not exist"
        } else {
            ::modify_devflash_file ${newstore_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--newstore-plugin)
        }
		
		if {[file exists $options(--np-eula-plugin)] == 0 } {
            log "Skipping np_eula_plugin, $options(--np-eula-plugin) does not exist"
        } else {
            ::modify_devflash_file ${np_eula_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--np-eula-plugin)
        }
		
		if {[file exists $options(--np-matching-plugin)] == 0 } {
            log "Skipping np_matching_plugin, $options(--np-matching-plugin) does not exist"
        } else {
            ::modify_devflash_file ${np_matching_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--np-matching-plugin)
        }
		
		if {[file exists $options(--np-multisignin-plugin)] == 0 } {
            log "Skipping np_multisignin_plugin, $options(--np-multisignin-plugin) does not exist"
        } else {
            ::modify_devflash_file ${np_multisignin_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--np-multisignin-plugin)
        }
		
		if {[file exists $options(--np-sns-plugin)] == 0 } {
            log "Skipping np_sns_plugin, $options(--np-sns-plugin) does not exist"
        } else {
            ::modify_devflash_file ${np_sns_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--np-sns-plugin)
        }
		
		if {[file exists $options(--np-trophy-ingame)] == 0 } {
            log "Skipping np_trophy_ingame, $options(--np-trophy-ingame) does not exist"
        } else {
            ::modify_devflash_file ${np_trophy_ingame} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--np-trophy-ingame)
        }
		
		if {[file exists $options(--np-trophy-plugin)] == 0 } {
            log "Skipping np_trophy_plugin, $options(--np-trophy-plugin) does not exist"
        } else {
            ::modify_devflash_file ${np_trophy_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--np-trophy-plugin)
        }
		
		if {[file exists $options(--npsignin-plugin)] == 0 } {
            log "Skipping npsignin_plugin, $options(--npsignin-plugin) does not exist"
        } else {
            ::modify_devflash_file ${npsignin_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--npsignin-plugin)
        }
		
		if {[file exists $options(--osk-plugin)] == 0 } {
            log "Skipping osk_plugin, $options(--osk-plugin) does not exist"
        } else {
            ::modify_devflash_file ${osk_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--osk-plugin)
        }
		
		if {[file exists $options(--oskfullkeypanel-plugin)] == 0 } {
            log "Skipping oskfullkeypanel_plugin, $options(--oskfullkeypanel-plugin) does not exist"
        } else {
            ::modify_devflash_file ${oskfullkeypanel_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--oskfullkeypanel-plugin)
        }
		
		if {[file exists $options(--oskpanel-plugin)] == 0 } {
            log "Skipping oskpanel_plugin, $options(--oskpanel-plugin) does not exist"
        } else {
            ::modify_devflash_file ${oskpanel_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--oskpanel-plugin)
        }
		
		if {[file exists $options(--pesm-plugin)] == 0 } {
            log "Skipping pesm_plugin, $options(--pesm-plugin) does not exist"
        } else {
            ::modify_devflash_file ${pesm_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--pesm-plugin)
        }
		
		if {[file exists $options(--photo-network-sharing-plugin)] == 0 } {
            log "Skipping photo_network_sharing_plugin, $options(--photo-network-sharing-plugin) does not exist"
        } else {
            ::modify_devflash_file ${photo_network_sharing_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--photo-network-sharing-plugin)
        }
		
		if {[file exists $options(--photolist-plugin)] == 0 } {
            log "Skipping photolist_plugin, $options(--photolist-plugin) does not exist"
        } else {
            ::modify_devflash_file ${photolist_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--photolist-plugin)
        }
		
		if {[file exists $options(--photoupload-plugin)] == 0 } {
            log "Skipping photoupload_plugin, $options(--photoupload-plugin) does not exist"
        } else {
            ::modify_devflash_file ${photoupload_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--photoupload-plugin)
        }
		
		if {[file exists $options(--photoviewer-plugin)] == 0 } {
            log "Skipping photoviewer_plugin, $options(--photoviewer-plugin) does not exist"
        } else {
            ::modify_devflash_file ${photoviewer_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--photoviewer-plugin)
        }
		
		if {[file exists $options(--playlist-plugin)] == 0 } {
            log "Skipping playlist_plugin, $options(--playlist-plugin) does not exist"
        } else {
            ::modify_devflash_file ${playlist_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--playlist-plugin)
        }
		
		if {[file exists $options(--poweroff-plugin)] == 0 } {
            log "Skipping poweroff_plugin, $options(--poweroff-plugin) does not exist"
        } else {
            ::modify_devflash_file ${poweroff_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--poweroff-plugin)
        }
		
		if {[file exists $options(--premo-plugin)] == 0 } {
            log "Skipping premo_plugin, $options(--premo-plugin) does not exist"
        } else {
            ::modify_devflash_file ${premo_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--premo-plugin)
        }
		
		if {[file exists $options(--print-plugin)] == 0 } {
            log "Skipping print_plugin, $options(--print-plugin) does not exist"
        } else {
            ::modify_devflash_file ${print_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--print-plugin)
        }
		
		if {[file exists $options(--profile-plugin)] == 0 } {
            log "Skipping profile_plugin, $options(--profile-plugin) does not exist"
        } else {
            ::modify_devflash_file ${profile_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--profile-plugin)
        }
		
		if {[file exists $options(--profile-plugin-mini)] == 0 } {
            log "Skipping profile_plugin_mini, $options(--profile-plugin-mini) does not exist"
        } else {
            ::modify_devflash_file ${profile_plugin_mini} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--profile-plugin-mini)
        }
		
		if {[file exists $options(--ps3-savedata-plugin)] == 0 } {
            log "Skipping ps3_savedata_plugin, $options(--ps3-savedata-plugin) does not exist"
        } else {
            ::modify_devflash_file ${ps3_savedata_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--ps3-savedata-plugin)
        }
		
		if {[file exists $options(--rec-plugin)] == 0 } {
            log "Skipping rec_plugin, $options(--rec-plugin) does not exist"
        } else {
            ::modify_devflash_file ${rec_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--rec-plugin)
        }
		
		if {[file exists $options(--regcam-plugin)] == 0 } {
            log "Skipping regcam_plugin, $options(--regcam-plugin) does not exist"
        } else {
            ::modify_devflash_file ${regcam_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--regcam-plugin)
        }
		
		if {[file exists $options(--sacd-plugin)] == 0 } {
            log "Skipping sacd_plugin, $options(--sacd-plugin) does not exist"
        } else {
            ::modify_devflash_file ${sacd_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--sacd-plugin)
        }
		
		if {[file exists $options(--scenefolder-plugin)] == 0 } {
            log "Skipping scenefolder_plugin, $options(--scenefolder-plugin) does not exist"
        } else {
            ::modify_devflash_file ${scenefolder_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--scenefolder-plugin)
        }
		
		if {[file exists $options(--screenshot-plugin)] == 0 } {
            log "Skipping screenshot_plugin, $options(--screenshot-plugin) does not exist"
        } else {
            ::modify_devflash_file ${screenshot_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--screenshot-plugin)
        }
		
		if {[file exists $options(--search-service)] == 0 } {
            log "Skipping search_service, $options(--search-service) does not exist"
        } else {
            ::modify_devflash_file ${search_service} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--search-service)
        }
		
		if {[file exists $options(--software-update-plugin)] == 0 } {
            log "Skipping software_update_plugin, $options(--software-update-plugin) does not exist"
        } else {
            ::modify_devflash_file ${software_update_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--software-update-plugin)
        }
		
		if {[file exists $options(--soundvisualizer-plugin)] == 0 } {
            log "Skipping soundvisualizer_plugin, $options(--soundvisualizer-plugin) does not exist"
        } else {
            ::modify_devflash_file ${soundvisualizer_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--soundvisualizer-plugin)
        }
		
		if {[file exists $options(--strviewer-plugin)] == 0 } {
            log "Skipping strviewer_plugin, $options(--strviewer-plugin) does not exist"
        } else {
            ::modify_devflash_file ${strviewer_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--strviewer-plugin)
        }
		
		if {[file exists $options(--subdisplay-plugin)] == 0 } {
            log "Skipping subdisplay_plugin, $options(--subdisplay-plugin) does not exist"
        } else {
            ::modify_devflash_file ${subdisplay_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--subdisplay-plugin)
        }
		
		if {[file exists $options(--sv-pseudoaudioplayer-plugin)] == 0 } {
            log "Skipping sv_pseudoaudioplayer_plugin, $options(--sv-pseudoaudioplayer-plugin) does not exist"
        } else {
            ::modify_devflash_file ${sv_pseudoaudioplayer_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--sv-pseudoaudioplayer-plugin)
        }
		
		if {[file exists $options(--sysconf-plugin)] == 0 } {
            log "Skipping sysconf_plugin, $options(--sysconf-plugin) does not exist"
        } else {
            ::modify_devflash_file ${sysconf_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--sysconf-plugin)
        }
		
		if {[file exists $options(--system-plugin)] == 0 } {
            log "Skipping system_plugin, $options(--system-plugin) does not exist"
        } else {
            ::modify_devflash_file ${system_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--system-plugin)
        }
		
		if {[file exists $options(--thumthum-plugin)] == 0 } {
            log "Skipping thumthum_plugin, $options(--thumthum-plugin) does not exist"
        } else {
            ::modify_devflash_file ${thumthum_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--thumthum-plugin)
        }
		
		if {[file exists $options(--upload-util)] == 0 } {
            log "Skipping upload_util, $options(--upload-util) does not exist"
        } else {
            ::modify_devflash_file ${upload_util} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--upload-util)
        }
				
		if {[file exists $options(--user-info-plugin)] == 0 } {
            log "Skipping user_info_plugin, $options(--user-info-plugin) does not exist"
        } else {
            ::modify_devflash_file ${user_info_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--user-info-plugin)
        }
		
		if {[file exists $options(--user-plugin)] == 0 } {
            log "Skipping user_plugin, $options(--user-plugin) does not exist"
        } else {
            ::modify_devflash_file ${user_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--user-plugin)
        }
		
		if {[file exists $options(--videodownloader-plugin)] == 0 } {
            log "Skipping videodownloader_plugin, $options(--videodownloader-plugin) does not exist"
        } else {
            ::modify_devflash_file ${videodownloader_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--videodownloader-plugin)
        }
		
		if {[file exists $options(--videoeditor-plugin)] == 0 } {
            log "Skipping videoeditor_plugin, $options(--videoeditor-plugin) does not exist"
        } else {
            ::modify_devflash_file ${videoeditor_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--videoeditor-plugin)
        }
		
		if {[file exists $options(--videoplayer-plugin)] == 0 } {
            log "Skipping videoplayer_plugin, $options(--videoplayer-plugin) does not exist"
        } else {
            ::modify_devflash_file ${videoplayer_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--videoplayer-plugin)
        }
		
		if {[file exists $options(--videoplayer-util)] == 0 } {
            log "Skipping videoplayer_util, $options(--videoplayer-util) does not exist"
        } else {
            ::modify_devflash_file ${videoplayer_util} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--videoplayer-util)
        }
		
		if {[file exists $options(--vmc-savedata-plugin)] == 0 } {
            log "Skipping vmc_savedata_plugin, $options(--vmc-savedata-plugin) does not exist"
        } else {
            ::modify_devflash_file ${vmc_savedata_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--vmc-savedata-plugin)
        }
		
		if {[file exists $options(--wboard-plugin)] == 0 } {
            log "Skipping wboard_plugin, $options(--wboard-plugin) does not exist"
        } else {
            ::modify_devflash_file ${wboard_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--wboard-plugin)
        }
		
		if {[file exists $options(--webbrowser-plugin)] == 0 } {
            log "Skipping webbrowser_plugin, $options(--webbrowser-plugin) does not exist"
        } else {
            ::modify_devflash_file ${webbrowser_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--webbrowser-plugin)
        }
		
		if {[file exists $options(--webrender-plugin)] == 0 } {
            log "Skipping webrender_plugin, $options(--webrender-plugin) does not exist"
        } else {
            ::modify_devflash_file ${webrender_plugin} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--webrender-plugin)
        }
		
		if {[file exists $options(--xmb-ingame)] == 0 } {
            log "Skipping xmb_ingame, $options(--xmb-ingame) does not exist"
        } else {
            ::modify_devflash_file ${xmb_ingame} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--xmb-ingame)
        }
		
		if {[file exists $options(--xmb-plugin-normal)] == 0 } {
            log "Skipping xmb_plugin_normal, $options(--xmb-plugin-normal) does not exist"
        } else {
            ::modify_devflash_file ${xmb_plugin_normal} ::change_rco_files_adv::copy_rco_file_adv $::change_rco_files_adv::options(--xmb-plugin-normal)
        }
    }

    proc copy_rco_file_adv { dst src } {
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
