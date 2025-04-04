export FABRIC_VERSION=2.5
export CA_VERSION=1.5
export THIRDPARTY_IMAGE_VERSION=0.5.0

# Peer, Orderer, and tools
docker pull hyperledger/fabric-peer:$FABRIC_VERSION
docker pull hyperledger/fabric-orderer:$FABRIC_VERSION
docker pull hyperledger/fabric-tools:$FABRIC_VERSION

# CA (if you plan to use it)
docker pull hyperledger/fabric-ca:$CA_VERSION

# Optional if using CouchDB or others
docker pull couchdb:3.1.1
#############################################################

# download the Fabric binaries under bin directory and Docker images: bin/cryptogen, bin/configtxgen, bin/peer and the necessary docker images
curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.5.0 1.5.5

# Rebuild Crypto and Channel Artifacts: Generate everything from the configtx.yaml and crypto-config.yaml: this also generates the /config directory and contents (genesis.block, channel.tx, ManufacturerMSPanchors.tx)

./bin/cryptogen generate --config=./crypto-config.yaml
./bin/configtxgen -profile SupplyChainGenesis -channelID system-channel -outputBlock ./config/genesis.block
./bin/configtxgen -profile SupplyChainChannel -outputCreateChannelTx ./config/channel.tx -channelID supplychannel
./bin/configtxgen -profile SupplyChainChannel -outputAnchorPeersUpdate ./config/ManufacturerMSPanchors.tx -channelID supplychannel -asOrg ManufacturerMSP

##############################################################
# Cleanup any previous setup

# Stop all Docker containers and remove volumes
docker rm -f $(docker ps -aq) 2>/dev/null
docker volume prune -f
docker network prune -f

# Remove old binaries, images, crypto, config
rm -rf fabric-samples
rm -rf ~/fabric-supply-chain
docker rmi $(docker images -q "hyperledger/*") -f 2>/dev/null

##############################################################################################
# This script does the following:

#Downloads the correct versions of:

#Hyperledger Fabric Binaries (peer, orderer, configtxgen, cryptogen, etc.)

#Fabric samples (fabric-samples)

#Docker images for the specified versions

#Version 2.5.0 is for Fabric binaries

#Version 1.5.6 is for Fabric CA binaries (Certificate Authority)

curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.5.0 1.5.6

############################################################################################################################
# Start over

#Install Hyperledger Fabric Binaries (v3.1.0)
cd ~/fabric-supply-chain
mkdir -p fabric-tools && cd fabric-tools
curl -sSL https://bit.ly/2ysbOFE | bash -s -- 3.1.0 1.5.6

#########################################
# run this froom host: :~$
echo 'export PATH=$PATH:$HOME/fabric-supply-chain/fabric-tools/fabric-samples/bin' >> ~/.bashrc

source ~/.bashrc

# Confirm it worked:
peer version
configtxgen version
cryptogen version
###############################################################################
# Prepare configtx.yaml and crypto-config.yaml

        # Let's generate clean configtx.yaml and crypto-config.yaml files tailored to the supply chain network. 
        #This setup includes four organizations: Manufacturer, Supplier, Logistics, and Regulator, along with a single Orderer 
        #organization using the Raft consensus protocol.
# configtx.yaml defines the Fabric channel and orderer configuration
# crypto-config.yaml defines the organizations and their peers

############################################################################
# The remaining steps are:

1. Generate Crypto Materials
2. Generate genesis block and channel transactions
3. Start Docker containers
4. Create and join the channel
5. Deploy DIAM smart contract
# The directory:

fabric-supply-chain
├── crypto-config
├── config
├── chaincode
│   └── diam
├── docker
├── scripts
└── fabric-tools
    └── fabric-samples


#####################################################
# publish to github: create the repo with same name without readme and then on terminal:

git init
git remote add origin https://github.com/HenokBerhanu/fabric-supply-chain.git
git add .
git commit -m "Initial commit - project structure setup"
git branch -M main
git push -u origin main
#####################################################################

# Generate Crypto Materials with cryptogen: the crypto-coonfig folder was empty

/home/henok/fabric-supply-chain/fabric-tools/fabric-samples/bin/cryptogen generate \
  --config=./crypto-config.yaml \
  --output=./crypto-config

# the output should be: 
        manufacturer.example.com
        supplier.example.com
        logistics.example.com
        regulator.example.com
###########################################################################
# Generate genesis block and channel transactions

/home/henok/fabric-supply-chain/fabric-tools/fabric-samples/bin/configtxgen \
  -profile SupplyChainGenesis \
  -channelID system-channel \
  -outputBlock ./config/genesis.block

# Generate Channel Creation Transaction: to generate channel.tx

/home/henok/fabric-supply-chain/fabric-tools/fabric-samples/bin/configtxgen \
  -profile SupplyChainChannel \
  -outputCreateChannelTx ./config/channel.tx \
  -channelID supplychannel

# Generate Anchor Peer Update Transaction : n Hyperledger Fabric v3.x, the -outputAnchorPeersUpdate flag has been removed, and anchor peers are now included directly within the channel creation transaction. 🎯 So, you no longer need to generate separate anchor peer updates like in Fabric v2.x. That step is deprecated and unnecessary in your case.
# Skip this
/home/henok/fabric-supply-chain/fabric-tools/fabric-samples/bin/configtxgen \
  -profile SupplyChainChannel \
  -outputAnchorPeersUpdate ./config/ManufacturerMSPanchors.tx \
  -channelID supplychannel \
  -asOrg ManufacturerMSP

# Start Docker containers
docker-compose -f ./docker/docker-compose.yaml up -d

# Create and Join the Channel


