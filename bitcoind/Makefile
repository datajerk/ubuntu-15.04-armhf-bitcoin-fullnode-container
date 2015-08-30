
VER = v2

default: build

build: Dockerfile
	docker build -t bitcoind:$(VER) .
	docker tag -f bitcoind:$(VER) bitcoind:latest

