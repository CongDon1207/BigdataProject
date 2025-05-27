FROM hadoop-base

USER hadoopcongdon
WORKDIR /home/hadoopcongdon

COPY config/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY config/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY config/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml

RUN mkdir -p $HADOOP_HOME/hadoop_data/hdfs/datanode && \\
    chown -R hadoopcongdon:hadoopcongdon $HADOOP_HOME/hadoop_data/hdfs/datanode

USER root
RUN dos2unix $HADOOP_HOME/etc/hadoop/core-site.xml && \\
    dos2unix $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \\
    dos2unix $HADOOP_HOME/etc/hadoop/yarn-site.xml

USER hadoopcongdon

USER root
CMD ["/bin/bash", "-c", "service ssh start && su - hadoopcongdon && bash"]
