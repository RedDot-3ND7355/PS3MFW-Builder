#!/usr/bin/tclsh

# Description: Welcome Message

# Option --welcome1::
# Option --welcome2::
# Option --welcome3::
# Option --empty1::
# Option --empty2::
# Option --empty3::
# Option --empty4::
# Option --empty5::
# Option --empty6::
# Option --empty7::
# Option --empty8::
# Option --empty9::
# Option --emptya::
# Option --emptyb::
# Option --emptyc::
# Option --emptyd::
# Option --emptye::
# Option --emptyf::
# Option --emptyg::
# Option --emptyh::
# Option --tuto0::
# Option --tuto1::
# Option --tuto2::
# Option --tuto3::
# Option --tuto4::
# Option --tuto5::
# Option --tuto6::
# Option --tuto7::


# Type --welcome1: label
# Type --welcome2: label
# Type --welcome3: label
# Type --empty1: label
# Type --empty2: label
# Type --empty3: label
# Type --empty4: label
# Type --empty5: label
# Type --empty6: label
# Type --empty7: label
# Type --empty8: label
# Type --empty9: label
# Type --emptya: label
# Type --emptyb: label
# Type --emptyc: label
# Type --emptyd: label
# Type --emptye: label
# Type --emptyf: label
# Type --emptyg: label
# Type --emptyh: label
# Type --tuto0: label
# Type --tuto1: label
# Type --tuto2: label
# Type --tuto3: label
# Type --tuto4: label
# Type --tuto5: label
# Type --tuto6: label
# Type --tuto7: label


namespace eval ::welcome_msg {
    array set ::welcome_msg::options {
        --welcome1 "Welcome to PS3MFW Builder"
        --welcome2 "Please set your key folder in settings to data | Usually set by itself."
		--welcome3 "Please verify your build if its updated by pressing to update"
		--empty1 ""
		--empty2 "This software will modify the PUP, and is therefore unofficial and not endorsed by SCE."
		--empty3 ""
		--empty4 "Installation of a Generated PUP may render your game system unstable or unusable."
		--empty5 "Depending if you are enough skilled to use it correctly."
		--empty6 ""
		--empty7 "Use at your own risk.  No guarantee expressed or implied."
		--empty8 ""
		--empty9 "If anything bad happens after installing the PUP, you cannot hold anyone responsible but yourself."
		--emptya "So if you put your UNSTABLE PUP on the web and brick others PS3 you the are the only one responsible."
		--emptyb "If only you declared it was stable, so plz dont forget to add a custom msg for the user agreement,"
		--emptyc "So that if any user wants to install your PUP make sure its stable so his ps3 wont be broke by HIS FAULT."
		--emptyd ""
		--emptye ""
		--emptyf "The creators of this framework tool, dosent condone piracy."
		--emptyg "Use your system responsibly and only play games that you have purchased."
		--emptyh "Enjoy!"
		--tuto0 ""
		--tuto1 "Settings"
		--tuto2 "Example of the temp folder you must set in settings!"
		--tuto3 "C:|Users|User Name|AppData|Local|Temp|PS3MFW <-Make sure they're backslashes!"
		--tuto4 "OR to the BUILD folder in the same place as ps3mfw.exe is located"
		--tuto5 "After Please set the keys folder to /.ps3/data from ps3mfw builder"
		--tuto6 "You can add the input file into the IN folder"
		--tuto7 "Also same for output in the OUT folder"
    }
}