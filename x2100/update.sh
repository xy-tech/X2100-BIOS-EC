#!/bin/bash

dd if=bios.bin of=new.bin bs=1024 count=4096
dd if=ec.bin of=new.bin bs=1024 count=64 seek=4096
dd if=bios.bin of=new.bin bs=1024 seek=4096 skip=4096
touch layout.txt
echo "00400000:0040ffff ec" > layout.txt
sudo ./flashrom -p internal -l layout.txt -i ec -w new.bin
rm new.bin
