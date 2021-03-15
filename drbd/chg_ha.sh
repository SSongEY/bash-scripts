#!/bin/bash

OLD_DRBD_OWN_RO=''
OLD_DRBD_OP_RO=''


HA_LOG="/root/ha/had.log"
HA_CHG_SCRIPT="/root/ha/chg_ha"

log()
{
  echo [`date +%Y/%m/%d-%H:%M:%S`] $1 $2 $3 $4 $5 >> $HA_LOG
  echo [`date +%Y/%m/%d-%H:%M:%S`] $1 $2 $3 $4 $5 
}

ROLE=$1

log "=========================="
log "==== Change HA Script ===="
log "=========================="

if [ "$ROLE" == 'Primary' ]; then
log $0 $ROLE
  drbdadm --force primary r0
  mount /dev/drbd0 /opt/autocrypt/data1
  service mysql start
  su - autocrypt -c /home/autocrypt/vpkiserver/run.sh
elif [ "$ROLE" == 'Secondary' ]; then
log $0 $ROLE
  service mysql stop
  umount /opt/autocrypt/data1 
  drbdadm secondary r0
fi

log `drbd-overview`

