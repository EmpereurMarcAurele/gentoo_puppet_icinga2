Setup and Install Gentoo Linux in VirtualBox
tux

This guide deals with setup and installation of Gentoo Linux in Oracle VM VirtualBox in most straight-forward and easiest way. The procedure is tested and verified. You may modify the process to suit 
your purpose.

Prerequisites: Oracle VM VirtualBox.

    1. Download installation image

    Download install-amd64-minimal-YYYYMMDD.iso and stage3-amd64-YYYYMMDD.tar.bz2 from Gentoo Linux - Downloads

    2. Verify your download

    Run sha512sum install-amd64-minimal-YYYYMMDD.iso and sha512sum stage3-amd64-YYYYMMDD.tar.bz2 and check the results with SHA512 checksums given in the .DIGESTS files at Gentoo Linux - Downloads

    3. Create an ISO of the stage3 tarball

    Create an ISO file stage3-amd64-YYYYMMDD.tar.bz2.iso, such that it only contains the stage3 tarball, stage3-amd64-YYYYMMDD.tar.bz2

    4. Create a new VM in VirtualBox for gentoo Linux guest
        Click New
        Select Gentoo (64 bit) in guest version
        Select 1024 MB or 1 GB of RAM for guest
        Select Create a virtual hard drive now
        Select VDI (VirtualBox Disk Image)
        Select Dynamically allocated
        Select 32 GB of hard drive for guest
        Click Create

    Note: In some host filesystems, VirtualBox may tell you that it has turned on Host I/O Cache when you start your guest. In that case, make this setting permanent by checking Use Host I/O Cache in 
Settings > Storage > Controller: SATA of your selected guest.
        Add one empty CD/DVD drive by selecting Adds Optical Drive icon in the Settings > Storage > Controller: IDE section. 

    5. Boot the VM with install-amd64-minimal-YYYYMMDD.iso in virtual drive
        Ensure your VM is selected and Click Settings > Storage > Controller: IDE > Empty primary (CD/DVD drive)
        From the drop down list browse install-amd64-minimal-YYYYMMDD.iso
        Similarly, select stage3-amd64-YYYYMMDD.tar.bz2.iso in the secondary drive and click OK
        Click Start to start the VM
        Press Enter in the boot prompt and you will be logged in as root automatically

    6. Check Internet Connection
        Run ping -c 3 www.gnu.org and look for success
        Run ip addr and look for inet 10.0.2.15/24 brd 10.0.2.255 scope global enp0s3 and under ethernet device enp0s3
        Run ip route and look for default via 10.0.2.2 dev enp0s3 metric 202 in the first line and 10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15 metric 202 in the second line
        Run cat /etc/resolv.conf and look for nameserver x.x.x.x where x.x.x.x is either 10.0.2.3 or the DNS of your router
        If any of the above is not found, check how your VirtualBox provides internet to its guest and ensure that it is a NAT Adapter in Settings > Network of your VM

        Note: VirtualBox usually provides a wired/ethernet network of 10.0.2.0 with subnet mask 255.255.255.0 (10.0.2.0/24 in CIDR), gateway 10.0.2.2, DNS 10.0.2.3 and a Dynamic IP for your NAT Adapter 
