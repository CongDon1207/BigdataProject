#!/bin/bash
set -e

echo "▶️ Starting SSH..."
service ssh start

NAMENODE_DIR="$HADOOP_HOME/hadoop_data/hdfs/namenode"

echo "🔍 Checking if HDFS is already formatted..."
if [ ! -f "$NAMENODE_DIR/current/VERSION" ]; then
  echo "📦 First run: Formatting HDFS NameNode..."
  su - hadoopuser -c '/home/hadoopuser/hadoop/bin/hdfs namenode -format -force -nonInteractive'
else
  echo "✅ HDFS already formatted."
fi

echo "✅ Format done. Container ready."

exec tail -f /dev/null
