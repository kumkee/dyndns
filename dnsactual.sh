#!/usr/bin/bash

IPCONF="$HOME/etc/dnsactual.conf"
APIKEY=`cat $HOME/etc/afraid_api.txt`
DIRURL="https://freedns.afraid.org/dynamic/update.php?$APIKEY"
IPCHECK="ifconfig.me"
LOGFIL="$HOME/var/log/dnsactual.log"
LOGERR="$HOME/var/log/dnsactual-errors.log"
LOGNRQ="$HOME/var/log/dnsactual-nrq.log"

##############################################################################
#
#  application name: dnsactual
#  other files: dnsactual.conf (keeps the last updated ip)
#               dnsactual.log  (register date & time of the actualization)
#               afraid_api.txt (where API KEY is stored)
#  Author: kumkee based on Ernest Danton 01/29/2007
#  Date: 2022/11/16
##############################################################################

if test -f $IPCONF
  then
  CacheIP=$(cat $IPCONF)
fi
#echo $CacheIP
CurreIP=$(curl -s $IPCHECK) # | grep Detected | cut -d : -f 2 | cut -d '<' -f 1 | tr -d " ")
#echo $CurreIP
if [ "$CurreIP" = "$CacheIP" ]
then
  # Both IP are equal
  echo `date` "Update not required. IP: $CurreIP" > $LOGNRQ
elif [ -z "$CurreIP" ]
then
  echo `date` "New IP empty." >> $LOGERR
elif [[ $CurreIP == *"upstream connect error"* ]]
then
  echo `date` "Connection error. $CurreIP" >> $LOGERR
else
  # The IP has change
  echo "Updating http://free.afraid.org with " $CurreIP
  curl $DIRURL 
  echo `date`  "Updating log with IP " $CurreIP >> $LOGFIL
  echo $CurreIP > $IPCONF
fi
