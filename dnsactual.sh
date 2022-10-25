#!/data/data/com.termux/files/usr/bin/sh
#/data/data/com.termux/files/usr/etc

IPCONF="/data/data/com.termux/files/usr/etc/freedns/dnsactual.conf"
DIRURL="[afraid freedns update link]"
IPCHECK="ifconfig.me"
LOGFIL="/data/data/com.termux/files/usr/var/log/dnsactual.log"

##############################################################################
#
#  application name: dnsactual
#  other files: dnsactual.conf (keeps the last updated ip)
#               dnsactual.log  (register date & time of the actualization)
#  Author: Ernest Danton
#  Date: 01/29/2007
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
  echo `date` "Update not required. IP: $CurreIP" # $CurreIP >> $LOGFIL
elif [ -z "$CurreIP" ]
then
  echo `date` "New IP empty."
else
  # The IP has change
  echo "Updating http://free.afraid.org with " $CurreIP
  curl $DIRURL
  echo `date`  "Updating log with IP " $CurreIP >> $LOGFIL
  echo $CurreIP > $IPCONF
fi