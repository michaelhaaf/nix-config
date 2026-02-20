#!/usr/bin/env bash
# Adapted from https://github.com/jordankoehn/sway-wsl2/blob/master/.local/bin/start-sway

# Wait for systemd to startup before launch.
if [[ ! -e "${XDG_RUNTIME_DIR}/bus" ]]; then
	# https://github.com/microsoft/WSL/issues/8842
	# Restart systemd for user

	# Starting recently, arch linux takes a few seconds for systemd to start, it used to be instant
	while ! sudo systemctl restart "user@$(id -u)"; do
		:
	done

	while [[ ! -e ${XDG_RUNTIME_DIR}/bus ]]; do
		printf "Waiting for user's systemd to start..."
		sleep 1
	done

fi

# Remove WSLG's xwayland so Sway can start its own
# umount /tmp/.X11-unix
# rm -rf /tmp/.X11-unix
# chmod 700 "$XDG_RUNTIME_DIR"
# mkdir /tmp/.X11-unix
# chmod 01777 /tmp/.X11-unix

# Remount .X11 as rw: https://github.com/microsoft/WSL/issues/9303#issuecomment-1345615675
sudo -s <<EOF
mount -o remount,rw /tmp/.X11-unix
EOF

# Fix incase this soft link is lost
ln -sf /mnt/wslg/runtime-dir/wayland-0 "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}"
ln -sf /mnt/wslg/runtime-dir/wayland-0.lock "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}.lock"

sway
