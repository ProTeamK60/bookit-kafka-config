#!/usr/bin/env bash
cronfile=/etc/cron.d/0configure-hosts
declare -a addresses
mapfile -t addresses < <(dig +short @service.namespace@|sort -t . -k 3n,3 )
if [[ ${#addresses[*]} -eq @number.of.instances@ ]]
then
  for i in ${!addresses[*]}
  do
    suffix=$((i + 1))
    a=${addresses[$i]}
    sed -i -E '/zookeeper'$suffix'$/d' /etc/hosts
    sed -i -E '/kafka'$suffix'$/d' /etc/hosts
    echo "$a zookeeper$suffix" >> /etc/hosts
    echo "$a     kafka$suffix" >> /etc/hosts
  done
  [ -e $cronfile ] && echo "rm $cronfile" | at now + 1 minute
  systemctl enable --now zookeeper.service
  systemctl enable --now kafka.service
fi
unset cronfile
unset addresses
