FROM openjdk:8-jre-buster
RUN apt-get update && apt-get upgrade
RUN apt-get install --fix-missing -y xvfb x11-utils unzip
COPY ./target/universal/odyssey-*.zip /opt
RUN unzip /opt/odyssey-*.zip -d /opt \
 && mv /opt/odyssey-*/ /opt/odyssey/ \
 && rm /opt/odyssey-*.zip
COPY ./entrypoint.sh /opt/odyssey/bin
EXPOSE 9000
ENTRYPOINT [ "/bin/bash", "/opt/odyssey/bin/entrypoint.sh" ]
