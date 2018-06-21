FROM krallin/ubuntu-tini:xenial
MAINTAINER ZEROSPAM, https://github.com/zerospam
ENV DEBIAN_FRONTEND=noninteractive

# Make sure that Upstart won't try to start avgd after dpkg installs it
# https://github.com/dotcloud/docker/issues/446
#ADD policy-rc.d /usr/sbin/policy-rc.d
#RUN /bin/chmod 755 /usr/sbin/policy-rc.d

ADD http://fiodor.zerospam.ca/ubuntu/zerospam-base-config.gpg /tmp/fiodor.gpg

# Install Requirements
RUN apt-key add /tmp/fiodor.gpg && \
dpkg --add-architecture i386 && \
echo "deb http://fiodor.zerospam.ca/ubuntu xenial zs" > /etc/apt/sources.list.d/fiodor.list && \
apt-get update && \
apt-get install -y avg2013flx:i386 \
&& rm -rf /var/lib/apt/lists/* /tmp/fiodor.gpg

# Install AVG
RUN avgcfgctl -w Default.setup.daemonize=false

ADD docker-entrypoint.sh /

ENTRYPOINT ["/usr/local/bin/tini", "--", "/docker-entrypoint.sh"]