#!/bin/bash

function _run-it {
    echo Running $1
    exec /sbin/setuser jenkins-slave $1
}

echo "INFO: SWARM version: $JENKINS_SWARM_VERSION"
JAR=`ls -1 /usr/share/jenkins/swarm-client-*.jar | tail -n 1`
_run-it "/usr/bin/java $JAVA_OPTS -jar $JAR -fsroot $JENKINS_SLAVE_HOME $JENKINS_SLAVE_PARAMS"
