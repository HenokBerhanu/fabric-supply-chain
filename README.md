## Henok
This is a Docker-based implementation of Hyperledger Fabric for simulating a supply chain use case (e.g., manufacturer ↔ supplier ↔ logistics ↔ regulator). It is just a basic simulation scenario and network setup to understand chaincode (Smart contract).

# I tested in ubuntu Jammy host machine

# Instruction and Installing Prerequisites

# This step sets up all the required tools for running and interacting with a Hyperledger Fabric blockchain network.

1. Install docker 
# https://docs.docker.com/get-docker/

# Docker Runs Fabric components (peers, orderers, CAs, etc.) in isolated containers

# Uninstall Old Versions (if any)

sudo apt remove docker docker-engine docker.io containerd runc

# Set Up the Docker Repository

sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker’s official GPG key:

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the stable repository:

echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install the Latest Docker Engine & CLI

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify Docker Installation

sudo docker version

# Enable Docker Without sudo

sudo usermod -aG docker $USER
newgrp docker

2. Install Docker Compose (Latest Standalone) 
# https://docs.docker.com/compose/install/

# Manages multi-container Fabric networks

DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | \
  grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
sudo curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
docker-compose version

3. Install Golang 
# https://go.dev/dl/

# Required for developing and running Fabric chaincode (smart contracts)

wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz

# Add Go to your path (put this in ~/.bashrc or ~/.zshrc):

export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go

# Or install go like this:

sudo apt update
sudo apt install golang-go -y


4. Install Node.js
# https://nodejs.org/

# Used for Fabric SDKs (Java, Go, Node.js) and applications, especially if you're building frontend clients

sudo apt update
sudo apt install curl

# download and install NVM

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# load NVM into your current shell session

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# install the latest version of Node.js

nvm install node

# check version

node -v
npm -v

5. Pull fabric components with this coommand

# Inside the mother folder
curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.5.0 1.5.6

# Check with: docker images

REPOSITORY                   TAG       IMAGE ID       CREATED       SIZE
hyperledger/fabric-orderer   2.5       6c3b8eae207f   2 years ago   106MB
hyperledger/fabric-orderer   2.5.0     6c3b8eae207f   2 years ago   106MB
hyperledger/fabric-orderer   latest    6c3b8eae207f   2 years ago   106MB # Ordering node — creates and distributes blocks
hyperledger/fabric-peer      2.5       3d131d2433b1   2 years ago   135MB
hyperledger/fabric-peer      2.5.0     3d131d2433b1   2 years ago   135MB
hyperledger/fabric-peer      latest    3d131d2433b1   2 years ago   135MB # Peer node — validates, endorses, and commits transactions
hyperledger/fabric-ccenv     2.5       84c7e32cc1fe   2 years ago   650MB
hyperledger/fabric-ccenv     2.5.0     84c7e32cc1fe   2 years ago   650MB
hyperledger/fabric-ccenv     latest    84c7e32cc1fe   2 years ago   650MB # Chaincode execution environment (Go chaincode)
hyperledger/fabric-baseos    2.5       082924a105c1   2 years ago   119MB
hyperledger/fabric-baseos    2.5.0     082924a105c1   2 years ago   119MB
hyperledger/fabric-baseos    latest    082924a105c1   2 years ago   119MB # Base image for building other Fabric components
hyperledger/fabric-ca        1.5       8446b174e2a9   2 years ago   209MB
hyperledger/fabric-ca        1.5.6     8446b174e2a9   2 years ago   209MB
hyperledger/fabric-ca        latest    8446b174e2a9   2 years ago   209MB # Fabric CA server — for identity management

# copy the binaries from fabric-samples/bin/ into fabric-supply-chain/

cp -r bin/ ../

# verify:

cd ../
ls bin/

    # Output:
      configtxgen  configtxlator  cryptogen  discover  fabric-ca-client  fabric-ca-server  ledgerutil  orderer  osnadmin  peer
    
# then check the binaries inside mother folder

./bin/cryptogen version
./bin/configtxgen --version
./bin/peer version

# You should see the versions


5. Install Fabric Binaries

# Includes tools like cryptogen (generate certs/keys), configtxgen (generate genesis and channel config), and peer (CLI tool) for generating configs, starting the network, and deploying chaincode