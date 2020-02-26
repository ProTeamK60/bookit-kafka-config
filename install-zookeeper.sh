mkdir /opt/zookeeper && \
(cd /opt/zookeeper && \
curl -s -O http://apache.mirrors.spacedump.net/zookeeper/zookeeper-3.5.7/apache-zookeeper-3.5.7-bin.tar.gz && \
tar xf apache-zookeeper-3.5.7-bin.tar.gz && \
ln -s apache-zookeeper-3.5.7-bin home && \
rm -f apache-zookeeper-3.5.7-bin.tar.gz)
export ZOOKEEPER_HOME=/opt/zookeeper/home
adduser -r zookeeper
chown -R zookeeper:zookeeper /opt/zookeeper
cp ./packages/zookeeper/service/etc/systemd/system/zookeeper-service.sh /etc/systemd/system/zookeeper-service.sh
