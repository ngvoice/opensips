FROM debian:buster AS builder
RUN export DEBIAN_FRONTEND=noninteractive
RUN sed -i 's/deb.debian.org/ftp2.de.debian.org/g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y dpkg-dev dnsutils wget software-properties-common net-tools curl lsb-release debhelper sofia-sip-bin flex bison devscripts default-libmysqlclient-dev dh-systemd docbook-xml erlang-dev libconfuse-dev libdb-dev libev-dev libevent-dev libexpat1-dev libgeoip-dev libhiredis-dev libjansson-dev libjson-c-dev libldap2-dev liblua5.1-0-dev libmemcached-dev libmono-2.0-dev libncurses5-dev libpcre3-dev libperl-dev libpq-dev librabbitmq-dev libradcli-dev libreadline-dev libsasl2-dev libsctp-dev libsnmp-dev libsqlite3-dev libsystemd-dev libunistring-dev libxml2-dev pkg-config python python-dev unixodbc-dev uuid-dev xsltproc zlib1g-dev libbson-dev libmaxminddb-dev libmnl-dev libmongoc-dev libphonenumber-dev python3-dev ruby-dev libssl-dev musl-dev musl-tools libcurl4-gnutls-dev libmicrohttpd-dev librdkafka-dev
COPY . /tmp/build/opensips/
COPY build-deb.sh /usr/sbin/build-deb.sh
RUN /usr/sbin/build-deb.sh

FROM debian:buster
COPY --from=builder /tmp/deb/ /tmp/debs/
RUN export DEBIAN_FRONTEND=noninteractive && \
apt-get update && \
dpkg -i /tmp/debs/*.deb || true && \
apt-get update && apt-get -f -y install && \
apt-get autoremove --purge -y && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*
