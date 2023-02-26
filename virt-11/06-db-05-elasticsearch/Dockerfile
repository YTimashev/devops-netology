FROM centos:7

ENV PATH=/usr/lib:/usr/lib/jvm/jre-11/bin:$PATH

EXPOSE 9200 9300

RUN yum install wget -y 
RUN yum install perl-Digest-SHA -y 
RUN yum install java-11-openjdk-devel -y 
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.14.0-linux-x86_64.tar.gz && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.14.0-linux-x86_64.tar.gz.sha512 
RUN shasum -a 512 -c elasticsearch-7.14.0-linux-x86_64.tar.gz.sha512 && \ 
    tar -xzf elasticsearch-7.14.0-linux-x86_64.tar.gz

RUN rm elasticsearch-7.14.0-linux-x86_64.tar.gz && \
    rm elasticsearch-7.14.0-linux-x86_64.tar.gz.sha512

ADD elasticsearch.yml /elasticsearch-7.14.0/config/

ENV ES_JAVA_HOME=/elasticsearch-7.14.0/jdk/
ENV ES_HOME=/elasticsearch-7.14.0

RUN groupadd elastic && useradd -g elastic elastic

RUN mkdir /var/lib/logs && \
    chown elastic:elastic /var/lib/logs && \
    mkdir /var/lib/data && \
    chown elastic:elastic /var/lib/data && \
    chown -R elastic:elastic /elasticsearch-7.14.0/

#RUN mkdir /elasticsearch-7.14.0/snapshots &&\
#    chown -R elastic:elastic /elasticsearch-7.14.0/snapshots

USER elastic
CMD ["/elasticsearch-7.14.0/bin/elasticsearch"]