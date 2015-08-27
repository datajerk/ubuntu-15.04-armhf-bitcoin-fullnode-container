FROM armv7/armhf-ubuntu:latest

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

MAINTAINER <datajerk@gmail.com>

RUN apt-get update -y
RUN apt-get dist-upgrade -y
RUN apt-get install aptitude wget -y
RUN apt-get install git -y
RUN apt-get install gcc -y
RUN apt-get install dh-autoreconf -y
RUN apt-get install autoconf -y
RUN apt-get install libtool -y
RUN apt-get install linux-headers-generic -y
RUN apt-get install build-essential -y
RUN apt-get install libqtcore4 libqtgui4 libqt4-dev -y
RUN apt-get install pkg-config -y
RUN apt-get install libboost-dev -y
RUN apt-get install libboost-system-dev -y
RUN apt-get install libboost-filesystem-dev -y
RUN apt-get install libboost-program-options-dev -y
RUN apt-get install libboost-thread-dev -y
RUN apt-get install libboost-test-dev -y
RUN apt-get install libssl-dev -y
RUN apt-get install libprotobuf-dev protobuf-compiler -y

WORKDIR /tmp
RUN wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
RUN tar zxvf db-4.8.30.NC.tar.gz
WORKDIR /tmp/db-4.8.30.NC/
RUN mkdir -p build
WORKDIR /tmp/db-4.8.30.NC/build
ENV BDB_PREFIX /tmp/db-4.8.30.NC/build
RUN ../dist/configure --disable-shared --enable-cxx --with-pic --prefix=$BDB_PREFIX
RUN make -j8
RUN make install

WORKDIR /tmp
RUN git clone https://github.com/bitcoin/bitcoin.git
WORKDIR /tmp/bitcoin/
RUN git checkout v0.11.0
RUN ./autogen.sh
RUN ./configure CPPFLAGS="-I${BDB_PREFIX}/include/ -O2" LDFLAGS="-L${BDB_PREFIX}/lib/" --with-gui
RUN make -j2 # needs 1GB RAM/j
RUN make install

WORKDIR /tmp
#RUN rm -rf bitcoin db*

WORKDIR /

