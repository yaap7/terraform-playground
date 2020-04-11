#!/bin/bash

cd
sudo apt update -y
sudo apt full-upgrade -y
sudo apt install -y git make gcc
git clone https://github.com/hashcat/hashcat.git
cd hashcat
make
sudo make install
cd
