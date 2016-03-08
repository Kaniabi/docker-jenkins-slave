NAME = kaniabi/jenkins-slave
VERSION = 0.2

.PHONY: all build test latest release

all: build

run:
	sudo docker run \
	-e RUNTIME_PACKAGES_SYSTEM="zsh libpq-dev mysql-client-5.6 libmysqlclient-dev" \
	-e RUNTIME_PACKAGES_RUBY="sass compass" \
	-e RUNTIME_PACKAGES_NODEJS="bower" \
	-e RUNTIME_PACKAGES_PYTHON="" \
	--link mysql \
	--rm \
	--name jenkins-slave $(NAME):$(VERSION) \
	-master=http://54.207.132.204:8080 -executors=1 -name=$HOST

bash:
	#sudo docker kill jenkins-slave-bash
	#sudo docker rm jenkins-slave-bash
	sudo docker run -i -t --rm --name jenkins-slave-bash $(NAME):$(VERSION) /bin/bash

build:
	sudo docker build -t $(NAME):$(VERSION) .

latest:
	sudo docker tag $(NAME):$(VERSION) $(NAME):latest

release: latest
	@if ! sudo docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	sudo docker push $(NAME)
