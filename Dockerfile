FROM ubuntu:wily
MAINTAINER Alexandre Andrade <kaniabi@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

ENV JENKINS_SWARM_VERSION 2.0
ENV HOME /home/jenkins-slave

# List of packages, separated by spaces, to update upon image STARTUP (see docker-entrypoint.sh).
ENV RUNTIME_PACKAGES_SYSTEM=""
ENV RUNTIME_PACKAGES_RUBY=""
ENV RUNTIME_PACKAGES_NODEJS=""
ENV RUNTIME_PACKAGES_PYTHON=""

ENV TIMEZONE America/Sao_Paulo

ENV ENTRY_POINT = /usr/local/bin/docker-entrypoint.sh

# PACKAGES-SYSTEM:
# * Install netstat to allow (jenkins) connection health check with: `netstat -tan | grep ESTABLISHED`
# * Install nodejs, fixing the executable on /usr/bin/node
RUN useradd -m jenkins-slave -c "Jenkins Slave User" -d $HOME  &&\
    echo "root:chucknorris" | chpasswd  &&\
    apt-get update  &&\
    apt-get install -y net-tools curl sudo git default-jre python-dev nodejs npm ruby-dev rubygems  &&\
    echo "jenkins-slave:jenkins" | chpasswd  &&\
    adduser jenkins-slave sudo  &&\
    echo "jenkins-slave ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers  &&\
    npm config set prefix /usr/local  &&\
    ln -s /usr/bin/nodejs /usr/bin/node  &&\
    curl -s https://bootstrap.pypa.io/get-pip.py > /tmp/get-pip.py  &&\
    python /tmp/get-pip.py  &&\
    rm /tmp/get-pip.py  &&\
    pip -q install virtualenv

# TIMEZONE: Configure the docker-image timezone.
RUN cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime  &&\
    echo ${TIMEZONE} > /etc/timezone

# SWARM-CLIENT: Configure JAR file for swarm-client
RUN curl --create-dirs -sSLo /usr/share/jenkins/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar  &&\
    chmod 755 /usr/share/jenkins

# ...
USER jenkins-slave
VOLUME ${HOME}

# Trying to get rid of errors on job output:
#   tput: No value for $TERM and no -T specified
# Experimenting with values. Trying vt100 to check if we keep the colored output. Other possible value is "dumb".
ENV TERM vt100

# ENTRY-POINT
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
