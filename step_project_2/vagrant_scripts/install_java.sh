#!/usr/bin/env bash
# install_java.sh

echo "Updating and installing OpenJDK 17"
sudo apt-get update
sudo apt-get install -y openjdk-17-jdk
echo "export JAVA_HOME=$(readlink -f /usr/bin/java | sed 's:/bin/java::')" >> ~/.bashrc
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.bashrc