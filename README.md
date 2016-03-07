[![Docker Stars](https://img.shields.io/docker/stars/kaniabi/jenkins-slave.svg?style=flat-square)](https://hub.docker.com/r/kaniabi/jenkins-slave/)
[![Docker Pulls](https://img.shields.io/docker/pulls/kaniabi/jenkins-slave.svg?style=flat-square)](https://hub.docker.com/r/kaniabi/jenkins-slave/)
[![ImageLayers Size](https://badge.imagelayers.io/kaniabi/jenkins-slave:latest.svg)](https://imagelayers.io/?images=kaniabi/jenkins-slave:latest)

# Jenkins Swarm Slave on Docker

A customizable jenkins-slave docker image, with python, ruby and nodejs.

```
$ docker run \
    -e RUNTIME_PACKAGES_SYSTEM="zsh libpq-dev mysql-client-5.6 libmysqlclient-dev" \
    -e RUNTIME_PACKAGES_RUBY="sass compass" \
    -e RUNTIME_PACKAGES_PYTHON="django" \
    -e RUNTIME_PACKAGES_NODEJS="bower" \
    kaniabi/jenkins-slave:latest \
      -master=http://<your jenkins server>:8080 \
      -executors=1 \
      -name=<a friendly name>
```

