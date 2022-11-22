#!/bin/sh
setfont ter-v12n 
DISK="/dev/sda" 
EFI_PARTITION="${DISK}1" 
SWAP_PARTITION="${DISK}2" 
ROOT_PARTITION="${DISK}3"
HOSTNAME="hades"
USERNAME="oenea"
LOCALE="pl_PL.UTF-8"
LOCAL_EDITOR="nvim"
SV_OPTS="rw,noatime,compress-force=zstd:1,space_cache=v2"
mount -o ${SV_OPTS},subvol=@ ${ROOT_PARTITION} /mnt
mkdir -p /mnt/{home,.snapshots,var/cache,var/lib/libvirt,var/log,var/tmp}
mount -o ${SV_OPTS},subvol=@home ${ROOT_PARTITION} /mnt/home
mount -o ${SV_OPTS},subvol=@snapshots ${ROOT_PARTITION} /mnt/.snapshots
mount -o ${SV_OPTS},subvol=@cache ${ROOT_PARTITION} /mnt/var/cache
mount -o ${SV_OPTS},subvol=@libvirt ${ROOT_PARTITION} /mnt/var/lib/libvirt
mount -o ${SV_OPTS},subvol=@log ${ROOT_PARTITION} /mnt/var/log
mount -o ${SV_OPTS},subvol=@tmp ${ROOT_PARTITION} /mnt/var/tmp
mkdir /mnt/boot
mount ${EFI_PARTITION} /mnt/boot
