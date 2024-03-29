#!/usr/bin/env bash

echo "Installing Node.js v20.12.01"
curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "Node.js and npm versions:"
node -v
npm -v