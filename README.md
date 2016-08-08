[![Docker Stars](https://img.shields.io/docker/stars/kaniabi/jenkins-slave.svg?style=flat-square)](https://hub.docker.com/r/kaniabi/jenkins-slave/)
[![Docker Pulls](https://img.shields.io/docker/pulls/kaniabi/jenkins-slave.svg?style=flat-square)](https://hub.docker.com/r/kaniabi/jenkins-slave/)
[![ImageLayers Size](https://badge.imagelayers.io/kaniabi/jenkins-slave:latest.svg)](https://imagelayers.io/?images=kaniabi/jenkins-slave:latest)

# Jenkins Swarm Slave on Docker

A jenkins-slave image with:
 
* Base image phusion/baseimage (Ubuntu);
* Jenkins Swarm Client (v2.2): `/etc/service/swarm-client/run`;
* Docker in Docker (remember to map /var/run/docker.sock);

```
$ docker run \
    -e JENKINS_SLAVE_PARAMS="-master=http://SERVER:8080 -executors=1 -name=SLAVE1 -labels='LABEL1' -mode=exclusive" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    kaniabi/jenkins-slave:latest
```

