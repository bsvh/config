#!/usr/bin/env bash

sudo setenforce Permissive
sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

read -e -p "Path to btrfs partition" btrfs_part

sudo mount "${btrfs_part}" /mnt
sudo btrfs subvolume create /mnt/nix
sudo umount /mnt

sudo mkdir /var/lib/nix
sudo mount "${btrfs_part}" -o subvol=nix,compress=zstd,noatime /var/lib/nix
sudo chown $USER:$USER /var/lib/nix
echo "${btrfs_part} /var/nix btrfs subvol=nix,compress=zstd:1,noatime,systemd.device-timeout=0 0 0" | sudo tee -a /etc/fstab

cat <<EOF | sudo tee /etc/systemd/system/mkdir-rootfs@.service
[Unit]
Description=Enable mount points in / for ostree
ConditionPathExists=!%f
DefaultDependencies=no
Requires=local-fs-pre.target
After=local-fs-pre.target

[Service]
Type=oneshot
ExecStartPre=chattr -i /
ExecStart=mkdir -p '%f'
ExecStopPost=chattr +i /
EOF

cat <<EOF | sudo tee /etc/systemd/system/nix.mount
[Unit]
Description=Nix Package Manager
DefaultDependencies=no
After=mkdir-rootfs@nix.service
Wants=mkdir-rootfs@nix.service
Before=sockets.target
After=ostree-remount.service
BindsTo=var.mount

[Mount]
What=/var/lib/nix
Where=/nix
Options=bind
Type=none

[Install]
WantedBy=local-fs.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now nix.mount

read -p "Press enter to install nix. "
sh <(curl -L https://nixos.org/nix/install) --no-daemon
