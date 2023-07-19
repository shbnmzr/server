FROM python:3.11-alpine
MAINTAINER Shabnam

ENV PYTHONUNBUFFERED 1
ENV MYSQLCLIENT_CFLAGS="-I/usr/include/mysql"
ENV MYSQLCLIENT_LDFLAGS="-L/usr/lib -lmysqlclient"

COPY ./requirements.txt /requirements.txt
#RUN apk add --no-cache libmysqlclient-dev
RUN apk add --no-cache --virtual .tmp-build-deps \
    gcc musl-dev libc-dev linux-headers
RUN apk add --no-cache mariadb-connector-c-dev

RUN pip install -r /requirements.txt

RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app
COPY ./setup.sql /docker-entrypoint-initdb.d/setup.sql

RUN adduser -D user
USER user