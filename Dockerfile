#
# System packages:
#   - openjdk 8
# Custom packages: 
#   - unity-idm 1.8.0
#

# Pull base image.
FROM docker.clarin.eu/base:1.0.1
MAINTAINER sysops@clarin.eu

#ENV TERM=xterm
ENV JAVA_HOME /usr
ENV CATALINA_HOME /usr/share/tomcat8
ENV CATALINA_BASE /var/lib/tomcat8
ENV CATALINA_PID /var/run/tomcat8.pid
ENV JAVA_OPTS "-Djava.security.egd=file:/dev/./urandom"

# Install required packages
RUN echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list \
 && apt-get update -y \
 && apt-get install -y openjdk-8-jre-headless

# Download and install unity-idm
RUN curl -SL -o/tmp/unity-server-distribution-1.8.0-dist.tar.gz http://downloads.sourceforge.net/project/unity-idm/Unity%20server/1.8.0/unity-server-distribution-1.8.0-dist.tar.gz \
 && cd /opt \
 && tar -xf /tmp/unity-server-distribution-1.8.0-dist.tar.gz \
 && rm /tmp/unity-server-distribution-1.8.0-dist.tar.gz

# Update unity configuration
RUN \
  sed -i 's/log4j.rootLogger=INFO, LOGFILE/log4j.rootLogger=INFO, CONSOLE, LOGFILE/' /opt/unity-server-distribution-1.8.0/conf/log4j.properties && \
  sed -i 's/unityServer.core.httpServer.host=localhost/unityServer.core.httpServer.host=0.0.0.0/' /opt/unity-server-distribution-1.8.0/conf/unityServer.conf && \
  sed -i 's/unityServer.core.httpServer.advertisedHost=localhost/unityServer.core.httpServer.advertisedHost=192.168.59.109/' /opt/unity-server-distribution-1.8.0/conf/unityServer.conf

# Expose volumes
VOLUME ["/opt/unity-server-distribution-1.8.0/logs", "/opt/unity-server-distribution-1.8.0/data"]

# Add new server start script running unity in foreground and use this as the containers command
COPY unity-idm-server-start-fg /opt/unity-server-distribution-1.8.0/bin/unity-idm-server-start-fg
RUN chmod u+x /opt/unity-server-distribution-1.8.0/bin/unity-idm-server-start-fg
CMD ["/opt/unity-server-distribution-1.8.0/bin/unity-idm-server-start-fg"]

# Export the unity main port
EXPOSE 2443