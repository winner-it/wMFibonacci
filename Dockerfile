FROM registry.docker.tests:5000/softwareag/msc:10.1

MAINTAINER fabien.sanglier@softwareaggov.com

ENV SAG_HOME=/opt/softwareag
ENV INSTANCE_NAME=default

ADD target/wMFibonacci/build/IS/WxFibonacci.tar.gz $SAG_HOME/IntegrationServer/instances/${INSTANCE_NAME}/packages/
RUN chown -R root:root $SAG_HOME/IntegrationServer/instances/${INSTANCE_NAME}/packages/
