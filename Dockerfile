#
# Grakn Dockerfile
#
# https://github.com/bfergerson/grakn-docker-toolbox
#
FROM openjdk:8-jdk

LABEL maintainer="github.com/bfergerson"

ARG GRAKN_VERSION=1.2.0

ENV GRAKN_HOME=/opt/grakn

RUN mkdir -p $GRAKN_HOME && \
    curl -sSL https://github.com/graknlabs/grakn/releases/download/v${GRAKN_VERSION}/grakn-dist-${GRAKN_VERSION}.tar.gz | \
    tar -C $GRAKN_HOME --strip-components=1 -xzv

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends supervisor gdb && \
    mkdir -p /var/log/supervisor && \
    rm -rf /var/lib/apt/lists/*

ENV PATH=$PATH:$GRAKN_HOME
WORKDIR $GRAKN_HOME

COPY cassandra.yaml $GRAKN_HOME/services/cassandra
COPY grakn-run /usr/local/bin
COPY supervisord.conf /etc/supervisord.conf

# Grakn Server
EXPOSE 4567
# Thrift client API
EXPOSE 9160
# Grakn gRPC
EXPOSE 48555

CMD ["/usr/bin/supervisord"]
