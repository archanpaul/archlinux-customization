echo "RSYNC_INCLUDES_PKG=\"" > archlinux-rsync.pkg.new
pacman -Qnq | awk '{ printf "--include="; print $0"-[0-9]* \\" }' | sort >> archlinux-rsync.pkg.new
echo "\"" >> archlinux-rsync.pkg.new
