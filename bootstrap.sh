#!/bin/bash
set -e

export PATH=$PATH:$(pwd)/bin
export FABRIC_CFG_PATH=$(pwd)

CHANNEL_NAME="supplychannel"

echo "🔐 Generating crypto material..."
./bin/cryptogen generate --config=./crypto-config.yaml --output=./crypto-config

echo "🛡️  Patching orderer MSP to trust all peer orgs..."
cp crypto-config/peerOrganizations/*/msp/cacerts/* crypto-config/ordererOrganizations/example.com/msp/cacerts/
echo "✅ Orderer MSP updated to trust all peer orgs."

echo "📦 Generating genesis block..."
./bin/configtxgen -profile SupplyChainGenesis -channelID system-channel -outputBlock ./config/genesis.block

echo "🔧 Generating channel configuration transaction..."
./bin/configtxgen -profile SupplyChainChannel -outputCreateChannelTx ./config/channel.tx -channelID $CHANNEL_NAME

echo "🚀 Starting the Docker containers..."
docker-compose -f ./docker/docker-compose.yaml up -d

echo "✅ Bootstrap complete. Now you can create/join the channel and deploy chaincode."

# bootstrap the network
# make it executable by running this command: chmod +x scripts/bootstrap.sh then execute ./scripts/bootstrap.sh

