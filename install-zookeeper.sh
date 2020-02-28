mkdir -p /data/zookeeper && \
(cd /opt/zookeeper && \
curl -s -O http://apache.mirrors.spacedump.net/zookeeper/zookeeper-3.5.7/apache-zookeeper-3.5.7-bin.tar.gz && \
tar xf apache-zookeeper-3.5.7-bin.tar.gz && \
ln -s apache-zookeeper-3.5.7-bin home && \
rm -f apache-zookeeper-3.5.7-bin.tar.gz)
export ZOOKEEPER_HOME=/opt/zookeeper/home
echo "$INSTANCE_NUMBER" > /data/zookeeper/myid
cp ./packages/zookeeper/config/zoo.cfg /tmp/zoo.cfg
for (( i=1; i <= TOTAL_INSTANCES; i++ ))
do
  echo "server.$i=zookeeper$i:2888:3888" >> /tmp/zoo.cfg
done
mv /tmp/zoo.cfg /opt/zookeeper/home/conf/zoo.cfg
cp ./packages/zookeeper/config/log4j.properties /opt/zookeeper/home/conf/log4j.properties
mkdir /opt/zookeeper/home/logs
ln -s /opt/zookeeper/home/logs /var/log/zookeeper

adduser -r zookeeper
chown -R zookeeper:zookeeper /opt/zookeeper

cp ./packages/zookeeper/service/etc/systemd/system/zookeeper.service /etc/systemd/system/zookeeper.service
chmod 644 /etc/systemd/system/zookeeper.service
systemctl daemon-reload


