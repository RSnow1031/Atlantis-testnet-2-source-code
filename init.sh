#!/bin/bash

MONIKER="MyNode"
PROJECT_DIR=$PWD

# Stop & remove old data
sudo systemctl stop blockxd.service
# sudo rm -f /etc/systemd/system/blockxd.service
# sudo rm $HOME/go/bin/blockxd
sudo rm -rf $HOME/.blockxd

# Replace service
cp blockxd.service /etc/systemd/system

# copy blockxd from /root/go/bin
cp /root/go/bin/blockxd blockxd

# init binary
./blockxd config chain-id blockx_50-1
./blockxd config keyring-backend file
./blockxd init $MONIKER --chain-id blockx_50-1 --keyring-backend file

cd $PROJECT_DIR
cp genesis.json $HOME/.blockxd/config
cp blockxd.service /etc/systemd/system

export DAEMON_NAME=blockxd         # binary name
export DAEMON_HOME=$HOME/.blockxd  # daemon's home directory

cd $HOME/.blockxd/config

sed -i 's/seeds = \"\"/seeds = \"3bdc1c076399ee1090b1b7efa0474ce1a1cb191a@146.190.153.165:26656,49a5a62543f5fec60db42b00d9ebe192c3185e15@146.190.157.123:26656\"/g' config.toml

systemctl daemon-reload
systemctl start blockxd.service