10.0.2.15

    7. Partition your guest hard drive
        Run fdisk /dev/sda
        In the fdisk prompt run the following commands n,p,1,,+2M
        t,1,ef
        n,p,2,,+128M
        a,2
        n,p,3,,+512M
        t,3,82
        n,p,4,,
        w

    8. Mount the Storage
        Run mkfs.ext2 /dev/sda2 and mkfs.ext4 /dev/sda4 to format the partitions

        Note: Run mkswap /dev/sda3 if /dev/sda3 is not formatted as swap
        Run swapon /dev/sda3
        Run mount /dev/sda4 /mnt/gentoo
        Run mkdir /mnt/gentoo/boot
        Run mount /dev/sda2 /mnt/gentoo/boot
        Run lsblk and review mountpoints

    9. Copy and extract stage3 tarball
        Run mkdir /mnt/gentoo/tar
        Run mount /dev/sr1 /mnt/gentoo/tar
        Run cp /mnt/gentoo/tar/stage3* /mnt/gentoo
        Run umount /dev/sr1
        Run rm -rf /mnt/gentoo/tar
        Run cd /mnt/gentoo
        Run tar xvjpf stage3*.tar.bz2 --xattrs

    10. Configure Portage
        Run cat /mnt/gentoo/etc/portage/make.conf and review protage configuration
        Run mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf and mirrorselect -i -r -o >> /mnt/gentoo/etc/portage/make.conf to select normal and rsync mirrors
        Run cp -L /etc/resolv.conf /mnt/gentoo/etc/ to copy the DNS resolve file from live Gentoo system

    11. Mount necessary filesystems
        Run mount -t proc proc /mnt/gentoo/proc
        Run mount --rbind /sys /mnt/gentoo/sys
        Run mount --rbind /dev /mnt/gentoo/dev
        Run mount --make-rslave /mnt/gentoo/sys
        Run mount --make-rslave /mnt/gentoo/dev

    12. Chroot to target system
        Run chroot /mnt/gentoo /bin/bash to chroot into new system
        Run source /etc/profile to load the new environment
        Run export PS1="(chroot) $PS1" to remind you that you are in chroot prompt

    13. Configure Portage
        Run emerge-webrsync to update the portage tree to the latest snapshot
        Run eselect profile list to list all the available profiles
        Run eselect profile set 4 to select a profile which sets the USE, CFLAGS, and other variables

    14. Select Time zone
        Search in /usr/share/zoneinfo/Zone/SubZone for your time zone
        Run echo "Zone/SubZone" > /etc/timezone
        Run emerge --config sys-libs/timezone-data to generate timezone data

    15. Configure locale
        Run nano /etc/locale.gen and uncomment the desired locales
        Run locale-gen to generate locale data
        Run locale -a to view available locales
        Run eselect locale list to view available locales
        Run eselect locale set 5 to select the desired locale
        Run env-update && source /etc/profile to reload the environment

    16. Compile the kernel (automatic configuration)
        Run emerge --ask sys-kernel/gentoo-sources to download the kernel source
        Run ls -l /usr/src/linux verify the source
        Run emerge --ask sys-kernel/genkernel to download and install genkernel
        Run nano /etc/fstab and edit /dev/BOOT to /dev/sda2 as genkernel reads this file
        Run genkernel all to compile the kernel with automatic configuration
        Run ls /boot/kernel* /boot/initramfs* to verify the kernel and initram

    17. Configure fstab
        Run nano /etc/fstab and edit as follows /dev/sda2  /boot      ext2 defaults,noatime   0 2
        /dev/sda4  /          ext4 noatime            0 1
        /dev/sda3  none       swap sw                 0 0
        /dev/cdrom /mnt/cdrom auto noauto,user        0 0

    18. Configure network and other services
        Run nano /etc/conf.d/hostname to check the hostname
        Run emerge net-misc/dhcpcd to install dhcp deamon
        Run rc-update add dhcpcd default to start dhcp service
        Run nano /etc/rc.conf to review the services
        Run nano /etc/conf.d/keymaps to review the keymap
        Run nano /etc/conf.d/hwclock to review the clock

    19. Set root password and add new user
        Run passwd to set root password
        Run useradd -m -G users,wheel,audio,lp,cdrom,portage -s /bin/bash myusername to add an user
        Run passwd myusername to set the password for that user
        Run emerge sudo to install sudo
        Run nano /etc/sudoers and Add myusername ALL=(ALL) ALL below root ALL=(ALL) ALL to give that user superuser privilege

    20. Install bootloader
        Run emerge sys-boot/grub to install grub
        Run grub2-install /dev/sda to install grub bootloader at /dev/sda
        Run grub2-mkconfig -o /boot/grub/grub.cfg to generate the configuration for bootloader

    21. Unmount the partitions and reboot
        Run exit to exit chroot
        Run cd to go to home directory
        Run umount -l /mnt/gentoo/dev{/shm,/pts,} to unmount filesystems
        Run umount -l /mnt/gentoo{/boot,/proc,} to unmount filesystems
        Run reboot to restart VM or Run poweroff to shutdown VM
        Remove the installation iso disk from virtual drive

    22. First login and others
        Run rm /stage3-*.tar.bz2 to remove the tarball
        Run emerge --sync to update the portage tree to very latest condition

