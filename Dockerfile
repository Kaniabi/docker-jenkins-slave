FROM phusion/baseimage:latest
MAINTAINER Alexandre Andrade <kaniabi@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

### TIMEZONE: Configure the docker-image timezone.
ENV TIMEZONE=America/Sao_Paulo
RUN cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime  &&\
    echo ${TIMEZONE} > /etc/timezone

### Update and root password.
RUN echo "root:chucknorris" | chpasswd  &&\
    apt-get update


### PACKAGES-SYSTEM:
# * Install netstat to allow (jenkins) connection health check with: `netstat -tan | grep ESTABLISHED`
# * Install nodejs, fixing the executable on /usr/bin/node
RUN apt-get install -y net-tools curl sudo git default-jre python-dev nodejs npm ruby-dev rubygems  &&\
    npm config set prefix /usr/local  &&\
    ln -s /usr/bin/nodejs /usr/bin/node  &&\
    curl -s https://bootstrap.pypa.io/get-pip.py > /tmp/get-pip.py  &&\
    python /tmp/get-pip.py  &&\
    rm /tmp/get-pip.py  &&\
    pip install -u pip  &&\
    pip -q install virtualenvwrapper invoke colorama


### DOCKER ###
RUN apt-get install -y apt-transport-https ca-certificates  &&\
    echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list  &&\
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D  &&\
    apt-get update &&\
    apt-get install -y docker-engine


### JENKINS-SLAVE ###
ENV JENKINS_SLAVE_HOME="/home/jenkins-slave"
ENV JENKINS_SLAVE_PARAMS=""
ENV JENKINS_SWARM_VERSION 2.2

# USER: jenkins-slave
RUN useradd -m jenkins-slave -c "Jenkins Slave User" -d $JENKINS_SLAVE_HOME  &&\
    echo "jenkins-slave:jenkins" | chpasswd  &&\
    adduser jenkins-slave sudo  &&\
    echo "jenkins-slave ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# SWARM-CLIENT: Configure JAR file for swarm-client
RUN curl --create-dirs -sSLo /usr/share/jenkins/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar \
    http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar  &&\
    chmod 755 /usr/share/jenkins

# Getting rid of errors on Jenkins job output:
#   tput: No value for $TERM and no -T specified
ENV TERM vt100
VOLUME ["${JENKINS_SLAVE_HOME}"]

# Aditional deamon: swarm-client
RUN mkdir /etc/service/swarm-client
ADD swarm-client.sh /etc/service/swarm-client/run
