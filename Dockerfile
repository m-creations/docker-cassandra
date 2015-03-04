FROM mcreations/openwrt-java:7

# Many thanks to the original author and maintainer of abh1nav/cassandra
# Abhinav Ajgaonkar <abhinav316@gmail.com>

MAINTAINER Kambiz Darabi <darabi@m-creations.net>

ENV CASS_VERSION 2.1.2
ENV AGENT_VERSION 5.0.1

ENV MAX_HEAP_SIZE 1G
ENV HEAP_NEWSIZE 100m
ENV CLUSTER_NAME testcluster

ENV CASSANDRA_HOME /opt/cass
ENV CASSANDRA_CONF $CASSANDRA_HOME/conf
ENV CASS_PASS cassandra

ENV AGENT_HOME /opt/agent

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${JAVA_HOME}/bin/bundled:${CASSANDRA_HOME}/bin:${AGENT_HOME}/bin

ENV DATA_DIR /data
ENV COMMITLOG_DIR /commitlog

ADD image/root /

# Download and extract Cassandra and DataStax Agent, and install python for the tools
RUN mkdir -p ${CASSANDRA_CONF} && mkdir -p ${DATA_DIR} && mkdir -p ${COMMITLOG_DIR} && \
  wget --progress=dot:giga http://www.apache.org/dist/cassandra/${CASS_VERSION}/apache-cassandra-${CASS_VERSION}-bin.tar.gz && \
  tar xzf apache-cassandra-${CASS_VERSION}-bin.tar.gz -C /tmp && \
  rm apache-cassandra-${CASS_VERSION}-bin.tar.gz && \
  mv /tmp/apache-cassandra*/* ${CASSANDRA_HOME} && \
  sed -ie 's/JAVA_HOME\/bin\/java/JAVA_HOME\/bin\/bundled\/java/g' ${CASSANDRA_HOME}/bin/* && \
  rm -rf ${CASSANDRA_HOME}/javadoc && \
  opkg update && \
  opkg install python && \
  rm /tmp/opkg-lists/* && \
  mkdir ${AGENT_HOME} && \
  wget --progress=dot:giga http://downloads.datastax.com/community/datastax-agent-${AGENT_VERSION}.tar.gz && \
  tar xzf datastax-agent-${AGENT_VERSION}.tar.gz -C /tmp && \
  rm datastax-agent-${AGENT_VERSION}.tar.gz && \
  mv /tmp/*agent*/* ${AGENT_HOME} && \
  sed -ie 's/JAVA_HOME\/bin\/java/JAVA_HOME\/bin\/bundled\/java/g' ${AGENT_HOME}/bin/* && \
  echo "export PATH=$PATH" >> /etc/profile

# Expose ports
EXPOSE 7199 7000 7001 9160 9042 8888

CMD ["/start-cassandra"]
