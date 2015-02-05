#!/bin/bash

export curdate=`date "+%m-%d-%Y"`

cd ~/android/Despair/lk.ramdisk/boot.img-ramdisk
chmod 750 init* sbin/adbd sbin/healthd
chmod 644 default* uevent* res/images/charger/*
chmod 755 sbin sbin/lkconfig
chmod 700 sbin/lk-post-boot.sh
chmod 755 res res/images res/images/charger
chmod 640 fstab.shamu
cd ..

echo "making ramdisk"
./mkbootfs boot.img-ramdisk | gzip > ramdisk.gz
echo "making boot image"
./mkbootimg --kernel zImage-dtb --cmdline 'console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=shamu msm_rtb.filter=0x37 ehci-hcd.park=3 utags.blkdev=/dev/block/platform/msm_sdcc.1/by-name/utags utags.backup=/dev/block/platform/msm_sdcc.1/by-name/utagsBackup coherent_pool=8M' --base 0x00000000 --pagesize 2048 --ramdisk_offset 0x02000000 --tags_offset 0x01E00000 --ramdisk ramdisk.gz --output ~/android/Despair/out/boot.img

echo " "
