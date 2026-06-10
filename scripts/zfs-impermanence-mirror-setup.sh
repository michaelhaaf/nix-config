#!/usr/bin/env bash

set -euo pipefail

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== NixOS ZFS+Impermanence Setup ===${NC}"
echo -e "${YELLOW}WARNING: This script will DESTROY ALL DATA on the selected disk.${NC}"
echo

# 1. Select Disk
echo "Available disks:"
lsblk -d -o NAME,SIZE,MODEL,TYPE | grep -v "rom"
echo
read -r -p "Enter the target disk (e.g., vda, sda, nvme0n1): " DISK1
read -r -p "Enter the mirror disk (same size as previous): " DISK2

# Sanitize input (remove /dev/ prefix if typed)
DISK1=${DISK1#/dev/}
DISK2=${DISK2#/dev/}
DISK1="/dev/${DISK1}"
DISK2="/dev/${DISK2}"
if [[ $DISK1 =~ "nvme" ]]; then
	D1PART1="${DISK1}p1"
	D1PART2="${DISK1}p2"
	D2PART1="${DISK2}p1"
	D2PART2="${DISK2}p2"
else
	D1PART1="${DISK1}1"
	D1PART2="${DISK1}2"
	D2PART1="${DISK2}1"
	D2PART2="${DISK2}2"
fi

check_disk() {
	if [ ! -b "$1" ]; then
		echo -e "${RED}Error: Device $1 not found.${NC}"
		exit 1
	fi
}

confirm_disks() {
	echo -e "${YELLOW}You have selected: $1 $2${NC}"
	read -r -p "Are you absolutely sure you want to proceed? (yes/NO): " CONFIRM
	if [ "$CONFIRM" != "yes" ]; then
		echo "Aborting."
		exit 1
	fi
}

partition() {
	sgdisk --zap-all "$1"
	wipefs -fa "$1"
	sgdisk -n 1:0:+1GiB -t 1:EF00 -c 1:boot "$1"
	# Swap is omitted.
	sgdisk -n 2:0:0 -t 2:BF01 -c 2:zfs "$1"
	sgdisk --print "$1"

	# Re-read partition table *after* creating partitions
	partprobe "$1"
}

check_disk "$DISK1"
check_disk "$DISK2"

confirm_disks "$DISK1" "$DISK2"

echo -e "${GREEN}[1/6] Partitioning disks...${NC}"
partition "$DISK1"
partition "$DISK2"
udevadm settle

echo -e "${GREEN}[2/6] Formatting EFI partitions...${NC}"
mkfs.vfat -F32 -n EFI "${D1PART1}"
mkfs.vfat -F32 -n EFI "${D2PART1}"

echo -e "${GREEN}[3/6] Creating ZFS Pool 'rpool'...${NC}"

# Destroy rpool if it exists, carry on if not
if ! zpool status 2>&1 >/dev/null | grep -q "no pools available"; then zpool destroy rpool; fi
zpool create -f \
	-o ashift=12 \
	-o autotrim=on \
	-O mountpoint=none \
	-O relatime=on \
	-O acltype=posixacl \
	-O xattr=sa \
	rpool mirror \
	"$D1PART2" "$D2PART2"

echo -e "${GREEN}[4/6] Creating ZFS datasets...${NC}"

# Method 1: (not necessarily used with impermanence)
# zfs create -p -o mountpoint=legacy rpool/root

# Method 2: (not necessarily used with mirroring)
# Root (ephemeral, will be rolled back)
zfs create -p -o canmount=noauto -o mountpoint=legacy rpool/local/root
# Blank snapshot (erase target)
zfs snapshot rpool/local/root@blank
# Boot
zfs create -p -o mountpoint=legacy rpool/local/boot
zfs create -p -o mountpoint=legacy rpool/local/boot-mirror
# Nix store (read-only, made to survie roll-backs)
zfs create -p -o mountpoint=legacy rpool/local/nix
# Persistent data
zfs create -p -o mountpoint=legacy rpool/safe/home
zfs create -p -o mountpoint=legacy rpool/safe/persist

echo -e "${GREEN}[5/6] Mounting filesystems...${NC}"

# Method 1: (not necessarily used with impermanence)
# mount -t zfs rpool/root /mnt
# mkdir /mnt/boot
# mkdir /mnt/boot-fallback
# mount $DISK1-part1 /mnt/boot
# mount $DISK2-part1 /mnt/boot-fallback

# Method 2: (not necessarily used with mirroring)
mount -t zfs rpool/local/root /mnt
mkdir -p /mnt/{nix,home,persist,boot,boot-mirror}
mount -t zfs rpool/local/boot /mnt/boot
mount -t zfs rpool/local/boot-mirror /mnt/boot-mirror
mkdir -p /mnt/{boot/efi,boot-mirror/efi}
mount -t vfat -o umask=0077 "$D1PART1" /mnt/boot/efi
mount -t vfat -o umask=0077 "$D2PART1" /mnt/boot-mirror/efi
mount -t zfs rpool/local/nix /mnt/nix
mount -t zfs rpool/safe/home /mnt/home
mount -t zfs rpool/safe/persist /mnt/persist

echo -e "${GREEN}=== Setup Complete! ===${NC}"
echo -e "${GREEN}=== [6/6] Post-flight checks ===${NC}"

fail() {
	echo -e "${RED}ERROR:${NC} $*" >&2
	exit 1
}
warn() { echo -e "${YELLOW}WARN:${NC} $*" >&2; }

# ZFS pool exists and is ONLINE
pool_state="$(zpool status rpool 2>/dev/null | awk -F': ' '/^ state:/ {print $2; exit}')"
[ -n "$pool_state" ] || fail "Could not read zpool state for rpool"

if [ "$pool_state" != "ONLINE" ]; then
	zpool status rpool >&2 || true
	fail "rpool state is '$pool_state' (expected ONLINE)"
fi

# Required datasets exist
for ds in \
	rpool/local/root \
	rpool/local/nix \
	rpool/safe/home \
	rpool/safe/persist; do
	zfs list -H -o name "$ds" >/dev/null 2>&1 || fail "Missing dataset: $ds"
done

# Impermanence base snapshot exists
# (zfs supports listing snapshots with -t snapshot) [web:107]
zfs list -t snapshot -H -o name rpool/local/root 2>/dev/null | grep -qx 'rpool/local/root@blank' ||
	fail "Missing snapshot: rpool/local/root@blank"

# Mountpoints are actually mounted where expected
# findmnt can search for a filesystem by a target path (-T/--target). [web:106]
findmnt -T /mnt >/dev/null 2>&1 || fail "/mnt is not a mountpoint"
findmnt -T /mnt/boot >/dev/null 2>&1 || fail "/mnt/boot is not a mountpoint"
findmnt -T /mnt/boot-mirror >/dev/null 2>&1 || fail "/mnt/boot-mirror is not a mountpoint"
findmnt -T /mnt/nix >/dev/null 2>&1 || fail "/mnt/nix is not a mountpoint"
findmnt -T /mnt/home >/dev/null 2>&1 || fail "/mnt/home is not a mountpoint"
findmnt -T /mnt/persist >/dev/null 2>&1 || fail "/mnt/persist is not a mountpoint"

# Show a compact status summary (useful when you paste logs)
echo
echo "--- lsblk -f ${DISK1} ---"
lsblk -f "$DISK1" || true
echo "--- lsblk -f ${DISK2} ---"
lsblk -f "$DISK2" || true
echo
echo "--- zpool status rpool ---"
zpool status rpool || true
echo
echo "--- zfs list ---"
zfs list || true
echo
echo -e "${GREEN}All checks passed.${NC}"

# Next steps:
# Generate a NixOS configuration
# nixos-generate-config --root /mnt
# edit configuration.nix and run `nixos-install`
