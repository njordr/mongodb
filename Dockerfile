FROM ubuntu:16.04

MAINTAINER "Giovanni Colapinto" alfheim@syshell.net

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 \
    && echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends --fix-missing \
    sudo \
    software-properties-common \
    mongodb-org-server \
    mongodb-org-shell \
    mongodb-org-mongos \
    mongodb-org-tools \
    pwgen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/ \
    && echo "mongodb-org hold" | dpkg --set-selections \
    && echo "mongodb-org-server hold" | dpkg --set-selections \
    && echo "mongodb-org-shell hold" | dpkg --set-selections \
    && echo "mongodb-org-mongos hold" | dpkg --set-selections \
    && echo "mongodb-org-tools hold" | dpkg --set-selections

VOLUME /data/db

ENV AUTH yes
ENV STORAGE_ENGINE wiredTiger
ENV JOURNALING yes

RUN mkdir /etc/mongodb

ADD run.sh /run.sh
ADD set_mongodb_password.sh /set_mongodb_password.sh
ADD mongod.conf /etc/mongodb/mongod.conf

RUN chmod 755 /run.sh /set_mongodb_password.sh && chown -R mongodb.mongodb /etc/mongodb

CMD ["/run.sh"]
