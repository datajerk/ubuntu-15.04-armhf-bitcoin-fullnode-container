
VER = v1

default: build

build: Dockerfile
	docker build -t bitcoin:$(VER) .
	docker tag -f bitcoin:$(VER) bitcoin:latest

