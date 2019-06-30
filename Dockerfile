FROM tomcat
MAINTAINER Deepali
ADD ./target/addressbook.war /usr/local/tomcat/webapps
CMD "sudo chown jenkins:jenkins /root/.docker -R"
CMD "catalina.sh" "run"
