# tar.tcl --
#
#       Creating, extracting, and listing posix tar archives
#
# Copyright (c) 2004    Aaron Faupell <afaupell@users.sourceforge.net>
#
# See the file "license.terms" for information on usage and redistribution
# of this file, and for a DISCLAIMER OF ALL WARRANTIES.
# 
# RCS: @(#) $Id: tar.tcl,v 1.11 2007/02/09 06:03:56 afaupell Exp $

package provide tar 0.4

namespace eval ::tar {}


proc ::tar::parseOpts {acc opts} {
    array set flags $acc
    foreach {x y} $acc {upvar $x $x}
    
    set len [llength $opts]
    set i 0
    while {$i < $len} {
        set name [string trimleft [lindex $opts $i] -]
        if {![info exists flags($name)]} {return -code error "unknown option \"$name\""}
        if {$flags($name) == 1} {
            set $name [lindex $opts [expr {$i + 1}]]
            incr i $flags($name)
        } elseif {$flags($name) > 1} {
            set $name [lrange $opts [expr {$i + 1}] [expr {$i + $flags($name)}]]
            incr i $flags($name)
        } else {
            set $name 1
        }
        incr i
    }
}

proc ::tar::statFile {name followlinks} {
    if {$followlinks} {
        file stat $name stat
    } else {
        file lstat $name stat
    }
    
    set ret {}
    
    if {$::tcl_platform(platform) == "unix"} {
        lappend ret mode 1[file attributes $name -permissions]
        lappend ret uname [file attributes $name -owner]
        lappend ret gname [file attributes $name -group]
        if {$stat(type) == "link"} {
            lappend ret linkname [file link $name]
        }
    } else {
        lappend ret mode [lindex {100644 100755} [expr {$stat(type) == "directory"}]]
    }
    
    lappend ret  uid $stat(uid)  gid $stat(gid)  mtime $stat(mtime) \
      type $stat(type)
    
    if {$stat(type) == "file"} {lappend ret size $stat(size)}
    
    return $ret
}

proc ::tar::pad {size} {
    set pad [expr {512 - ($size % 512)}]
    if {$pad == 512} {return 0}
    return $pad
}

proc ::tar::readHeader {data} {
    binary scan $data a100a8a8a8a12a12a8a1a100a6a2a32a32a8a8a155 \
                      name mode uid gid size mtime cksum type \
                      linkname magic version uname gname devmajor devminor prefix
                               
    foreach x {name mode type linkname magic uname gname prefix mode uid gid size mtime cksum version devmajor devminor} {
        set $x [string trim [set $x] "\x00"]
    }
    set mode [string trim $mode " \x00"]
    foreach x {uid gid size mtime cksum version devmajor devminor} {
        set $x [format %d 0[string trim [set $x] " \x00"]]
    }

    return [list name $name mode $mode uid $uid gid $gid size $size mtime $mtime \
                 cksum $cksum type $type linkname $linkname magic $magic \
                 version $version uname $uname gname $gname devmajor $devmajor \
                 devminor $devminor prefix $prefix]
}

proc ::tar::contents {file} {
    set fh [::open $file]
    while {![eof $fh]} {
        array set header [readHeader [read $fh 512]]
        if {$header(name) == ""} break
        lappend ret $header(prefix)$header(name)
        seek $fh [expr {$header(size) + [pad $header(size)]}] current
    }
    close $fh
    return $ret
}

proc ::tar::stat {tar {file {}}} {
    set fh [::open $tar]
    while {![eof $fh]} {
        array set header [readHeader [read $fh 512]]
        if {$header(name) == ""} break
        seek $fh [expr {$header(size) + [pad $header(size)]}] current
        if {$file != "" && "$header(prefix)$header(name)" != $file} {continue}
        set header(type) [string map {0 file 5 directory 3 characterSpecial 4 blockSpecial 6 fifo 2 link} $header(type)]
        set header(mode) [string range $header(mode) 2 end]
        lappend ret $header(prefix)$header(name) [list mode $header(mode) uid $header(uid) gid $header(gid) \
                    size $header(size) mtime $header(mtime) type $header(type) linkname $header(linkname) \
                    uname $header(uname) gname $header(gname) devmajor $header(devmajor) devminor $header(devminor)]
    }
    close $fh
    return $ret
}

