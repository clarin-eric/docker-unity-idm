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
ADD unity-server-distribution-1.8.1-SNAPSHOT-ldap-dist.tar.gz /opt
RUN ln -s /opt/unity-server-distribution-1.8.1-SNAPSHOT /opt/unity-server

COPY conf /opt/unity-server/conf
# Update unity configuration
#RUN \
#  sed -i 's/log4j.rootLogger=INFO, LOGFILE/log4j.rootLogger=INFO, CONSOLE, LOGFILE/' /opt/unity-server/conf/log4j.properties && \
#  sed -i 's/unityServer.core.httpServer.host=localhost/unityServer.core.httpServer.host=0.0.0.0/' /opt/unity-server/conf/unityServer.conf && \
#  sed -i 's/unityServer.core.httpServer.advertisedHost=localhost/unityServer.core.httpServer.advertisedHost=192.168.59.109/' /opt/unity-server/conf/unityServer.conf

# Expose volumes
VOLUME ["/opt/unity-server/logs", "/opt/unity-server/data"]

# Add new server start script running unity in foreground and use this as the containers command
COPY unity-idm-server-start-fg /opt/unity-server/bin/unity-idm-server-start-fg
RUN chmod u+x /opt/unity-server/bin/unity-idm-server-start-fg
CMD ["/opt/unity-server/bin/unity-idm-server-start-fg"]

# Export the unity main port
EXPOSE 2443 10000 10443