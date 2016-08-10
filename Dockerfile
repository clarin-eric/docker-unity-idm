#
# System packages:
#   - openjdk 8
# Custom packages: 
#   - unity-idm 1.8.1 ldap branch
#

# Pull base image.
FROM docker.clarin.eu/base:1.0.1
MAINTAINER sysops@clarin.eu

ENV JAVA_HOME /usr
ENV CATALINA_HOME /usr/share/tomcat8
ENV CATALINA_BASE /var/lib/tomcat8
ENV CATALINA_PID /var/run/tomcat8.pid
ENV JAVA_OPTS "-Djava.security.egd=file:/dev/./urandom"

# Install required packages
RUN echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list \
 && apt-get update -y \
 && apt-get install -y openjdk-8-jre-headless supervisor openssh-server

# Download and install unity-idm
ADD unity-server-distribution-1.8.1-SNAPSHOT-ldap-dist.tar.gz /opt
RUN ln -s /opt/unity-server-distribution-1.8.1-SNAPSHOT /opt/unity-server

# Update unity configuration
COPY conf /opt/unity-server/conf
# Restore database
COPY data /opt/unity-server/data

# Expose volumes
VOLUME ["/opt/unity-server/data"]

COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod u+x /opt/entrypoint.sh

#
# Supervisor
#
COPY supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/supervisord

ADD download-sp-metadata.sh /opt/download-metadata.sh
RUN chmod u+x /opt/download-metadata.sh

RUN mkdir /var/run/sshd \
 && useradd -m -s /bin/bash test \
 && echo "test:test"|chpasswd

WORKDIR /opt/unity-server/

CMD ["/opt/entrypoint.sh"]

# Export the unity main and ldap ports
EXPOSE 2443 10000 10443 22