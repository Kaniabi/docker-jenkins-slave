#!/bin/bash

if [[ -n "$RUNTIME_PACKAGES_SYSTEM" ]]; then sudo apt-get install -y ${RUNTIME_PACKAGES_SYSTEM}; fi
if [[ -n "$RUNTIME_PACKAGES_RUBY" ]]; then sudo gem install ${RUNTIME_PACKAGES_RUBY}; fi
if [[ -n "$RUNTIME_PACKAGES_NODEJS" ]]; then sudo npm install ${RUNTIME_PACKAGES_NODEJS}; fi
if [[ -n "$RUNTIME_PACKAGES_PYTHON" ]]; then sudo pip install ${RUNTIME_PACKAGES_PYTHON}; fi

# if `docker run` first argument start with `-` the user is passing jenkins swarm launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "-"* ]]; then
  # jenkins swarm slave
  JAR=`ls -1 /usr/share/jenkins/swarm-client-*.jar | tail -n 1`

  # if -master is not provided and using --link jenkins:jenkins
  if [[ "$@" != *"-master "* ]] && [ ! -z "$JENKINS_PORT_8080_TCP_ADDR" ]; then
    PARAMS="-master http://$JENKINS_PORT_8080_TCP_ADDR:$JENKINS_PORT_8080_TCP_PORT"
  fi

  echo Running java $JAVA_OPTS -jar $JAR -fsroot $HOME $PARAMS "$@"
  exec java $JAVA_OPTS -jar $JAR -fsroot $HOME $PARAMS "$@"
fi

# As argument is not jenkins, assume user want to run his own process, for sample a `bash` shell to explore this image
exec "$@"
