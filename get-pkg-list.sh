echo "RSYNC_INCLUDES_PKG=\"" > archlinux-rsync.pkg.new
pacman -Qnq | awk '{ printf "--include="; print $0"-[0-9]* \\" }' | sort >> archlinux-rsync.pkg.new
echo "\"" >> archlinux-rsync.pkg.new

# Remove all lib32 packages
# pacman -R `LANG=C pacman -Sl multilib | grep installed | cut -d ' ' -f 2`
