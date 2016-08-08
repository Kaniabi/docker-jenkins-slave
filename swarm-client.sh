#!/bin/bash

function _run-it {
    echo Running $1
    exec /sbin/setuser jenkins-slave $1 >> /var/log/jenkins-slave.log 2>&1
}

JAR=`ls -1 /usr/share/jenkins/swarm-client-*.jar | tail -n 1`
_run-it "/usr/bin/java $JAVA_OPTS -jar $JAR -fsroot $JENKINS_SLAVE_HOME $JENKINS_SLAVE_PARAMS"
