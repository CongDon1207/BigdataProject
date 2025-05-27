FROM hadoop-base

USER hadoopcongdon
WORKDIR /home/hadoopcongdon

COPY config/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY config/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY config/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY config/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml

USER root
RUN dos2unix $HADOOP_HOME/etc/hadoop/core-site.xml && \\
    dos2unix $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \\
    dos2unix $HADOOP_HOME/etc/hadoop/mapred-site.xml && \\
    dos2unix $HADOOP_HOME/etc/hadoop/yarn-site.xml

CMD ["/bin/bash", "-c", "service ssh start && tail -f /dev/null"]
