# ez azért kell, hogy legyen fabric-* command line parancsunk
export PATH=/home/zsapkagy/go/src/github.com/zsapkagy/fabric-samples/bin:$PATH

sudo timedatectl set-ntp no
sudo timedatectl set-time '2022-03-01'

# https://github.com/adhavpavan/FabricNetwork-2.x/blob/main/artifacts/channel/create-certificate-with-ca/docker-compose.yaml UP

sudo chmod -R 777 fabric-ca/
sed -i 's/8760h/720h/g' fabric-ca/ordererOrg/fabric-ca-server-config.yaml
sed -i 's/8760h/720h/g' fabric-ca/org1/fabric-ca-server-config.yaml
sed -i 's/8760h/720h/g' fabric-ca/org2/fabric-ca-server-config.yaml
sed -i 's/8760h/720h/g' fabric-ca/org3/fabric-ca-server-config.yaml

# https://github.com/adhavpavan/FabricNetwork-2.x/blob/main/artifacts/channel/create-certificate-with-ca/docker-compose.yaml DOWN + UP

# https://github.com/adhavpavan/FabricNetwork-2.x/blob/main/artifacts/channel/create-certificate-with-ca/create-certificate-with-ca.sh (ehhez kell a fabric cli-s eszközök)

# https://github.com/adhavpavan/FabricNetwork-2.x/blob/main/artifacts/channel/create-artifacts.sh

# - /var/pavan/-t cserélem le ./production/
# https://github.com/adhavpavan/FabricNetwork-2.x/blob/main/artifacts/docker-compose.yaml UP


# https://github.com/adhavpavan/FabricNetwork-2.x/blob/main/createChannel.sh
# https://github.com/adhavpavan/FabricNetwork-2.x/blob/main/deployChaincode.sh

# https://github.com/adhavpavan/FabricNetwork-2.x/blob/main/api-2.0/config/generate-ccp.sh

# nodemon https://github.com/adhavpavan/FabricNetwork-2.x/blob/main/api-2.0/app.js

# Már tesztelhető a chaincode hívás, először register user, majd azzal a tokennel lehet car-t létrehozni:
# https://www.postman.com/collections/f5852a4b011a245ee318

# leállítunk mindent (2 docker-compose DOWN)

sudo timedatectl set-ntp yes

###########
# RENEW ==>

# CAs UP
# artifacts/channel/create-certificate-with-ca/renew-certs.sh

### MSP Update
mv ../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp ../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/orig_msp
cp -r ../new-certs/ordererOrganizations/example.com/orderers/orderer.example.com/msp ../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp

mv ../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp ../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/orig_msp
cp -r ../new-certs/ordererOrganizations/example.com/orderers/orderer2.example.com/msp ../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp

mv ../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp ../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/orig_msp
cp -r ../new-certs/ordererOrganizations/example.com/orderers/orderer3.example.com/msp ../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp


mv ../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp ../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/orig_msp
cp -r ../new-certs/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp ../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp

mv ../crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp ../crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/orig_msp
cp -r ../new-certs/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp ../crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp

mv ../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/msp ../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/orig_msp
cp -r ../new-certs/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/msp ../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/msp

# Add orderer Timeshift ENVs
# Start orderes and peers

### TLS update
# Do this for every Orderer 1 by 1
# UPDATE the TLS in the channel's config blocks
### SYSTEM channel artifacts/channel/create-certificate-with-ca/rotate-certs/step_1/orderer1/add_tls_o1_sys_channel.sh
### APPLICATION channel artifacts/channel/create-certificate-with-ca/rotate-certs/step_2/orderer1/add_tls_o1_app_channel.sh
# Replace the OLD TLS with the new-cert/.../tls
# Orderer1
mv ../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls ../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/orig_tls
cp -r ../new-certs/ordererOrganizations/example.com/orderers/orderer.example.com/tls ../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls
# Restart the orderer
docker restart orderer.example.com # Restart the orderer
docker logs orderer.example.com -f # check the logs for the orderer

# Orderer2
mv ../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls ../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/orig_tls
cp -r ../new-certs/ordererOrganizations/example.com/orderers/orderer2.example.com/tls ../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls
# Restart the orderer
docker restart orderer2.example.com # Restart the orderer
docker logs orderer2.example.com -f # check the logs for the orderer

# Orderer3
mv ../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls ../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/orig_tls
cp -r ../new-certs/ordererOrganizations/example.com/orderers/orderer3.example.com/tls ../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls
# Restart the orderer
docker restart orderer3.example.com # Restart the orderer
docker logs orderer3.example.com -f # check the logs for the orderer

# UPDATE all the TLS of the peers
mv ../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls ../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/orig_tls
cp -r ../new-certs/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls ../crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls

mv ../crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls ../crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/orig_tls
cp -r ../new-certs/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls ../crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls

mv ../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls ../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/orig_tls
cp -r ../new-certs/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls ../crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls

# Remove Timeshift ENVs from the orderer docker-compositions

# restart orderers and peers
# regenerate api connection profile
# delete admin from the wallet
# register NEW user with postman

# Everything should be OK
