FROM bitcoin:latest

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

MAINTAINER <datajerk@gmail.com>

RUN useradd -u 2000 bitcoin -d /tmp/bitcoin_data

USER bitcoin

EXPOSE 8333

ENTRYPOINT /usr/local/bin/bitcoind -reindex -datadir=$DATADIR -par=$VER_THREADS

