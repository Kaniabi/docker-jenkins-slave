NAME = kaniabi/jenkins-slave
VERSION = 0.4.1

.PHONY: all build test latest release

all: build

run:
	sudo docker run \
	-e JENKINS_SLAVE_HOME=/home/jenkins-slave \
	-e JENKINS_SLAVE_PARAMS="-master=http://hack-01:9090 -executors=1 -name=hack-99" \
	-v /var/run/docker.sock:/var/run/docker.sock \
	--link mysql --rm --name jenkins-slave \
	registry.opexe:5000/jenkins-slave:$(VERSION)

bash:
	sudo docker kill jenkins-slave-bash | true
	sudo docker rm jenkins-slave-bash | true
	sudo docker run -it --rm --name jenkins-slave-bash $(NAME):$(VERSION) /bin/bash

build:
	sudo docker build -t $(NAME):$(VERSION) -t $(NAME):latest .

build-locally:
	sudo docker build -t registry.opexe:5000/jenkins-slave:$(VERSION) -t registry.opexe:5000/jenkins-slave:latest .
	sudo docker push registry.opexe:5000/jenkins-slave:$(VERSION)
	sudo docker push registry.opexe:5000/jenkins-slave:latest

latest:
	sudo docker tag $(NAME):$(VERSION) $(NAME):latest

release: latest
	@if ! sudo docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	sudo docker push $(NAME)
