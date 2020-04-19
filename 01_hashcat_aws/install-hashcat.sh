#!/bin/bash

cd
sudo yum update -y
sudo yum install -y git make gcc tmux
git clone https://github.com/hashcat/hashcat.git
cd hashcat
make -j 4
sudo make install
cd