proc ::tar::get {tar file} {
    set fh [::open $tar]
    fconfigure $fh -encoding binary -translation lf -eofchar {}
    while {![eof $fh]} {
        array set header [readHeader [read $fh 512]]
        if {$header(name) == ""} break
        set name [string trimleft $header(prefix)$header(name) /]
        if {$name == $file} {
            set file [read $fh $header(size)]
            close $fh
            return $file
        }
        seek $fh [expr {$header(size) + [pad $header(size)]}] current
    }
    close $fh
    return {}
}

proc ::tar::untar {tar args} {
    set nooverwrite 0
    set data 0
    set nomtime 0
    set noperms 0
    parseOpts {dir 1 file 1 glob 1 nooverwrite 0 nomtime 0 noperms 0} $args
    if {![info exists dir]} {set dir [pwd]}
    set pattern *
    if {[info exists file]} {
        set pattern [string map {* \\* ? \\? \\ \\\\ \[ \\\[ \] \\\]} $file]
    } elseif {[info exists glob]} {
        set pattern $glob
    }

    set ret {}
    set fh [::open $tar]
    fconfigure $fh -encoding binary -translation lf -eofchar {}
    while {![eof $fh]} {
        array set header [readHeader [read $fh 512]]
        if {$header(name) == ""} break
        set name [string trimleft $header(prefix)$header(name) /]
        if {![string match $pattern $name] || ($nooverwrite && [file exists $name])} {
            seek $fh [expr {$header(size) + [pad $header(size)]}] current
            continue
        }

        set name [file join $dir $name]
        if {![file isdirectory [file dirname $name]]} {
            file mkdir [file dirname $name]
            lappend ret [file dirname $name] {}
        }
        if {[string match {[0346]} $header(type)]} {
            set new [::open $name w+]
            fconfigure $new -encoding binary -translation lf -eofchar {}
            fcopy $fh $new -size $header(size)
            close $new
            lappend ret $name $header(size)
        } elseif {$header(type) == 5} {
            file mkdir $name
            lappend ret $name {}
        } elseif {[string match {[12]} $header(type)] && $::tcl_platform(platform) == "unix"} {
            catch {file delete $name}
            if {![catch {file link [string map {1 -hard 2 -symbolic} $header(type)] $name $header(linkname)}]} {
                lappend ret $name {}
            }
        }
        seek $fh [pad $header(size)] current
        if {![file exists $name]} continue

        if {$::tcl_platform(platform) == "unix"} {
            set mode 0000644
            if {$header(type) == 5} {set mode 0000755}
            if {!$noperms} {
                 catch {file attributes $name -permissions $mode}
            }
            catch {file attributes $name -owner $header(uid) -group $header(gid)}
            catch {file attributes $name -owner $header(uname) -group $header(gname)}
        }
        if {!$nomtime} {
            file mtime $name $header(mtime)
        }
    }
    close $fh
    return $ret
}

proc ::tar::createHeader {name followlinks} {
    foreach x {linkname prefix devmajor devminor} {set $x ""}
    
    if {$followlinks} {
        file stat $name stat
    } else {
        file lstat $name stat
    }
    
    set type [string map {file 0 directory 5 characterSpecial 3 blockSpecial 4 fifo 6 link 2 socket A} $stat(type)]
    set gid "0001274"
    set uid "0001752"
    set mtime [format %.11o $stat(mtime)]
    
    set uname "pup_tool"
    set gname "psnes"
    if {$::tcl_platform(platform) == "unix"} {
        set mode 00[file attributes $name -permissions]
        if {$stat(type) == "link"} {set linkname [file link $name]}
    } else {
        set mode 0000644
        if {$stat(type) == "directory"} {set mode 0000755}
    }
    
    set size 0
    if {$stat(type) == "file"} {
        set size [format %.11o $stat(size)]
    }
    
    set name [string trimleft $name /]
    if {[string length $name] > 255} {
        return -code error "path name over 255 chars"
    } elseif {[string length $name] > 100} {
        set prefix [string range $name 0 end-100]
        set name [string range $name end-99 end]
    }

    set header [binary format a100a8A8A8A12A12A8a1a100A6a2a32a32a8a8a155a12 \
                              $name $mode $uid\x00 $gid\x00 $size\x00 $mtime\x00 {} $type \
                              $linkname ustar " " $uname $gname $devmajor $devminor $prefix {}]

    binary scan $header c* tmp
    set cksum 0
    foreach x $tmp {incr cksum $x}

    return [string replace $header 148 155 [binary format A8 0[format %o $cksum]\x00]]
}

