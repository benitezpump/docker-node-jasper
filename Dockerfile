FROM openjdk:8u191-jdk-alpine3.9 AS dependencies

RUN apk add --no-cache python && \
    python -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip install --upgrade pip setuptools && \
    rm -r /root/.cache

RUN apk add --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ --no-cache \
  bash \
  build-base \
  libpng-dev \
  autoconf \
  libtool \
  nasm \
  automake \
  nodejs \
  nodejs-npm \
  curl

RUN echo "unsafe-perm = true" >> ~/.npmrc
RUN npm install -g java
RUN ls /usr/local/lib
RUN echo $NODE_PATH

FROM openjdk:8u191-jdk-alpine3.9

ENV LANG en_GB.UTF-8
ENV LD_LIBRARY_PATH /usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/server
RUN apk add --update ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family && rm -rf /var/cache/apk/*

RUN apk add --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ --no-cache \
	nodejs \
  nodejs-npm
COPY --from=dependencies /usr/lib/node_modules/java /usr/lib/node_modules/java

ADD https://svwh.dl.sourceforge.net/project/jasperreports/jasperreports/JasperReports%206.2.0/jasperreports-6.2.0-project.tar.gz ./
RUN tar -xzf jasperreports-6.2.0-project.tar.gz \
    && rm jasperreports-6.2.0-project.tar.gz \
	&& cd jasperreports-6.2.0 \
	&& rm -rf web test src docs demo build .settings tests dist/docs \
	&& rm ThirdPartySoftwareNotices.txt ThirdPartySoftwareNotices.pdf readme.txt pom.xml license.txt changes.txt build.xml .project .gitignore .classpath ._.project

ENV JASPER_LIB /jasperreports-6.2.0