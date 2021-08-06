#!/bin/bash

# dump current bios & ec
sudo ./flashrom -p internal -r dump.bin
# extract dumped ec
dd if=dump.bin of=ec_dump.bin bs=1 skip=$((0x400000)) count=$((0x10000))

# place new bios into to bios to flash
dd if=bios.bin of=new_bios.bin bs=1024 count=4096
# place extracted ec into new bios to preserve old ec
dd if=ec_dump.bin of=new_bios.bin bs=1024 count=64 seek=4096
# place new bios into the rest of the bios to flash
dd if=bios.bin of=new_bios.bin bs=1024 seek=4160 skip=4160

# flash new_bios.bin
sudo ./flashrom -p internal -w new_bios.bin

# clean up
rm new_bios.bin
rm dump.bin
rm ec_dump.bin
