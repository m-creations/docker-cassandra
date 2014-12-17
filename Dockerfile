FROM mcreations/openwrt-java:7

# Many thanks to the original author and maintainer of abh1nav/cassandra
# Abhinav Ajgaonkar <abhinav316@gmail.com>

MAINTAINER Kambiz Darabi <darabi@m-creations.net>

ENV CASS_VERSION 2.1.2
ENV AGENT_VERSION 5.0.1

ENV MAX_HEAP_SIZE 1G
ENV HEAP_NEWSIZE 100m
ENV CLUSTER_NAME testcluster

ENV CASSANDRA_HOME /opt/cassandra
ENV CASSANDRA_CONF $CASSANDRA_HOME/conf

ENV DATA_DIR /data
ENV COMMITLOG_DIR /commitlog

ADD image/root /

# Download and extract Cassandra
RUN mkdir -p ${CASSANDRA_CONF} && mkdir -p ${DATA_DIR} && mkdir -p ${COMMITLOG_DIR} && \
  wget --progress=dot:giga http://www.apache.org/dist/cassandra/${CASS_VERSION}/apache-cassandra-${CASS_VERSION}-bin.tar.gz && \
  tar xzf apache-cassandra-${CASS_VERSION}-bin.tar.gz -C /tmp && \
  rm apache-cassandra-${CASS_VERSION}-bin.tar.gz && \
  mv /tmp/apache-cassandra*/* /opt/cassandra && \
  rm -rf /opt/cassandra/javadoc && \
  opkg update && \
  opkg install python && \
  rm /tmp/opkg-lists/* && \
  mkdir /opt/agent && \
  wget --progress=dot:giga http://downloads.datastax.com/community/datastax-agent-${AGENT_VERSION}.tar.gz && \
  tar xzf datastax-agent-${AGENT_VERSION}.tar.gz -C /tmp && \
  rm datastax-agent-${AGENT_VERSION}.tar.gz && \
  mv /tmp/*agent*/* /opt/agent && \
  echo "export PATH=$PATH:$CASSANDRA_HOME/bin:/opt/agent/bin" >> /etc/profile

# Expose ports
EXPOSE 7199 7000 7001 9160 9042 8888

CMD ["/start-cassandra"]
