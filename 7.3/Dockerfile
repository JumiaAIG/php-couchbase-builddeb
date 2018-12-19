FROM marceloalmeida/php-docker:7.2

MAINTAINER Marcelo Almeida <marcelo.almeida@jumia.com>

WORKDIR "/root"

ENV \
  DEBIAN_FRONTEND="noninteractive" \
  VERSION="2.6.0"

# INSTALL BUILDER DEPENDENCIES
RUN apt-get update && apt-get install -y --no-install-recommends \
  apt-utils \
  build-essential \
  ca-certificates \
  checkinstall \
  lsb-release \
  make \
  php7.3-dev \
  php7.3-igbinary \
  re2c \
  runawk \
  wget

COPY src /src

# INSTALL PACKAGES DEPENDENCIES
RUN mkdir /pkg && \
  wget -q http://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-4-amd64.deb && \
  dpkg -i /root/*.deb && \
  apt-get update && \
  apt-get install -y libcouchbase-dev libcouchbase2-bin build-essential php-dev zlib1g-dev

# CREATE PACKAGE
RUN wget -q https://pecl.php.net/get/couchbase-$VERSION.tgz && \
  tar -zxvf couchbase-$VERSION.tgz && \
  cd couchbase-$VERSION && \
  cp -r /src/* /root/couchbase-$VERSION/. && \
  phpize && \
  ./configure && \
  checkinstall -y --install=no --pkgname='php7.3-couchbase' --pkgversion='$VERSION' --pkggroup='php' --pkgsource='https://github.com/couchbase/php-couchbase' --maintainer='Jumia TechOps \<techops@jumia.com\>' --requires='php7.3-common \(\>= 7.3.0\), php7.3-json \(\>= 7.3.0\), php7.3-igbinary \(\>= 2.0.1\), libcouchbase2-core \(\>= 2.8.2\)' --include=include_etc

VOLUME ["/pkg"]
