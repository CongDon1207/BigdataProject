FROM ubuntu:22.04

LABEL maintainer="yourname <youremail@example.com>"

RUN echo "root:root" | chpasswd

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y openjdk-11-jdk wget ssh openssh-server dos2unix vim sudo telnet iputils-ping && \
    apt-get clean

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV HADOOP_HOME=/home/hadoopcongdon/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$JAVA_HOME/bin

RUN adduser --disabled-password --gecos "" hadoopcongdon && \
    echo "hadoopcongdon:hadoopcongdon" | chpasswd && \
    usermod -aG sudo hadoopcongdon && \
    echo "hadoopcongdon ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER hadoopcongdon
WORKDIR /home/hadoopcongdon

RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.1/hadoop-3.4.1.tar.gz && \
    tar -xzf hadoop-3.4.1.tar.gz && \
    mv hadoop-3.4.1 hadoop && \
    rm hadoop-3.4.1.tar.gz

RUN echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> /home/hadoopcongdon/hadoop/etc/hadoop/hadoop-env.sh

COPY .bashrc /home/hadoopcongdon/.bashrc

RUN mkdir -p /home/hadoopcongdon/.ssh && \
    ssh-keygen -t rsa -P '' -f /home/hadoopcongdon/.ssh/id_rsa && \
    cat /home/hadoopcongdon/.ssh/id_rsa.pub >> /home/hadoopcongdon/.ssh/authorized_keys && \
    chmod 600 /home/hadoopcongdon/.ssh/authorized_keys && \
    chown -R hadoopcongdon:hadoopcongdon /home/hadoopcongdon/.ssh

USER root

RUN dos2unix /home/hadoopcongdon/.bashrc

EXPOSE 9000 50070 9001 9002 9003 9004 9005 9006 9870 9864 8088 8042 8080 7070 4040
