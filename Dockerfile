#
# System packages:
#   - vim, less, curl, openjdk 7
# Custom packages: 
#   - unity-idm 1.6.0
#

# Pull base image.
FROM debian:jessie

MAINTAINER willem@clarin.eu

ENV TERM=xterm

#
# Update system and install required packages
#
RUN \
  apt-get update && \
  apt-get install -y nano less curl openjdk-7-jre && \
  rm -rf /var/lib/apt/lists/*

#
# Download and install unity-idm
#
RUN \
  curl -SL -o/tmp/unity-server-distribution-1.6.0-dist.tar.gz http://downloads.sourceforge.net/project/unity-idm/Unity%20server/1.6.0/unity-server-distribution-1.6.0-dist.tar.gz && \
  cd /opt && \
  tar -xf /tmp/unity-server-distribution-1.6.0-dist.tar.gz && \
  rm /tmp/unity-server-distribution-1.6.0-dist.tar.gz

#
# Update unity configuration
#
RUN \
  sed -i 's/log4j.rootLogger=INFO, LOGFILE/log4j.rootLogger=INFO, CONSOLE, LOGFILE/' /opt/unity-server-distribution-1.6.0/conf/log4j.properties && \
  sed -i 's/unityServer.core.httpServer.host=localhost/unityServer.core.httpServer.host=0.0.0.0/' /opt/unity-server-distribution-1.6.0/conf/unityServer.conf && \
  sed -i 's/unityServer.core.httpServer.advertisedHost=localhost/unityServer.core.httpServer.advertisedHost=192.168.59.109/' /opt/unity-server-distribution-1.6.0/conf/unityServer.conf

#
# Expose volumes
#
VOLUME ["/opt/unity-server-distribution-1.6.0/conf", "/opt/unity-server-distribution-1.6.0/logs", "/opt/unity-server-distribution-1.6.0/data"]

#
# Add new server start script running unity in foreground and use this as the containers command
#
ADD unity-idm-server-start-fg /opt/unity-server-distribution-1.6.0/bin/unity-idm-server-start-fg
RUN chmod u+x /opt/unity-server-distribution-1.6.0/bin/unity-idm-server-start-fg
CMD ["/opt/unity-server-distribution-1.6.0/bin/unity-idm-server-start-fg"]

# 
# Export the unity main port
#
EXPOSE 2443