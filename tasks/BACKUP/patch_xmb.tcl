#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
# Copyright (C) RedDot-3ND7355 (For making this simpler and smaller)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#
    
# Priority: 11
# Description: [4.xx] Patch XMB

# Option --label::
# Option --pointer: [4.xx&Pointer&Broken] Read the label!
# Option --add-install-pkg: [4.xx] Add the standart Install Package Files Segment to the HomeBrew Category in XMB
# Option --patch-app-home: [Needs Fix] Add "/app_home" icon to the XMB Game Category

# Type --label: label
# Type --pointer: boolean
# Type --add-install-pkg: boolean
# Type --patch-app-home: boolean


namespace eval patch_xmb {
    
    array set ::patch_xmb::options {
	    --label "Only turn on Pointer if 'Add standart ipf...' [or/and] 'Add /app_home icon...' are on!"
		--pointer true
        --add-install-pkg true
        --patch-app-home true
    }

    proc main {} {
        variable options
		set self [file join ${::CUSTOM_TEMPLAT_DIR} mfw_templat.xml]
		set rapeo "cond=An+Game:Game.category"
		set rapen "cond=An+Game:Game.category X4+An+Game:Game.category X0+An+Game:Game.category"
		
		if {$::patch_xmb::options(--add-install-pkg)} {
        log "Doing Add Install pkg Routine"
			set self [file join dev_flash vsh resource explore_plugin_full.rco]
			::modify_rco_file $self ::patch_xmb::callback_homebrew
			set self [file join dev_flash vsh resource xmb_ingame.rco]
		    ::modify_rco_file $self ::patch_xmb::callback_homebrew
        log "Done Add Install pkg Routine"
		}
	
        if {$::patch_xmb::options(--pointer)} {
	    log "Doing the following: Pointer, Add the standart Install Package Files Routine"
		set self [file join ${::CUSTOM_TEMPLAT_DIR} mfw_templat.xml]
            ::patch_xmb::find_nodes $self
			set self [file join dev_flash vsh resource xmb category_game_tool2.xml]
            ::patch_xmb::find_nodes1 $self
			set self [file join dev_flash vsh resource xmb category_game.xml]
		    ::patch_xmb::inject_nodes2 $self
			set self [file join dev_flash vsh resource xmb category_network.xml]
            ::patch_xmb::read_cat $self
            ::patch_xmb::inject_node $self
			set self [file join dev_flash vsh resource xmb category_psn.xml]
            ::patch_xmb::inject_cat $self
			log "Done pointer tasks"
        }
	}

    proc patch_self {self} {
        log "Patching [file tail $self]"
        ::modify_self_file $[file tail $self] ::patch_xmb::patch_elf
    }

	proc patch_act {elf} {
	log "Patching RCO to add Install Package Files back to the XMB..."
         
            set search  "\xF8\x21\xFE\xD1\x7C\x08\x02\xA6\xFB\x81\x01\x10\x3B\x81\x00\x70"
            set replace "\x38\x60\x00\x01\x4E\x80\x00\x20"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
			log "Patched!"
			
	set self [file join dev_flash vsh resource explore_plugin_full.rco]
    ::modify_rco_file $self ::patch_xmb::patch_elf::act_part2
	}
	
    proc patch_elf {elf} {
	
		log "Patching [file tail $elf] to add tv category"
       
        set search  "\x64\x65\x76\x5f\x68\x64\x64\x30\x2f\x67\x61\x6d\x65\x2f\x42\x43\x45\x53\x30\x30\x32\x37\x35"
        set replace "\x64\x65\x76\x5f\x66\x6c\x61\x73\x68\x2f\x64\x61\x74\x61\x2f\x63\x65\x72\x74\x00\x00\x00\x00"
       
        catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
		
		proc act_part2 {elf} {
		log "Patching [file tail $elf] to add Install Package Files back to the XMB"
         
            set search  "\xF8\x21\xFE\xD1\x7C\x08\x02\xA6\xFB\x81\x01\x10\x3B\x81\x00\x70"
            set replace "\x38\x60\x00\x01\x4E\x80\x00\x20"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
		}
    }
    
    proc alpha_sort {path args} {
        log "Patching Alphabetical Sort for Games in file [file tail $path]"
        sed_in_place [file join $path] -Game:Common.stat.rating-Game:Common.timeCreated+Game:Common.titleForSort-Game:Game.category -Game:Common.stat.rating-Game:Common.title+Game:Common.titleForSort-Game:Game.category
        sed_in_place [file join $path] -Game:Common.stat.rating+Game:Common.timeCreated+Game:Common.titleForSort-Game:Game.category -Game:Common.stat.rating+Game:Common.title+Game:Common.titleForSort-Game:Game.category
        sed_in_place [file join $path] -Game:Common.stat.rating-Game:Common.stat.timeLastUsed+Game:Common.titleForSort-Game:Common.timeCreated-Game:Game.category -Game:Common.stat.rating-Game:Common.stat.timeLastUsed+Game:Common.titleForSort-Game:Common.title-Game:Game.category
        sed_in_place [file join $path] -Game:Common.stat.rating+Game:Common.titleForSort-Game:Common.timeCreated-Game:Game.category -Game:Common.stat.rating+Game:Common.titleForSort-Game:Common.title-Game:Game.category
        sed_in_place [file join $path] -Game:Common.stat.rating+Game:Game.gameCategory-Game:Common.timeCreated+Game:Common.titleForSort -Game:Common.stat.rating+Game:Game.gameCategory-Game:Common.title+Game:Common.titleForSort
        
    }
    
