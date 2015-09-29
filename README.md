### Ubuntu 15.04 armhf Bitcoin fullnode base and run containers

#### Tested:

1. Odroid UX4, 16 GB eMMC, USB3/120 GB SSD, Ubuntu 15.04, Docker 1.5.0, Bitcoin 0.11.0
1. RPI2, 32 GB SD, HyperIOT (20150416-201537), Docker 1.6.0, Bitcoin 0.11.0

#### Notes:

1. Pulling down the entire blockchain will take ~2 days and ~52GB of space.
1. By default every core will be running `bitcoin-scriptc`.  If you want to limit the overhead of this container, then edit `bitcoind.service` and change `VER_THREADS=0` to `VER_THREADS=n` where *n* is the max number of cores to use.

#### Requirements:

1. `apt-get install docker.io`
1. `/var/lib/docker` needs 2.5 GB of space (not including data).

	> Recommend that you use SSD on USB and move /var/lib/docker there.
1. `systemctl enable docker`
1. `systemctl start docker`
1. ~52GB of data storage for an indexed fullnode
1. `sudo -s # be lazy :-)`

#### Build Times:

| Platform    | OS Storage   | Docker/Swap Storage | Swap* (GB) | -j (jobs) | Time (min) |
|-------------|--------------|---------------------|:----------:|:---------:|-----------:|
| Odroid UX4  | eMMC         | USB3 SSD            | 0          |         2 |  70        |
| Odroid UX4  | eMMC         | USB3 SSD            | 4          |         4 |  56        |
| RPi 2       | SD           | SD                  | 0          |         1 | 331        |
| RPi 2       | SD           | USB2 SSD            | 0          |         1 | 252        |
| RPi 2       | SD           | USB2 SSD            | 2          |         2 | 182        |
| RPi 2       | SD           | USB2 SSD            | 2          |         4 | 168        |
| qemu-static-arm<br />2 GHz x86_64 cloud instance | SSD | SSD | 0 | 1 | FAIL |
| qemu-system-arm<br />Debian 8, Kernel 3.18.21<br />2 GHz x86_64 cloud instance | SSD | SSD | 0 | 1 | 910 |
| qemu-system/static-arm<br />multistage hybrid<br />2 GHz x86_64 cloud instance | SSD | SSD | 0 | 1 | TBD |
| qemu-static-arm<br />cross compiler hybrid<br />2 GHz x86_64 cloud instance | SSD | SSD | 0 | 1 | TBD |

\* Swap on SD/eMMC is a poor idea and a quick way to wear them out.

#### Build:

> Edit Dockerfile and change `-j` to the correct number of `make` jobs.

```
cd bitcoin
make
cd ..
cd bitcoind
make # seconds (RPi2/SD: minutes)
cd ..
```

#### First Run:

> NOTE: `/ssd/bitcoin_data` can be any director you want.  However, make sure you change all the commands below as well as edit `bitcoind.service`.

> NOTE: Username (`bitcoin`) and UID (`2000`) can be changed, however `bitcoind/Dockerfile`, will also have to be updated.

```
mkdir -p /ssd/bitcoin_data
chmod 700 /ssd/bitcoin_data
useradd -u 2000 bitcoin -d /ssd/bitcoin_data

cat >/ssd/bitcoin_data/bitcoin.conf <<EOF
rpcuser=bitcoinrpc
rpcpassword=$(openssl rand -base64 32)
txindex=1
EOF

chmod 600 /ssd/bitcoin_data/bitcoin.conf
chown -R bitcoin.bitcoin /ssd/bitcoin_data
```

#### Run:

```
docker run --name=bitcoind -d \
    -e 'DATADIR=/tmp/bitcoin_data' \
    -v /ssd/bitcoin_data:/tmp/bitcoin_data \
    bitcoind:latest
```

#### Check:

```
echo -n "total blocks: "; curl https://blockchain.info/q/getblockcount; echo
docker exec bitcoind bitcoin-cli -datadir=/tmp/bitcoin_data/ getinfo
```

> Example Output:
```
total blocks: 371795
{
    "version" : 110000,
    "protocolversion" : 70002,
    "walletversion" : 60000,
    "balance" : 0.00000000,
    "blocks" : 51280,
    "timeoffset" : -1,
    "connections" : 8,
    "proxy" : "",
    "difficulty" : 7.81979699,
    "testnet" : false,
    "keypoololdest" : 1440701395,
    "keypoolsize" : 101,
    "paytxfee" : 0.00000000,
    "relayfee" : 0.00001000,
    "errors" : ""
}
```

#### Stop:
```
docker stop bitcoind
docker rm bitcoind
```

#### Create Service:
```
cp bitcoind.service /etc/systemd/system/
systemctl enable bitcoind
systemctl start bitcoind
```

#### Test Service:
```
docker exec bitcoind bitcoin-cli -datadir=/tmp/bitcoin_data/ getinfo
```

