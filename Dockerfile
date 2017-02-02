FROM debian:jessie

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        ca-certificates \
        bzip2 \
        libfontconfig \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN set -x  \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
        curl \
 && mkdir /tmp/phantomjs \
 && curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
        | tar -xj --strip-components=1 -C /tmp/phantomjs \
 && mv /tmp/phantomjs/bin/phantomjs /usr/local/bin \
 && curl -Lo /tmp/dumb-init.deb https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64.deb \
 && dpkg -i /tmp/dumb-init.deb \
 && apt-get purge --auto-remove -y \
        curl \
 && apt-get clean \
 && rm -rf /tmp/* /var/lib/apt/lists/* \
    \
 && useradd --system --uid 72379 -m --shell /usr/sbin/nologin phantomjs \
 && su phantomjs -s /bin/sh -c "phantomjs -v"

USER phantomjs

EXPOSE 8910

ENTRYPOINT ["dumb-init"]
CMD ["phantomjs --webdriver=8080 --ignore-ssl-errors=true --webdriver=127.0.0.1:8080 —webdriver-selenium-grid-hub=http://100.96.2.9:4444/grid/register/"]
