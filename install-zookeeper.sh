mkdir -p /opt/zookeeper/dataDir && \
(cd /opt/zookeeper && \
curl -s -O http://apache.mirrors.spacedump.net/zookeeper/zookeeper-3.5.7/apache-zookeeper-3.5.7-bin.tar.gz && \
tar xf apache-zookeeper-3.5.7-bin.tar.gz && \
ln -s apache-zookeeper-3.5.7-bin home && \
rm -f apache-zookeeper-3.5.7-bin.tar.gz)
export ZOOKEEPER_HOME=/opt/zookeeper/home
echo "$INSTANCE_NUMBER" > /opt/zookeeper/dataDir/myid
cp ./packages/zookeeper/config/zoo.cfg /tmp/zoo.cfg
for (( i=1; i <= TOTAL_INSTANCES; i++ ))
do
  echo "server.$i=zookeeper$i:2888:3888" >> /tmp/zoo.cfg
done
mv /tmp/zoo.cfg /opt/zookeeper/home/conf/zoo.cfg
cp ./packages/zookeeper/config/log4j.properties /opt/zookeeper/home/conf/log4j.properties

adduser -r zookeeper
chown -R zookeeper:zookeeper /opt/zookeeper

cp ./packages/zookeeper/service/etc/systemd/system/zookeeper.service /etc/systemd/system/zookeeper.service
chmod 644 /etc/systemd/system/zookeeper.service
systemctl daemon-reload

[[ -d ./packages/scripts/opt/bookit/bin && -d ./packages/cron/etc/cron.d/ ]] && mkdir -p /opt/bookit/bin && \
sed -E 's!¤path.to.cronfile¤!/etc/cron.d/0configure-hosts!;s/¤service.namespace¤/'\
"${DISCOVERY_SERVICE_NAME}.${NAMESPACE}"'/;s/¤number.of.instances¤/'"${TOTAL_INSTANCES}"'/' \
./packages/scripts/opt/bookit/bin/configure-hosts.sh > /opt/bookit/bin/configure-hosts.sh
chmod 744 /opt/bookit/bin/configure-hosts.sh

cp ./packages/cron/etc/cron.d/0configure-hosts /etc/cron.d/0configure-hosts
chmod 644 /etc/cron.d/0configure-hosts
