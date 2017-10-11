#!/bin/bash

WORKDIR="/home/public/archlinux-repos"
DEST="$WORKDIR/archlinux/"
LCK_FLE="$WORKDIR/archlinux-rsync.lck"
TIMESTAMP_FLE="$WORKDIR/archlinux-rsync.timestamp"

## mirrors

#SOURCE='rsync://ftp.jaist.ac.jp/pub/Linux/ArchLinux/'
SOURCE='rsync://mirror.leaseweb.com/archlinux/'

## rsync includes and excludes

RSYNC_INCLUDES_GENERIC="
--include=*abs.tar.gz \
--include=*db \
--include=*db.tar.gz \
--include=*files \
--include=*files.tar.gz \
"
#pacman -Qnq | awk '{ printf "--include="; print $0"-[0-9]* \\" }' | sort
#RSYNC_INCLUDES_PKG=""
source $WORKDIR/scripts/archlinux-rsync.pkg

RSYNC_INCLUDES_ISO="
--include=archlinux-bootstrap-2016.08.01-x86_64.tar.gz \
"

RSYNC_EXCLUDES="
--exclude=**i686** \
--exclude=**staging** \
--exclude=**testing** \
--exclude=**unstable** \
--exclude=iso/ \
--exclude=.~tmp~ \
--exclude=.* \
--exclude=*5.[2-9].95-** \
--exclude=*.[0-9]beta** \
--exclude=*.[0-9].beta** \
--exclude=*.[0-9]-beta** \
"

RSYNC_RULES="--include=*/ $RSYNC_EXCLUDES $RSYNC_INCLUDES_GENERIC $RSYNC_INCLUDES_PKG $RSYNC_INCLUDES_ISO --exclude=*"

## sync with server

RSYNC_OPTS='-vaH --numeric-ids --delete --delete-after --delay-updates --safe-links --delete-excluded --prune-empty-dirs'
mkdir -p $DEST
if [ -e "$LCK_FLE" ] ; then
        OTHER_PID=`/bin/cat $LCK_FLE`
        echo "Another instance already running: $OTHER_PID"
        exit 1
fi

echo `date` > "$TIMESTAMP_FLE"
echo $$ > "$LCK_FLE"
/usr/bin/rsync ${RSYNC_OPTS} ${RSYNC_RULES} ${SOURCE} ${DEST}
/bin/rm -f "$LCK_FLE"

exit 0

