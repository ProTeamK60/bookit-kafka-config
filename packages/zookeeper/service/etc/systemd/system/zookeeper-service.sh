[Unit]
Description=Apache Zookeeper server (Kafka)
Documentation=http://zookeeper.apache.org
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
User=zookeeper
Group=zookeeper
Environment=JAVA_HOME=/usr/lib/jvm/java-1.8.0
ExecStart=/opt/zookeeper/home/bin/zkServer.sh start
ExecStop=/opt/zookeeper/home/bin/zkServer.sh stop

[Install]
WantedBy=multi-user.target
