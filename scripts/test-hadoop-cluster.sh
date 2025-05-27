#!/bin/bash
# test-hadoop-cluster.sh - Script to test basic Hadoop cluster functionality

set -e

echo "🧪 Starting Hadoop Cluster Test Suite..."
echo "=================================="

# Function to run commands in master container
run_in_master() {
    docker exec -it congdon-master su - hadoopcongdon -c "$1"
}

# Function to run commands in slave container  
run_in_slave() {
    docker exec -it congdon-slave1 su - hadoopcongdon -c "$1"
}

# Test 1: Check if containers are running
echo "📦 Test 1: Checking container status..."
if docker ps | grep -q "congdon-master"; then
    echo "✅ Master container is running"
else
    echo "❌ Master container is not running"
    exit 1
fi

if docker ps | grep -q "congdon-slave1"; then
    echo "✅ Slave container is running"
else
    echo "❌ Slave container is not running"
    exit 1
fi

# Test 2: Check Java installation
echo ""
echo "☕ Test 2: Checking Java installation..."
JAVA_VERSION=$(run_in_master "java -version 2>&1 | head -n 1")
echo "Master Java: $JAVA_VERSION"
JAVA_VERSION_SLAVE=$(run_in_slave "java -version 2>&1 | head -n 1")
echo "Slave Java: $JAVA_VERSION_SLAVE"

# Test 3: Check Hadoop installation
echo ""
echo "🐘 Test 3: Checking Hadoop installation..."
HADOOP_VERSION=$(run_in_master "hadoop version 2>&1 | head -n 1")
echo "Hadoop version: $HADOOP_VERSION"

# Test 4: Check SSH connectivity between nodes
echo ""
echo "🔐 Test 4: Testing SSH connectivity..."
SSH_TEST=$(run_in_master "ssh -o StrictHostKeyChecking=no congdon-slave1 'echo SSH_SUCCESS' 2>/dev/null || echo SSH_FAILED")
if [[ "$SSH_TEST" == "SSH_SUCCESS" ]]; then
    echo "✅ SSH connectivity between master and slave is working"
else
    echo "❌ SSH connectivity between master and slave failed"
    echo "Debug: $SSH_TEST"
fi

# Test 5: Format HDFS (if not already formatted)
echo ""
echo "💾 Test 5: Checking/Formatting HDFS..."
HDFS_STATUS=$(run_in_master "ls -la /home/hadoopcongdon/hadoop/hadoop_data/hdfs/namenode/ 2>/dev/null | wc -l")
if [[ $HDFS_STATUS -le 2 ]]; then
    echo "Formatting HDFS NameNode..."
    run_in_master "hdfs namenode -format -force -nonInteractive"
    echo "✅ HDFS formatted successfully"
else
    echo "✅ HDFS already formatted"
fi

# Test 6: Start Hadoop services
echo ""
echo "🚀 Test 6: Starting Hadoop services..."
echo "Starting HDFS..."
run_in_master "start-dfs.sh"
sleep 5

echo "Starting YARN..."
run_in_master "start-yarn.sh"
sleep 5

echo "Starting MapReduce JobHistory Server..."
run_in_master "mapred --daemon start historyserver"
sleep 3

# Test 7: Check running Java processes
echo ""
echo "🔍 Test 7: Checking running Hadoop processes..."
echo "Master processes:"
run_in_master "jps"
echo ""
echo "Slave processes:"
run_in_slave "jps"

# Test 8: Test HDFS functionality
echo ""
echo "📁 Test 8: Testing HDFS operations..."
echo "Creating test directory..."
run_in_master "hdfs dfs -mkdir -p /test"

echo "Creating test file..."
run_in_master "echo 'Hello Hadoop World!' > /tmp/test.txt"
run_in_master "hdfs dfs -put /tmp/test.txt /test/"

echo "Listing HDFS contents..."
run_in_master "hdfs dfs -ls /"
run_in_master "hdfs dfs -ls /test"

echo "Reading test file from HDFS..."
HDFS_CONTENT=$(run_in_master "hdfs dfs -cat /test/test.txt")
echo "HDFS file content: $HDFS_CONTENT"

if [[ "$HDFS_CONTENT" == "Hello Hadoop World!" ]]; then
    echo "✅ HDFS read/write operations working correctly"
else
    echo "❌ HDFS read/write operations failed"
fi

# Test 9: Test YARN functionality
echo ""
echo "🧶 Test 9: Testing YARN functionality..."
echo "Running pi calculation example..."
PI_OUTPUT=$(run_in_master "hadoop jar /home/hadoopcongdon/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar pi 2 10" 2>&1)
echo "Pi calculation output (last few lines):"
echo "$PI_OUTPUT" | tail -5

if echo "$PI_OUTPUT" | grep -q "Estimated value of Pi"; then
    echo "✅ YARN and MapReduce are working correctly"
else
    echo "❌ YARN or MapReduce test failed"
fi

# Test 10: Check web UIs accessibility
echo ""
echo "🌐 Test 10: Checking web UI accessibility..."
echo "HDFS NameNode Web UI: http://localhost:9870"
echo "YARN ResourceManager Web UI: http://localhost:8088"
echo "MapReduce JobHistory Server Web UI: http://localhost:19888"

echo ""
echo "🎉 Hadoop Cluster Test Suite Completed!"
echo "======================================="
echo "Please check the web UIs to verify they're accessible from your browser."