    proc rape_sfo {path args} {
        log "Patching Rape SFO in file [file tail $path]"
		set rapeo "cond=An+Game:Game.category"
		set rapen "cond=An+Game:Game.category X4+An+Game:Game.category X0+An+Game:Game.category"
        sed_in_place [file join $path] $rapeo $rapen       
    }

    proc callback_fix_typo_sysconf_Italian {path args} {
        log "Patching Italian.xml into [file tail $path]"
        sed_in_place [file join $path Italian.xml] backuip backup
    }

    proc callback_discless {path args} {
        log "Patching English.xml into [file tail $path]"
        sed_in_place [file join $path English.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching German.xml into [file tail $path]"
        sed_in_place [file join $path German.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Korean.xml into [file tail $path]"
        sed_in_place [file join $path Korean.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Russian.xml into [file tail $path]"
        sed_in_place [file join $path Russian.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Swedish.xml into [file tail $path]"
        sed_in_place [file join $path Swedish.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Spanish.xml into [file tail $path]"
        sed_in_place [file join $path Spanish.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Portugese.xml into [file tail $path]"
        sed_in_place [file join $path Portugese.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Norwegian.xml into [file tail $path]"
        sed_in_place [file join $path Norwegian.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Japanese.xml into [file tail $path]"
        sed_in_place [file join $path Japanese.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Italian.xml into [file tail $path]"
         sed_in_place [file join $path Italian.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching French.xml into [file tail $path]"
        sed_in_place [file join $path French.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Finnish.xml into [file tail $path]"
        sed_in_place [file join $path Finnish.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Dutch.xml into [file tail $path]"
        sed_in_place [file join $path Dutch.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Danish.xml into [file tail $path]"
        sed_in_place [file join $path Danish.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching ChineseTrad.xml into [file tail $path]"
        sed_in_place [file join $path ChineseTrad.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching ChineseSimpl.xml into [file tail $path]"
        sed_in_place [file join $path ChineseSimpl.xml] /app_home/PS3_GAME/ Discless
    }
    
    proc change_welcome_string { path args } {
        log "Changing Welcome string to Hombrew segment"       
        sed_in_place [file join $path category_networkt.xml] key="seg_browser"> key="seg_hbrew">
    }
    
    proc clean_net { file } {
        log "Modifying XML file [file tail $file]"
        log "Cleaning Homebrew category"
     
        set xml [::remove_node_from_xmb_xml $xml "seg_browser" "Internet Browser"]
        set xml [::remove_node_from_xmb_xml $xml "seg_folding_at_home" "Life with PlayStation "]
        set xml [::remove_node_from_xmb_xml $xml "seg_kensaku" "Internet Search"]
        set xml [::remove_node_from_xmb_xml $xml "seg_manual" "Online Instruction Manuals"]
        set xml [::remove_node_from_xmb_xml $xml "seg_premo" "Remote Play"]
        set xml [::remove_node_from_xmb_xml $xml "seg_dlctrl" "Download Controle"]
		
		::xml::SaveToFile $xml $file
    }
    
    proc read_cat { file } {
        log "Parsing XML: [file tail $file]"
        set xml [::xml::LoadFile $file]
        
        set ::query_manual [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_manual"]
        set ::view_seg_manual [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_manual"]
        
        if {$::query_manual == "" || $::view_manual == "" } {
            die "Could not parse $file"
        }
        
        set ::query_premo [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_premo"]
        set ::view_premo [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_premo"]
        
        if {$::query_premo == "" || $::view_premo == "" } {
            die "Could not parse $file"
        }
        
        set ::query_browser [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_browser"]
        set ::view_browser [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_browser"]
        
        if {$::query_browser == "" || $::view_browser == "" } {
            die "Could not parse $file"
        }
        
        set ::query_kensaku [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_kensaku"]
        set ::view_kensaku [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_kensaku"]
        
        if {$::query_kensaku == "" || $::view_kensaku == "" } {
            die "Could not parse $file"
        }
        
        set ::query_dlctrl [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_dlctrl"]
        
        if {$::query_dlctrl == "" } {
            die "Could not parse $file"
        }
        
        ::patch_xmb::inject_nodes
        
    }
    
    proc inject_cat { file } {
        log "Modifying XML: [file tail $file]"
        set xml [::xml::LoadFile $file]
        
        set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key ""] $::query_dlctrl]
      
        
        set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "" ] $::query_kensaku]
        set xml [::xml::InsertNode $xml {2 end 0} $::view_kensaku]

        
        set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "" ] $::query_browser]
        set xml [::xml::InsertNode $xml {2 end 0} $::view_browser]

        
        set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "" ] $::query_premo]
        set xml [::xml::InsertNode $xml {2 end 0} $::view_premo]

        
        set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "" ] $::query_manual]
        set xml [::xml::InsertNode $xml {2 end 0} $::view_manual]

        
        ::xml::SaveToFile $xml $file
    }
    
	    proc callback_homebrew {path args} {		
        log "Patching English.xml into [file tail $path]"
        sed_in_place [file join $path English.xml] Network Homebrew
        
        log "Patching German.xml into [file tail $path]"
        sed_in_place [file join $path German.xml] Network Homebrew
        
        log "Patching Korean.xml into [file tail $path]"
        sed_in_place [file join $path Korean.xml] Network Homebrew
        
        log "Patching Russian.xml into [file tail $path]"
        sed_in_place [file join $path Russian.xml] Network Homebrew
        
        log "Patching Swedish.xml into [file tail $path]"
        sed_in_place [file join $path Swedish.xml] Network Homebrew
        
        log "Patching Spanish.xml into [file tail $path]"
        sed_in_place [file join $path Spanish.xml] Network Homebrew
        
        log "Patching Portugese.xml into [file tail $path]"
        sed_in_place [file join $path Portugese.xml] Network Homebrew
        
        log "Patching Norwegian.xml into [file tail $path]"
        sed_in_place [file join $path Norwegian.xml] Network Homebrew
        
        log "Patching Japanese.xml into [file tail $path]"
        sed_in_place [file join $path Japanese.xml] Network Homebrew
        
        log "Patching Italian.xml into [file tail $path]"
        sed_in_place [file join $path Italian.xml] Network Homebrew
        
        log "Patching French.xml into [file tail $path]"
        sed_in_place [file join $path French.xml] Network Homebrew
        
        log "Patching Finnish.xml into [file tail $path]"
        sed_in_place [file join $path Finnish.xml] Network Homebrew
        
        log "Patching Dutch.xml into [file tail $path]"
        sed_in_place [file join $path Dutch.xml] Network Homebrew
        
        log "Patching Danish.xml into [file tail $path]"
        sed_in_place [file join $path Danish.xml] Network Homebrew
        
        log "Patching ChineseTrad.xml into [file tail $path]"
        sed_in_place [file join $path ChineseTrad.xml] Network Homebrew
        
        log "Patching ChineseSimpl.xml into [file tail $path]"
        sed_in_place [file join $path ChineseSimpl.xml] Network Homebrew
    }
	
    proc find_nodes { file } {
        log "Parsing XML: [file tail $file]"
        set xml [::xml::LoadFile $file]
        
    }
    
    proc find_nodes1 { self } {
        log "Parsing XML: [file tail $self]"
        set xml [::xml::LoadFile $self]
        
        if {$::patch_xmb::options(--add-install-pkg)} {
            set ::self2 [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_package_files"]
            set ::selfo [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_package_files"]
            set ::selfp [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_packages"]
        }

        if {$::patch_xmb::options(--patch-app-home)} {
            set ::query_gamedebug [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_gamedebug"]
            set ::view_gamedebug [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_gamedebug"]
        }
    }
    
    proc find_nodes2 { file } {
        log "Parsing XML: [file tail $file]"
        set xml [::xml::LoadFile $file]
     
        set ::XMBML [::xml::GetNodeByAttribute $xml "XMBML" version "1.0"]
     
    }
    
    proc inject_nodes { file } {
        log "Modifying XML: [file tail $file]"
        set xml [::xml::LoadFile $file]
        
        if {$::patch_xmb::options(--add-install-pkg)} {
            set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "seg_gameexit"] $::self2]
            set xml [::xml::InsertNode $xml {2 end 0} $::selfo]
            set xml [::xml::InsertNode $xml {2 end 0} $::selfp]
        }
        
        ::patch_xmb::clean_net
        
        log "Saving XML"
        ::xml::SaveToFile $xml $file
        
        ::patch_xmb::change_welcome_string
        
        log "Copy custom icon's into dev_flash"
        ::copy_mfw_imgs		
    }

    proc inject_nodes2 { file } {
        log "Modifying XML: [file tail $file]"
        set xml [::xml::LoadFile $file]
        
        if {$::patch_xmb::options(--patch-app-home)} {
            set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "seg_gameexit"] $::query_gamedebug]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_gamedebug]
        }       
        log "Saving XML"
        ::xml::SaveToFile $xml $file
	
	# fix for network cat, sony left a unclosed brace which will "modify_xml" command cause a error
	proc remove_line_from_network_cat {file} {
	    set src $file
	    set tmpname ${src}.work
     
        set source [open $file]
        set destination [open $tmpname w]
        set content [read $source]
        close $source
        set lines [split $content \n]
        set lines_after_deletion [lreplace $lines 47 47]
        puts -nonewline $destination [join $lines_after_deletion \n]
        close $destination
        file rename -force $tmpname $file
	}
  }
}
