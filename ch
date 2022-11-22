#!/bin/sh
#setfont ter-v12n 
DISK="/dev/sda" 
EFI_PARTITION="${DISK}1" 
SWAP_PARTITION="${DISK}2" 
ROOT_PARTITION="${DISK}3"
HOSTNAME="hades"
USERNAME="oenea"
LOCALE="pl_PL.UTF-8"
LANGUAGE="en_US.UTF-8"
LOCAL_EDITOR="nvim"
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc --localtime
printf "${HOSTNAME}" > /etc/hostname
printf "nameserver 8.8.8.8" > /etc/resolv.conf
cat > /etc/hosts <<EOF
127.0.0.1 localhost
::1       localhost
127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}
EOF
sed -i "s/^#\(${LOCALE}\)/\1/" /etc/locale.gen
printf "LANG=${LANGUAGE}" > /etc/locale.conf
locale-gen
printf "KEYMAP="pl"\nFONT=ter-v12n" > /etc/vconsole.conf
printf "EDITOR=${LOCAL_EDITOR}\nVISUAL=${LOCAL_EDITOR}" > /etc/environment
useradd -m -G wheel -s /bin/bash ${USERNAME}
sed -i "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" /etc/sudoers
systemctl enable sshd.service
bootctl install
cat > /boot/loader/loader.conf <<EOF
default      arch.conf
timeout      4
console-mode max
editor       no
EOF
PARTUUID=$(blkid -s PARTUUID -o value ${ROOT_PARTITION})
cat > /boot/loader/entries/arch.conf <<EOF
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
initrd /initramfs-linux-fallback.img
options root=PARTUUID=${PARTUUID} rootflags=subvol=@ rw quiet 
EOF
systemctl enable fstrim.timer
cp -v 10-network.rules /etc/udev/rules.d/
printf "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudoer_${USERNAME}
printf "\nnew ROOT password\n"
passwd
printf "\nnew USER password\n"
passwd ${USERNAME} 
