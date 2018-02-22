FROM registry.docker.tests:5000/softwareag/msc:10.1

MAINTAINER fabien.sanglier@softwareaggov.com

ENV SAG_HOME=/opt/softwareag
ENV INSTANCE_NAME=default

ADD target/wMFibonacci/build/IS/WxFibonacci.zip $SAG_HOME/IntegrationServer/instances/${INSTANCE_NAME}/replicate/inbound/