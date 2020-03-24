#!/bin/sh -eux

OSNAME=$(cat /etc/system-release-cpe | cut -d: -f3)
#OSVERSION=$(cat /etc/system-release-cpe | cut -d: -f5)

echo "$0: $OSNAME"

case "$OSNAME" in
centos)
    ;;
redhat)
    ;;
*)
    exit
    ;;
esac

SCRIPTSDIR=/tmp/scripts/$OSNAME
ls -lR $SCRIPTSDIR

if [ -d $SCRIPTSDIR ]; then
  for x in $SCRIPTSDIR/*.sh; do
    sh -eux $x
  done
fi
 
