# Makefile for bitcoin

VER = 0.11.2
IMAGE=bitcoin

default: $(IMAGE)-$(VER).tar

local/deps.txt: Dockerfile.build deps.sh
	docker build --no-cache -t $(IMAGE)build:$(VER) -f Dockerfile.build .
	#docker build -t $(IMAGE)build:$(VER) -f Dockerfile.build .
	docker tag -f $(IMAGE)build:$(VER) $(IMAGE)build:latest
	mkdir -p local
	docker run --rm -it -v $(PWD)/local:/mylocal $(IMAGE)build:$(VER) /bin/bash -c "cp -va /usr/local/* /mylocal/"

$(IMAGE)-$(VER).tar: Dockerfile.run local/deps.txt
	docker build --no-cache -t $(IMAGE):$(VER) -f Dockerfile.run .
	#docker build -t $(IMAGE):$(VER) -f Dockerfile.run .
	docker tag -f $(IMAGE):$(VER) $(IMAGE):latest
	docker save -o $(IMAGE)-$(VER).tar $(IMAGE):$(VER)

clean:
	rm -rf local $(IMAGE)-$(VER).tar

dockerclean:
	docker rmi $(IMAGE):latest $(IMAGE)build:latest $(IMAGE):$(VER) $(IMAGE)build:$(VER)

realclean: clean dockerclean

