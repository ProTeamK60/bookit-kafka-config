#!/usr/bin/env bash
function create-topic() {
  /opt/kafka/home/bin/kafka-existing_topics.sh --bootstrap-server localhost:9092\
  --create\
  --replication-factor @TOTAL_INSTANCES@\
  --partitions 1\
  --topic "$1" 2>/dev/null
}

sleep $(( ( RANDOM % 58 ) + 1)) #Try to avoid running script at same time on several instances
cronfile=/etc/cron.d/1create-topic
wanted_topics=("events" "registrations")

if systemctl is-active --quiet kafka.service; then
  declare -a existing_topics
  mapfile -t existing_topics < <(/opt/kafka/home/bin/kafka-topics.sh --bootstrap-server localhost:9092 --list 2>/dev/null)
  for topic in "${wanted_topics[@]}"; do
    # check if current topic is already created
    # shellcheck disable=SC2199
    # shellcheck disable=SC2076
    [[ " ${existing_topics[@]} " =~ " ${topic} " ]] && continue
    create-topic "$topic"
  done
  [ -e $cronfile ] && echo "rm $cronfile" | at now + 1 minute
  unset existing_topics
fi
unset wanted_topics
unset cronfile