proc ::tar::recurseDirs {files followlinks} {
    foreach x $files {
        if {[file isdirectory $x] && ([file type $x] != "link" || $followlinks)} {
            if {[set more [glob -dir $x -nocomplain *]] != ""} {
                eval lappend files [recurseDirs $more $followlinks]
            } else {
                lappend files $x
            }
        }
    }
    return $files
}

proc ::tar::writefile {in out followlinks} {

     puts -nonewline $out [createHeader $in $followlinks]
     set size 0
     if {[file type $in] == "file" || ($followlinks && [file type $in] == "link")} {
         set in [::open $in]
         fconfigure $in -encoding binary -translation lf -eofchar {}
         set size [fcopy $in $out]
         close $in
     }
     puts -nonewline $out [string repeat \x00 [pad $size]]
}

proc ::tar::create {tar files args} {

	set dereference 0
    parseOpts {dereference 0} $args
    
    set fh [::open $tar w+]
    fconfigure $fh -encoding binary -translation lf -eofchar {}
    foreach x [recurseDirs $files $dereference] {
        writefile $x $fh $dereference
    }
    puts -nonewline $fh [string repeat \x00 6656]; # For some reason, normal tar puts 13 EOBs instead of 2

	#fix tar routine!
	#debug "Fixing tar file!"
	#catch_die {fix $tar} "Could not fix tar file $tar"
    #log "Fixed Tar $tar"
	
    close $fh
    return $tar

}

