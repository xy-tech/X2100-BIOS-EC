#!/bin/bash

# extracts first part of bios portion and puts it into new.bin
dd if=bios.bin of=new.bin bs=1024 count=4096
# extracts ec portion and puts it into new.bin
dd if=ec.bin of=new.bin bs=1024 count=64 seek=4096
# extracts the rest of the bios portion and puts it into new.bin
dd if=bios.bin of=new.bin bs=1024 seek=4160 skip=4160
# create the layout file 
touch layout.txt
echo "00400000:0040ffff ec" > layout.txt

# flashing in the combined bios files
sudo ./flashrom -p internal -l layout.txt -i ec -w new.bin

# cleans up temp files
rm new.bin
rm layout.txt
