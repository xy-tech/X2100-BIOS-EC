# X210/X2100 compiled EC/BIOS
**Focus of this repo will be on the X2100. The X210 and other repos are linked in this repo.**
A copy of this article is on [my website](https://www.xyte.ch/support/51nb-x210-x2100-software-support/x2100-x210-bios-ec) as well, along with older versions of the BIOS.
This repo aims to cover all the relevant BIOS/EC information on the X210 and the X2100.

# If you just want to update the BIOS/EC and don't want to read so much
Download the [latest release](https://github.com/xy-tech/X2100-BIOS-EC/releases) and read the README to flash the updates. The instructions are also found [here](#flashing-the-full-bios-image).

# Contents
* x2100 (Main content of this repo, includes the BIOS and EC)
* [X210 EC: Original X210 EC patches](https://github.com/l29ah/x210-ec)
* [X210 BIOS/EC: Compiled X210 BIOS/EC patches in a single repo](https://github.com/harrykipper/x210)
* [X2100 EC: X2100 EC patches based on the X210](https://github.com/jwise/x2100-ec)
* [X2100 EC updated: exander77's patches based on jwise's repo, not included in this repo](https://github.com/exander77/x2100-ec)
* [Flashrom for Linux](https://flashrom.org/Flashrom)
* [Coreboot for X2100](https://github.com/mjg59/coreboot/tree/x2100_ng)

The git repos listed above are listed as git submodules, once you cloned this repo you can fetch them by `git submodule init` and `git submodule update`.

# Everything inside the x2100 folder 
## BIOS images
### All the BIOS binaries contains the updated EC

* `*_17012022_*.bin`
	* Update over the 15 December binaries are the changed Intel HDA GPIO voltage from 1.8v to 3.3v which should prevent new boards from bricked ME. 
	* For detailed information, refer to the notes below. 

* `bios_15122021.bin`
	* BIOS is properly configured with sensible power levels (15W fallback).
	* CPU C states are enabled with options of promotion and demotion. Enables better power savings. 
	* UEFI video is disabled under CSM. Disable if OS does not display.
	* RAM is set to 2666MHz all the time to reduce screen tearing.
	* IGP is set to 1GB for higher intel GVT-G resolutions.
	* CPU microcode is updated. 
	* Intel ME is updated to 14.1.
	* GOP updated.
	* EC is updated using [patches](https://github.com/exander77/x2100-ec)

* `bios_15122021_me_disable.bin` (may not work from some preliminary testings)
	* Exactly the same image as `bios_15122021.bin` except the following: ME disabled, useful for those with the [ME issue](https://www.xyte.ch/2021/12/14/x2100-me-bios-ec-and-coreboot/). This disables the ME in the menu section in BIOS and does not set HAP bit = 1.

* `dual_pcie_15122021_me_disable.bin` (may not work from some preliminary testings) and `dual_pcie_15122021.bin`
	* Exactly the same image as `bios_15122021.bin` except the following: The stock mSATA/4G module (top slot) has been changed to PCIe. Unfortunately it does not work with Intel WiFi cards, but NVMe drives and other WiFi drives do work. This would unlock faster NVMe SSDs by using an NVMe 2242 female to mPCIe male adapter. This also enables dual WiFi cards, allowing those who wants dual WiFi cards for development and testing.

* `v25_original.bin`
	* The latest factory BIOS (V25)
	
## EC binaries

* `*_fast_charge.bin`
	* Patched EC using [exander's patches](https://github.com/exander77/x2100-ec). Includes all the patches except the fn/ctrl patch. Power charging is set at 80W peak. Only chargers >65W will work, excluding most 65W chargers. Fan speed is set to silent 1 profile.

* `*_slow_charge.bin`
	* Patched EC using [exander's patches](https://github.com/exander77/x2100-ec). Includes all the patches detailed above. Power charging is set at minimum 45W. 65W chargers will work, useful for those who wants to bring a small USB-C charger.

* `*_fn_ctrl_swapped.bin`
	* Patched EC using [exander's patches](https://github.com/exander77/x2100-ec). Includes all the patches detailed above including swapped fn/ctrl patch.
	* May have weird behaviour when using an external mouse. Try it out and revert to non swapped variant.

## Other useful files

* `layout`
	* BIOS layout files for the X2100 BIOS image 

* `x2100_helper.sh`
	* BIOS and EC update and management script for Unix users. Requires flashrom to be in the same directory.

* `flashrom`
	* Compiled flashrom from master that will work on 10th gen Comet Lake. Compiled for Linux x64 systems. SHA256: dbfadc52b1e1aa12bfb3e26c8e72d183037962b0ba0e65fb1987df5b2d888e56

# Instructions to update
**Note:** After updating the BIOS to some of the recent unofficial ones, the version and build date shown in the BIOS setup won't change.

## Windows
This patches both the BIOS and EC. You'll need to build the BIOS with your [preferred BIOS image and EC](#building-and-flashing-your-selected-bios-in-linux) if you want a customised image.
1. Download the BIOS update programme from [my website](https://www.xyte.ch/support/51nb-x210-x2100-software-support/) or from the release tab on this page.
1. Be sure to install the drivers in the downloaded folder.
1. Copy the preferred full BIOS image to the folder.
1. Rename as `bios.bin`.
1. Run `update.bat` as admin. 
1. Shutdown and unplug power, including battery power.
1. _IMPORTANT_: Wait 1 minute before plugging power back in.

## Linux

### Obtaining flashrom

For Linux users, flashrom has to be compiled from source in order to flash the firmware as the support for 10th generation Intel chipsets is not included in the stable release yet. A compiled binary is [provided in this repo](https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/flashrom), or you can compile it yourself:

1. Run `git clone https://github.com/flashrom/flashrom.git` to clone flashrom
1. `cd flashrom` and build flashrom by running `make`. More instructions are located in the flashrom README.

### Flashing the full BIOS image
1. Set the `iomem=relaxed` kernel parameter in your bootloader config ([see a guide for GRUB here](https://askubuntu.com/questions/1120578/how-do-i-edit-grub-to-add-iomem-relaxed)).  
1. Download the files needed from [my website](https://www.xyte.ch/support/51nb-x210-x2100-software-support/) or from the [release page](https://github.com/xy-tech/X2100-BIOS-EC/releases) or [generate your own](building-and-flashing-your-selected-bios-in-linux) using the helper script.
1. Make sure you have the full BIOS image, [flashrom](#obtaining-flashrom) and `x2100_helper.sh` in the same directory
1. Run helper script: `sudo bash x2100_helper.sh -f -i bios.bin`
1. Alternative, look [here to update the BIOS only](#to-update-the-bios-region-only)
1. [Or here for the EC only](#to-update-the-ec-region-only)

### Building and flashing your selected BIOS in Linux
1. Set the `iomem=relaxed` kernel parameter in your booloader config ([see a guide for GRUB here](https://askubuntu.com/questions/1120578/how-do-i-edit-grub-to-add-iomem-relaxed)).
1. Download the BIOS and EC you want to use. There are 4 options for BIOS (HAP bit 0 vs. 1, top slot mSATA vs. mPCIe) and 4 options for EC (with or without Fn/Ctrl swap and fast charge) so you have a total of 16 options:
    | ME disabled in menu | Top slot | Fn/Ctrl swap | Fast charge | BIOS file                                                                                                               | EC file                                                                                                                        |
    |-----------------------------|----------|--------------|-------------|-------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|
    | No                          | mSATA    | No           | No          | [Download](https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/bios/normal/bios_17012022.bin)                       | [Download](https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/ec/normal/ec_15122021_slow_charge.bin)                      |
    | No                          | mSATA    | No           | Yes         | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/bios/normal/bios_17012022.bin )                     | [Download](https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/ec/normal/ec_15122021_fast_charge.bin)                      |
    | No                          | mSATA    | Yes          | No          | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/bios/normal/bios_17012022.bin )                     | [Download](https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/ec/fn_ctrl_swap/ec_15122021_slow_charge_fn_ctrl_swap.bin)   |
    | No                          | mSATA    | Yes          | Yes         | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/bios/normal/bios_17012022.bin )                     | [Download](https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/ec/fn_ctrl_swap/ec_15122021_fast_charge_fn_ctrl_swap.bin)   |
    | No                          | mPCIe    | No           | No          | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/bios/normal/dual_pcie_17012022.bin )                | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/ec/normal/ec_15122021_slow_charge.bin )                    |
    | No                          | mPCIe    | No           | Yes         | [Download](https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/bios/normal/dual_pcie_17012022.bin)                  | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/ec/normal/ec_15122021_fast_charge.bin )                    |
    | No                          | mPCIe    | Yes          | No          | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/bios/normal/dual_pcie_17012022.bin )                | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/ec/fn_ctrl_swap/ec_15122021_slow_charge_fn_ctrl_swap.bin ) |
    | No                          | mPCIe    | Yes          | Yes         | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/bios/normal/dual_pcie_17012022.bin )                | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/ec/fn_ctrl_swap/ec_15122021_fast_charge_fn_ctrl_swap.bin ) |
    | Yes                         | mSATA    | No           | No          | [Download](https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/bios/me_disable/bios_17012022_me_disable.bin)        | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/ec/normal/ec_15122021_slow_charge.bin )                    |
    | Yes                         | mSATA    | No           | Yes         | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/bios/me_disable/bios_17012022_me_disable.bin )      | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/ec/normal/ec_15122021_fast_charge.bin )                    |
    | Yes                         | mSATA    | Yes          | No          | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/bios/me_disable/bios_17012022_me_disable.bin )      | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/ec/fn_ctrl_swap/ec_15122021_slow_charge_fn_ctrl_swap.bin ) |
    | Yes                         | mSATA    | Yes          | Yes         | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/bios/me_disable/bios_17012022_me_disable.bin )      | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/ec/fn_ctrl_swap/ec_15122021_fast_charge_fn_ctrl_swap.bin ) |
    | Yes                         | mPCIe    | No           | No          | [Download](https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/bios/me_disable/dual_pcie_17012022_me_disable.bin)   | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/ec/normal/ec_15122021_slow_charge.bin )                    |
    | Yes                         | mPCIe    | No           | Yes         | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/bios/me_disable/dual_pcie_17012022_me_disable.bin ) | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/ec/normal/ec_15122021_fast_charge.bin )                    |
    | Yes                         | mPCIe    | Yes          | No          | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/bios/me_disable/dual_pcie_17012022_me_disable.bin ) | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/ec/fn_ctrl_swap/ec_15122021_slow_charge_fn_ctrl_swap.bin ) |
    | Yes                         | mPCIe    | Yes          | Yes         | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/bios/me_disable/dual_pcie_17012022_me_disable.bin ) | [Download]( https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/ec/fn_ctrl_swap/ec_15122021_fast_charge_fn_ctrl_swap.bin ) |
