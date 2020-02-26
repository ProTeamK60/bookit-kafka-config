#!/usr/bin/env bash
source install-zookeper.sh $INSTANCE_COUNTER
source install-kafka.sh $INSTANCE_COUNTER
source mount-kafka-volume.sh