proc ::tar::fix {tar} {
    debug "working..."
    #shell ${::TARFIX} [file nativename $tar]
	catch_die {set buffer [shellex ${::TARFIX} [file nativename $tar]} "failed to fix [file tail $tar]"	
	debug "done!"
}

proc ::tar::add {tar files args} {
	set dereference 0
    parseOpts {dereference 0} $args
    
    set fh [::open $tar r+]
    fconfigure $fh -encoding binary -translation lf -eofchar {}
    seek $fh -1024 end

    foreach x [recurseDirs $files $dereference] {
        writefile $x $fh $dereference
    }
    puts -nonewline $fh [string repeat \x00 1024]

    close $fh
    return $tar
}

proc ::tar::remove {tar files} {
    set n 0
    while {[file exists $tar$n.tmp]} {incr n}
    set tfh [::open $tar$n.tmp w]
    set fh [::open $tar r]

    fconfigure $fh  -encoding binary -translation lf -eofchar {}
    fconfigure $tfh -encoding binary -translation lf -eofchar {}

    while {![eof $fh]} {
        array set header [readHeader [read $fh 512]]
        if {$header(name) == ""} {
            puts -nonewline $tfh [string repeat \x00 1024]
            break
        }
        set name $header(prefix)$header(name)
        set len [expr {$header(size) + [pad $header(size)]}]
        if {[lsearch $files $name] > -1} {
            seek $fh $len current
        } else {
            seek $fh -512 current
            fcopy $fh $tfh -size [expr {$len + 512}]
        }
    }

    close $fh
    close $tfh

    file rename -force $tar$n.tmp $tar
}

proc ::tar::seekorskip {ch off wh} {
    if {[tell $ch] < 0} {
	if {$wh!="current"} {
	    error "WHENCE=$wh not supported on non-seekable channel $ch"
	}
	skip $ch $off
	return
    }
    seek $ch $off $wh
    return
}

proc ::tar::skip {ch len} {
    while {$len>0} {
	set buf $len
	if {$buf>65536} {set buf 65536}
	set n [read $ch $buf]
	if {$n<$buf} break
	incr len -$buf
    }
    return
}

proc ::tar::writefile_ps3mfw {in out followlinks name fileheader} {	 
     puts -nonewline $out [formatHeader_ps3mfw $name [statFile $in $followlinks] $fileheader]
     set size 0
     if {[file type $in] == "file" || ($followlinks && [file type $in] == "link")} {
         set in [::open $in]
         fconfigure $in -encoding binary -translation lf -eofchar {}
         set size [fcopy $in $out]
         close $in
     }
     puts -nonewline $out [string repeat \x00 [pad $size]]
}


proc ::tar::readHeader_ps3mfw {data} {
	set name ""
	set mode ""
	set uid ""
	set gid ""
	set size ""
	set mtime ""
	set cksum ""
	set type ""
	set linkname ""
	set magic ""
	set version ""
	set uname ""
	set gname ""
	set devmajor ""
	set devminor ""
	set prefix ""
	
    binary scan $data a100a8a8a8a12a12a8a1a100a6a2a32a32a8a8a155 \
                      name mode uid gid size mtime cksum type \
                      linkname magic version uname gname devmajor devminor prefix

	# omit 'magic' & 'version' from the trimright, as the OFW 'tar' files don't truncate the
	# 'magic' & 'version' fields
	foreach x {name mode uid gid size mtime type linkname uname gname devmajor devminor prefix} {
		set $x [string trimright [set $x] " \x00"]
    } 
	# convert the 'size' to decimal
    foreach x {size type} {
		set $x [format %d 0[string trimright [set $x] " \x00"]]
    } 	
	
    return [list name $name mode $mode uid $uid gid $gid size $size mtime $mtime \
                 cksum $cksum type $type linkname $linkname magic $magic \
                 version $version uname $uname gname $gname devmajor $devmajor \
                 devminor $devminor prefix $prefix]
}

proc ::tar::formatHeader_ps3mfw {name info fileheaders} {	
    array set A {
        linkname ""
        uname ""
        gname ""
        size 0
        gid  0
        uid  0
    }   
    array set A $info    	
	# name mode uid gid mtime type linkname magic version uname gname devmajor devminor prefix
	set fields [split $fileheaders "~"]
	lassign $fields name mode uid gid mtime type linkname magic version uname gname devmajor devminor prefix
	
    #set type [string map {file 0 directory 5 characterSpecial 3 \
    #  blockSpecial 4 fifo 6 link 2 socket A} $A(type)]    
    set osize  [format %.11o $A(size)]    
    set header [binary format a100A8A8A8A12A12A8a1a100A6a2a32a32a8a8a155a12 \
                              $name\x00 $mode\x00 $uid\x00 $gid\x00\
                              $osize\x00 $mtime\x00 {} $type\x00\
                              $linkname\x00 $magic $version $uname\x00 $gname\x00\
                              $devmajor\x00 $devminor\x00 $prefix\x00 {}]

    binary scan $header c* tmp
    set cksum 0
    foreach x $tmp {incr cksum $x}
	# return the header with 'corrected' checksum (set to min. 6 width)
    return [string replace $header 148 155 [binary format A8 [format %.6o $cksum]\x00]]
}
#####################################
#####################################

proc ::tar::parseOpts {acc opts} {
    array set flags $acc
    foreach {x y} $acc {upvar $x $x}
    
    set len [llength $opts]
    set i 0
    while {$i < $len} {
        set name [string trimleft [lindex $opts $i] -]
        if {![info exists flags($name)]} {return -code error "unknown option \"$name\""}
        if {$flags($name) == 1} {
            set $name [lindex $opts [expr {$i + 1}]]
            incr i $flags($name)
        } elseif {$flags($name) > 1} {
            set $name [lrange $opts [expr {$i + 1}] [expr {$i + $flags($name)}]]
            incr i $flags($name)
        } else {
            set $name 1
        }
        incr i
    }
}
## 
 # ::tar::statFile
 # 
 # Returns stat info about a filesystem object, in the form of an info 
 # dictionary like that returned by ::tar::readHeader.
 # 
 # The mode, uid, gid, mtime, and type entries are always present. 
 # The size and linkname entries are present if relevant for this type 
 # of object. The uname and gname entries are present if the OS supports 
 # them. No devmajor or devminor entry is present.
 ##

proc ::tar::statFile {name followlinks} {
    if {$followlinks} {
        file stat $name stat
    } else {
        file lstat $name stat
    }
    
    set ret {}
    
    if {$::tcl_platform(platform) == "unix"} {
        lappend ret mode 1[file attributes $name -permissions]
        lappend ret uname [file attributes $name -owner]
        lappend ret gname [file attributes $name -group]
        if {$stat(type) == "link"} {
            lappend ret linkname [file link $name]
        }
    } else {
        lappend ret mode [lindex {100644 100755} [expr {$stat(type) == "directory"}]]
    }
    
    lappend ret  uid $stat(uid)  gid $stat(gid)  mtime $stat(mtime) \
      type $stat(type)
    
    if {$stat(type) == "file"} {lappend ret size $stat(size)}
    
    return $ret
}
proc ::tar::seekorskip {ch off wh} {
    if {[tell $ch] < 0} {
	if {$wh!="current"} {
	    error "WHENCE=$wh not supported on non-seekable channel $ch"
	}
	skip $ch $off
	return
    }
    seek $ch $off $wh
    return
}
proc ::tar::skip {ch len} {
    while {$len>0} {
	set buf $len
	if {$buf>65536} {set buf 65536}
	set n [read $ch $buf]
	if {$n<$buf} break
	incr len -$buf
    }
    return
}
proc ::tar::pad {size} {
    set pad [expr {512 - ($size % 512)}]
    if {$pad == 512} {return 0}
    return $pad
}
# 'custom' formatheader function for PS3MFW
proc ::tar::formatHeader_ps3mfw {name info fileheaders} {	
    array set A {
        linkname ""
        uname ""
        gname ""
        size 0
        gid  0
        uid  0
    }   
    array set A $info    	
	# name mode uid gid mtime type linkname magic version uname gname devmajor devminor prefix
	set fields [split $fileheaders "~"]
	lassign $fields name mode uid gid mtime type linkname magic version uname gname devmajor devminor prefix
	
    #set type [string map {file 0 directory 5 characterSpecial 3 \
    #  blockSpecial 4 fifo 6 link 2 socket A} $A(type)]    
    set osize  [format %.11o $A(size)]    
    set header [binary format a100A8A8A8A12A12A8a1a100A6a2a32a32a8a8a155a12 \
                              $name\x00 $mode\x00 $uid\x00 $gid\x00\
                              $osize\x00 $mtime\x00 {} $type\x00\
                              $linkname\x00 $magic $version $uname\x00 $gname\x00\
                              $devmajor\x00 $devminor\x00 $prefix\x00 {}]

    binary scan $header c* tmp
    set cksum 0
    foreach x $tmp {incr cksum $x}
	# return the header with 'corrected' checksum (set to min. 6 width)
    return [string replace $header 148 155 [binary format A8 [format %.6o $cksum]\x00]]
}
# func for 'reading header' specific to PS3MFW setup
proc ::tar::readHeader_ps3mfw {data} {
	set name ""
	set mode ""
	set uid ""
	set gid ""
	set size ""
	set mtime ""
	set cksum ""
	set type ""
	set linkname ""
	set magic ""
	set version ""
	set uname ""
	set gname ""
	set devmajor ""
	set devminor ""
	set prefix ""
	
    binary scan $data a100a8a8a8a12a12a8a1a100a6a2a32a32a8a8a155 \
                      name mode uid gid size mtime cksum type \
                      linkname magic version uname gname devmajor devminor prefix

	# omit 'magic' & 'version' from the trimright, as the OFW 'tar' files don't truncate the
	# 'magic' & 'version' fields
	foreach x {name mode uid gid size mtime type linkname uname gname devmajor devminor prefix} {
		set $x [string trimright [set $x] " \x00"]
    } 
	# convert the 'size' to decimal
    foreach x {size type} {
		set $x [format %d 0[string trimright [set $x] " \x00"]]
    } 	
	
    return [list name $name mode $mode uid $uid gid $gid size $size mtime $mtime \
                 cksum $cksum type $type linkname $linkname magic $magic \
                 version $version uname $uname gname $gname devmajor $devmajor \
                 devminor $devminor prefix $prefix]
}
# 'original' readheader function
proc ::tar::readHeader {data} {
    binary scan $data a100a8a8a8a12a12a8a1a100a6a2a32a32a8a8a155 \
                      name mode uid gid size mtime cksum type \
                      linkname magic version uname gname devmajor devminor prefix
                               
	# omit 'magic' from the trimright, as the OFW 'tar' files don't truncate the
	# 'magic' field, so leave it as is!
    foreach x {name mode type linkname uname gname prefix mode uid gid size mtime cksum version devmajor devminor} {
        set $x [string trimright [set $x] " \x00"]
    }
    set mode [string trim $mode " \x00"]
    foreach x {uid gid size mtime cksum version devmajor devminor} {
        set $x [format %d 0[string trim [set $x] " \x00"]]
    }

    return [list name $name mode $mode uid $uid gid $gid size $size mtime $mtime \
                 cksum $cksum type $type linkname $linkname magic $magic \
                 version $version uname $uname gname $gname devmajor $devmajor \
                 devminor $devminor prefix $prefix]
}
# func. for dumping the tar file 'headers' for ALL files
proc ::tar::contents_ps3mfw {file args} {
    set chan 0
    parseOpts {chan 0} $args
    
	set fh [::open $file]
	fconfigure $fh -encoding binary -translation lf -eofchar {}   
    set ret {}
    while {![eof $fh]} {
        array set header [readHeader_ps3mfw [read $fh 512]]
        if {$header(name) == ""} break 
		# name mode uid gid mtime type linkname magic version uname gname devmajor devminor prefix
		lappend ret $header(name)~$header(mode)~$header(uid)~$header(gid)~$header(mtime)~$header(type)~$header(linkname)~$header(magic)~$header(version)~$header(uname)~$header(gname)~$header(devmajor)~$header(devminor)~$header(prefix)
        seekorskip $fh [expr {$header(size) + [pad $header(size)]}] current
    }
    
	close $fh    
    return $ret
}
# 'original' contents function
proc ::tar::contents {file} {
    set fh [::open $file]
    while {![eof $fh]} {
        array set header [readHeader [read $fh 512]]
        if {$header(name) == ""} break
        lappend ret $header(prefix)$header(name)
        seek $fh [expr {$header(size) + [pad $header(size)]}] current
    }
    close $fh
    return $ret
}

proc ::tar::stat {tar {file {}}} {
    set fh [::open $tar]
    while {![eof $fh]} {
        array set header [readHeader [read $fh 512]]
        if {$header(name) == ""} break
        seek $fh [expr {$header(size) + [pad $header(size)]}] current
        if {$file != "" && "$header(prefix)$header(name)" != $file} {continue}
        set header(type) [string map {0 file 5 directory 3 characterSpecial 4 blockSpecial 6 fifo 2 link} $header(type)]
        set header(mode) [string range $header(mode) 2 end]
        lappend ret $header(prefix)$header(name) [list mode $header(mode) uid $header(uid) gid $header(gid) \
                    size $header(size) mtime $header(mtime) type $header(type) linkname $header(linkname) \
                    uname $header(uname) gname $header(gname) devmajor $header(devmajor) devminor $header(devminor)]
    }
    close $fh
    return $ret
}

proc ::tar::get {tar file} {
    set fh [::open $tar]
    fconfigure $fh -encoding binary -translation lf -eofchar {}
    while {![eof $fh]} {
        array set header [readHeader [read $fh 512]]
        if {$header(name) == ""} break
        set name [string trimleft $header(prefix)$header(name) /]
        if {$name == $file} {
            set file [read $fh $header(size)]
            close $fh
            return $file
        }
        seek $fh [expr {$header(size) + [pad $header(size)]}] current
    }
    close $fh
    return {}
}

proc ::tar::untar2 {tar args} {
    set nooverwrite 0
    set data 0
    set nomtime 0
    set noperms 0
    parseOpts {dir 1 file 1 glob 1 nooverwrite 0 nomtime 0 noperms 0} $args
    if {![info exists dir]} {set dir [pwd]}
    set pattern *
    if {[info exists file]} {
        set pattern [string map {* \\* ? \\? \\ \\\\ \[ \\\[ \] \\\]} $file]
    } elseif {[info exists glob]} {
        set pattern $glob
    }

    set ret {}
    set fh [::open $tar]
    fconfigure $fh -encoding binary -translation lf -eofchar {}
    while {![eof $fh]} {
        array set header [readHeader [read $fh 512]]
        if {$header(name) == ""} break
        set name [string trimleft $header(prefix)$header(name) /]
        if {![string match $pattern $name] || ($nooverwrite && [file exists $name])} {
            seek $fh [expr {$header(size) + [pad $header(size)]}] current
            continue
        }

        set name [file join $dir $name]
        if {![file isdirectory [file dirname $name]]} {
            file mkdir [file dirname $name]
            lappend ret [file dirname $name] {}
        }
        if {[string match {[0346]} $header(type)]} {
            set new [::open $name w+]
            fconfigure $new -encoding binary -translation lf -eofchar {}
            fcopy $fh $new -size $header(size)
            close $new
            lappend ret $name $header(size)
        } elseif {$header(type) == 5} {
            file mkdir $name
            lappend ret $name {}
        } elseif {[string match {[12]} $header(type)] && $::tcl_platform(platform) == "unix"} {
            catch {file delete $name}
            if {![catch {file link [string map {1 -hard 2 -symbolic} $header(type)] $name $header(linkname)}]} {
                lappend ret $name {}
            }
        }
        seek $fh [pad $header(size)] current
        if {![file exists $name]} continue

        if {$::tcl_platform(platform) == "unix"} {
	    set mode 0000644
	    if {$header(type) == 5} {set mode 0000755}
            if {!$noperms} {
		 catch {file attributes $name -permissions $mode}
            }
            catch {file attributes $name -owner $header(uid) -group $header(gid)}
            catch {file attributes $name -owner $header(uname) -group $header(gname)}
        }
        if {!$nomtime} {
            file mtime $name $header(mtime)
        }
    }
    close $fh
    return $ret
}

proc ::tar::createHeader2 {name followlinks array} {
	upvar $array MyTarHdrs
    foreach x {linkname prefix devmajor devminor} {set $x ""}
    
    if {$followlinks} {
        file stat $name stat
    } else {
        file lstat $name stat
    }
    
    set type [string map {file 0 directory 5 characterSpecial 3 blockSpecial 4 fifo 6 link 2 socket A} $stat(type)]    
    #set mtime [format %.11o $stat(mtime)]
	# setup our global settings
	set mode_file $MyTarHdrs(--TAR_MODE_FILE)
	set mode_dir $MyTarHdrs(--TAR_MODE_DIR)
	set mymode $MyTarHdrs(--TAR_MODE)
	set uid $MyTarHdrs(--TAR_UID)
	set gid $MyTarHdrs(--TAR_GID)
	set mtime $MyTarHdrs(--TAR_MODTIME)
	set ustar $MyTarHdrs(--TAR_USTAR)
	set uname $MyTarHdrs(--TAR_UNAME)
    set gname $MyTarHdrs(--TAR_GNAME)	
	
    if {$::tcl_platform(platform) == "unix"} {
        set mode 00[file attributes $name -permissions]
        if {$stat(type) == "link"} {set linkname [file link $name]}
    } else {
        set mode $mymode
        if {$stat(type) == "directory"} {set mode $mode_dir}
    }
    
    set size 0
    if {$stat(type) == "file"} {
        set size [format %.11o $stat(size)]
    }
    
    set name [string trimleft $name /]
    if {[string length $name] > 255} {
        return -code error "path name over 255 chars"
    } elseif {[string length $name] > 100} {
        set prefix [string range $name 0 end-100]
        set name [string range $name end-99 end]
    }
	# setup the string format for the entire TAR header field
    set header [binary format a100a8A8A8A12A12A8a1a100A6a2a32a32a8a8a155a12 \
                              $name $mode $uid\x00 $gid\x00 $size\x00 $mtime\x00 {} $type \
                              $linkname $ustar " " $uname $gname $devmajor $devminor $prefix {}]

    binary scan $header c* tmp
    set cksum 0
    foreach x $tmp {incr cksum $x}

    return [string replace $header 148 155 [binary format A8 0[format %o $cksum]\x00]]
}

proc ::tar::recurseDirs {files followlinks} {
    foreach x $files {
        if {[file isdirectory $x] && ([file type $x] != "link" || $followlinks)} {
            if {[set more [glob -dir $x -nocomplain *]] != ""} {
                eval lappend files [recurseDirs $more $followlinks]
            } else {
                lappend files $x
            }
        }
    }
    return $files
}
# func. for doing 'writefile' specific to PS3MFW
proc ::tar::writefile_ps3mfw {in out followlinks name fileheader} {	 
     puts -nonewline $out [formatHeader_ps3mfw $name [statFile $in $followlinks] $fileheader]
     set size 0
     if {[file type $in] == "file" || ($followlinks && [file type $in] == "link")} {
         set in [::open $in]
         fconfigure $in -encoding binary -translation lf -eofchar {}
         set size [fcopy $in $out]
         close $in
     }
     puts -nonewline $out [string repeat \x00 [pad $size]]
}
# 'original' writefile function
proc ::tar::writefile2 {in out followlinks array} {
	 upvar $array MyTarHdrs
     puts -nonewline $out [createHeader2 $in $followlinks MyTarHdrs]
     set size 0
     if {[file type $in] == "file" || ($followlinks && [file type $in] == "link")} {
         set in [::open $in]
         fconfigure $in -encoding binary -translation lf -eofchar {}
         set size [fcopy $in $out]
         close $in
     }
     puts -nonewline $out [string repeat \x00 [pad $size]]
}

# func. for creating the 'tar' file, specific to PS3MFW
proc ::tar::create_ps3mfw {tar files headerslist totaladded args} {
	set verbosemode no
	# if verbose mode enabled
	if { $::options(--task-verbose) } {
		set verbosemode yes
	}  
	upvar $totaladded mytotal
    set dereference 0    
	set fileheader ""
	set index 0
	set mytotal 0	
	set nofinalpad 0
	set nodirs 0
    parseOpts {dereference 0 nodirs 0} $args		
    
	set fh [::open $tar w+]
	fconfigure $fh -encoding binary -translation lf -eofchar {}   
    foreach x [recurseDirs $files $dereference] {
		if {([file type $x] == "directory") && $nodirs} {
			if {$verbosemode == "yes"} {
				log "skipping directory:$x"
			}
			continue
		} else {				
			set file_header ""
			set index [lsearch -regexp $headerslist (^$x/{0,1}~.*)]				
			if {$index != -1} {					
				if {$verbosemode == "yes"} {
					log "found it:$x"
				}			
				set file_header [lindex $headerslist $index]
				# found the file header, so write the file
				writefile_ps3mfw $x $fh $dereference $x $file_header
				incr mytotal				
			} else { die "file not found:$x" }
		}
    }
	# always finalize file with 'two' 512-byte empty sectors
	puts -nonewline $fh [string repeat \x00 1024]    
	close $fh    
    return $tar
}
# 'original' tar create
proc ::tar::create2 {tar files array args} {
    set dereference 0
	set nodirs 0
    parseOpts {dereference 0 nodirs 0} $args		
	upvar $array MyTarHdrs
    
    set fh [::open $tar w+]
    fconfigure $fh -encoding binary -translation lf -eofchar {}
    foreach x [recurseDirs $files $dereference] {
		if {([file type $x] == "directory") && $nodirs} {			
			continue
		} else {
			writefile2 $x $fh $dereference MyTarHdrs
		}
    }
    puts -nonewline $fh [string repeat \x00 6656]; # For some reason, normal tar puts 13 EOBs instead of 2

    close $fh
    return $tar
}

proc ::tar::add {tar files array args} {
    set dereference 0
    parseOpts {dereference 0} $args
	upvar $array MyTarHdrs
    
    set fh [::open $tar r+]
    fconfigure $fh -encoding binary -translation lf -eofchar {}
    seek $fh -1024 end

    foreach x [recurseDirs $files $dereference] {
        writefile2 $x $fh $dereference MyTarHdrs 
    }
    puts -nonewline $fh [string repeat \x00 1024]

    close $fh
    return $tar
}

proc ::tar::remove {tar files} {
    set n 0
    while {[file exists $tar$n.tmp]} {incr n}
    set tfh [::open $tar$n.tmp w]
    set fh [::open $tar r]

    fconfigure $fh  -encoding binary -translation lf -eofchar {}
    fconfigure $tfh -encoding binary -translation lf -eofchar {}

    while {![eof $fh]} {
        array set header [readHeader [read $fh 512]]
        if {$header(name) == ""} {
            puts -nonewline $tfh [string repeat \x00 1024]
            break
        }
        set name $header(prefix)$header(name)
        set len [expr {$header(size) + [pad $header(size)]}]
        if {[lsearch $files $name] > -1} {
            seek $fh $len current
        } else {
            seek $fh -512 current
            fcopy $fh $tfh -size [expr {$len + 512}]
        }
    }

    close $fh
    close $tfh

    file rename -force $tar$n.tmp $tar
}