1. Rename the BIOS as `bios.bin` and EC as `ec.bin`
1. Download [flashrom](https://github.com/xy-tech/X2100-BIOS-EC/raw/main/x2100/flashrom) and the [helper script](https://raw.githubusercontent.com/xy-tech/X2100-BIOS-EC/main/x2100/x2100_helper.sh) (both are also available in the [releases](https://github.com/xy-tech/X2100-BIOS-EC/releases)). Alternatively, you can [compile flashrom yourself](#obtaining-flashrom).
1. Place `bios.bin`, `ec.bin`, flashrom binary and `x2100_helper.sh` in the same folder.
1. To build a full flashable BIOS image, run: `sudo bash x2100_helper.sh -c -b bios.bin -e ec.bin -o output.bin`
1. [Update the whole BIOS image](#flashing-the-full-bios-image) or [only the BIOS](#to-update-the-bios-region-only) or [only the EC](#to-update-the-ec-region-only)

### To update the BIOS region only
1. Run the helper script to update the BIOS: `sudo bash x2100_helper.sh -f -b bios.bin`
1. _IMPORTANT_: Shutdown and unplug the power for 1 minute. 
1. Reboot and verify that all the settings are intact. 

### To update the EC region only
1. Run the helper script to update the EC: `sudo bash x2100_helper.sh -f -e ec.bin`
1. _IMPORTANT_: Shutdown and unplug the power for 1 minute.
1. Reboot and verify that all the settings are intact.

# Enable PCH TPM2.0 (onboard TPM that is in Intel ME)
1. Go into BIOS
1. Advanced
1. PCH-FW Config
1. PTT
1. Change dTPM to PTT

# Fixing screen tearing
* Turn off CSM settings in the advanced menu.
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

# ME diable via HAP = 1
* From my limited testings, HAP = 1 does not work as intended after running the me_cleaner script. The behaviour of the laptop is the same as HAP = 0 and intelmetool reports everything to be working even though the dumped ME image after running the script reports HAP bit to be set. The only way to set HAP = 1 seems to be via hardware [as detailed on my blogpost](https://www.xyte.ch/2021/12/14/x2100-me-bios-ec-and-coreboot/). 

# External flashing
* Grab a CH341a to save yourself from the pain of figuring out how to use the RPI in flashing. The CH341a is natively supported by flashrom and probably works for 99% of flash chips out there. 
* Part number of the X2100 flash chip is MX25L12835F.
* EEPROM chip is underneath the keyboard, next to the IO daughterboard. 

# BONUS 0: Coreboot
* mjg59 has kindly ported coreboot to the X2100. Feel free to compile from his repo. It is included as a submodule for in this repo as well.

# BONUS 1: How to edit and patch BIOS
* Changing factory presets:
	* Use AMIBIOS (google around for the binary) to adjust settings. Several versions don't really work. Just try out different versions on the internet and see which one works.
* Updating internal ME, change PCIe/SATA lanes etc:
	* Intel CSME v14 R1 (Intel FIT) to adjust these internal settings.

# BONUS 2: Provisioning Intel Bootguard yourself
* By using Intel FIT, you can technically provision Bootguard yourself as the machine comes unprovisioned with a clean unfused PCH. 
* Google around to find out more. All warranty is voided if you attempt to do this. 
* Doing this would probably make this the most secure laptop in the world as literally only you own the firmware keys. 

# Thanks
Thanks to everyone who made it possible.
* EC patches: mjg59, jwise, l29ah, exander77
* X210 coreboot: mjg59
* X210 compilation: harrykipper
* X2100 BIOS updates: chose to remain anonymous
* Flashrom: [flashrom team](https://www.flashrom.org/)
* Motherboard: 51nb, Hope, 17m19
* Everyone else who has contributed to this project, the maintainerr and you: the user who has tested and debugged this laptop.

# License
The BIOS binaries contains copyrighted material from AMI but this repo is for documentation so please do not sue me. Everything else belongs to their respective copyright owners. Everything by me is GPLv3 including the helper script. Feel free to fork and play around.
