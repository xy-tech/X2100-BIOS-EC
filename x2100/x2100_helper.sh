#!/bin/bash

############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Helper script to flash X2100 BIOS images."
   echo
   echo "Syntax: bash x2100_bios.sh [-h | -f [-b <bios> | -e <ec> | -i <full_bios_image>] | -c [-b <bios>] [-e <bios>] [-o <output.bin>]]"
   echo ""
   echo "Options:"
   echo "	-h"     
   echo "	Print this Help."
   echo ""
   echo "	-f [-b <bios> | -e <ec> | -i <full_bios_image>]"
   echo "	Flash a BIOS image or EC image or a full image."
   echo "		-b <bios>			Specify the BIOS image, eg: bash x2100_bios.sh -f -b bios.bin"
   echo "		-e <ec>				Specify the EC image, eg: bash x2100_bios.sh -f -e ec.bin"
   echo "		-i <full_bios_image>		Specify the full image to flash, eg: bash x2100_bios.sh -f -i bios.bin"
   echo ""
   echo "	-c [-b <bios>] [-e <bios>] [-o <output.bin>]"
   echo "	Combine a BIOS and EC binary to generate an flashable BIOS image."
   echo "		-b <bios>		Specify the BIOS image, eg: bash x2100_bios.sh -c -b bios.bin -e ec.bin -o new_bios.bin"
   echo "		-e <ec>			Specify the EC image, eg: bash x2100_bios.sh -c -b bios.bin -e ec.bin -o output.bin"
   echo "		-o <output.bin>		Specify the new BIOS output image, eg: bash x2100_bios.sh -c -b bios.bin -e ec.bin -o output.bin"
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

# get all the options keyed in
while getopts "cfhb:e:i:o:" optname; do
	argarr+=("$OPTARG")
	optarr+=("$optname")
done

Flash()
{
	# Error checking
	if [ "${#optarr[@]}" -ne 2 ]; then
		echo "Error: Expecting 2 options"
		exit
	fi
	
	# Main for loop
	for ((i=0;i<${#optarr[@]};i++)); do
		
		# Skip first "f"
		if [ ${optarr[$i]} == "f" ]; then
			continue
		fi
		
		# Argument of "b" bios
		if [ ${optarr[$i]} == "b" ]; then
			# dump current bios & ec
			./flashrom -p internal -r dump.bin
			# extract dumped ec
			dd if=dump.bin of=ec_dump.bin bs=1 skip=$((0x400000)) count=$((0x10000))
			# place new bios into to bios to flash
			dd if="${argarr[$i]}" of=new_bios.bin bs=1024 count=4096
			# place extracted ec into new bios to preserve old ec
			dd if=ec_dump.bin of=new_bios.bin bs=1024 count=64 seek=4096
			# place new bios into the rest of the bios to flash
			dd if="${argarr[$i]}" of=new_bios.bin bs=1024 seek=4160 skip=4160
			# flash new_bios.bin
			./flashrom -p internal -w new_bios.bin
			# clean up
			echo "Cleaning up"
			rm new_bios.bin
			rm dump.bin
			rm ec_dump.bin
			# Success
			echo ""
			echo "Success!"
			# exit without checking the rest
			exit
		fi
		
		# Argument of "e" ec
		if [ ${optarr[$i]} == "e" ]; then
			# dump current BIOS
			./flashrom -p internal -r dump.bin
			# extracts first part of bios portion and puts it into new.bin
			dd if=dump.bin of=new.bin bs=1024 count=4096
			# extracts ec portion and puts it into new.bin
			dd if="${argarr[$i]}" of=new.bin bs=1024 count=64 seek=4096
			# extracts the rest of the bios portion and puts it into new.bin
			dd if=dump.bin of=new.bin bs=1024 seek=4160 skip=4160
			# create the layout file 
			touch layout.txt
			echo "00400000:0040ffff ec" > layout.txt
			# flashing in the combined bios files
			./flashrom -p internal -l layout.txt -i ec -w new.bin
			# cleans up temp files
			echo "Cleaning up"
			rm new.bin
			rm layout.txt
			# Success
			echo ""
			echo "Success!"
			# exit without going through the rest
			exit
		fi
		
		# Argument of full "i" image
		if [ ${optarr[$i]} == "i" ]; then
			./flashrom -p internal -w "${argarr[$i]}"
			echo ""
			echo "Success!"
			exit
		fi
	done
}

Combine()
{
	# Error checking
	if [ "${#optarr[@]}" -ne 4 ]; then
		echo "Error: Expecting 4 options"
		exit
	fi
	
	for ((j=0;j<${#optarr[@]};j++)); do
		if [ ${optarr[$j]} == "c" ]; then
			continue
		fi
		if [ ${optarr[$j]} == "e" ]; then
			ec="${argarr[$j]}"
		fi
		if [ ${optarr[$j]} == "b" ]; then
			bios="${argarr[$j]}"
		fi
		if [ ${optarr[$j]} == "o" ]; then
			output="${argarr[$j]}"
		fi
	done
	
	# extracts first part of bios portion and puts it into new.bin
	dd if=$bios of=$output bs=1024 count=4096
	# extracts ec portion and puts it into new.bin
	dd if=$ec of=$output bs=1024 count=64 seek=4096
	# extracts the rest of the bios portion and puts it into new.bin
	dd if=$bios of=$output bs=1024 seek=4160 skip=4160
	
	echo "Success!"
	echo "Output binary is $output"
	exit
}

case "${optarr[0]}" in
	:|h)
		Help
		;;
	f)
		Flash
		;;
	c)
		Combine
		;;
	*)
		echo "Illegal argument entered. Run with argument -h to view help"
		exit
		;;
esac
