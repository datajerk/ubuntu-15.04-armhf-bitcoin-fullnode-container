## Ubuntu 15.04 armhf bitcoin fullnode base and run containers

### Tested:

1. Odroid UX4, 16 GB eMMC, 120 GB SSD, Ubuntu 15.04, Docker 1.5.0, Bitcoin 0.11.0

### Requirements:

1. `apt-get install docker.io`
1. `/var/lib/docker` needs 2.5 GB of space (not including data).  (Recommend that you install SSD on USB3 and move /var/lib/docker there.)
1. `systemctl enable docker`
1. `systemctl start docker`
1. ~40GB of data storage for full indexed node
1. `sudo -s` # be lazy

### Build:

```
cd bitcoin
make # takes an hour
cd ..
cd bitcoind
make # takes seconds
cd ..
```

### First Run:

> NOTE: `/ssd/bitcoin_data` can be any director you want.  However, make sure you change all the commands below as well as edit `bitcoind.service`.

> NOTE: Username and UID (2000) can be changed, however `bitcoind/Dockerfile`, will also have to be updated.

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

### Run:

```
docker run --name=bitcoind -d \
    -e 'DATADIR=/tmp/bitcoin_data' \
    -v /ssd/bitcoin_data:/tmp/bitcoin_data \
    bitcoind:latest
```

### Check:

```
echo -n "total blocks: "; curl https://blockchain.info/q/getblockcount; echo
docker exec bitcoind bitcoin-cli -datadir=/tmp/bitcoin_data/ getinfo
```

### Stop:
```
docker stop bitcoind
docker rm bitcoind
```

### Create Service:
```
cp bitcoind.service /etc/systemd/system/
systemctl enable bitcoind
systemctl start bitcoind
```

### Test Service:
```
docker exec bitcoind bitcoin-cli -datadir=/tmp/bitcoin_data/ getinfo
```

