FROM mcreations/openwrt-java:7

# Many thanks to the original author and maintainer of abh1nav/cassandra
# Abhinav Ajgaonkar <abhinav316@gmail.com>

MAINTAINER Kambiz Darabi <darabi@m-creations.net>

ADD image/root /

# Download and extract Cassandra
RUN mkdir -p /opt/cassandra/conf && \
  wget -O - http://www.us.apache.org/dist/cassandra/2.1.2/apache-cassandra-2.1.2-bin.tar.gz \
  | tar xzf - -C "/tmp" && \
  mv /tmp/apache-cassandra*/* /opt/cassandra && \
  # Download and extract DataStax OpsCenter Agent &&\
  mkdir /opt/agent && \
  wget -O - http://downloads.datastax.com/community/datastax-agent-5.0.1.tar.gz \
  | tar xzf - -C "/tmp" && \
  mv /tmp/*agent*/* /opt/agent && \
  cp /tmp/cassandra.yaml /opt/cassandra/conf/ && \
  mkdir -p /etc/service/cassandra && \
  # FIXME: add this to startup script && \
  cp /tmp/cassandra-run /etc/service/cassandra/run && \
  mkdir -p /etc/service/agent && \
  # FIXME: add this to startup script && \
  cp /tmp/agent-run /etc/service/agent/run

# Expose ports
EXPOSE 7199 7000 7001 9160 9042

WORKDIR /opt/cassandra

CMD ["/sbin/my_init"]
