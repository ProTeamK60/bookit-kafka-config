# shellcheck source=/tmp/git/bookit-kafka-config/
mkdir -p /opt/bookit/bin
source "$1/mount-kafka-volume.sh"
source "$1/install-zookeeper.sh"
source "$1/install-kafka.sh"
source "$1/install-cluster-discovery.sh"
