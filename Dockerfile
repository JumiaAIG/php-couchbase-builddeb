FROM debian:stretch

MAINTAINER TechOps <techops@jumia.com>

WORKDIR "/root"

ENV \
  DEBIAN_FRONTEND="noninteractive" \
  VERSION="2.6.0"

# INSTALL BUILDER DEPENDENCIES
RUN   apt-get update && apt-get install -y --no-install-recommends \
      apt-utils \
      build-essential \
      ca-certificates \
      checkinstall \
      lsb-release \
      curl \
      php-pear \
      gnupg \
      make \
      php7.0-dev \
      php7.0-igbinary \
      re2c \
      runawk \
      wget

RUN   curl -s http://packages.couchbase.com/ubuntu/couchbase.key | apt-key add - && \
      echo "deb http://packages.couchbase.com/ubuntu stretch stretch/main" > /etc/apt/sources.list.d/couchbase.list

COPY src /src

# INSTALL PACKAGES DEPENDENCIES
RUN mkdir /pkg && \
  apt-get update && \
  apt-get install -y libcouchbase-dev libcouchbase2-bin build-essential zlib1g-dev

# CREATE PACKAGE
RUN pecl download couchbase-$VERSION && \
  tar -zxvf couchbase-$VERSION.tgz && \
  cd couchbase-$VERSION && \
  cp -r /src/* /root/couchbase-$VERSION/. && \
  phpize && \
  ./configure && \
  checkinstall -y --install=no --pkgname='php7.0-couchbase' --pkgversion='$VERSION' --pkggroup='php' --pkgsource='https://github.com/couchbase/php-couchbase' --maintainer='TechOps \<techops@jumia.com\>' --requires='php7.0-common \(\>= 7.0.0\), php7.0-json \(\>= 1.3.6\), php7.0-igbinary \(\>= 1.2.1\), libcouchbase2-core \(\>= 2.8.2\)' --include=include_etc

VOLUME ["/pkg"]
