# X210/X2100 compiled EC/BIOS
**Focus of this repo will be on the X2100. The X210 and other repos are linked in this repo.**

# Content
* x2100 (Main content of this repo, includes the BIOS and EC)
* [X210 EC: Original X210 EC patches](https://github.com/l29ah/x210-ec)
* [X210 BIOS/EC: Compiled X210 BIOS/EC patches in a single repo](https://github.com/harrykipper/x210)
* [X2100 EC: X2100 EC patches based on the X210](https://github.com/jwise/x2100-ec)
* [Flashrom for Linux](https://flashrom.org/Flashrom)

# Everything inside the x2100 folder 
* bios_hap_0_safe.bin, bios_hap_1_safe.bin and bios_hap_0_unsafe.bin
	* bios_hap_0_safe.bin and bios_hap_1_safe.bin: EC is _UNPATCHED_
	* bios_hap_0_unsafe.bin: EC is PATCHED, _NOT RECOMMENDED_
	* BIOS is properly configured with sensible power levels (15W fallback).
	* CPU C states are enabled with options of promotion and demotion. Enables better power savings. 
	* CSM completely disabled to avoid screen tearing. This will not allow BIOS (non UEFI) OS to boot. Reenable this option to use BIOS OS.
	* RAM is set to 2666MHz all the time to reduce screen tearing.
	* IGP is set to 1GB for higher intel GVT-G resolutions.
	* CPU microcode is updated. 
	* Intel ME is updated to 14.1.
	* GOP updated.

* bios_hap_0_safe.bin vs bios_hap_1_safe.bin
	* HAP bit is set to 1 on bios_hap_1.bin. This is the modern equivalent of ME Cleaner. 

* v25_original.bin
	* The latest factory BIOS (V25) is unoptimised. The main issue is that the EC is unpatched and power level settings are not set properly (65W PL1). The main BIOS is in the folder x2100.

* ec_patched.bin
	* Patched EC using [jwise's patches](https://github.com/jwise/x2100-ec). Includes all the patches except the fn/ctrl patch.

* ec_patched_fn_ctrl_swapped.bin
	* Patched EC using [jwise's patches](https://github.com/jwise/x2100-ec). Includes all the patches including the fn/ctrl patch.
	* May have weird behaviour when using an external mouse. Try it out and revert to non swapped variant.

* layout
	* Updated layout file for the X2100. EC section manually added in after extracting the sections via ifdtool. 
	
* update.sh
	* Linux script to update BIOS safely.

# Instructions to update
## Background
There has been people who has experienced a corrupted Intel ME after applying the firmware update directly with the EC patch. It's still unknown why and we guess that it somehow set off an eFuse which caused the ME to be corrupted. The only problem that appears is that it takes about 10s to cold boot each time due to memory retraining.

If you are OK with that risk, you can take the easy way to flash the firmware in via Windows. 

For Linux users, flashrom has to be compiled from source in order to flash the firmware.

## Risky and easy way (Windows)
1. Download the BIOS update programme from [my website](). 
1. Be sure to install the drivers included in the folder. 
1. Copy bios_hap_0_unsafe.bin to the folder.
1. Rename as bios.bin
1. Run update.bat as admin. 
1. Shutdown and unplug power, including battery power.
1. _IMPORTANT_: Wait 1 minute before plugging power back in. 

## Risk free way (Linux)
1. Download the BIOS and EC you want to use. 
	* Download bios_hap_0_unsafe.bin for a HAP bit 0 BIOS and ec_patched.bin for a normal patched EC
1. Run `git clone --recursive https://github.com/xy-tech/X2100-BIOS-EC` to clone this repo and all the submodules. 
1. Alternatively, run `git clone https://github.com/xy-tech/X2100-BIOS-EC` followed by `git clone https://github.com/flashrom/flashrom.git` to just clone the files here and 
