#! /usr/bin/bash
set -e  # Interrompe o script se algum comando falhar

emerge --oneshot app-portage/mirrorselect
mirrorselect -i -o /etc/portage/make.conf

emerge --sync
eselect news read
eselect profile set default/linux/amd64/23.0/desktop/gnome

emerge --oneshot app-portage/cpuid2cpuflags
echo "*/* $(cpuid2cpuflags)" > /etc/portage/package.use/00cpu-flags
emerge --update --deep --changed-use @world
emerge --depclean
echo "pt_BR.UTF-8" > /etc/locale.gen
locale-gen
eselect locale set pt_BR.UTF-8
env-update && source /etc/profile && export PS1="(chroot) ${PS1}"

echo "sys-kernel/installkernel grub" >> /etc/portage/package.use/installkernel
echo "llvm-core/clang extra" >> /etc/portage/package.use/clang
emerge sys-kernel/linux-firmware sys-kernel/gentoo-kernel sys-firmware/sof-firmware

echo "/dev/nvme0n1p1		/efi		vfat		umask=0077,tz=UTC 0 2" >> /etc/fstab
echo "/dev/nvme0n1p2		none		swap		sw		0 0" >> /etc/fstab
echo "/dev/nvme0n1p3		/ext4		defaults,noatime 0 1" >> /etc/fstab
echo gentoo > /etc/hostname
passwd

emerge networkmanager
rc-update add NetworkManager
emerge app sysklogd dcron chrony power-profiles-daemon mlocate
rc-update add sysklogd
rc-update add chronyd
rc-update add dcron
crontab /etc/crontab
rc-update add power-profiles-daemon


echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
grub-install --efi-directory=/efi
grub-mkconfig -o /boot/grub/grub.cfg

emerge gui-libs/display-manager-init app-admin/doas
echo "permit persist :wheel" >> /etc/doas.conf
chown -c root:root /etc/doas.conf
chmod -c 0400 /etc/doas.conf
emerge gnome-base/gnome-light dev-lang/rust app-editors/helix x11-terms/xfce4-terminal dev-util/ruff
emerge app-shells/fish gnome-extra/gnome-shell-extension-pop-shell
emerge -aC gnome-extra/gnome-shell-extension-pop-shell
emerge sys-apps/flatpak net-im/discord media-sound/spotify gnome-extra/gnome-tweaks media-gfx/eog
emerge media-fonts/noto media-fonts/noto-emoji media-fonts/noto-cjk

exit

