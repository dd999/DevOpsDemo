FROM tomcat
MAINTAINER Deepali
ADD ./target/addressbook.war /usr/local/tomcat/webapps
CMD "catalina.sh" "run"
EXPOSE 8082
