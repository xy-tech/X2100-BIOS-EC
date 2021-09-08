# X210/X2100 compiled EC/BIOS
**Focus of this repo will be on the X2100. The X210 and other repos are linked in this repo.**
A copy of this article is on [my website](https://www.xyte.ch/support/51nb-x210-x2100-software-support/) as well, along with older versions of the BIOS.
This repo aims to compile all the relevant BIOS/EC information on the X210 and the X2100. 

# If you just want to update the BIOS/EC and don't want to read so much
Download the [latest release](https://github.com/xy-tech/X2100-BIOS-EC/releases) and read the README to flash the updates. The instructions are also found [here](#risk-free-way-linux-easy).

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
	* CSM completely disabled to avoid screen tearing. This will not allow BIOS (non UEFI) OS to boot. *Reenable this option to use BIOS OS*.
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
	
* dual_pcie.bin
	* The stock mSATA/4G module (top slot) has been changed to PCIe. Unfortunately it does not work with Intel WiFi cards, but NVMe drives and other WiFi drives do work. This would unlock faster NVMe SSDs by using an NVMe 2242 > mPCIe adapter. 

# Instructions to update
## Background
There have been people who has experienced a corrupted Intel ME after applying the firmware update directly with the EC patch. It's still unknown why and we guess that it somehow set off an eFuse which caused the ME to be corrupted. The only problem that appears is that it takes about 10s to cold boot each time due to memory retraining.

If you are OK with that risk, you can take the easy way to flash the firmware in via Windows. 

For Linux users, flashrom has to be compiled from source in order to flash the firmware. I have provided the compiled binary as well.

## Risky and easy way (Windows)
1. Download the BIOS update programme from [my website](https://www.xyte.ch/support/51nb-x210-x2100-software-support/) or from the release tab on this page.
1. Be sure to install the drivers in the downloaded folder. 
1. Copy bios_hap_0_unsafe.bin to the folder.
1. Rename as bios.bin
1. Run update.bat as admin. 
1. Shutdown and unplug power, including battery power.
1. _IMPORTANT_: Wait 1 minute before plugging power back in.

## Risk free way (Linux, complicated)
1. Set `iomem=relaxed` in [grub config](https://askubuntu.com/questions/1120578/how-do-i-edit-grub-to-add-iomem-relaxed).  
1. Download the BIOS and EC you want to use. 
	* There are 2 options for BIOS and 2 options for EC so you have a total of 4 options.
		* HAP bit 0 BIOS and normal EC
		* HAP bit 0 BIOS and fn/ctrl swapped EC
		* HAP bit 1 BIOS and normal EC
		* HAP bit 1 BIOS and fn/ctrl swapped EC
1. Rename the BIOS as bios.bin and EC as ec.bin
1. Download update.sh from this repository.
1. Download flashrom binary from the release page.
	1. Alternatively, run `git clone https://github.com/flashrom/flashrom.git` to clone flashrom
	1. `cd flashrom` and build flashrom by running `make`. More instructions are located in the flashrom readme. 
1. Place bios.bin, ec.bin, flashrom binary and update.sh in the same folder.
1. [Update the BIOS](#to-update-the-bios)
1. [Update the EC](#to-update-the-ec)

## Risk free way (Linux, easy)
The BIOS provided comes with HAP bit set to 0. EC is also patched.
1. Set `iomem=relaxed` in [grub config](https://askubuntu.com/questions/1120578/how-do-i-edit-grub-to-add-iomem-relaxed).  
1. Download the files needed from [my website](https://www.xyte.ch/support/51nb-x210-x2100-software-support/) or from the [release page](https://github.com/xy-tech/X2100-BIOS-EC/releases).
1. [Update the BIOS](#to-update-the-bios)
1. [Update the EC](#to-update-the-ec)

## To update the BIOS
1. Run `sudo bash bios_update.sh` to flash the BIOS.
1. _IMPORTANT_: Shutdown and unplug the power for 1 minute. 
1. Reboot and verify that all the settings are intact. 

## To update the EC 
1. After booting back up, run `sudo bash ec_update.sh` to flash the updated EC. 
1. _IMPORTANT_: Shutdown and unplug the power for 1 minute. 
1. Reboot and verify that all the settings are intact. 

# Fixing screen tearing
* Turn off CSM settings in the advanced menu. This is turned off by default if you flash the BIOS in here.
* Disable SA GV for RAM. 
	* Located under advanced > chipset. 

# Other BIOS tweaks
* Undervolt the machine
	* Advanced > Overclocking Performance Menu. 
	* Enable overclocking features
	* Processor > core/ring 
	* Change the offset of the voltage in mV. 
	* Change prefix to negative to indicate undervolt. 
	* Take caution with this and do plenty of test to ensure stability.
	* There are also software options to do this. 
* [PL1/PL2 adjustments](https://www.anandtech.com/show/13544/why-intel-processors-draw-more-power-than-expected-tdp-turbo)
	* [Article I wrote on this](https://www.xyte.ch/2020/05/29/x2100-performance/)
	* Advanced > Power & Performance > CPU - Power management Control > Config TDP
	* A few presets here. Default is nominal and you can change the nominal preset.
	* Adjust PL1, PL2 and tau setting for nominal profile.
* Enable C states
	* Advanced > Power & Performance
	* Enable C1 & C3 states.
	* Enable promotion and demotion of C-states.
	* Change package C-state to auto.

# BONUS 1: How to edit and patch BIOS
* Changing factory presets:
	* Use AMIBIOS to adjust settings. Several versions don't really work. Just try out different versions on the internet and see which one works. 
* Updating internal ME, change PCIe/SATA lanes etc:
	* Intel CSME v14 R1 (Intel FIT) to adjust these internal settings.

# BONUS 2: Provisioning Intel Bootguard yourself
* By using Intel FIT, you can technically provision Bootguard yourself as the machine comes unprovisioned with a clean unfused PCH. 
* Google around to find out more. All warranty is voided if you attempt to do this. 
* Doing this would probably make this the most secure laptop in the world as literally only you own the firmware keys. 

# Thanks
Thanks to everyone who made it possible.
EC patches: mjg59, jwise, l29ah
X210 coreboot: mjg59
X210 compilation: harrykipper
X2100 BIOS updates: chose to remain anonymous
Flashrom: flashrom team
Motherboard: 51nb, Hope, 17m19

# License
The BIOS binaries are copyrighted material but this repo is for easy file browsing so please do not sue me. Everything else belongs to their respective copyright owners. Everything by me is GPLv3. Feel free to fork and play around. 
