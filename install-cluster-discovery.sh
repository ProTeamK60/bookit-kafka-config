[[ -d ./packages/scripts/opt/bookit/bin && -d ./packages/cron/etc/cron.d/ ]] && mkdir -p /opt/bookit/bin && \
sed -E 's/¤service.namespace¤/'"${DISCOVERY_SERVICE_NAME}.${NAMESPACE}"'/'\
';s/¤number.of.instances¤/'"${TOTAL_INSTANCES}"'/' \
./packages/scripts/opt/bookit/bin/configure-hosts.sh > /opt/bookit/bin/configure-hosts.sh
chmod 744 /opt/bookit/bin/configure-hosts.sh

cp ./packages/cron/etc/cron.d/0configure-hosts /etc/cron.d/0configure-hosts
chmod 644 /etc/cron.d/0configure-hosts
