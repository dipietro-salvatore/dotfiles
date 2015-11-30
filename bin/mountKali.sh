#!/bin/bash
 mount /dev/mapper/OSes-Kali /mnt
 mount /dev/sda1 /mnt/boot
 mount --bind /dev /mnt/dev
 mount --bind /sys /mnt/sys
 mount --bind /proc /mnt/proc
# mount --bind /lib /mnt/lib
