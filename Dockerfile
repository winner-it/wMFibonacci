FROM https://hub.docker.com/r/winneritdocker/softwareag

MAINTAINER eduardo.pomaro@winner-it.com.br

ENV SAG_HOME=/opt/softwareag
ENV INSTANCE_NAME=default
ENV PACKAGES_HOME=$SAG_HOME/IntegrationServer/instances/${INSTANCE_NAME}/packages

ADD target/wMFibonacci/build/IS/WxFibonacci.zip $PACKAGES_HOME/WxFibonacci/WxFibonacci.zip
RUN yum install -y unzip && \
unzip $PACKAGES_HOME/WxFibonacci/WxFibonacci.zip -d $PACKAGES_HOME/WxFibonacci/ && \
rm -f $PACKAGES_HOME/WxFibonacci/WxFibonacci.zip && \
yum remove -y unzip
