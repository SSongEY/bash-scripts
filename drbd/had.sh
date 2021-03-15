#!/bin/bash

OLD_DRBD_OWN_RO=''
OLD_DRBD_OP_RO=''


HA_LOG="/root/ha/had.log"
HA_CHG_SCRIPT="/root/ha/chg_ha"

HA_SECONDARY_CHECK=0

#set the priority of network interface
ifmetric enp4s0f3 100
ifmetric enp4s0f0 1


log()
{
  echo [`date +%Y/%m/%d-%H:%M:%S`] $1 $2 $3 $4 $5>> $HA_LOG
  echo [`date +%Y/%m/%d-%H:%M:%S`] $1 $2 $3 $4 $5 
}

check_mariadb ()
{
  processStatus=`ps -ef | grep mysqld | grep -v grep | grep -v logger | grep -v mysqld_safe | wc | awk '{print $1}'`

  if [ "$processStatus" != "1" ]; then
    log "processStatus=${processStatus}"
    return 1
  fi

  mariadbPortStatus=`netstat -tlnp | grep 3306 | grep mysqld | awk '{print $6}'`

  if [ "$mariadbPortStatus" != "LISTEN" ]; then
    log "mariadbPortStatus=${mariadbPortStatus}"
    return 1
  fi

  return 0
}

drbdadm connect r0

while true
do
  log "==== had Loop ===="

  DRBD_OWN_RO=`drbd-overview | head -1 | awk -F' ' '{print $3}' | awk -F'/' '{print $1}'`
  DRBD_OP_RO=`drbd-overview | head -1 | awk -F' ' '{print $3}' | awk -F'/' '{print $2}'`

  log "Old Role:" ${OLD_DRBD_OWN_RO} "/" ${OLD_DRBD_OP_RO}
  log "Current Role:" ${DRBD_OWN_RO} "/" ${DRBD_OP_RO}

  DRBD_R0_CS=`drbd-overview | head -1 | awk -F' ' '{print $2}'`
  log $DRBD_R0_CS

  if [ "$DRBD_R0_CS" = "StandAlone"];then
    drbdadm connect r0
  fi

  if [ "$DRBD_OWN_RO" = "Primary" -a "${DRBD_OP_RO}" = "Secondary" ]; then
    if ! check_mariadb; then
      log "MaridDB Check Fail!"
      ${HA_CHG_SCRIPT} Secondary
    fi
  fi

  if [ "$DRBD_OWN_RO" = "Secondary" -a "${DRBD_OP_RO}" = "Secondary" ]; then
	  if [ "$HA_SECONDARY_CHECK" = 10 ]; then
		  ${HA_CHG_SCRIPT} Primary
		  HA_SECONDARY_CHECK=0
	  else
		  let HA_SECONDARY_CHECK=$HA_SECONDARY_CHECK+1
	  fi
	  
  fi
  
  if [ "$DRBD_OWN_RO" = "Secondary" -a "${DRBD_OP_RO}" != "Primary" -a "${OLD_DRBD_OP_RO}" = "Primary" ]; then
    ${HA_CHG_SCRIPT} Primary
    
  fi

  OLD_DRBD_OWN_RO=$DRBD_OWN_RO
  OLD_DRBD_OP_RO=$DRBD_OP_RO

  sleep 1
done



