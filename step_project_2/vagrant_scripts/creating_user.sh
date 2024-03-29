#!/usr/bin/env bash

echo "Creating user: ${1}"
sudo adduser --disabled-password --gecos "" "${1}"
sudo mkdir -p "/home/${1}/.ssh"
sudo cp /home/vagrant/.ssh/authorized_keys "/home/${1}/.ssh/authorized_keys"
sudo chown -R "${1}:${1}" "/home/${1}/.ssh"
sudo echo "${1} ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
sudo hostnamectl set-hostname "jenkins-${1}"
sudo usermod -aG docker vagrant
sudo usermod -aG docker "${1}"